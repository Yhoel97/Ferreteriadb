-- ==========================================
-- TABLA: ROL
-- ==========================================
CREATE TABLE Rol (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- ==========================================
-- TABLA: USUARIO
-- ==========================================
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    id_rol INT NOT NULL REFERENCES Rol(id_rol)
);

-- ==========================================
-- TABLA: EMPLEADO
-- ==========================================
CREATE TABLE Empleado (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    estado VARCHAR(20),
    id_usuario INT UNIQUE REFERENCES Usuario(id_usuario)
);

-- ==========================================
-- TABLA: CLIENTE
-- ==========================================
CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dui VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    tipo_cliente VARCHAR(50)
);

-- ==========================================
-- TABLA: PROVEEDOR
-- ==========================================
CREATE TABLE Proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(20)
);

-- ==========================================
-- TABLA: CATEGORIA
-- ==========================================
CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- ==========================================
-- TABLA: PRODUCTO
-- ==========================================
CREATE TABLE Producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_compra NUMERIC(10,2) NOT NULL,
    precio_venta NUMERIC(10,2) NOT NULL,
    unidad_medida VARCHAR(20),
    descripcion TEXT,
    id_categoria INT NOT NULL REFERENCES Categoria(id_categoria)
);

-- ==========================================
-- TABLA: INVENTARIO
-- ==========================================
CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INT NOT NULL UNIQUE REFERENCES Producto(id_producto),
    stock_actual INT NOT NULL DEFAULT 0,
    stock_min INT NOT NULL DEFAULT 0,
    stock_max INT NOT NULL,
    ultima_actualizacion DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ==========================================
-- TABLA: COMPRA (cabecera)
-- ==========================================
CREATE TABLE Compra (
    id_compra SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total NUMERIC(12,2) NOT NULL DEFAULT 0, -- se recalcula desde los detalles
    estado VARCHAR(20),
    observacion TEXT,
    id_proveedor INT NOT NULL REFERENCES Proveedor(id_proveedor),
    id_empleado INT NOT NULL REFERENCES Empleado(id_empleado)
);

-- ==========================================
-- TABLA: VENTA (cabecera)
-- ==========================================
CREATE TABLE Venta (
    id_venta SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total NUMERIC(12,2) NOT NULL DEFAULT 0, -- se recalcula desde los detalles
    metodo_pago VARCHAR(50),
    estado VARCHAR(20),
    id_cliente INT NOT NULL REFERENCES Cliente(id_cliente),
    id_empleado INT NOT NULL REFERENCES Empleado(id_empleado)
);

-- ==========================================
-- TABLA: Detalle_Compra (líneas)
-- ==========================================
CREATE TABLE Detalle_Compra (
    id_detalle_c SERIAL PRIMARY KEY,
    cantidad INT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(12,2) GENERATED ALWAYS AS (cantidad * precio) STORED,
    id_compra INT NOT NULL REFERENCES Compra(id_compra) ON DELETE CASCADE,
    id_producto INT NOT NULL REFERENCES Producto(id_producto)
);

-- ==========================================
-- TABLA: Detalle_Venta (líneas)
-- ==========================================
CREATE TABLE Detalle_Venta (
    id_detalle_v SERIAL PRIMARY KEY,
    cantidad INT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    descuento NUMERIC(10,2) DEFAULT 0,
    subtotal NUMERIC(12,2) GENERATED ALWAYS AS (cantidad * precio - descuento) STORED,
    id_venta INT NOT NULL REFERENCES Venta(id_venta) ON DELETE CASCADE,
    id_producto INT NOT NULL REFERENCES Producto(id_producto)
);

-- ==========================================
-- TABLA: Movimiento_Inventario (histórico)
-- ==========================================
CREATE TABLE Movimiento_Inventario (
    id_mov SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL DEFAULT now(),
    tipo_mov VARCHAR(20) NOT NULL CHECK (tipo_mov IN (
        'COMPRA','COMPRA-AJUSTE','COMPRA-ELIMINADA',
        'VENTA','VENTA-AJUSTE','VENTA-ELIMINADA'
    )),
    cantidad INT NOT NULL, -- positivo para compras, negativo para ventas
    observacion TEXT,
    id_inventario INT NOT NULL REFERENCES Inventario(id_inventario),
    id_compra INT REFERENCES Compra(id_compra),
    id_venta INT REFERENCES Venta(id_venta),
    id_producto INT NOT NULL REFERENCES Producto(id_producto),
    id_empleado INT REFERENCES Empleado(id_empleado)
);

-- ==========================================
-- Índices útiles
-- ==========================================
CREATE INDEX idx_mov_prod_fecha ON Movimiento_Inventario(id_producto, fecha);
CREATE INDEX idx_det_compra ON Detalle_Compra(id_compra);
CREATE INDEX idx_det_venta ON Detalle_Venta(id_venta);


--poblando la base de datos


-- ==========================================
-- TABLA: ROL
-- ==========================================
INSERT INTO Rol (nombre_rol, descripcion) VALUES
('Administrador', 'Acceso total al sistema'),
('Ventas', 'Acceso a módulos de ventas'),
('Bodega', 'Acceso a inventario y compras');

-- ==========================================
-- TABLA: USUARIO (3 usuarios)
-- ==========================================
INSERT INTO Usuario (nombre, contrasena, correo, id_rol) VALUES
('Carlos Admin', 'admin123', 'admin@empresa.com', 1), -- Administrador
('Lucía Vendedora', 'venta123', 'ventas@empresa.com', 2), -- Ventas
('Pedro Bodeguero', 'bodega123', 'bodega@empresa.com', 3); -- Bodega

-- ==========================================
-- TABLA: EMPLEADO (3 empleados vinculados a usuarios)
-- ==========================================
INSERT INTO Empleado (nombre, correo, telefono, estado, id_usuario) VALUES
('Carlos Admin', 'admin@empresa.com', '7000-0001', 'activo', 1),
('Lucía Vendedora', 'ventas@empresa.com', '7000-0002', 'activo', 2),
('Pedro Bodeguero', 'bodega@empresa.com', '7000-0003', 'activo', 3);

-- ==========================================
-- TABLA: CLIENTE (10 registros)
-- ==========================================
INSERT INTO Cliente (nombre, dui, correo, direccion, telefono, tipo_cliente) VALUES
('Juan Pérez', '12345678-9', 'juan@correo.com', 'San Salvador', '7100-0001', 'Minorista'),
('Ana Gómez', '12345678-8', 'ana@correo.com', 'Soyapango', '7100-0002', 'Mayorista'),
('Luis Martínez', '12345678-7', 'luis@correo.com', 'Mejicanos', '7100-0003', 'Minorista'),
('María López', '12345678-6', 'maria@correo.com', 'Ilopango', '7100-0004', 'Mayorista'),
('José Rivera', '12345678-5', 'jose@correo.com', 'Apopa', '7100-0005', 'Minorista'),
('Carmen Torres', '12345678-4', 'carmen@correo.com', 'Santa Tecla', '7100-0006', 'Mayorista'),
('Ricardo Hernández', '12345678-3', 'ricardo@correo.com', 'San Miguel', '7100-0007', 'Minorista'),
('Patricia Díaz', '12345678-2', 'patricia@correo.com', 'Usulután', '7100-0008', 'Mayorista'),
('Miguel Castillo', '12345678-1', 'miguel@correo.com', 'La Libertad', '7100-0009', 'Minorista'),
('Sofía Ramos', '12345678-0', 'sofia@correo.com', 'Sonsonate', '7100-0010', 'Mayorista');

-- ==========================================
-- TABLA: PROVEEDOR (10 registros)
-- ==========================================
INSERT INTO Proveedor (nombre, correo, direccion, telefono) VALUES
('Ferretería El Martillo', 'martillo@proveedor.com', 'San Salvador', '7200-0001'),
('Distribuidora Clavos', 'clavos@proveedor.com', 'Soyapango', '7200-0002'),
('Herramientas S.A.', 'herramientas@proveedor.com', 'Santa Tecla', '7200-0003'),
('ConstruMarket', 'constru@proveedor.com', 'San Miguel', '7200-0004'),
('Proveedora Industrial', 'industrial@proveedor.com', 'Usulután', '7200-0005'),
('MegaProveeduría', 'mega@proveedor.com', 'La Libertad', '7200-0006'),
('Suministros Globales', 'global@proveedor.com', 'Sonsonate', '7200-0007'),
('Materiales del Norte', 'norte@proveedor.com', 'Chalatenango', '7200-0008'),
('Acero y Más', 'acero@proveedor.com', 'San Vicente', '7200-0009'),
('Plásticos Unidos', 'plasticos@proveedor.com', 'Ahuachapán', '7200-0010');

-- ==========================================
-- TABLA: CATEGORIA (5 registros)
-- ==========================================
INSERT INTO Categoria (nombre) VALUES
('Herramientas'),
('Materiales'),
('Eléctricos'),
('Pinturas'),
('Seguridad');

-- ==========================================
-- TABLA: PRODUCTO (10 registros)
-- ==========================================
INSERT INTO Producto (nombre, precio_compra, precio_venta, unidad_medida, descripcion, id_categoria) VALUES
('Martillo', 5.00, 8.00, 'unidad', 'Martillo de acero', 1),
('Clavos caja', 2.00, 3.50, 'caja', 'Caja de clavos 100 unidades', 2),
('Destornillador', 3.00, 5.00, 'unidad', 'Destornillador plano', 1),
('Taladro', 50.00, 70.00, 'unidad', 'Taladro eléctrico', 3),
('Brocha', 1.50, 2.50, 'unidad', 'Brocha para pintar', 4),
('Pintura blanca', 10.00, 15.00, 'galón', 'Pintura látex blanca', 4),
('Guantes de seguridad', 4.00, 6.00, 'par', 'Guantes industriales', 5),
('Casco protector', 12.00, 18.00, 'unidad', 'Casco de seguridad', 5),
('Cable eléctrico', 20.00, 30.00, 'rollo', 'Cable calibre 12', 3),
('Lija', 0.50, 1.00, 'unidad', 'Lija para madera', 2);

-- ==========================================
-- TABLA: INVENTARIO (10 registros, uno por producto)
-- ==========================================
INSERT INTO Inventario (id_producto, stock_actual, stock_min, stock_max) VALUES
(1, 100, 10, 200),
(2, 200, 20, 500),
(3, 150, 15, 300),
(4, 50, 5, 100),
(5, 80, 10, 200),
(6, 60, 5, 150),
(7, 120, 10, 250),
(8, 40, 5, 100),
(9, 70, 10, 150),
(10, 300, 30, 600);

--poblando las compras y ventas

-- ==========================================
-- TABLA: COMPRA (5 registros)
-- ==========================================
INSERT INTO Compra (fecha, estado, observacion, id_proveedor, id_empleado)
VALUES
('2026-06-01', 'completada', 'Compra inicial de martillos', 1, 3),
('2026-06-02', 'completada', 'Compra de clavos y lijas', 2, 3),
('2026-06-03', 'pendiente', 'Compra de pintura blanca', 5, 3),
('2026-06-03', 'completada', 'Compra de guantes y cascos', 7, 3),
('2026-06-04', 'completada', 'Compra de cables eléctricos', 9, 3);

-- ==========================================
-- TABLA: DETALLE_COMPRA (máx 10 registros)
-- ==========================================
INSERT INTO Detalle_Compra (cantidad, precio, id_compra, id_producto)
VALUES
(20, 5.00, 1, 1), -- Martillos
(50, 2.00, 2, 2), -- Clavos
(100, 0.50, 2, 10), -- Lijas
(10, 10.00, 3, 6), -- Pintura blanca
(30, 4.00, 4, 7), -- Guantes
(15, 12.00, 4, 8), -- Cascos
(25, 20.00, 5, 9), -- Cables eléctricos
(10, 3.00, 2, 3), -- Destornilladores
(5, 50.00, 1, 4), -- Taladros
(40, 1.50, 3, 5); -- Brochas

-- ==========================================
-- TABLA: VENTA (5 registros)
-- ==========================================
INSERT INTO Venta (fecha, metodo_pago, estado, id_cliente, id_empleado)
VALUES
('2026-06-01', 'efectivo', 'completada', 1, 2),
('2026-06-02', 'tarjeta', 'completada', 2, 2),
('2026-06-02', 'efectivo', 'pendiente', 3, 2),
('2026-06-03', 'transferencia', 'completada', 4, 2),
('2026-06-04', 'efectivo', 'completada', 5, 2);

-- ==========================================
-- TABLA: DETALLE_VENTA (máx 10 registros)
-- ==========================================
INSERT INTO Detalle_Venta (cantidad, precio, descuento, id_venta, id_producto)
VALUES
(5, 8.00, 0, 1, 1), -- Martillos
(10, 3.50, 0.50, 2, 2), -- Clavos
(2, 70.00, 0, 3, 4), -- Taladro
(3, 15.00, 0, 4, 6), -- Pintura blanca
(4, 6.00, 0, 5, 7), -- Guantes
(2, 18.00, 0, 1, 8), -- Cascos
(1, 30.00, 0, 2, 9), -- Cable eléctrico
(20, 1.00, 0, 3, 10), -- Lijas
(6, 2.50, 0, 4, 5), -- Brochas
(3, 5.00, 0, 5, 3); -- Destornilladores

--poblada el movimiento inventario
-- Entradas por compras
INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_compra, id_producto, id_empleado)
VALUES
('COMPRA', 20, 'Ingreso de martillos', 1, 1, 1, 3),
('COMPRA', 50, 'Ingreso de clavos', 2, 2, 2, 3),
('COMPRA', 100, 'Ingreso de lijas', 10, 2, 10, 3);

-- Salidas por ventas
INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_venta, id_producto, id_empleado)
VALUES
('VENTA', -5, 'Venta de martillos', 1, 1, 1, 2),
('VENTA', -10, 'Venta de clavos', 2, 2, 2, 2),
('VENTA', -2, 'Venta de taladros', 4, 3, 4, 2);

--funcion trigger para detalles_compra

-- Función: actualiza inventario y registra movimiento al operar en detalle_compra
CREATE OR REPLACE FUNCTION fn_movimiento_compra()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- Movimiento de entrada
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_compra, id_producto, id_empleado)
    VALUES ('COMPRA', NEW.cantidad, 'Compra registrada',
            (SELECT id_inventario FROM Inventario WHERE id_producto = NEW.id_producto),
            NEW.id_compra, NEW.id_producto,
            (SELECT id_empleado FROM Compra WHERE id_compra = NEW.id_compra));

    -- Actualizar inventario
    UPDATE Inventario
    SET stock_actual = stock_actual + NEW.cantidad,
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = NEW.id_producto;

  ELSIF TG_OP = 'UPDATE' THEN
    -- Diferencia
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_compra, id_producto, id_empleado)
    VALUES ('COMPRA-AJUSTE', NEW.cantidad - OLD.cantidad, 'Ajuste de compra',
            (SELECT id_inventario FROM Inventario WHERE id_producto = NEW.id_producto),
            NEW.id_compra, NEW.id_producto,
            (SELECT id_empleado FROM Compra WHERE id_compra = NEW.id_compra));

    UPDATE Inventario
    SET stock_actual = stock_actual + (NEW.cantidad - OLD.cantidad),
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = NEW.id_producto;

  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_compra, id_producto, id_empleado)
    VALUES ('COMPRA-ELIMINADA', -OLD.cantidad, 'Detalle de compra eliminado',
            (SELECT id_inventario FROM Inventario WHERE id_producto = OLD.id_producto),
            OLD.id_compra, OLD.id_producto,
            (SELECT id_empleado FROM Compra WHERE id_compra = OLD.id_compra));

    UPDATE Inventario
    SET stock_actual = stock_actual - OLD.cantidad,
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = OLD.id_producto;
  END IF;

  RETURN NULL;
END;
$$;

-- Trigger: ejecuta la función en cada operación sobre detalle_compra
CREATE TRIGGER trg_movimiento_compra
AFTER INSERT OR UPDATE OR DELETE
ON Detalle_Compra
FOR EACH ROW
EXECUTE FUNCTION fn_movimiento_compra();

-- funcion trigger detalle_venta

-- Función: actualiza inventario y registra movimiento al operar en detalle_venta
CREATE OR REPLACE FUNCTION fn_movimiento_venta()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_venta, id_producto, id_empleado)
    VALUES ('VENTA', -NEW.cantidad, 'Venta registrada',
            (SELECT id_inventario FROM Inventario WHERE id_producto = NEW.id_producto),
            NEW.id_venta, NEW.id_producto,
            (SELECT id_empleado FROM Venta WHERE id_venta = NEW.id_venta));

    UPDATE Inventario
    SET stock_actual = stock_actual - NEW.cantidad,
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = NEW.id_producto;

  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_venta, id_producto, id_empleado)
    VALUES ('VENTA-AJUSTE', -(NEW.cantidad - OLD.cantidad), 'Ajuste de venta',
            (SELECT id_inventario FROM Inventario WHERE id_producto = NEW.id_producto),
            NEW.id_venta, NEW.id_producto,
            (SELECT id_empleado FROM Venta WHERE id_venta = NEW.id_venta));

    UPDATE Inventario
    SET stock_actual = stock_actual - (NEW.cantidad - OLD.cantidad),
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = NEW.id_producto;

  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO Movimiento_Inventario (tipo_mov, cantidad, observacion, id_inventario, id_venta, id_producto, id_empleado)
    VALUES ('VENTA-ELIMINADA', OLD.cantidad, 'Detalle de venta eliminado',
            (SELECT id_inventario FROM Inventario WHERE id_producto = OLD.id_producto),
            OLD.id_venta, OLD.id_producto,
            (SELECT id_empleado FROM Venta WHERE id_venta = OLD.id_venta));

    UPDATE Inventario
    SET stock_actual = stock_actual + OLD.cantidad,
        ultima_actualizacion = CURRENT_DATE
    WHERE id_producto = OLD.id_producto;
  END IF;

  RETURN NULL;
END;
$$;

-- Trigger: ejecuta la función en cada operación sobre detalle_venta
CREATE TRIGGER trg_movimiento_venta
AFTER INSERT OR UPDATE OR DELETE
ON Detalle_Venta
FOR EACH ROW
EXECUTE FUNCTION fn_movimiento_venta();


-- Funciones para calcular totales

-- Función: recalcula total de compra
CREATE OR REPLACE FUNCTION fn_recalcular_total_compra()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE Compra
  SET total = (
    SELECT COALESCE(SUM(subtotal),0)
    FROM Detalle_Compra
    WHERE id_compra = COALESCE(NEW.id_compra, OLD.id_compra)
  )
  WHERE id_compra = COALESCE(NEW.id_compra, OLD.id_compra);

  RETURN NULL;
END;
$$;

CREATE TRIGGER trg_recalcular_total_compra
AFTER INSERT OR UPDATE OR DELETE
ON Detalle_Compra
FOR EACH ROW
EXECUTE FUNCTION fn_recalcular_total_compra();


-- Función: recalcula total de venta
CREATE OR REPLACE FUNCTION fn_recalcular_total_venta()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE Venta
  SET total = (
    SELECT COALESCE(SUM(subtotal),0)
    FROM Detalle_Venta
    WHERE id_venta = COALESCE(NEW.id_venta, OLD.id_venta)
  )
  WHERE id_venta = COALESCE(NEW.id_venta, OLD.id_venta);

  RETURN NULL;
END;
$$;

CREATE TRIGGER trg_recalcular_total_venta
AFTER INSERT OR UPDATE OR DELETE
ON Detalle_Venta
FOR EACH ROW
EXECUTE FUNCTION fn_recalcular_total_venta();


-- PROCEDIMIENTOS PARA REGISTRO DE COMPRAS

CREATE OR REPLACE FUNCTION sp_registrar_compra(
    p_id_proveedor INT,
    p_id_empleado INT,
    p_estado VARCHAR,
    p_observacion TEXT,
    p_detalles JSON -- array JSON con objetos {id_producto, cantidad, precio}
) RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_compra INT;
    v_item JSON;
    v_id_producto INT;
    v_cantidad INT;
    v_precio NUMERIC(10,2);
BEGIN
    -- 1) Insertar cabecera
    INSERT INTO Compra (fecha, estado, observacion, id_proveedor, id_empleado)
    VALUES (CURRENT_DATE, p_estado, p_observacion, p_id_proveedor, p_id_empleado)
    RETURNING id_compra INTO v_id_compra;

    -- 2) Insertar detalles (cada insert disparará triggers de inventario y movimiento)
    FOR v_item IN SELECT * FROM json_array_elements(p_detalles)
    LOOP
        v_id_producto := (v_item->>'id_producto')::INT;
        v_cantidad   := (v_item->>'cantidad')::INT;
        v_precio     := (v_item->>'precio')::NUMERIC;

        INSERT INTO Detalle_Compra (cantidad, precio, id_compra, id_producto)
        VALUES (v_cantidad, v_precio, v_id_compra, v_id_producto);
    END LOOP;

    -- 3) Recalcular total (trigger también lo hace, pero lo reforzamos aquí)
    UPDATE Compra
    SET total = (SELECT COALESCE(SUM(subtotal),0) FROM Detalle_Compra WHERE id_compra = v_id_compra)
    WHERE id_compra = v_id_compra;

    RETURN v_id_compra;
END;
$$;

-- PROCEDIMIENTOS PARA REGISTRAR LAS VENTAS

CREATE OR REPLACE FUNCTION sp_registrar_venta(
    p_id_cliente INT,
    p_id_empleado INT,
    p_metodo_pago VARCHAR,
    p_estado VARCHAR,
    p_detalles JSON -- array JSON con objetos {id_producto, cantidad, precio, descuento}
) RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_venta INT;
    v_item JSON;
    v_id_producto INT;
    v_cantidad INT;
    v_precio NUMERIC(10,2);
    v_descuento NUMERIC(10,2);
BEGIN
    -- 1) Insertar cabecera
    INSERT INTO Venta (fecha, metodo_pago, estado, id_cliente, id_empleado)
    VALUES (CURRENT_DATE, p_metodo_pago, p_estado, p_id_cliente, p_id_empleado)
    RETURNING id_venta INTO v_id_venta;

    -- 2) Insertar detalles (cada insert disparará triggers de inventario y movimiento)
    FOR v_item IN SELECT * FROM json_array_elements(p_detalles)
    LOOP
        v_id_producto := (v_item->>'id_producto')::INT;
        v_cantidad   := (v_item->>'cantidad')::INT;
        v_precio     := (v_item->>'precio')::NUMERIC;
        v_descuento  := COALESCE((v_item->>'descuento')::NUMERIC,0);

        INSERT INTO Detalle_Venta (cantidad, precio, descuento, id_venta, id_producto)
        VALUES (v_cantidad, v_precio, v_descuento, v_id_venta, v_id_producto);
    END LOOP;

    -- 3) Recalcular total
    UPDATE Venta
    SET total = (SELECT COALESCE(SUM(subtotal),0) FROM Detalle_Venta WHERE id_venta = v_id_venta)
    WHERE id_venta = v_id_venta;

    RETURN v_id_venta;
END;
$$;

-- JOBS DE AVISO DE STOCK MINIMO

CREATE OR REPLACE FUNCTION sp_aviso_stock_minimo()
RETURNS TABLE (
    id_producto INT,
    nombre_producto VARCHAR,
    stock_actual INT,
    stock_min INT,
    mensaje TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id_producto,
        p.nombre,
        i.stock_actual,
        i.stock_min,
        '⚠️ Stock en nivel mínimo o inferior'
    FROM Inventario i
    JOIN Producto p ON p.id_producto = i.id_producto
    WHERE i.stock_actual <= i.stock_min;
END;
$$;

--PROCEDIMIENTO

-- Procedimiento de auditoría de inventario
CREATE OR REPLACE PROCEDURE sp_auditar_inventario()
LANGUAGE plpgsql
AS $$
DECLARE
    v_inconsistencias INT;
BEGIN
    -- Limpia auditoría del día (opcional)
    DELETE FROM Auditoria_Inventario WHERE fecha::date = CURRENT_DATE;

    -- Inserta resultados de comparación
    INSERT INTO Auditoria_Inventario (id_producto, stock_inventario, stock_movimientos, diferencia, observacion)
    SELECT
        i.id_producto,
        i.stock_actual,
        COALESCE(SUM(m.cantidad),0) AS stock_movimientos,
        i.stock_actual - COALESCE(SUM(m.cantidad),0) AS diferencia,
        CASE
            WHEN i.stock_actual = COALESCE(SUM(m.cantidad),0) THEN '✅ Todo está bien'
            ELSE '⚠️ Inconsistencia detectada'
        END AS observacion
    FROM Inventario i
    LEFT JOIN Movimiento_Inventario m ON m.id_producto = i.id_producto
    GROUP BY i.id_producto, i.stock_actual;

    -- Contar inconsistencias
    SELECT COUNT(*) INTO v_inconsistencias
    FROM Auditoria_Inventario
    WHERE fecha::date = CURRENT_DATE
      AND observacion LIKE '⚠️%';

    -- Aviso en consola/log
    IF v_inconsistencias = 0 THEN
        RAISE NOTICE '✅ Auditoría completada: todo está bien, no se detectaron inconsistencias.';
    ELSE
        RAISE NOTICE '⚠️ Auditoría completada: se detectaron % inconsistencias.', v_inconsistencias;
    END IF;
END;
$$;


--se crea una tabla para auditoria para llevar un control de ello

CREATE TABLE Auditoria_Inventario (
    id_auditoria SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL DEFAULT now(),
    id_producto INT NOT NULL REFERENCES Producto(id_producto),
    stock_inventario INT NOT NULL,
    stock_movimientos INT NOT NULL,
    diferencia INT NOT NULL,
    observacion TEXT
);


-- CREACION DE VISTAS

-- Vista de inventario con estado de stock

CREATE OR REPLACE VIEW vw_inventario_estado AS
SELECT 
    p.id_producto,
    p.nombre AS producto,
    i.stock_actual,
    i.stock_min,
    i.stock_max,
    CASE 
        WHEN i.stock_actual <= i.stock_min THEN '⚠️ En nivel mínimo'
        ELSE 'OK'
    END AS estado_stock
FROM Inventario i
JOIN Producto p ON p.id_producto = i.id_producto;

--vista  de compras con totales y proveedores

CREATE OR REPLACE VIEW vw_compras AS
SELECT 
    c.id_compra,
    c.fecha,
    pr.nombre AS proveedor,
    e.nombre AS empleado,
    c.total,
    c.estado,
    c.observacion
FROM Compra c
JOIN Proveedor pr ON pr.id_proveedor = c.id_proveedor
JOIN Empleado e ON e.id_empleado = c.id_empleado;

-- Vista de ventas con cliente y total

CREATE OR REPLACE VIEW vw_ventas AS
SELECT 
    v.id_venta,
    v.fecha,
    cl.nombre AS cliente,
    e.nombre AS empleado,
    v.total,
    v.metodo_pago,
    v.estado
FROM Venta v
JOIN Cliente cl ON cl.id_cliente = v.id_cliente
JOIN Empleado e ON e.id_empleado = v.id_empleado;

-- Vista de movimiento de inventario

CREATE OR REPLACE VIEW vw_movimientos_inventario AS
SELECT 
    m.id_mov,
    m.fecha,
    m.tipo_mov,
    m.cantidad,
    p.nombre AS producto,
    e.nombre AS empleado,
    COALESCE(c.id_compra, v.id_venta) AS id_documento,
    CASE 
        WHEN m.id_compra IS NOT NULL THEN 'Compra'
        WHEN m.id_venta IS NOT NULL THEN 'Venta'
        ELSE 'Otro'
    END AS origen
FROM Movimiento_Inventario m
JOIN Producto p ON p.id_producto = m.id_producto
LEFT JOIN Compra c ON c.id_compra = m.id_compra
LEFT JOIN Venta v ON v.id_venta = m.id_venta
LEFT JOIN Empleado e ON e.id_empleado = m.id_empleado;

--------------------------------------------------------------
--------------------------------------------------------------
-- 					PRUEBAS REALIZADAS 
--------------------------------------------------------------
--------------------------------------------------------------

--vamos a insertar una compra

--verificacmos el inventario antes de actualizar y despues actualizado
select * from Inventario where id_producto=4;

select sp_registrar_compra(
4, --id del proveedor
3, --id empleado (bodega)
'completada',
'compra de taladros',
'[{"id_producto":4, "cantidad":10, "precio":55.00}]'
);

-- Verificar movimiento registrado
SELECT * FROM vw_movimientos_inventario WHERE producto = 1 ORDER BY fecha DESC;

-- Verificar total recalculado en cabecera
SELECT * FROM vw_compras ORDER BY id_compra DESC;


-- vamos a realizar una venta

-- Insertar una venta de prueba
SELECT sp_registrar_venta(
    1, -- id_cliente
    2, -- id_empleado (ventas)
    'efectivo',
    'completada',
    '[{"id_producto":1,"cantidad":2,"precio":8.00,"descuento":0}]'
);

-- Verificar inventario actualizado
SELECT * FROM Inventario WHERE id_producto = 1;

-- Verificar movimiento registrado
SELECT * FROM vw_movimientos_inventario WHERE id_producto = 1 ORDER BY fecha DESC;

-- Verificar total recalculado en cabecera
SELECT * FROM vw_ventas ORDER BY id_venta DESC;

------------------------------------------------
-- pruebas de procedimientos
------------------------------------------------

-- Ejecutar el procedimiento
CALL sp_auditar_inventario();

-- Consultar resultados en la tabla de auditoría
SELECT * FROM Auditoria_Inventario ORDER BY fecha DESC;


-- Ejecutar alerta
SELECT * FROM sp_aviso_stock_minimo();

------------------------------------------------
-- pruebas de vistas
------------------------------------------------

-- Inventario con estado
SELECT * FROM vw_inventario_estado;

-- Compras con proveedor
SELECT * FROM vw_compras;

-- Ventas con cliente
SELECT * FROM vw_ventas;

-- Movimientos de inventario
SELECT * FROM vw_movimientos_inventario ORDER BY fecha DESC;



