-- 05_pred_valor_mensual.sql
-- Entrega 3. Tabla de predicciones del modelo elegido y ampliacion de dim_tiempo a 2026 para recibir el pronostico.
-- Se puede ejecutar varias veces sin error (INSERT IGNORE y CREATE TABLE IF NOT EXISTS).
-- El notebook modelo/modelo_predictivo.ipynb la ejecuta automaticamente antes de guardar las predicciones.
USE bi_secop;

SET SESSION cte_max_recursion_depth = 5000;

-- 1. Ampliar dim_tiempo con los 365 dias de 2026 (sin IPC, porque son meses futuros)
INSERT IGNORE INTO dim_tiempo (fecha_key, fecha, dia, nombre_dia, mes, nombre_mes, trimestre, anio)
WITH RECURSIVE calendario (f) AS (
    SELECT DATE('2026-01-01')
    UNION ALL
    SELECT f + INTERVAL 1 DAY FROM calendario WHERE f < '2026-12-31'
)
SELECT YEAR(f) * 10000 + MONTH(f) * 100 + DAY(f),
       f,
       DAY(f),
       ELT(DAYOFWEEK(f), 'Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'),
       MONTH(f),
       ELT(MONTH(f), 'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto',
                     'Septiembre','Octubre','Noviembre','Diciembre'),
       QUARTER(f),
       YEAR(f)
FROM calendario;

-- 2. Tabla de predicciones. Grano = una entidad en un mes (fecha_key = primer dia del mes).
CREATE TABLE IF NOT EXISTS pred_valor_mensual (
  pred_id                  BIGINT        NOT NULL AUTO_INCREMENT,
  entidad_key              INT           NOT NULL,
  fecha_key                INT           NOT NULL,
  anio                     SMALLINT      NOT NULL,
  mes                      TINYINT       NOT NULL,
  tipo                     VARCHAR(20)   NOT NULL,
  valor_real_millones      DECIMAL(18,2) NULL,
  valor_predicho_millones  DECIMAL(18,2) NOT NULL,
  error_abs_millones       DECIMAL(18,2) NULL,
  promedio_hist_millones   DECIMAL(18,2) NULL,
  modelo                   VARCHAR(60)   NOT NULL,
  fecha_ejecucion          DATETIME      NOT NULL,
  CONSTRAINT pk_pred_valor_mensual PRIMARY KEY (pred_id),
  CONSTRAINT uq_pred_valor_mensual UNIQUE (entidad_key, fecha_key, tipo),
  CONSTRAINT fk_pred_entidad FOREIGN KEY (entidad_key) REFERENCES dim_entidad (entidad_key),
  CONSTRAINT fk_pred_tiempo  FOREIGN KEY (fecha_key)   REFERENCES dim_tiempo (fecha_key)
) ENGINE=InnoDB;
