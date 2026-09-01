-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Filtramos con IS NULL para aislar los productos sin transacciones.
SELECT 
    p.producto_id,
    p.nombre AS producto_catalogo,
    p.categoria,
    v.venta_id
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos 
-- que no figuran en nuestro catálogo? (registro huérfano con producto_id = 999)
SELECT 
    v.venta_id,
    v.producto_id AS producto_id_en_ventas,
    v.cantidad,
    p.nombre AS nombre_en_catalogo
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestra 
-- todas las discordancias (tanto productos sin ventas como ventas con productos inexistentes).
SELECT 
    COALESCE(p.producto_id, v.producto_id) AS producto_id,
    p.nombre AS producto_catalogo,
    v.venta_id,
    v.cantidad
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL OR v.producto_id IS NULL;