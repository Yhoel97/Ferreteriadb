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

