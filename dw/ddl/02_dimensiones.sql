-- 02_dimensiones.sql
-- Dimensiones del modelo en estrella. Llaves subrogadas (AUTO_INCREMENT) y llave de la fuente como atributo.
-- Cada dimensión tiene el miembro desconocido con llave -1.
USE bi_secop;

CREATE TABLE dim_tiempo (
  fecha_key        INT          NOT NULL,          -- aaaammdd (-1 = desconocida)
  fecha            DATE         NOT NULL,
  dia              TINYINT      NOT NULL,
  nombre_dia       VARCHAR(10)  NOT NULL,
  mes              TINYINT      NOT NULL,
  nombre_mes       VARCHAR(12)  NOT NULL,
  trimestre        TINYINT      NOT NULL,
  anio             SMALLINT     NOT NULL,
  ipc_indice_mes   DECIMAL(8,2) NULL,              -- IPC de servicios del mes (F3), lo llena PDI
  CONSTRAINT pk_dim_tiempo PRIMARY KEY (fecha_key)
) ENGINE=InnoDB;

CREATE TABLE dim_entidad (
  entidad_key          INT          NOT NULL AUTO_INCREMENT,
  nit_entidad          VARCHAR(20)  NOT NULL,      -- llave de la fuente (F1.nit_entidad)
  nombre_entidad       VARCHAR(255) NOT NULL,
  orden                VARCHAR(40),
  sector               VARCHAR(100),
  rama                 VARCHAR(40),
  entidad_centralizada VARCHAR(40),
  ciudad               VARCHAR(80),
  departamento         VARCHAR(60),
  CONSTRAINT pk_dim_entidad PRIMARY KEY (entidad_key),
  CONSTRAINT uq_dim_entidad UNIQUE (nit_entidad, nombre_entidad(150))
) ENGINE=InnoDB;

CREATE TABLE dim_proveedor (
  proveedor_key    INT          NOT NULL AUTO_INCREMENT,
  proveedor_hash   CHAR(64)     NOT NULL,          -- SHA-256 del documento (llave anónima de la fuente)
  nombre_proveedor VARCHAR(255) NULL,              -- solo personas jurídicas
  tipo_documento   VARCHAR(60),
  tipo_persona     VARCHAR(10),                    -- Natural / Jurídica
  es_pyme          VARCHAR(12),
  es_grupo         VARCHAR(12),
  CONSTRAINT pk_dim_proveedor PRIMARY KEY (proveedor_key),
  CONSTRAINT uq_dim_proveedor UNIQUE (proveedor_hash)
) ENGINE=InnoDB;

CREATE TABLE dim_modalidad (
  modalidad_key            INT          NOT NULL AUTO_INCREMENT,
  modalidad_contratacion   VARCHAR(120) NOT NULL,
  justificacion_modalidad  VARCHAR(255) NOT NULL,
  tipo_seleccion           VARCHAR(20)  NOT NULL,   -- Competitiva / No competitiva
  CONSTRAINT pk_dim_modalidad PRIMARY KEY (modalidad_key),
  CONSTRAINT uq_dim_modalidad UNIQUE (modalidad_contratacion, justificacion_modalidad(150))
) ENGINE=InnoDB;

CREATE TABLE dim_objeto_contractual (
  objeto_key        INT         NOT NULL AUTO_INCREMENT,
  codigo_unspsc     VARCHAR(12) NOT NULL,          -- sin el prefijo «V1.»
  clase_unspsc      CHAR(6),
  familia_unspsc    CHAR(4),
  segmento_unspsc   CHAR(2),
  tipo_de_contrato  VARCHAR(80) NOT NULL,
  CONSTRAINT pk_dim_objeto PRIMARY KEY (objeto_key),
  CONSTRAINT uq_dim_objeto UNIQUE (codigo_unspsc, tipo_de_contrato)
) ENGINE=InnoDB;

-- Miembros desconocidos (-1)
INSERT INTO dim_tiempo VALUES (-1, '1900-01-01', 0, 'N/D', 0, 'N/D', 0, 0, NULL);
INSERT INTO dim_entidad (entidad_key, nit_entidad, nombre_entidad, orden, sector, rama, entidad_centralizada, ciudad, departamento)
  VALUES (-1, 'N/D', 'Desconocida', 'N/D', 'N/D', 'N/D', 'N/D', 'Desconocida', 'N/D');
INSERT INTO dim_proveedor (proveedor_key, proveedor_hash, nombre_proveedor, tipo_documento, tipo_persona, es_pyme, es_grupo)
  VALUES (-1, REPEAT('0', 64), 'Desconocido', 'N/D', 'N/D', 'N/D', 'N/D');
INSERT INTO dim_modalidad (modalidad_key, modalidad_contratacion, justificacion_modalidad, tipo_seleccion)
  VALUES (-1, 'Desconocida', 'Desconocida', 'N/D');
INSERT INTO dim_objeto_contractual (objeto_key, codigo_unspsc, clase_unspsc, familia_unspsc, segmento_unspsc, tipo_de_contrato)
  VALUES (-1, 'N/D', NULL, NULL, NULL, 'Desconocido');
