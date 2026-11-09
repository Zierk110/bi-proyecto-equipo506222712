-- 03_fact_contrato.sql
-- Tabla de hechos. Grano: un contrato electrónico firmado por una entidad de Cundinamarca.
USE bi_secop;

CREATE TABLE fact_contrato (
  contrato_sk               BIGINT        NOT NULL AUTO_INCREMENT,
  fecha_firma_key           INT           NOT NULL,
  entidad_key               INT           NOT NULL,
  proveedor_key             INT           NOT NULL,
  modalidad_key             INT           NOT NULL,
  objeto_key                INT           NOT NULL,
  id_contrato               VARCHAR(40)   NOT NULL,   -- dimensión degenerada
  proceso_de_compra         VARCHAR(40),              -- dimensión degenerada (cruce con F2)
  estado_contrato           VARCHAR(40),              -- dimensión degenerada
  valor_contrato            DECIMAL(18,2) NOT NULL,
  valor_contrato_constante  DECIMAL(18,2),
  valor_pagado              DECIMAL(18,2),
  duracion_dias             INT,
  dias_publicacion_a_firma  INT,
  conteo_contratos          TINYINT       NOT NULL DEFAULT 1,
  CONSTRAINT pk_fact_contrato PRIMARY KEY (contrato_sk),
  CONSTRAINT uq_fact_id_contrato UNIQUE (id_contrato),
  CONSTRAINT fk_fact_tiempo    FOREIGN KEY (fecha_firma_key) REFERENCES dim_tiempo (fecha_key),
  CONSTRAINT fk_fact_entidad   FOREIGN KEY (entidad_key)     REFERENCES dim_entidad (entidad_key),
  CONSTRAINT fk_fact_proveedor FOREIGN KEY (proveedor_key)   REFERENCES dim_proveedor (proveedor_key),
  CONSTRAINT fk_fact_modalidad FOREIGN KEY (modalidad_key)   REFERENCES dim_modalidad (modalidad_key),
  CONSTRAINT fk_fact_objeto    FOREIGN KEY (objeto_key)      REFERENCES dim_objeto_contractual (objeto_key)
) ENGINE=InnoDB;
