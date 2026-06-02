-- ==========================================
-- TABLA: ROL
-- ==========================================
CREATE TABLE Rol (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion TEXT
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
-- TABLA: USUARIO
-- ==========================================
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    id_rol INT NOT NULL
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
    id_usuario INT UNIQUE
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
    id_categoria INT NOT NULL
);

-- ==========================================
-- TABLA: INVENTARIO
-- ==========================================

CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    stock_actual INT NOT NULL,
    stock_min INT NOT NULL,
    stock_max INT NOT NULL,
    ultima_actualizacion DATE NOT NULL
);

-- ==========================================
-- TABLA: COMPRA
-- ==========================================

CREATE TABLE Compra (
    id_compra SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20),
    observacion TEXT,
    id_proveedor INT NOT NULL,
    id_empleado INT NOT NULL
);

-- ==========================================
-- TABLA: COMPRA
-- ==========================================

CREATE TABLE Venta (
    id_venta SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    metodo_pago VARCHAR(50),
    estado VARCHAR(20),
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL
);

-- ==========================================
-- TABLA: Detalle_Compra
-- ==========================================

CREATE TABLE Detalle_Compra (
    id_detalle_c SERIAL PRIMARY KEY,
    cantidad INT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL
);

-- ==========================================
-- TABLA: Detalle_Venta
-- ==========================================

CREATE TABLE Detalle_Venta (
    id_detalle_v SERIAL PRIMARY KEY,
    cantidad INT NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    descuento NUMERIC(10,2) DEFAULT 0,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL
);

-- ==========================================
-- TABLA: Movimiento_Inventario
-- ==========================================

CREATE TABLE Movimiento_Inventario (
    id_mov SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    tipo_mov VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    observacion TEXT,

    id_inventario INT NOT NULL,
    id_compra INT,
    id_venta INT
);