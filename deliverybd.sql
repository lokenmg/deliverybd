CREATE TABLE genero (
  id_genero SERIAL PRIMARY KEY,
  genero varchar(30)
);

CREATE TABLE categoria (
  id_categoria SERIAL PRIMARY KEY,
  categoria varchar(60)
);

CREATE TABLE estado_pago (
  id_estado SERIAL PRIMARY KEY,
  estado_pago varchar(25) NOT NULL
);

CREATE TABLE tipo_pago (
  id_tipo SERIAL PRIMARY KEY,
  tipo_pago varchar(25)
);

CREATE TABLE estado_pedido (
  id_estado SERIAL PRIMARY KEY,
  estado_pedido varchar(25)
);

CREATE TABLE vehiculo (
  id_vehiculo SERIAL PRIMARY KEY,
  placa varchar(7) NOT NULL,
  marca varchar(80) NOT NULL,
  tipo varchar(80) NOT NULL,
  modelo varchar(80) NOT NULL,
  repube varchar(100) NOT NULL,
  niv varchar(17) NOT NULL
);

CREATE TABLE direccion (
  id_direccion SERIAL PRIMARY KEY,
  cp int NOT NULL,
  estado varchar(30) NOT NULL,
  municipio varchar(80) NOT NULL,
  colonia varchar(80) NOT NULL,
  calle1 varchar(100) NOT NULL,
  calle2 varchar(100),
  calle3 varchar(100),
  referencia text,
  nomeroext varchar(25) NOT NULL,
  nomeroint varchar(25)
);

CREATE TABLE encargado (
  id_encargado SERIAL PRIMARY KEY,
  nombre varchar(40) NOT NULL,
  apellidos varchar(100) NOT NULL,
  email varchar(120) NOT NULL,
  genero int,
  curp varchar(100) NOT NULL,
  ine varchar(100) NOT NULL,
  antecedentes varchar(100) NOT NULL,
  FOREIGN KEY (genero) REFERENCES genero (id_genero)
);

CREATE TABLE tienda (
  id_tienda SERIAL PRIMARY KEY,
  nombre varchar(60) NOT NULL,
  direccion int NOT NULL,
  telefono varchar(30) NOT NULL,
  email varchar(120) NOT NULL,
  descripcion text NOT NULL,
  horarios varchar(100),
  encargado int,
  calificacion decimal(3,2),
  FOREIGN KEY (direccion) REFERENCES direccion (id_direccion),
  FOREIGN KEY (encargado) REFERENCES encargado (id_encargado)
);

CREATE TABLE productos (
  id_producto SERIAL PRIMARY KEY,
  nombre varchar(120) NOT NULL,
  precio decimal(8,2) NOT NULL,
  descripcion text,
  imagen varchar(100),
  stock int,
  descuento decimal(5,2),
  tienda int,
  FOREIGN KEY (tienda) REFERENCES tienda (id_tienda)
);

CREATE TABLE categoria_producto (
  id_categoria int,
  id_producto int,
  PRIMARY KEY (id_categoria, id_producto),
  FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),
  FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

CREATE TABLE repartidor (
  id_repartidor SERIAL PRIMARY KEY,
  nombre varchar(80) NOT NULL,
  apellidos varchar(100) NOT NULL,
  fecha_nacimiento date NOT NULL,
  genero int NOT NULL,
  telefono varchar(30) NOT NULL,
  email varchar(120) NOT NULL,
  contraseña varchar(120) NOT NULL,
  licencia varchar(100) NOT NULL,
  curp varchar(100) NOT NULL,
  antecedentes_penales varchar(100) NOT NULL,
  vehiculo int,
  ine varchar(100) NOT NULL,
  FOREIGN KEY (genero) REFERENCES genero (id_genero),
  FOREIGN KEY (vehiculo) REFERENCES vehiculo (id_vehiculo)
);

CREATE TABLE usuario (
  id_usuario SERIAL PRIMARY KEY,
  nombre varchar(80) NOT NULL,
  apellidos varchar(120) NOT NULL,
  feha_nacimiento date NOT NULL,
  genero int,
  email varchar(120) NOT NULL,
  contraseña varchar(120),
  telefono varchar(30) NOT NULL,
  direccion int,
  foto_perfil varchar(100),
  FOREIGN KEY (genero) REFERENCES genero (id_genero),
  FOREIGN KEY (direccion) REFERENCES direccion (id_direccion)
);

CREATE TABLE nota_venta (
  n_venta SERIAL PRIMARY KEY,
  fecha_creacion date NOT NULL,
  cliente int,
  estado_pago int,
  estado_pedido int,
  repartidor int,
  tipo_pago int,
  total decimal(8,2),
  FOREIGN KEY (cliente) REFERENCES usuario (id_usuario),
  FOREIGN KEY (estado_pago) REFERENCES estado_pago (id_estado),
  FOREIGN KEY (estado_pedido) REFERENCES estado_pedido (id_estado),
  FOREIGN KEY (repartidor) REFERENCES repartidor (id_repartidor),
  FOREIGN KEY (tipo_pago) REFERENCES tipo_pago (id_tipo)
);

CREATE TABLE detalle_venta (
  id_detalle SERIAL PRIMARY KEY,
  cantidad int NOT NULL,
  id_producto int,
  n_venta int,
  subtotal decimal(8,2),
  FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
  FOREIGN KEY (n_venta) REFERENCES nota_venta (n_venta)
);

-- Insertar datos en las tablas

INSERT INTO genero (genero) VALUES
('Masculino'),
('Femenino');

INSERT INTO categoria (categoria) VALUES
('Electrónica'),
('Ropa');

INSERT INTO estado_pago (estado_pago) VALUES
('Pagado'),
('Pendiente');

INSERT INTO tipo_pago (tipo_pago) VALUES
('Tarjeta de Crédito'),
('PayPal');

INSERT INTO estado_pedido (estado_pedido) VALUES
('En Proceso'),
('Enviado');

INSERT INTO vehiculo (placa, marca, tipo, modelo, repube, niv) VALUES
('ABC1234', 'Toyota', 'Sedán', 'Corolla', '1234567890', '1HGCM82633A123456'),
('XYZ5678', 'Honda', 'Motocicleta', 'CBR', '0987654321', '2HGCM82633A123456');

INSERT INTO direccion (cp, estado, municipio, colonia, calle1, calle2, calle3, referencia, nomeroext, nomeroint) VALUES
(12345, 'Estado A', 'Municipio A', 'Colonia A', 'Calle 1', 'Calle 2', 'Calle 3', 'Referencia A', 'No Ext 1', 'No Int 1'),
(54321, 'Estado B', 'Municipio B', 'Colonia B', 'Calle 4', 'Calle 5', 'Calle 6', 'Referencia B', 'No Ext 2', 'No Int 2');

INSERT INTO encargado (nombre, apellidos, email, genero, curp, ine, antecedentes) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 1, 'JUPE800101HDFRNN08', '1234567890123', 'Ninguno'),
('María', 'García', 'maria.garcia@example.com', 2, 'MAGA850202MDFRNN09', '9876543210987', 'Ninguno');

INSERT INTO tienda (nombre, direccion, telefono, email, descripcion, horarios, encargado, calificacion) VALUES
('TechStore', 1, '5551234567', 'info@techstore.com', 'Tienda de electrónica', 'Lunes a Viernes 9am - 6pm', 1, 4.50),
('ModaChic', 2, '5557654321', 'contact@modachic.com', 'Tienda de ropa', 'Lunes a Sábado 10am - 8pm', 2, 4.20);

INSERT INTO productos (nombre, precio, descripcion, imagen, stock, descuento, tienda) VALUES
('Laptop', 15000.00, 'Laptop de alta gama', 'laptop.jpg', 10, 10.00, 1),
('Camiseta', 300.00, 'Camiseta de algodón', 'camiseta.jpg', 50, 5.00, 2);

INSERT INTO categoria_producto (id_categoria, id_producto) VALUES
(1, 1),
(2, 2);

INSERT INTO repartidor (nombre, apellidos, fecha_nacimiento, genero, telefono, email, contraseña, licencia, curp, antecedentes_penales, vehiculo, ine) VALUES
('Carlos', 'Hernández', '1990-05-21', 1, '5559876543', 'carlos.hernandez@example.com', 'password123', '1234567890', 'CAHE900521HDFRNR05', 'Ninguno', 1, '1234567890123'),
('Ana', 'Martínez', '1988-08-15', 2, '5558765432', 'ana.martinez@example.com', 'password456', '0987654321', 'ANMA880815MDFRNR08', 'Ninguno', 2, '9876543210987');

INSERT INTO usuario (nombre, apellidos, feha_nacimiento, genero, email, contraseña, telefono, direccion, foto_perfil) VALUES
('Pedro', 'López', '1995-03-10', 1, 'pedro.lopez@example.com', 'password789', '5551231234', 1, 'pedro.jpg'),
('Laura', 'Rodríguez', '1992-07-25', 2, 'laura.rodriguez@example.com', 'password012', '5553213214', 2, 'laura.jpg');

INSERT INTO nota_venta (fecha_creacion, cliente, estado_pago, estado_pedido, repartidor, tipo_pago, total) VALUES
('2024-05-01', 1, 1, 1, 1, 1, 15000.00),
('2024-05-02', 2, 2, 2, 2, 2, 900.00);

INSERT INTO detalle_venta (cantidad, id_producto, n_venta, subtotal) VALUES
(1, 1, 1, 13500.00),
(3, 2, 2, 900.00);
