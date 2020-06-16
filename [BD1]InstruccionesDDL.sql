--Elimina las tablas de la base de datos
DROP TABLE PROFESION CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE EVALUACION CASCADE CONSTRAINTS;
DROP TABLE SINTOMA CASCADE CONSTRAINTS;
DROP TABLE DETALLE_EVALUACION CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE TRATAMIENTO CASCADE CONSTRAINTS;
DROP TABLE DETALLE_TRATAMIENTO CASCADE CONSTRAINTS;
DROP TABLE TEMPORAL;

--Creamos las tablas para la base de datos

--Creamos la Tabla Profesion, que contendra un catalogo de todas las profesiones
CREATE TABLE Profesion(
    Id_Profesion    NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50) NOT NULL
);

--Creamos la Tabla para Empleado, que contendra todos los empleados y su informacion
CREATE TABLE Empleado(
    Id_Empleado     NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(25) NOT NULL,
    Apellido        VARCHAR2(50) NOT NULL,
    Direccion       VARCHAR2(50) NOT NULL,
    Telefono        VARCHAR(20) NOT NULL,
    Fecha_Nacimiento    DATE,
    Genero          VARCHAR(1) NOT NULL,
    ID_PROFESION    NUMBER NOT NULL,
    CONSTRAINT FK_EMPLEADO_PROFESION FOREIGN KEY (ID_PROFESION) REFERENCES Profesion(Id_Profesion),
    CONSTRAINT CHECK_GENERO_EMPLEADO CHECK (Genero IN ('M','F'))
);

--Creamos la Tabla Paciente, que contendra todos los pacientes y su informacion
CREATE TABLE Paciente(
    Id_Paciente     NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(25) NOT NULL,
    Apellido        VARCHAR2(50) NOT NULL,
    Direccion       VARCHAR2(50) NOT NULL,
    Telefono        VARCHAR(20) NOT NULL,
    Fecha_Nacimiento    DATE NOT NULL,
    Genero          VARCHAR(1) NOT NULL,
    Altura          NUMBER NOT NULL,    
    Peso            NUMBER NOT NULL,
    CONSTRAINT CHECK_GENERO_PACIENTE CHECK (Genero IN ('M','F'))
);

--Creamos la Tabla Evaluacion, que tendra la evaluacion de los pacientes
CREATE TABLE Evaluacion(
    Id_Evaluacion   NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Fecha           DATE,
    ID_EMPLEADO     NUMBER NOT NULL,
    ID_PACIENTE     NUMBER NOT NULL,
    CONSTRAINT FK_EVALUACION_EMPLEADO FOREIGN KEY (ID_EMPLEADO) REFERENCES Empleado(Id_Empleado),
    CONSTRAINT FK_EVALUACION_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES Paciente(Id_Paciente)
);

--Creamos la Tabla Sintoma, que tendra un catalogo con todos los sintomas
CREATE TABLE Sintoma(
    Id_Sintoma      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);

--Creamos la Tabla Diagnostico, que tendra un catalogo con todos los diagnosticos comprobados
CREATE TABLE Diagnostico(
    Id_Diagnostico  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);


--Creamos la Tabla Detalle_Evaluacion, que tendra todos los sintomas que presento el paciente durante la evaluacion.
CREATE TABLE Detalle_Evaluacion(
    Id_Detalle      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Rango           NUMBER NOT NULL,
    ID_EVALUACION   NUMBER NOT NULL,
    ID_SINTOMA      NUMBER NOT NULL,
    ID_DIAGNOSTICO  NUMBER NOT NULL,
    CONSTRAINT FK_DETALLE_EVALUACION FOREIGN KEY (ID_EVALUACION) REFERENCES Evaluacion(Id_Evaluacion),
    CONSTRAINT FK_DETALLE_SINTOMA FOREIGN KEY (ID_SINTOMA) REFERENCES Sintoma (Id_Sintoma),
    CONSTRAINT FK_DETALLE_DIAGNOSTICO FOREIGN KEY (ID_DIAGNOSTICO) REFERENCES Diagnostico (Id_Diagnostico),
    CONSTRAINT CHECK_RANGO CHECK(Rango>0 AND Rango<=10)
);

--Creamos la Tabla Tratamiento que tendra un catalogo con todos los tratamientos que se han comprobado
CREATE TABLE Tratamiento(
    Id_Tratamiento  NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Nombre          VARCHAR2(50)
);

--Creamos la Tabla Detalle_Tratamiento donde estaran todos los tratamientos que esta llevando un Paciente
CREATE TABLE Detalle_Tratamiento(
    Id_Detalle      NUMBER GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
    Fecha           DATE,
    ID_TRATAMIENTO  NUMBER NOT NULL,
    ID_PACIENTE     NUMBER NOT NULL,
    CONSTRAINT FK_DETALLE_TRATAMIENTO_TRATAMIENTO FOREIGN KEY (ID_TRATAMIENTO) REFERENCES Tratamiento(Id_Tratamiento),
    CONSTRAINT FK_DETALLE_TRATAMIENTO_PACIENTE FOREIGN KEY (ID_PACIENTE) REFERENCES Paciente(Id_Paciente)
);


-- Creamos la tabla temporal que tendra los datos de la Carga Masiva
CREATE TABLE Temporal(
    NOMBRE_EMPLEADO VARCHAR2(50),
    APELLIDO_EMPLEADO VARCHAR2(50),
    DIRECCION_EMPLEADO VARCHAR2(50),
    TELEFONO_EMPLEADO VARCHAR2(50),
    GENERO_EMPLEADO VARCHAR2(50),
    FECHA_NACIMIENTO_EMPLEADO VARCHAR2(50),
    TITULO_DEL_EMPLEADO VARCHAR2(50),
    NOMBRE_PACIENTE VARCHAR2(50),
    APELLIDO_PACIENTE VARCHAR2(50),
    DIRECCION_PACIENTE VARCHAR2(50),
    TELEFONO_PACIENTE VARCHAR2(50),
    GENERO_PACIENTE VARCHAR2(50),
    FECHA_NACIMIENTO_PACIENTE VARCHAR2(50),
    ALTURA VARCHAR2(50),
    PESO VARCHAR2(50),
    FECHA_EVALUACION VARCHAR2(50),
    SINTOMA_DEL_PACIENTE VARCHAR2(50),
    DIAGNOSTICO_DEL_SINTOMA VARCHAR2(50),
    RANGO_DEL_DIAGNOSTICO VARCHAR2(50),
    FECHA_TRATAMIENTO VARCHAR2(50),
    TRATAMIENTO_APLICADO VARCHAR2(50)
);

