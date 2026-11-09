-- 01_crear_base.sql
-- Crea la base de datos del data warehouse (MySQL 8).
-- Ejecutar con un usuario administrador. Borra la base si existe, para cargar siempre sobre una base vacía.
DROP DATABASE IF EXISTS bi_secop;
CREATE DATABASE bi_secop CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE bi_secop;
