# Descarga y trazabilidad de fuentes
Alcance: entidades con departamento = Cundinamarca, contratos firmados entre el 01/01/2023 y el 31/12/2025.
Fecha de descarga de las tres fuentes: 23/10/2026. Registros: F1 = 137.016 contratos; F2 = 148.228 procesos (8.348 duplicados exactos); F3 = 36 meses usados. Detalle en `datos/perfilamiento.md`.

## F1 – SECOP II, Contratos Electrónicos (Colombia Compra Eficiente)
- Página: https://www.datos.gov.co/Estad-sticas-Nacionales/SECOP-II-Contratos-Electr-nicos/jbjy-vk9h
- Endpoint (CSV, SODA2): https://www.datos.gov.co/resource/jbjy-vk9h.csv
- Filtro: `departamento = 'Cundinamarca' AND fecha_de_firma between '2023-01-01T00:00:00' and '2025-12-31T23:59:59'`, paginado de 50.000.
- Licencia: ver pestaña «Acerca de».

## F2 – SECOP II, Procesos de Contratación (Colombia Compra Eficiente)
- Página: https://www.datos.gov.co/Estad-sticas-Nacionales/SECOP-II-Procesos-de-Contrataci-n/p6dx-8zbt
- Endpoint (JSON, SODA2): https://www.datos.gov.co/resource/p6dx-8zbt.json
- Filtro: `id_del_portafolio in (...)` con los procesos de F1, en lotes de 150.
- Licencia: ver pestaña «Acerca de».

## F3 – DANE, Índice de Precios al Consumidor
- Página: https://www.dane.gov.co/index.php/estadisticas-por-tema/precios-y-costos/indice-de-precios-al-consumidor-ipc
- Archivo: anexo XLSX publicado el 07/10/2026 (anex-IPC-sep2026.xlsx), guardado en datos/raw.
- Hoja usada: 13, índice mensual del IPC de servicios (base dic. 2018 = 100), ene-2009 a sep-2026; se usan los 36 meses de 2023–2025.
- Licencia: uso libre con atribución al DANE.
