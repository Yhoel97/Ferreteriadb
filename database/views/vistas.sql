-- ============================================================================
-- 1. VISTA: Resumen de Ventas (vw_resumen_ventas)
-- ============================================================================
CREATE OR REPLACE VIEW vw_resumen_ventas AS
SELECT 
    v.id_venta AS factura_nro,
    v.fecha,
    c.nombre AS cliente,
    c.tipo_cliente,
    e.nombre AS vendedor,
    v.metodo_pago,
    v.estado,
    v.total
FROM Venta v
JOIN Cliente c ON v.id_cliente = c.id_cliente
JOIN Empleado e ON v.id_empleado = e.id_empleado;


-- ============================================================================
-- 2. VISTA: Alerta de Inventario Crítico (vw_alerta_inventario)
-- ============================================================================
CREATE OR REPLACE VIEW vw_alerta_inventario AS
SELECT 
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    i.stock_actual,
    i.stock_min,
    i.stock_max,
    (i.stock_max - i.stock_actual) AS cantidad_a_pedir
FROM Inventario i
JOIN Producto p ON i.id_producto = p.id_producto
JOIN Categoria c ON p.id_categoria = c.id_categoria
WHERE i.stock_actual <= i.stock_min;


-- ============================================================================
-- 3. VISTA: Detalle de Compras a Proveedores (vw_detalle_compras_proveedor)
-- ============================================================================
CREATE OR REPLACE VIEW vw_detalle_compras_proveedor AS
SELECT 
    co.id_compra AS pedido_nro,
    co.fecha,
    pr.nombre AS proveedor,
    p.nombre AS producto,
    dc.cantidad,
    dc.precio AS precio_compra_unitario,
    (dc.cantidad * dc.precio) AS subtotal_producto,
    co.estado AS estado_pedido
FROM Detalle_Compra dc
JOIN Compra co ON dc.id_compra = co.id_compra
JOIN Proveedor pr ON co.id_proveedor = pr.id_proveedor
JOIN Producto p ON dc.id_producto = p.id_producto;


-- ============================================================================
-- 4. VISTA: Organigrama de Usuarios y Empleados (vw_usuarios_empleados)
-- ============================================================================
CREATE OR REPLACE VIEW vw_usuarios_empleados AS
SELECT 
    e.id_empleado,
    e.nombre AS nombre_completo,
    u.correo AS usuario_login,
    r.nombre_rol AS rol_asignado,
    e.telefono,
    e.estado AS estado_empleado
FROM Empleado e
JOIN Usuario u ON e.id_usuario = u.id_usuario
JOIN Rol r ON u.id_rol = r.id_rol;