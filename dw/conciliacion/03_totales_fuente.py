"""
03_totales_fuente.py · Conteos y totales calculados directamente sobre las fuentes originales,
para compararlos con 01_conteos_dw.sql y 02_totales_dw.sql.
Uso (desde la raíz del repositorio):  python dw/conciliacion/03_totales_fuente.py
"""
import json
from pathlib import Path
import pandas as pd

RAW = Path(__file__).resolve().parents[2] / "datos" / "raw"

f1 = pd.read_csv(next(RAW.glob("F1_*.csv")), dtype=str)
valor = pd.to_numeric(f1["valor_del_contrato"], errors="coerce")
pagado = pd.to_numeric(f1["valor_pagado"], errors="coerce")
anio = f1["fecha_de_firma"].str[:4]
print("F1 leídos:", len(f1))
print("F1 id_contrato duplicados:", int(f1["id_contrato"].duplicated().sum()))
print("F1 total valor_del_contrato:", f"{valor.sum():,.2f}")
print("F1 total valor_pagado:", f"{pagado.sum():,.2f}")
print(pd.DataFrame({"anio": anio, "valor": valor}).groupby("anio")["valor"].agg(["count", "sum"]))

f2 = pd.DataFrame(json.loads(next(RAW.glob("F2_*.json")).read_text(encoding="utf-8")))
f2s = f2.astype(str)
print("F2 leídos:", len(f2), "· duplicados exactos:", int(f2s.duplicated().sum()),
      "· procesos distintos:", f2["id_del_portafolio"].nunique())
