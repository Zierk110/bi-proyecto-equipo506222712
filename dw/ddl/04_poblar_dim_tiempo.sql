-- 04_poblar_dim_tiempo.sql
-- Pobla dim_tiempo día a día del 01/01/2023 al 31/12/2025 (1.096 días, sin huecos).
-- El atributo ipc_indice_mes lo completa la transformación t_dim_tiempo_ipc.ktr con F3.
USE bi_secop;
SET SESSION cte_max_recursion_depth = 5000;

INSERT INTO dim_tiempo (fecha_key, fecha, dia, nombre_dia, mes, nombre_mes, trimestre, anio)
WITH RECURSIVE calendario (f) AS (
  SELECT DATE('2023-01-01')
  UNION ALL
  SELECT f + INTERVAL 1 DAY FROM calendario WHERE f < '2025-12-31'
)
SELECT CAST(DATE_FORMAT(f, '%Y%m%d') AS UNSIGNED),
       f,
       DAY(f),
       ELT(DAYOFWEEK(f), 'Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'),
       MONTH(f),
       ELT(MONTH(f), 'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto',
                     'Septiembre','Octubre','Noviembre','Diciembre'),
       QUARTER(f),
       YEAR(f)
FROM calendario;

-- Verificación: 1.096 días + miembro desconocido = 1.097 filas
SELECT COUNT(*) AS filas, MIN(fecha) AS desde, MAX(fecha) AS hasta
FROM dim_tiempo WHERE fecha_key > 0;
