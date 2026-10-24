"""
Descarga las fuentes del proyecto «Vigilancia de la contratación pública en Cundinamarca».
F1 (CSV) y F2 (JSON) se descargan de datos.gov.co por la API SODA.
F3 (XLSX, IPC del DANE) se descarga a mano desde la página del DANE y se guarda en datos/raw.

Uso:
    pip install pandas requests openpyxl
    python datos/descargar_fuentes.py
"""
import io, json, datetime as dt
from pathlib import Path
import requests
import pandas as pd

BASE = Path(__file__).resolve().parent
RAW, MUE = BASE / "raw", BASE / "muestras"
RAW.mkdir(parents=True, exist_ok=True); MUE.mkdir(parents=True, exist_ok=True)
HOY = dt.date.today().strftime("%d/%m/%Y")
PAGINA = 50000

WHERE_F1 = ("departamento = 'Cundinamarca' AND fecha_de_firma between "
            "'2023-01-01T00:00:00' and '2025-12-31T23:59:59'")


def soda_csv(dataset, where):
    partes, offset = [], 0
    while True:
        r = requests.get(f"https://www.datos.gov.co/resource/{dataset}.csv",
                         params={"$where": where, "$limit": PAGINA, "$offset": offset, "$order": ":id"},
                         timeout=600)
        r.raise_for_status()
        df = pd.read_csv(io.StringIO(r.text), dtype=str)
        partes.append(df); print(f"  {dataset}: +{len(df)} filas")
        if len(df) < PAGINA:
            return pd.concat(partes, ignore_index=True)
        offset += PAGINA


def soda_json_por_ids(dataset, campo, ids, lote=150):
    filas = []
    ids = sorted(set(i for i in ids if isinstance(i, str) and i.strip()))
    for k in range(0, len(ids), lote):
        grupo = ",".join(f"'{i}'" for i in ids[k:k + lote])
        r = requests.get(f"https://www.datos.gov.co/resource/{dataset}.json",
                         params={"$where": f"{campo} in({grupo})", "$limit": PAGINA}, timeout=600)
        r.raise_for_status()
        filas.extend(r.json())
        print(f"  {dataset}: lote {k // lote + 1} → {len(filas)} filas acumuladas")
    return filas


def perfil(nombre, df):
    out = [f"## {nombre}", f"- Registros: **{len(df):,}**".replace(",", "."),
           f"- Columnas ({df.shape[1]}): {', '.join(df.columns)}",
           f"- Filas duplicadas exactas: {int(df.duplicated().sum())}"]
    for c in df.columns:
        if df[c].dtype == object and 1 < df[c].nunique() <= 30:
            out.append(f"- `{c}`: {df[c].fillna('<NULO>').value_counts().head(10).to_dict()}")
    nulos = {c: int(v) for c, v in df.isna().sum().items() if v}
    out.append(f"- Nulos por columna: {nulos or 'ninguno'}")
    return "\n".join(out) + "\n"


def main():
    informe, registro = [f"# Perfilamiento – generado el {HOY}\n"], {}

    print("F1 · SECOP II Contratos Electrónicos (CSV)")
    f1 = soda_csv("jbjy-vk9h", WHERE_F1)
    f1.to_csv(RAW / "F1_secop2_contratos_cundinamarca_2023_2025.csv", index=False, encoding="utf-8")
    informe.append(perfil("F1 – SECOP II Contratos Electrónicos (jbjy-vk9h)", f1))

    print("F2 · SECOP II Procesos de Contratación (JSON), solo procesos de los contratos de F1")
    f2 = soda_json_por_ids("p6dx-8zbt", "id_del_portafolio", f1["proceso_de_compra"].tolist())
    (RAW / "F2_secop2_procesos_cundinamarca.json").write_text(json.dumps(f2, ensure_ascii=False), encoding="utf-8")
    f2df = pd.DataFrame(f2)
    informe.append(perfil("F2 – SECOP II Procesos de Contratación (p6dx-8zbt)", f2df))

    ipc = list(RAW.glob("*IPC*.xlsx")) + list(RAW.glob("*ipc*.xlsx"))
    if ipc:
        f3 = pd.read_excel(ipc[0], header=None, dtype=str)
        informe.append(f"## F3 – IPC DANE ({ipc[0].name})\n- Filas del libro (incluye títulos): {len(f3)}\n")
        f3.head(20).to_csv(MUE / "F3_muestra_20.csv", index=False)
        registro["F3"] = {"archivo": ipc[0].name, "filas_libro": len(f3), "fecha_descarga": HOY}
    else:
        print("¡Falta F3! Descarga el Excel de índices del IPC del DANE y guárdalo en datos/raw con 'IPC' en el nombre.")

    f1.head(20).to_csv(MUE / "F1_muestra_20.csv", index=False)
    f2df.head(20).to_csv(MUE / "F2_muestra_20.csv", index=False)
    registro["F1"] = {"registros": len(f1), "fecha_descarga": HOY}
    registro["F2"] = {"registros": len(f2df), "fecha_descarga": HOY}
    estado = "CUMPLE" if len(f1) >= 50000 else "NO CUMPLE: ampliar alcance (p. ej., sumar Bogotá o 2022)"
    informe.append(f"## Tabla de hechos\n- fact_contrato tendrá ≈ {len(f1):,} filas → {estado} el mínimo de 50.000\n".replace(",", "."))
    (BASE / "perfilamiento.md").write_text("\n".join(informe), encoding="utf-8")
    (BASE / "registro_descarga.json").write_text(json.dumps(registro, indent=2), encoding="utf-8")
    print(json.dumps(registro, indent=2)); print(estado)


if __name__ == "__main__":
    main()
