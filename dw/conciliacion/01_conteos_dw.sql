-- 01_conteos_dw.sql  ·  Conciliación de conteos en el data warehouse (MySQL 8)
USE bi_secop;

-- 1. Registros por tabla (sin contar el miembro desconocido -1)
SELECT 'dim_tiempo' AS tabla, COUNT(*) AS registros FROM dim_tiempo WHERE fecha_key > 0
UNION ALL SELECT 'dim_entidad',            COUNT(*) FROM dim_entidad            WHERE entidad_key   > 0
UNION ALL SELECT 'dim_proveedor',          COUNT(*) FROM dim_proveedor          WHERE proveedor_key > 0
UNION ALL SELECT 'dim_modalidad',          COUNT(*) FROM dim_modalidad          WHERE modalidad_key > 0
UNION ALL SELECT 'dim_objeto_contractual', COUNT(*) FROM dim_objeto_contractual WHERE objeto_key    > 0
UNION ALL SELECT 'fact_contrato',          COUNT(*) FROM fact_contrato;

-- 2. Hechos que quedaron apuntando al miembro desconocido (-1) por dimensión
SELECT SUM(fecha_firma_key = -1) AS sin_fecha,
       SUM(entidad_key     = -1) AS sin_entidad,
       SUM(proveedor_key   = -1) AS sin_proveedor,
       SUM(modalidad_key   = -1) AS sin_modalidad,
       SUM(objeto_key      = -1) AS sin_objeto
FROM fact_contrato;

-- 3. Contratos sin proceso en F2 (dias_publicacion_a_firma nulo)
SELECT COUNT(*) AS contratos_sin_proceso_en_f2
FROM fact_contrato WHERE dias_publicacion_a_firma IS NULL;

-- 4. Meses de dim_tiempo sin IPC (debe dar 0)
SELECT COUNT(DISTINCT anio, mes) AS meses_sin_ipc
FROM dim_tiempo WHERE fecha_key > 0 AND ipc_indice_mes IS NULL;
