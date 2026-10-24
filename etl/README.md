# Orden de ejecución del ETL (Pentaho Data Integration) – se construye en la Entrega 2
1. t_01_stg_contratos.ktr (CSV F1) · 2. t_02_stg_procesos.ktr (JSON F2) · 3. t_03_stg_ipc.ktr (XLSX F3)
4. Dimensiones: tiempo, entidad, proveedor (anonimizado), modalidad, objeto contractual
5. t_20_fact_contrato.ktr · 6. j_00_principal.kjb (orquestación y etl_log)
