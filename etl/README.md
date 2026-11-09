# ETL – Pentaho Data Integration

## Motor y conexión
- Motor: MySQL Community Server 8.4 LTS. Base de datos: `bi_secop` (host `localhost`, puerto `3306`, usuario `bi_etl`).
- Herramienta ETL: Pentaho Data Integration 9.4 (Spoon) con Java 11 (`PENTAHO_JAVA_HOME`) y memoria `-Xmx3072m` (`PENTAHO_DI_JAVA_OPTIONS`).
- Driver JDBC: `mysql-connector-j-8.4.0.jar` copiado en `data-integration/lib`.
- Conexión de PDI: `dw_bi_secop` (tipo MySQL, opciones `allowPublicKeyRetrieval=true`, `useSSL=false`, `serverTimezone=America/Bogota`).
- **Ningún archivo del repositorio contiene contraseñas.** Cada integrante define estas variables en `%USERPROFILE%\.kettle\kettle.properties`:
  ```
  DB_HOST=localhost
  DB_PORT=3306
  DB_NAME=bi_secop
  DB_USER=bi_etl
  DB_PASS=********
  PROJECT_DIR=C:/ruta/a/bi-proyecto-equipo506222712
  ```

## Ubicación esperada de las fuentes (`${PROJECT_DIR}/datos/raw/`)
| Fuente | Archivo | Paso de lectura |
|---|---|---|
| F1 | `F1_secop2_contratos_cundinamarca_2023_2025.csv` | CSV file input |
| F2 | `F2_secop2_procesos_cundinamarca.json` | JSON input |
| F3 | `anex-IPC-sep2026.xlsx` (hoja 13) | Microsoft Excel input |

F1 y F2 superan 50 MB: no se suben (ver `.gitignore`) y se obtienen con `python datos/descargar_fuentes.py` (detalle en `datos/descarga.md`).

## Orden de ejecución
1. En MySQL, sobre una base vacía: `dw/ddl/01_crear_base.sql` → `02_dimensiones.sql` → `03_fact_contrato.sql` → `04_poblar_dim_tiempo.sql`, y crear el usuario `bi_etl` con permisos sobre `bi_secop`.
2. En PDI, ejecutar `etl/trabajos/j_carga_completa.kjb`, que corre en orden:
   1. `t_dim_tiempo_ipc.ktr` (F3 → `dim_tiempo.ipc_indice_mes`)
   2. `t_dim_entidad.ktr` (F1 → `dim_entidad`)
   3. `t_dim_modalidad.ktr` (F1 → `dim_modalidad`)
   4. `t_dim_objeto_contractual.ktr` (F1 → `dim_objeto_contractual`)
   5. `t_dim_proveedor.ktr` (F1 → `dim_proveedor`, con anonimización SHA-256)
   6. `t_fact_contrato.ktr` (F1 + F2 + dimensiones → `fact_contrato`, con *truncate*)
3. Conciliación: `dw/conciliacion/01_conteos_dw.sql`, `02_totales_dw.sql` y `python dw/conciliacion/03_totales_fuente.py`.
4. Tablero: abrir `dashboard/tablero_secop.pbix` (conexión ODBC al DSN `bi_secop`, controlador MySQL ODBC Unicode).
