"""
Perfila los archivos YA descargados en datos/raw (no vuelve a descargar nada).
Genera: datos/perfilamiento.md, datos/muestras/F*_muestra_20.csv y datos/registro_descarga.json

Uso (desde la carpeta bi-proyecto):
    python datos\\perfilar.py
"""
import json
import datetime as dt
from pathlib import Path
import pandas as pd

BASE = Path(__file__).resolve().parent
RAW, MUE = BASE / "raw", BASE / "muestras"
MUE.mkdir(exist_ok=True)
HOY = dt.date.today().strftime("%d/%m/%Y")


def plano(df):
    """Convierte celdas con diccionarios o listas (JSON anidado) en texto."""
    return df.apply(lambda col: col.map(lambda v: json.dumps(v, ensure_ascii=False)
                                        if isinstance(v, (dict, list)) else v))


def ejemplo(df, col):
    if col not in df:
        return "(no existe la columna)"
    s = df[col].dropna()
    s = s[s.astype(str).str.strip() != ""]
    return repr(s.iloc[0]) if len(s) else "(vacía)"


def perfil(nombre, df, claves):
    out = [f"## {nombre}",
           f"- Registros: **{len(df):,}**".replace(",", "."),
           f"- Columnas ({df.shape[1]}): {', '.join(map(str, df.columns))}",
           f"- Filas duplicadas exactas: {int(df.astype(str).duplicated().sum())}"]
    out.append("- Ejemplos reales:")
    for c in claves:
        out.append(f"  - `{c}`: {ejemplo(df, c)}")
    for c in df.columns:
        n = df[c].astype(str).nunique()
        if 1 < n <= 25:
            vc = df[c].fillna("<NULO>").astype(str).value_counts().head(8).to_dict()
            out.append(f"- Valores de `{c}`: {vc}")
    nd = {c: int((df[c].astype(str).str.strip() == "No Definido").sum()) for c in df.columns}
    nd = {c: v for c, v in nd.items() if v}
    out.append(f"- Celdas con «No Definido»: {nd or 'ninguna'}")
    nulos = {c: int(v) for c, v in df.isna().sum().items() if v}
    out.append(f"- Nulos por columna: {nulos or 'ninguno'}")
    return "\n".join(out) + "\n"


def main():
    informe, registro = [f"# Perfilamiento – generado el {HOY}\n"], {}

    p1 = next(RAW.glob("F1_*.csv"))
    f1 = pd.read_csv(p1, dtype=str)
    claves1 = ["nombre_entidad", "nit_entidad", "ciudad", "proceso_de_compra", "estado_contrato",
               "codigo_de_categoria_principal", "fecha_de_firma", "tipodocproveedor", "es_pyme",
               "valor_del_contrato", "valor_pagado", "dias_adicionados"]
    informe.append(perfil(f"F1 – SECOP II Contratos ({p1.name})", f1, claves1))
    f1.head(20).to_csv(MUE / "F1_muestra_20.csv", index=False, encoding="utf-8-sig")
    registro["F1"] = {"registros": len(f1), "fecha_descarga": "23/10/2026"}

    p2 = next(RAW.glob("F2_*.json"))
    f2 = plano(pd.DataFrame(json.loads(p2.read_text(encoding="utf-8"))))
    claves2 = ["entidad", "nit_entidad", "ordenentidad", "ppi", "id_del_portafolio", "fase",
               "fecha_de_publicacion_del", "fecha_de_ultima_publicaci"]
    informe.append(perfil(f"F2 – SECOP II Procesos ({p2.name})", f2, claves2))
    if "id_del_portafolio" in f2 and "proceso_de_compra" in f1:
        casan = f1["proceso_de_compra"].isin(f2["id_del_portafolio"]).sum()
        informe.append(f"- Contratos de F1 cuyo proceso aparece en F2: {casan:,} de {len(f1):,}\n".replace(",", "."))
    f2.head(20).to_csv(MUE / "F2_muestra_20.csv", index=False, encoding="utf-8-sig")
    registro["F2"] = {"registros": len(f2), "fecha_descarga": "23/10/2026"}

    ipc = [p for p in RAW.glob("*.xlsx") if "ipc" in p.name.lower()]
    if ipc:
        hojas = pd.read_excel(ipc[0], sheet_name=None, header=None, dtype=str)
        informe.append(f"## F3 – IPC DANE ({ipc[0].name})\n- Hojas: {list(hojas.keys())}\n")
        for nombre, h in hojas.items():
            informe.append(f"### Hoja «{nombre}» ({len(h)} filas)\n```\n{h.head(12).fillna('').to_string()}\n```\n")
        primera = list(hojas.values())[0]
        primera.head(20).to_csv(MUE / "F3_muestra_20.csv", index=False, encoding="utf-8-sig")

    informe.append(f"## Tabla de hechos\n- fact_contrato ≈ {len(f1):,} filas → "
                   f"{'CUMPLE' if len(f1) >= 50000 else 'NO CUMPLE'} el mínimo de 50.000\n".replace(",", "."))
    (BASE / "perfilamiento.md").write_text("\n".join(informe), encoding="utf-8")
    (BASE / "registro_descarga.json").write_text(json.dumps(registro, indent=2), encoding="utf-8")
    print("F1 registros:", len(f1))
    print("F2 registros:", len(f2))
    print("Listo: abre datos\\perfilamiento.md y copia su contenido.")


if __name__ == "__main__":
    main()
