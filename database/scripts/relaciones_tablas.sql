-- ==========================================
-- Relación 1: Usuario → Rol
-- ==========================================

ALTER TABLE Usuario
ADD CONSTRAINT fk_usuario_rol
FOREIGN KEY (id_rol)
REFERENCES Rol(id_rol);

-- ==========================================
-- Relación 2: Empleado → Usuario (1:1)
-- ==========================================

ALTER TABLE Empleado
ADD CONSTRAINT fk_empleado_usuario
FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_usuario);

-- ==========================================
-- Relación 3: Producto → Categoria
-- ==========================================

ALTER TABLE Producto
ADD CONSTRAINT fk_producto_categoria
FOREIGN KEY (id_categoria)
REFERENCES Categoria(id_categoria);

-- ==========================================
-- Relación 4: Inventario → Producto

-- Aquí está la relación 1:1.
-- ==========================================

--Primero agregamos la FK:

ALTER TABLE Inventario
ADD CONSTRAINT fk_inventario_producto
FOREIGN KEY (id_producto)
REFERENCES Producto(id_producto);

-- Luego garantizamos el 1:1:

ALTER TABLE Inventario
ADD CONSTRAINT uq_inventario_producto
UNIQUE (id_producto);

-- ==========================================
-- Relación 5: Compra → Proveedor
-- ==========================================

ALTER TABLE Compra
ADD CONSTRAINT fk_compra_proveedor
FOREIGN KEY (id_proveedor)
REFERENCES Proveedor(id_proveedor);


-- ==========================================
-- Relación 6: Compra → Empleado
-- ==========================================

ALTER TABLE Compra
ADD CONSTRAINT fk_compra_empleado
FOREIGN KEY (id_empleado)
REFERENCES Empleado(id_empleado);

-- ==========================================
-- Relación 7: Venta → Cliente
-- ==========================================

ALTER TABLE Venta
ADD CONSTRAINT fk_venta_cliente
FOREIGN KEY (id_cliente)
REFERENCES Cliente(id_cliente);

-- ==========================================
-- Relación 8: Venta → Empleado
-- ==========================================

ALTER TABLE Venta
ADD CONSTRAINT fk_venta_empleado
FOREIGN KEY (id_empleado)
REFERENCES Empleado(id_empleado);

-- ==========================================
-- Relación 9: Detalle_Compra → Compra
-- ==========================================

ALTER TABLE Detalle_Compra
ADD CONSTRAINT fk_detalle_compra_compra
FOREIGN KEY (id_compra)
REFERENCES Compra(id_compra);

-- ==========================================
-- Relación 10: Detalle_Compra → Producto
-- ==========================================

ALTER TABLE Detalle_Compra
ADD CONSTRAINT fk_detalle_compra_producto
FOREIGN KEY (id_producto)
REFERENCES Producto(id_producto);

-- ==========================================
-- Relación 11: Detalle_Venta → Venta
-- ==========================================

ALTER TABLE Detalle_Venta
ADD CONSTRAINT fk_detalle_venta_venta
FOREIGN KEY (id_venta)
REFERENCES Venta(id_venta);

-- ==========================================
-- Relación 12: Detalle_Venta → Producto
-- ==========================================

ALTER TABLE Detalle_Venta
ADD CONSTRAINT fk_detalle_venta_producto
FOREIGN KEY (id_producto)
REFERENCES Producto(id_producto);

-- ==========================================
-- Relación 13: Movimiento_Inventario → Inventario
-- ==========================================

ALTER TABLE Movimiento_Inventario
ADD CONSTRAINT fk_movimiento_inventario
FOREIGN KEY (id_inventario)
REFERENCES Inventario(id_inventario);

-- ==========================================
-- Relación 14: Movimiento_Inventario → Compra
-- ==========================================

ALTER TABLE Movimiento_Inventario
ADD CONSTRAINT fk_movimiento_compra
FOREIGN KEY (id_compra)
REFERENCES Compra(id_compra);

-- ==========================================
-- Relación 15: Movimiento_Inventario → Venta
-- ==========================================

ALTER TABLE Movimiento_Inventario
ADD CONSTRAINT fk_movimiento_venta
FOREIGN KEY (id_venta)
REFERENCES Venta(id_venta);