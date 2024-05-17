-- Borrar la base de datos si ya existe
DROP DATABASE IF EXISTS "Delibery";

-- Crear la base de datos
CREATE DATABASE "Delibery"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_MX.UTF-8'
    LC_CTYPE = 'es_MX.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Conectar a la base de datos
\c Delibery

-- Crear las tablas con PK bigint
CREATE TABLE "genero" (
  "id_genero" BIGINT NOT NULL PRIMARY KEY,
  "genero" varchar(30)
);

CREATE TABLE "categoria" (
  "id_categoria" BIGINT NOT NULL PRIMARY KEY,
  "categoria" varchar(60)
);

CREATE TABLE "estado_pago" (
  "id_estado" BIGINT NOT NULL PRIMARY KEY,
  "estado_pago" varchar(25) NOT NULL
);

CREATE TABLE "tipo_pago" (
  "id_tipo" BIGINT NOT NULL PRIMARY KEY,
  "tipo_pago" varchar(25)
);

CREATE TABLE "estado_pedido" (
  "id_estado" BIGINT NOT NULL PRIMARY KEY,
  "estado_pedido" varchar(25)
);

CREATE TABLE "vehiculo" (
  "id_vehiculo" BIGINT NOT NULL PRIMARY KEY,
  "placa" varchar(7) NOT NULL,
  "marca" varchar(80) NOT NULL,
  "tipo" varchar(80) NOT NULL,
  "modelo" varchar(80) NOT NULL,
  "repube" varchar(100) NOT NULL,
  "niv" varchar(17) NOT NULL
);

CREATE TABLE "direccion" (
  "id_direccion" BIGINT NOT NULL PRIMARY KEY,
  "cp" int NOT NULL,
  "estado" varchar(30) NOT NULL,
  "municipio" varchar(80) NOT NULL,
  "colonia" varchar(80) NOT NULL,
  "calle1" varchar(100) NOT NULL,
  "calle2" varchar(100),
  "calle3" varchar(100),
  "referencia" text,
  "nomeroext" varchar(25) NOT NULL,
  "nomeroint" varchar(25)
);

CREATE TABLE "encargado" (
  "id_usuario" BIGINT NOT NULL PRIMARY KEY,
  "nombre" varchar(40) NOT NULL,
  "apellidos" varchar(100) NOT NULL,
  "email" varchar(120) NOT NULL,
  "password" varchar(120) NOT NULL, 
  "genero" BIGINT,
  "curp" varchar(100) NOT NULL,
  "ine" varchar(100) NOT NULL,
  "antecedentes" varchar(100) NOT NULL,
  "direccion" BIGINT
);

CREATE TABLE "tienda" (
  "id_tienda" BIGINT NOT NULL PRIMARY KEY,
  "nombre" varchar(60) NOT NULL,
  "direccion" BIGINT NOT NULL,
  "telefono" varchar(30) NOT NULL,
  "email" varchar(120) NOT NULL,
  "descripcion" text NOT NULL,
  "horarios" varchar(100),
  "encargado" BIGINT,
  "calificacion" decimal(3,2)
);

CREATE TABLE "productos" (
  "id_producto" BIGINT NOT NULL PRIMARY KEY,
  "nombre" varchar(120) NOT NULL,
  "precio" decimal(8,2) NOT NULL,
  "descripcion" text,
  "imagen" varchar(100),
  "stock" int,
  "descuento" decimal(5,2),
  "tienda" BIGINT
);

CREATE TABLE "categoria_producto" (
  "id_categoria" BIGINT,
  "id_producto" BIGINT,
  PRIMARY KEY ("id_categoria", "id_producto")
);

CREATE TABLE "repartidor" (
  "id_usuario" BIGINT NOT NULL PRIMARY KEY,
  "nombre" varchar(80) NOT NULL,
  "apellidos" varchar(100) NOT NULL,
  "fecha_nacimiento" date NOT NULL,
  "genero" BIGINT NOT NULL,
  "telefono" varchar(30) NOT NULL,
  "email" varchar(120) NOT NULL,
  "password" varchar(120) NOT NULL,
  "licencia" varchar(100) NOT NULL,
  "curp" varchar(100) NOT NULL,
  "antecedentes_penales" varchar(100) NOT NULL,
  "vehiculo" BIGINT,
  "ine" varchar(100) NOT NULL,
  "direccion" BIGINT
);

CREATE TABLE "usuario" (
  "id_usuario" BIGINT NOT NULL PRIMARY KEY,
  "nombre" varchar(80) NOT NULL,
  "apellidos" varchar(120) NOT NULL,
  "fecha_nacimiento" date NOT NULL,
  "genero" BIGINT,
  "email" varchar(120) NOT NULL,
  "password" varchar(120),
  "telefono" varchar(30) NOT NULL,
  "direccion" BIGINT NOT NULL,
  "foto_perfil" varchar(100)
);

CREATE TABLE "nota_venta" (
  "n_venta" BIGINT NOT NULL PRIMARY KEY,
  "fecha_creacion" date NOT NULL,
  "cliente" BIGINT,
  "estado_pago" BIGINT,
  "estado_pedido" BIGINT,
  "repartidor" BIGINT,
  "tipo_pago" BIGINT,
  "total" decimal(8,2)
);

CREATE TABLE "detalle_venta" (
  "id_detalle" BIGINT NOT NULL PRIMARY KEY,
  "cantidad" int NOT NULL,
  "id_producto" BIGINT,
  "n_venta" BIGINT,
  "subtotal" decimal(8,2)
);

-- Añadir relaciones de claves foráneas
ALTER TABLE "encargado" ADD FOREIGN KEY ("genero") REFERENCES "genero" ("id_genero");
ALTER TABLE "encargado" ADD FOREIGN KEY ("direccion") REFERENCES "direccion" ("id_direccion");

ALTER TABLE "tienda" ADD FOREIGN KEY ("direccion") REFERENCES "direccion" ("id_direccion");
ALTER TABLE "tienda" ADD FOREIGN KEY ("encargado") REFERENCES "encargado" ("id_usuario");

ALTER TABLE "productos" ADD FOREIGN KEY ("tienda") REFERENCES "tienda" ("id_tienda");

ALTER TABLE "categoria_producto" ADD FOREIGN KEY ("id_categoria") REFERENCES "categoria" ("id_categoria");
ALTER TABLE "categoria_producto" ADD FOREIGN KEY ("id_producto") REFERENCES "productos" ("id_producto");

ALTER TABLE "repartidor" ADD FOREIGN KEY ("genero") REFERENCES "genero" ("id_genero");
ALTER TABLE "repartidor" ADD FOREIGN KEY ("vehiculo") REFERENCES "vehiculo" ("id_vehiculo");
ALTER TABLE "repartidor" ADD FOREIGN KEY ("direccion") REFERENCES "direccion" ("id_direccion");

ALTER TABLE "usuario" ADD FOREIGN KEY ("genero") REFERENCES "genero" ("id_genero");
ALTER TABLE "usuario" ADD FOREIGN KEY ("direccion") REFERENCES "direccion" ("id_direccion");

ALTER TABLE "nota_venta" ADD FOREIGN KEY ("cliente") REFERENCES "usuario" ("id_usuario");
ALTER TABLE "nota_venta" ADD FOREIGN KEY ("estado_pago") REFERENCES "estado_pago" ("id_estado");
ALTER TABLE "nota_venta" ADD FOREIGN KEY ("estado_pedido") REFERENCES "estado_pedido" ("id_estado");
ALTER TABLE "nota_venta" ADD FOREIGN KEY ("repartidor") REFERENCES "repartidor" ("id_usuario");
ALTER TABLE "nota_venta" ADD FOREIGN KEY ("tipo_pago") REFERENCES "tipo_pago" ("id_tipo");

ALTER TABLE "detalle_venta" ADD FOREIGN KEY ("id_producto") REFERENCES "productos" ("id_producto");
ALTER TABLE "detalle_venta" ADD FOREIGN KEY ("n_venta") REFERENCES "nota_venta" ("n_venta");

-- Insertar datos en la tabla genero
INSERT INTO "genero" ("id_genero", "genero") VALUES
(1, 'Masculino'),
(2, 'Femenino'),
(3, 'No binario');

-- Insertar datos en la tabla categoria
INSERT INTO "categoria" ("id_categoria", "categoria") VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Alimentos');

-- Insertar datos en la tabla estado_pago
INSERT INTO "estado_pago" ("id_estado", "estado_pago") VALUES
(1, 'Pendiente'),
(2, 'Pagado'),
(3, 'Rechazado');

-- Insertar datos en la tabla tipo_pago
INSERT INTO "tipo_pago" ("id_tipo", "tipo_pago") VALUES
(1, 'Tarjeta de Crédito'),
(2, 'Tarjeta de Débito'),
(3, 'Efectivo');

-- Insertar datos en la tabla estado_pedido
INSERT INTO "estado_pedido" ("id_estado", "estado_pedido") VALUES
(1, 'Procesando'),
(2, 'En camino'),
(3, 'Entregado');

-- Insertar datos en la tabla vehiculo
INSERT INTO "vehiculo" ("id_vehiculo", "placa", "marca", "tipo", "modelo", "repube", "niv") VALUES
(1, 'ABC1234', 'Toyota', 'Sedán', 'Corolla', '12345', '1HGCM82633A123456'),
(2, 'XYZ5678', 'Honda', 'SUV', 'CR-V', '67890', '1HGCM82633A654321');

-- Insertar datos en la tabla direccion
INSERT INTO "direccion" ("id_direccion", "cp", "estado", "municipio", "colonia", "calle1", "calle2", "calle3", "referencia", "nomeroext", "nomeroint") VALUES
(1, 12345, 'Estado A', 'Municipio A', 'Colonia A', 'Calle 1', 'Calle 2', 'Calle 3', 'Referencia A', '123', '1A'),
(2, 67890, 'Estado B', 'Municipio B', 'Colonia B', 'Calle 4', 'Calle 5', NULL, 'Referencia B', '456', NULL);

-- Insertar datos en la tabla encargado
INSERT INTO "encargado" ("id_usuario", "nombre", "apellidos", "email", "genero", "curp", "ine", "antecedentes", "direccion", "password") VALUES
(1, 'Juan', 'Pérez', 'juan.perez@example.com', 1, 'CURP1234', 'INE1234', 'Sin antecedentes', 1, 'password123'),
(2, 'María', 'Gómez', 'maria.gomez@example.com', 2, 'CURP5678', 'INE5678', 'Sin antecedentes', 2, 'password456');

-- Insertar datos en la tabla tienda
INSERT INTO "tienda" ("id_tienda", "nombre", "direccion", "telefono", "email", "descripcion", "horarios", "encargado", "calificacion") VALUES
(1, 'Tienda A', 1, '1234567890', 'tienda.a@example.com', 'Descripción de Tienda A', '9:00-18:00', 1, 4.5),
(2, 'Tienda B', 2, '0987654321', 'tienda.b@example.com', 'Descripción de Tienda B', '10:00-19:00', 2, 4.2);

-- Insertar datos en la tabla productos
INSERT INTO "productos" ("id_producto", "nombre", "precio", "descripcion", "imagen", "stock", "descuento", "tienda") VALUES
(1, 'Producto A', 100.00, 'Descripción de Producto A', 'imagen_a.jpg', 50, 10.00, 1),
(2, 'Producto B', 200.00, 'Descripción de Producto B', 'imagen_b.jpg', 30, 15.00, 2);

-- Insertar datos en la tabla categoria_producto
INSERT INTO "categoria_producto" ("id_categoria", "id_producto") VALUES
(1, 1),
(2, 2);

-- Insertar datos en la tabla repartidor
INSERT INTO "repartidor" ("id_usuario", "nombre", "apellidos", "fecha_nacimiento", "genero", "telefono", "email", "password", "licencia", "curp", "antecedentes_penales", "vehiculo", "ine", "direccion") VALUES
(3, 'Carlos', 'López', '1990-01-01', 1, '1234567890', 'carlos.lopez@example.com', 'password123', 'LIC1234', 'CURP12345', 'Sin antecedentes', 1, 'INE12345', 1);

-- Insertar datos en la tabla usuario
INSERT INTO "usuario" ("id_usuario", "nombre", "apellidos", "fecha_nacimiento", "genero", "email", "password", "telefono", "direccion", "foto_perfil") VALUES
(4, 'Ana', 'Martínez', '1985-05-05', 2, 'ana.martinez@example.com', 'password456', '0987654321', 2, 'perfil_ana.jpg'),
(5, 'Luis', 'Hernández', '1978-08-08', 1, 'luis.hernandez@example.com', 'password789', '5678901234', 1, 'perfil_luis.jpg');

-- Insertar datos en la tabla nota_venta
INSERT INTO "nota_venta" ("n_venta", "fecha_creacion", "cliente", "estado_pago", "estado_pedido", "repartidor", "tipo_pago", "total") VALUES
(1, '2023-01-01', 4, 1, 1, 3, 1, 150.00),
(2, '2023-02-02', 5, 2, 2, 3, 2, 250.00);

-- Insertar datos en la tabla detalle_venta
INSERT INTO "detalle_venta" ("id_detalle", "cantidad", "id_producto", "n_venta", "subtotal") VALUES
(1, 2, 1, 1, 200.00),
(2, 1, 2, 2, 200.00);
