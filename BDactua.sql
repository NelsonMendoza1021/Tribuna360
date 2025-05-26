-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS tribuna360 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Usar la base de datos
USE tribuna360;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    equipo_favorito VARCHAR(100),
    tipo ENUM('abonado', 'administrador') NOT NULL DEFAULT 'abonado'
);

-- Tabla de clubes
CREATE TABLE clubes (
    id_club INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    escudo VARCHAR(255),
    ciudad VARCHAR(100) NOT NULL
);

-- Tabla de abonos
CREATE TABLE abonos (
    id_abono INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('activo', 'inactivo') NOT NULL DEFAULT 'activo',
    id_club INT,
    FOREIGN KEY (id_club) REFERENCES clubes(id_club)
);

-- Tabla de relación entre usuarios y abonos
CREATE TABLE usuario_abono (
    id_usuario INT,
    id_abono INT,
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_abono),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_abono) REFERENCES abonos(id_abono)
);

-- Tabla de boletos
CREATE TABLE boletos (
    id_boleto INT AUTO_INCREMENT PRIMARY KEY,
    fecha_partido DATE NOT NULL,
    estado ENUM('activo', 'utilizado', 'cancelado') DEFAULT 'activo',
    id_abono INT,
    FOREIGN KEY (id_abono) REFERENCES abonos(id_abono)
);

-- Tabla de pagos
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_abono INT,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),
    estado_transaccion ENUM('completado', 'fallido', 'pendiente') DEFAULT 'pendiente',
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_abono) REFERENCES abonos(id_abono)
);

CREATE TABLE localidad (
    id_localidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_club INT,
    FOREIGN KEY (id_club) REFERENCES clubes(id_club)
);

-- -----------------------------------------------------
-- INSERTS

-- Registro clubes
INSERT INTO clubes (nombre, ciudad) VALUES 
('Millonarios FC', 'Bogotá'),
('Atlético Nacional', 'Medellín'),
('América de Cali', 'Cali'),
('Club Independiente Santa Fe', 'Bogotá'),
('Club Atlético Bucaramanga', 'Bucaramanga'),
('Junior de Barranquilla', 'Barranquilla');

-- Registro abonos
INSERT INTO abonos (tipo, precio, fecha_inicio, fecha_fin, estado, id_club) VALUES
('Temporada completa', 350000, '2025-01-15', '2025-12-15', 'activo', 1), -- Millonarios FC
('Media temporada', 200000, '2025-07-01', '2025-12-15', 'activo', 2),     -- Atlético Nacional
('Abono VIP', 500000, '2025-01-15', '2025-12-15', 'activo', 3),           -- América de Cali
('Temporada completa', 340000, '2025-01-15', '2025-12-15', 'activo', 4), -- Santa Fe
('Media temporada', 180000, '2025-07-01', '2025-12-15', 'activo', 5),     -- Bucaramanga
('Abono familiar', 300000, '2025-01-15', '2025-12-15', 'activo', 6);      -- Junior de Barranquilla

-- Registro usuarios
INSERT INTO usuarios (nombre, correo, contrasena, fecha_nacimiento, equipo_favorito, tipo) VALUES
('Ashley Calderon', 'ashley.calderon@example.com', 'ashley2002', '2002-06-12', 'Millonarios FC', 'abonado'),
('Sergio Mariño', 'sergio.marino@example.com', 'sergio2000', '2000-11-02', 'América de Cali', 'abonado'),
('Nelson Mendoza', 'nelson.mendoza@example.com', 'nelson2001', '2001-03-25', 'Atlético Nacional', 'abonado'),
('Juan Herrera', 'juan.herrera@example.com', 'juan2000', '2000-08-19', 'Junior de Barranquilla', 'administrador');



-- Relacion usuario-abono
INSERT INTO usuario_abono (id_usuario, id_abono) VALUES
(1, 1);
INSERT INTO usuario_abono (id_usuario, id_abono) VALUES
(2, 3),
(2, 4);
INSERT INTO usuario_abono (id_usuario, id_abono) VALUES
(3, 2),
(3, 5),
(3, 6);



-- Pago de abonos
INSERT INTO pagos (id_usuario, id_abono, monto, metodo_pago, estado_transaccion) VALUES
(1, 1, 350000, 'tarjeta', 'completado');
INSERT INTO pagos (id_usuario, id_abono, monto, metodo_pago, estado_transaccion) VALUES
(2, 3, 500000, 'tarjeta', 'completado'),
(2, 4, 340000, 'tarjeta', 'completado');
INSERT INTO pagos (id_usuario, id_abono, monto, metodo_pago, estado_transaccion) VALUES
(3, 2, 200000, 'tarjeta', 'completado'),
(3, 5, 180000, 'tarjeta', 'completado'),
(3, 6, 300000, 'tarjeta', 'completado');

-- Boletos para el abono 
INSERT INTO boletos (fecha_partido, estado, id_abono) VALUES
('2025-07-10', 'activo', 1),
('2025-08-20', 'activo', 1);
INSERT INTO boletos (fecha_partido, estado, id_abono) VALUES
('2025-07-15', 'activo', 3),
('2025-09-05', 'activo', 3),
('2025-07-22', 'activo', 4);
INSERT INTO boletos (fecha_partido, estado, id_abono) VALUES
('2025-07-08', 'activo', 2),
('2025-08-18', 'activo', 5),
('2025-10-01', 'activo', 5),
('2025-09-12', 'activo', 6),
('2025-11-03', 'activo', 6);

-- Localidades
INSERT INTO localidad (nombre, id_club) VALUES
('Localidad Norte', 1),
('Localidad Sur', 1),

('Localidad Centro', 2),
('Localidad Oeste', 2),

('Localidad Este', 3),
('Localidad Norte', 3),

('Localidad Centro', 4),
('Localidad Sur', 4),

('Localidad Norte', 5),
('Localidad Este', 5),

('Localidad Sur', 6),
('Localidad Oeste', 6);


-- no se habian agregado la tablalocalidad
ALTER TABLE abonos
ADD COLUMN id_localidad INT,
ADD FOREIGN KEY (id_localidad) REFERENCES localidad(id_localidad);
