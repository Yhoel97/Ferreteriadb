-- Roles

INSERT INTO Rol (nombre_rol, descripcion)
VALUES
('Administrador', 'Control total del sistema'),
('Vendedor', 'Gestiona ventas y clientes'),
('Bodeguero', 'Gestiona inventario'),
('Gerente', 'Consulta reportes y estadísticas');

-- Categorias

INSERT INTO Categoria (nombre)
VALUES
('Herramientas'),
('Electricidad'),
('Pinturas'),
('Tornilleria'),
('Fontaneria');

-- Usuarios
-- Los roles creados tienen IDs del 1 al 4.

INSERT INTO Usuario (nombre, contrasena, correo, id_rol)
VALUES
('Juan Perez', 'admin123', 'juan@ferreteria.com', 1),
('Maria Lopez', 'venta123', 'maria@ferreteria.com', 2),
('Carlos Ruiz', 'bodega123', 'carlos@ferreteria.com', 3),
('Ana Martinez', 'gerencia123', 'ana@ferreteria.com', 4),
('Luis Gomez', 'venta456', 'luis@ferreteria.com', 2);

-- Empleados
--Los usuarios creados tendrán IDs del 1 al 5.

INSERT INTO Empleado (nombre, correo, telefono, estado, id_usuario)
VALUES
('Juan Perez', 'juan@ferreteria.com', '70000001', 'Activo', 1),
('Maria Lopez', 'maria@ferreteria.com', '70000002', 'Activo', 2),
('Carlos Ruiz', 'carlos@ferreteria.com', '70000003', 'Activo', 3),
('Ana Martinez', 'ana@ferreteria.com', '70000004', 'Activo', 4),
('Luis Gomez', 'luis@ferreteria.com', '70000005', 'Activo', 5);

-- Clientes

INSERT INTO Cliente (nombre, dui, correo, direccion, telefono, tipo_cliente)
VALUES
('Constructora El Salvador', '00000001-1', 'constructora@email.com', 'San Salvador', '71000001', 'Empresa'),
('Jose Hernandez', '00000002-2', 'jose@email.com', 'Santa Ana', '71000002', 'Frecuente'),
('Maria Torres', '00000003-3', 'maria@email.com', 'San Miguel', '71000003', 'Frecuente'),
('Taller Los Amigos', '00000004-4', 'taller@email.com', 'La Libertad', '71000004', 'Empresa'),
('Pedro Ramirez', '00000005-5', 'pedro@email.com', 'Sonsonate', '71000005', 'Ocasional');

-- Proveedores

INSERT INTO Proveedor (nombre, correo, direccion, telefono)
VALUES
('Truper', 'ventas@truper.com', 'Mexico', '22000001'),
('Stanley', 'contacto@stanley.com', 'Estados Unidos', '22000002'),
('Pinturas Corona', 'ventas@corona.com', 'El Salvador', '22000003'),
('ElectroDistribuidora', 'ventas@electro.com', 'San Salvador', '22000004'),
('FerreImport', 'info@ferreimport.com', 'Guatemala', '22000005');

-- Productos 
-- Las categorías tienen IDs del 1 al 5.

INSERT INTO Producto (
    nombre,
    precio_compra,
    precio_venta,
    unidad_medida,
    descripcion,
    id_categoria
)
VALUES
('Martillo', 5.00, 8.50, 'Unidad', 'Martillo de acero', 1),
('Taladro', 45.00, 60.00, 'Unidad', 'Taladro eléctrico', 1),
('Cable THHN', 0.50, 0.80, 'Metro', 'Cable eléctrico', 2),
('Pintura Blanca', 12.00, 18.00, 'Galon', 'Pintura para interiores', 3),
('Tornillo Phillips', 0.05, 0.10, 'Unidad', 'Tornillo galvanizado', 4);

-- Inventario
-- Los productos tienen IDs del 1 al 5.

INSERT INTO Inventario (
    id_producto,
    stock_actual,
    stock_min,
    stock_max,
    ultima_actualizacion
)
VALUES
(1, 50, 10, 100, CURRENT_DATE),
(2, 20, 5, 50, CURRENT_DATE),
(3, 200, 50, 500, CURRENT_DATE),
(4, 30, 10, 80, CURRENT_DATE),
(5, 1000, 100, 5000, CURRENT_DATE);

-- Prueba de insercion de datos, debe devolver 5 antes de seguir al siguiente bloque
SELECT COUNT(*) FROM Inventario;

-- BLOQUE 2 --

-- Creamos 5 compras porque tenemos 5 empleados y 5 proveedores
INSERT INTO Compra (
    fecha,
    total,
    estado,
    observacion,
    id_proveedor,
    id_empleado
)
VALUES
(CURRENT_DATE, 150.00, 'Recibida', 'Compra de herramientas', 1, 1),
(CURRENT_DATE, 300.00, 'Recibida', 'Compra de equipos electricos', 2, 2),
(CURRENT_DATE, 120.00, 'Recibida', 'Compra de pinturas', 3, 3),
(CURRENT_DATE, 200.00, 'Pendiente', 'Compra en proceso', 4, 4),
(CURRENT_DATE, 500.00, 'Recibida', 'Compra de tornilleria', 5, 5);

-- Tenemos 5 ventas al tener 5 clientes y 5 empleados 

INSERT INTO Venta (
    fecha,
    total,
    metodo_pago,
    estado,
    id_cliente,
    id_empleado
)
VALUES
(CURRENT_DATE, 25.00, 'Efectivo', 'Completada', 1, 2),
(CURRENT_DATE, 80.00, 'Tarjeta', 'Completada', 2, 2),
(CURRENT_DATE, 15.00, 'Efectivo', 'Completada', 3, 5),
(CURRENT_DATE, 60.00, 'Transferencia', 'Pendiente', 4, 2),
(CURRENT_DATE, 120.00, 'Tarjeta', 'Completada', 5, 5);

-- Detalle_Compra 
-- Una compra puede tener varios productos.

INSERT INTO Detalle_Compra (
    cantidad,
    precio,
    id_compra,
    id_producto
)
VALUES
(10, 5.00, 1, 1),
(5, 45.00, 2, 2),
(20, 0.50, 2, 3),
(8, 12.00, 3, 4),
(200, 0.05, 5, 5);

-- Detalle_Venta

INSERT INTO Detalle_Venta (
    cantidad,
    subtotal,
    descuento,
    id_venta,
    id_producto
)
VALUES
(2, 17.00, 0.00, 1, 1),
(1, 60.00, 0.00, 2, 2),
(10, 8.00, 0.00, 3, 3),
(3, 54.00, 0.00, 4, 4),
(50, 5.00, 0.00, 5, 5);

-- Movimiento_Inventario

-- Como el MER indica que un movimiento puede provenir de una compra o de una venta, 
-- podemos insertar ejemplos de ambos tipos.

INSERT INTO Movimiento_Inventario (
    tipo_mov,
    cantidad,
    fecha,
    observacion,
    id_inventario,
    id_compra,
    id_venta
)
VALUES
('Entrada', 10, CURRENT_DATE, 'Ingreso por compra', 1, 1, NULL),

('Entrada', 5, CURRENT_DATE, 'Ingreso por compra', 2, 2, NULL),

('Salida', 2, CURRENT_DATE, 'Venta realizada', 1, NULL, 1),

('Salida', 1, CURRENT_DATE, 'Venta realizada', 2, NULL, 2),

('Entrada', 200, CURRENT_DATE, 'Compra de tornillos', 5, 5, NULL);

-- Consulta para probar que la insercion fue correcta 

SELECT COUNT(*) FROM Compra;
SELECT COUNT(*) FROM Venta;
SELECT COUNT(*) FROM Detalle_Compra;
SELECT COUNT(*) FROM Detalle_Venta;
SELECT COUNT(*) FROM Movimiento_Inventario;

SELECT * FROM producto;