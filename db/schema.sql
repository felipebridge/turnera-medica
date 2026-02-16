-- Base de datos: Turnera Médica


CREATE DATABASE IF NOT EXISTS turnera_medica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE turnera_medica;

-- Tabla usuario

CREATE TABLE IF NOT EXISTS usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  tipo ENUM('MEDICO', 'PACIENTE', 'ADMIN') NOT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT uk_usuario_username UNIQUE (username)
) ENGINE=InnoDB;


-- Tabla consultorio

CREATE TABLE IF NOT EXISTS consultorio (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) NOT NULL,
  piso VARCHAR(10),
  descripcion VARCHAR(200),
  CONSTRAINT uk_consultorio_numero UNIQUE (numero)
) ENGINE=InnoDB;


-- Tabla obra_social

CREATE TABLE IF NOT EXISTS obra_social (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  descuento DOUBLE NOT NULL DEFAULT 0,
  CONSTRAINT uk_obra_social_nombre UNIQUE (nombre)
) ENGINE=InnoDB;


-- Tabla medico

CREATE TABLE IF NOT EXISTS medico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  nombre VARCHAR(80) NOT NULL,
  apellido VARCHAR(80) NOT NULL,
  matricula VARCHAR(30) NOT NULL,
  especialidad VARCHAR(120),
  honorario DOUBLE NOT NULL DEFAULT 0,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT uk_medico_matricula UNIQUE (matricula),
  CONSTRAINT fk_medico_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuario(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_medico_apellido ON medico(apellido);


-- Tabla paciente

CREATE TABLE IF NOT EXISTS paciente (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  nombre VARCHAR(80) NOT NULL,
  apellido VARCHAR(80) NOT NULL,
  dni VARCHAR(20) NOT NULL,
  telefono VARCHAR(30),
  email VARCHAR(120),
  obra_social_id INT,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT uk_paciente_dni UNIQUE (dni),
  CONSTRAINT fk_paciente_usuario
    FOREIGN KEY (usuario_id)
    REFERENCES usuario(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_paciente_obra_social
    FOREIGN KEY (obra_social_id)
    REFERENCES obra_social(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_paciente_obra_social ON paciente(obra_social_id);


-- Tabla turno

CREATE TABLE IF NOT EXISTS turno (
  id INT AUTO_INCREMENT PRIMARY KEY,
  medico_id INT NOT NULL,
  paciente_id INT NOT NULL,
  consultorio_id INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  estado ENUM('PENDIENTE', 'CANCELADO', 'ATENDIDO') NOT NULL DEFAULT 'PENDIENTE',
  observacion VARCHAR(255),
  CONSTRAINT uk_turno_medico_fecha_hora UNIQUE (medico_id, fecha, hora),
  CONSTRAINT fk_turno_medico
    FOREIGN KEY (medico_id)
    REFERENCES medico(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_turno_paciente
    FOREIGN KEY (paciente_id)
    REFERENCES paciente(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_turno_consultorio
    FOREIGN KEY (consultorio_id)
    REFERENCES consultorio(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_turno_fecha ON turno(fecha);
CREATE INDEX idx_turno_medico_fecha ON turno(medico_id, fecha);
