# Diccionario F1 – SECOP II Contratos Electrónicos (jbjy-vk9h), CSV

| Campo | Tipo | Descripción | Ejemplo | Problema de calidad |
|---|---|---|---|---|
| nombre_entidad | Texto | Entidad que publica el contrato | ESE HOSPITAL SAN JOSE DE GUADUAS | Mayúsculas y sin tildes |
| nit_entidad | Número | NIT de la entidad | 860020283 | Sin dígito de verificación |
| departamento | Texto | Departamento de la entidad | Cundinamarca | Filtro del alcance |
| ciudad | Texto | Ciudad de la entidad | Guaduas | 12.586 «No Definido» |
| orden | Texto | Orden de la entidad | Territorial | — |
| sector | Texto | Sector de la entidad | Servicio Público | Minúsculas en «deportes» |
| proceso_de_compra | Texto | Código del proceso de origen | CO1.BDOS.7993212 | Llave de cruce con F2 |
| estado_contrato | Texto | Estado del contrato | En ejecución | «terminado», «cedido» |
| codigo_de_categoria_principal | Texto | Código UNSPSC del objeto | V1.85101500 | Prefijo «V1.» |
| tipo_de_contrato | Texto | Tipo de contrato | Prestación de servicios | — |
| modalidad_de_contratacion | Texto | Modalidad de selección | Contratación directa | Variantes «(con ofertas)» |
| fecha_de_firma | Texto (fecha) | Fecha de firma | 2025-04-21T00:00:00.000 | Texto con hora |
| fecha_de_inicio_del_contrato | Texto (fecha) | Inicio del contrato | AAAA-MM-DDT00:00:00.000 | 1.199 nulos |
| fecha_de_fin_del_contrato | Texto (fecha) | Fin del contrato | AAAA-MM-DDT00:00:00.000 | Texto con hora |
| tipodocproveedor | Texto | Tipo de documento del proveedor | Cédula de Ciudadanía | 124 «No Definido» |
| documento_proveedor | Texto | Documento del proveedor | (omitido por privacidad) | Dato personal: se anonimiza |
| proveedor_adjudicado | Texto | Nombre del proveedor | (omitido por privacidad) | Dato personal en personas naturales |
| es_pyme | Texto | Indicador de pyme | No | Texto Sí/No, no booleano |
| valor_del_contrato | Número | Valor del contrato en pesos | 45000000 | Pesos corrientes |
| valor_pagado | Número | Valor pagado a la fecha | 0 | Cambia con cada descarga |
