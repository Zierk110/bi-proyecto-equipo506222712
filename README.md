# bi-proyecto-equipo506222712 – Vigilancia de la contratación pública en Cundinamarca (SECOP II)

Proyecto final del curso Business Intelligence – Fundación Universitaria Konrad Lorenz (docente: Leandro Pájaro Fuentes).

Caso verosímil: la Unidad de Analítica para el Control Fiscal de una contraloría departamental prioriza las auditorías del
Plan de Vigilancia y Control Fiscal 2027 con indicadores de la contratación 2023–2025 de las entidades de Cundinamarca.

## Integrantes
| Nombre | Código |
|---|---|
| Luis Alfredo Bañol Falla | 506222712 |
| Juan Camilo Londoño Cifuentes | 507241030 |
| Jennifer Urueña Gutiérrez | 507241702 |

## Herramientas
MySQL 8.4 · DBeaver · Pentaho Data Integration 9.4 · Power BI Desktop · Python (pandas, scikit-learn, SQLAlchemy) · Jupyter · draw.io · GitHub

## Fuentes (detalle en `datos/descarga.md`)
| Id | Fuente | Formato |
|---|---|---|
| F1 | SECOP II – Contratos Electrónicos (datos.gov.co, jbjy-vk9h) | CSV |
| F2 | SECOP II – Procesos de Contratación (datos.gov.co, p6dx-8zbt) | JSON |
| F3 | DANE – IPC, anexo sep. 2026, hoja 13 (IPC de servicios) | XLSX |

## Cómo reproducir la solución
1. **Datos:** `pip install pandas requests openpyxl` y `python datos/descargar_fuentes.py` (F1 y F2 pesan más de 50 MB y no se suben). El anexo del IPC va en `datos/raw/`.
2. **Data warehouse (Entrega 2):** en MySQL 8.4 ejecutar `dw/ddl/01` a `04`, crear el usuario `bi_etl` y correr `etl/trabajos/j_carga_completa.kjb` en Pentaho (ver `etl/README.md`).
3. **Conciliación:** `dw/conciliacion/01_conteos_dw.sql`, `02_totales_dw.sql` y `python dw/conciliacion/03_totales_fuente.py`.
4. **Modelo predictivo (Entrega 3):**
   ```
   cd modelo
   pip install -r requirements.txt
   jupyter notebook modelo_predictivo.ipynb
   ```
   En Jupyter: **Kernel → Restart & Run All**. El notebook pide la contraseña de MySQL (o la lee de la variable de entorno `DB_PASS`), extrae los datos con `modelo/extraccion.sql`, entrena regresión lineal y bosque aleatorio, ejecuta `dw/ddl/05_pred_valor_mensual.sql` y guarda las predicciones en la tabla `pred_valor_mensual`. Las figuras quedan en `modelo/figuras/` y los resultados en `modelo/salidas/`.
5. **Tablero:** abrir `dashboard/tablero_secop.pbix` (conexión ODBC al DSN `bi_secop`) y **Actualizar**. La página «P4 · Predicciones» muestra el valor real de 2025 frente al predicho y el pronóstico de 2026.

## Entregas
`docs/entregas/`: BI-Entrega-1, BI-Entrega-2 y BI-Entrega-3 (PDF). Ninguna contraseña está en el repositorio.
