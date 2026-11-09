-- 02_totales_dw.sql  ·  Totales de métricas en el data warehouse, para comparar con la fuente
USE bi_secop;

SELECT COUNT(*)                      AS contratos,
       SUM(valor_contrato)           AS total_valor_contrato,
       SUM(valor_pagado)             AS total_valor_pagado,
       SUM(valor_contrato_constante) AS total_valor_constante
FROM fact_contrato;

-- Totales por año de firma (para revisar diferencias por periodo)
SELECT t.anio, COUNT(*) AS contratos, SUM(f.valor_contrato) AS total_valor_contrato
FROM fact_contrato f JOIN dim_tiempo t ON t.fecha_key = f.fecha_firma_key
GROUP BY t.anio ORDER BY t.anio;
