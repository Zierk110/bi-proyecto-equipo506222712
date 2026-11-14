-- modelo/extraccion.sql
-- Conjunto de datos del modelo predictivo (Entrega 3), extraído del data warehouse bi_secop (MySQL 8.4).
-- Una fila por entidad y mes (enero de 2023 a diciembre de 2025): 350 entidades x 36 meses.
-- Une fact_contrato con dim_tiempo (mes de firma), dim_entidad (atributos de la entidad) y dim_modalidad (tipo de seleccion).
-- Los meses sin contratos se completan con cero (CROSS JOIN de entidades por meses + LEFT JOIN).
-- Filtra los miembros desconocidos (llave -1). Valores en millones de pesos constantes de diciembre de 2025.
WITH meses AS (
    SELECT DISTINCT anio, mes
    FROM dim_tiempo
    WHERE fecha_key > 0 AND anio BETWEEN 2023 AND 2025
),
agregado AS (
    SELECT f.entidad_key,
           t.anio,
           t.mes,
           COUNT(*)                         AS contratos,
           SUM(f.valor_contrato_constante)  AS valor,
           SUM(CASE WHEN m.tipo_seleccion = 'No competitiva'
                    THEN f.valor_contrato_constante ELSE 0 END) AS valor_directa
    FROM fact_contrato f
    JOIN dim_tiempo    t ON t.fecha_key     = f.fecha_firma_key
    JOIN dim_modalidad m ON m.modalidad_key = f.modalidad_key
    WHERE t.fecha_key > 0
    GROUP BY f.entidad_key, t.anio, t.mes
)
SELECT e.entidad_key,
       e.nombre_entidad,
       e.orden,
       e.sector,
       e.rama,
       e.entidad_centralizada,
       ms.anio,
       ms.mes,
       COALESCE(a.contratos, 0)                    AS contratos,
       COALESCE(a.valor, 0) / 1000000              AS valor_millones,
       COALESCE(a.valor_directa, 0) / 1000000      AS valor_directa_millones
FROM dim_entidad e
CROSS JOIN meses ms
LEFT JOIN agregado a
       ON a.entidad_key = e.entidad_key
      AND a.anio = ms.anio
      AND a.mes  = ms.mes
WHERE e.entidad_key > 0
ORDER BY e.entidad_key, ms.anio, ms.mes;
