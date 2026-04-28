CREATE DATABASE IF NOT EXISTS ecclesyum CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecclesyum;

-- 1. CATÁLOGOS Y TABLAS DE CONFIGURACIÓN
CREATE TABLE roles (
    id_role INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE jurisdicciones (
    id_jurisdiccion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE iglesia_tipos (
    id_iglesia_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE sacerdote_tipos (
    id_sacerdote_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE generos (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    estado TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE religiones (
    id_religion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    estado TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE ocupaciones (
    id_ocupacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE parentesco_tipos (
    id_parentesco_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    estado TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

-- 2. ESTRUCTURA DE IGLESIAS Y USUARIOS
CREATE TABLE iglesias (
    id_iglesia INT AUTO_INCREMENT PRIMARY KEY,
    id_jurisdiccion INT,
    id_iglesia_tipo INT,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    sitio_web VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_jurisdiccion) REFERENCES jurisdicciones(id_jurisdiccion),
    FOREIGN KEY (id_iglesia_tipo) REFERENCES iglesia_tipos(id_iglesia_tipo)
) ENGINE=InnoDB;

CREATE TABLE comunidades (
    id_comunidad INT AUTO_INCREMENT PRIMARY KEY,
    id_iglesia INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    direccion TEXT,
    contacto_nombre VARCHAR(100),
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia)
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_role INT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    activo TINYINT(1) DEFAULT 1,
    ultimo_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_role) REFERENCES roles(id_role)
) ENGINE=InnoDB;

-- 3. PERSONAS (Sacerdotes y Feligreses)
CREATE TABLE personas (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    id_genero INT,
    id_religion INT,
    id_ocupacion INT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cui_dpi VARCHAR(20) UNIQUE,
    fecha_nacimiento DATE,
    direccion TEXT,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_genero) REFERENCES generos(id_genero),
    FOREIGN KEY (id_religion) REFERENCES religiones(id_religion),
    FOREIGN KEY (id_ocupacion) REFERENCES ocupaciones(id_ocupacion)
) ENGINE=InnoDB;

CREATE TABLE sacerdotes (
    id_sacerdote INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_sacerdote_tipo INT,
    id_iglesia_asignada INT,
    fecha_ordenacion DATE,
    estado TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY (id_sacerdote_tipo) REFERENCES sacerdote_tipos(id_sacerdote_tipo),
    FOREIGN KEY (id_iglesia_asignada) REFERENCES iglesias(id_iglesia)
) ENGINE=InnoDB;

-- 4. RELACIONES Y OBSERVACIONES
CREATE TABLE feligres_relaciones (
    id_relacion INT AUTO_INCREMENT PRIMARY KEY,
    id_persona_principal INT NOT NULL,
    id_persona_relacionada INT NOT NULL,
    id_parentesco_tipo INT NOT NULL,
    notas_relacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_persona_principal) REFERENCES personas(id_persona),
    FOREIGN KEY (id_persona_relacionada) REFERENCES personas(id_persona),
    FOREIGN KEY (id_parentesco_tipo) REFERENCES parentesco_tipos(id_parentesco_tipo)
) ENGINE=InnoDB;

CREATE TABLE persona_observaciones (
    id_observacion INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_usuario INT NOT NULL,
    observacion TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

-- 5. SACRAMENTOS Y LIBROS
-- Tabla para centralizar los datos de inscripción en libros físicos
CREATE TABLE libros_registros (
    id_registro_libro INT AUTO_INCREMENT PRIMARY KEY,
    libro VARCHAR(20),
    folio VARCHAR(20),
    partida VARCHAR(20),
    inscrito_libro TINYINT(1) DEFAULT 0,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE bautismos (
    id_bautismo INT AUTO_INCREMENT PRIMARY KEY,
    id_feligres INT NOT NULL,
    id_sacerdote INT NOT NULL,
    id_iglesia INT NOT NULL,
    id_padre INT,
    id_madre INT,
    id_padrino INT,
    id_madrina INT,
    id_registro_libro INT,
    fecha_inscripcion DATE,
    fecha_sacramento DATE NOT NULL,
    lugar_sacramento VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_feligres) REFERENCES personas(id_persona),
    FOREIGN KEY (id_sacerdote) REFERENCES sacerdotes(id_sacerdote),
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia),
    FOREIGN KEY (id_padre) REFERENCES personas(id_persona),
    FOREIGN KEY (id_madre) REFERENCES personas(id_persona),
    FOREIGN KEY (id_padrino) REFERENCES personas(id_persona),
    FOREIGN KEY (id_madrina) REFERENCES personas(id_persona),
    FOREIGN KEY (id_registro_libro) REFERENCES libros_registros(id_registro_libro)
) ENGINE=InnoDB;

-- Estructuras similares para Comunion y Confirmacion
CREATE TABLE comuniones (
    id_comunion INT AUTO_INCREMENT PRIMARY KEY,
    id_feligres INT NOT NULL,
    id_sacerdote INT NOT NULL,
    id_iglesia INT NOT NULL,
    id_padrino_madrina INT,
    id_registro_libro INT,
    fecha_inscripcion DATE,
    fecha_sacramento DATE NOT NULL,
    lugar_sacramento VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_feligres) REFERENCES personas(id_persona),
    FOREIGN KEY (id_sacerdote) REFERENCES sacerdotes(id_sacerdote),
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia),
    FOREIGN KEY (id_padrino_madrina) REFERENCES personas(id_persona),
    FOREIGN KEY (id_registro_libro) REFERENCES libros_registros(id_registro_libro)
) ENGINE=InnoDB;

CREATE TABLE confirmaciones (
    id_confirmacion INT AUTO_INCREMENT PRIMARY KEY,
    id_feligres INT NOT NULL,
    id_sacerdote INT NOT NULL,
    id_iglesia INT NOT NULL,
    id_padrino_madrina INT,
    id_registro_libro INT,
    fecha_inscripcion DATE,
    fecha_sacramento DATE NOT NULL,
    lugar_sacramento VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_feligres) REFERENCES personas(id_persona),
    FOREIGN KEY (id_sacerdote) REFERENCES sacerdotes(id_sacerdote),
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia),
    FOREIGN KEY (id_padrino_madrina) REFERENCES personas(id_persona),
    FOREIGN KEY (id_registro_libro) REFERENCES libros_registros(id_registro_libro)
) ENGINE=InnoDB;

-- Matrimonios
CREATE TABLE matrimonio_estados (
    id_matrimonio_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE matrimonios (
    id_matrimonio INT AUTO_INCREMENT PRIMARY KEY,
    id_esposo INT NOT NULL,
    id_esposa INT NOT NULL,
    id_testigo1 INT,
    id_testigo2 INT,
    id_sacerdote INT NOT NULL,
    id_iglesia INT NOT NULL,
    id_registro_libro INT,
    id_estado INT,
    fecha_inscripcion DATE,
    fecha_sacramento DATE NOT NULL,
    papeleria_completa TINYINT(1) DEFAULT 0,
    cantidad_intentos INT DEFAULT 1,
    tiempo_relacion_valor INT,
    tiempo_relacion_unidad ENUM('Dias', 'Meses', 'Años'),
    observaciones_papeleria TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_esposo) REFERENCES personas(id_persona),
    FOREIGN KEY (id_esposa) REFERENCES personas(id_persona),
    FOREIGN KEY (id_testigo1) REFERENCES personas(id_persona),
    FOREIGN KEY (id_testigo2) REFERENCES personas(id_persona),
    FOREIGN KEY (id_sacerdote) REFERENCES sacerdotes(id_sacerdote),
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia),
    FOREIGN KEY (id_registro_libro) REFERENCES libros_registros(id_registro_libro),
    FOREIGN KEY (id_estado) REFERENCES matrimonio_estados(id_matrimonio_estado)
) ENGINE=InnoDB;

-- 6. AUDITORÍA Y CONSTANCIAS
CREATE TABLE registro_constancias (
    id_constancia INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_persona INT NOT NULL,
    tipo_sacramento ENUM('Bautismo', 'Comunion', 'Confirmacion', 'Matrimonio'),
    codigo_verificacion VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
) ENGINE=InnoDB;

CREATE TABLE bitacora (
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(100),
    tabla_afectada VARCHAR(50),
    id_registro_afectado INT,
    descripcion TEXT,
    antes JSON,
    despues JSON,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

-- 7. INSERTS DE DATOS INICIALES
INSERT INTO roles (nombre, descripcion) VALUES
('Administrador', 'Acceso total al sistema'),
('Parroco', 'Gestión de sacramentos y feligresía'),
('Vicario', 'Gestión de sacramentos'),
('Sacristan', 'Apoyo administrativo'),
('Catequista', 'Gestión de comunidades y formación'),
('Feligres', 'Acceso limitado a información personal');

INSERT INTO jurisdicciones (nombre) VALUES
('Diócesis de Sololá-Chimaltenango'),
('Arquidiócesis de Santiago de Guatemala');

INSERT INTO iglesia_tipos (nombre) VALUES
('Parroquia'), ('Cuasiparroquia'), ('Catedral'), ('Concatedral');

INSERT INTO sacerdote_tipos (nombre) VALUES
('Párroco'), ('Vicario'), ('Capellán'), ('Adscrito');

INSERT INTO generos (nombre) VALUES ('Masculino'), ('Femenino'), ('No Especifica');

INSERT INTO parentesco_tipos (nombre) VALUES
('Padre'), ('Madre'), ('Padrino'), ('Madrina'), ('Testigo');

INSERT INTO matrimonio_estados (nombre) VALUES ('Novios'), ('Unidos');

-- Modoficaciones Posteriores: Creadas 28/04/2026


CREATE TABLE personas_imagenes (
    id_persona_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    ruta VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(150),
    es_principal TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
) ENGINE=InnoDB;


CREATE TABLE iglesias_imagenes (
    id_iglesia_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_iglesia INT NOT NULL,
    ruta VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(150),
    es_principal TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (id_iglesia) REFERENCES iglesias(id_iglesia)
) ENGINE=InnoDB;

