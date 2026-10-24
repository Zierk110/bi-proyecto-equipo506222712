# bi-proyecto-equipo506222712 – Vigilancia de la contratación pública en Cundinamarca (SECOP II)

Proyecto final del curso Business Intelligence – Fundación Universitaria Konrad Lorenz (docente: Leandro Pájaro Fuentes).

Caso verosímil: la Unidad de Analítica para el Control Fiscal de una contraloría departamental necesita priorizar
las auditorías del Plan de Vigilancia y Control Fiscal 2027 con indicadores de la contratación 2023–2025 de las
entidades de Cundinamarca.

## Integrantes
| Nombre | Código |
|---|---|
| Luis Alfredo Bañol Falla | 506222712 |
| Juan Camilo Londoño Cifuentes | 507241030 |
| Jennifer Urueña Gutiérrez | 507241702 |

## Herramientas
Python  · draw.io · GitHub

## Fuentes (detalle en datos/descarga.md)
| Id | Fuente | Formato |
|---|---|---|
| F1 | SECOP II – Contratos Electrónicos (datos.gov.co, jbjy-vk9h) | CSV |
| F2 | SECOP II – Procesos de Contratación (datos.gov.co, p6dx-8zbt) | JSON |
| F3 | DANE – IPC, anexo sep. 2026, hoja 13 (IPC de servicios) | XLSX |

## Cómo reproducir
1. Descargar el anexo XLSX del IPC del DANE en `datos/raw/`.
2. `pip install pandas requests openpyxl`
3. `python datos/descargar_fuentes.py` → descarga F1 y F2 en `datos/raw`.
4. `python datos/perfilar.py` → genera `datos/muestras` y `datos/perfilamiento.md`.

Entrega 1: `docs/entregas/BI-Entrega-1-Equipo506222712.pdf`.

Los archivos completos de F1 y F2 superan el límite de tamaño de GitHub; se regeneran con el script.
