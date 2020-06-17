--Insertamos los Datos de Nuestra Tabla Temporal hacia Nuestro Modelo E-R
--Insertamos Las Profesiones
INSERT INTO profesion (
    nombre
) 
SELECT DISTINCT 
    t.TITULO_DEL_EMPLEADO 
FROM temporal t 
WHERE TITULO_DEL_EMPLEADO IS NOT NULL ;
    
--Insertamos Los Empleados del Centro 
INSERT INTO empleado (
    nombre,
    apellido,
    direccion,
    telefono,
    fecha_nacimiento,
    genero,
    id_profesion
)
SELECT DISTINCT
    t.NOMBRE_EMPLEADO,
    t.APELLIDO_EMPLEADO, 
    t.DIRECCION_EMPLEADO, 
    t.TELEFONO_EMPLEADO,
    TO_CHAR(TO_DATE(t.FECHA_NACIMIENTO_EMPLEADO,'YYYY/MM/DD'),'DD/MM/YYYY'),
    t.GENERO_EMPLEADO, 
    p.id_profesion
FROM Temporal t
INNER JOIN profesion p ON t.TITULO_DEL_EMPLEADO = p.nombre
WHERE   t.NOMBRE_EMPLEADO IS NOT NULL AND 
        t.APELLIDO_EMPLEADO IS NOT NULL AND
        t.DIRECCION_EMPLEADO IS NOT NULL AND
        t.TELEFONO_EMPLEADO IS NOT NULL AND 
        t.GENERO_EMPLEADO IS NOT NULL AND 
        t.FECHA_NACIMIENTO_EMPLEADO IS NOT NULL AND
        t.TITULO_DEL_EMPLEADO  IS NOT NULL;

-- Insertamos los Paciente que han llegado al Centro
INSERT INTO paciente (
    nombre,
    apellido,
    direccion,
    telefono,
    fecha_nacimiento,
    genero,
    altura,
    peso
)
SELECT DISTINCT
    t.NOMBRE_PACIENTE,
    t.APELLIDO_PACIENTE, 
    t.DIRECCION_PACIENTE, 
    t.TELEFONO_PACIENTE,
    TO_CHAR(TO_DATE(t.FECHA_NACIMIENTO_PACIENTE,'YYYY/MM/DD'),'DD/MM/YYYY'),
    t.GENERO_PACIENTE, 
    t.ALTURA,
    t.PESO
FROM temporal t
WHERE   t.NOMBRE_PACIENTE IS NOT NULL AND 
        t.APELLIDO_PACIENTE IS NOT NULL AND
        t.DIRECCION_PACIENTE IS NOT NULL AND
        t.TELEFONO_PACIENTE IS NOT NULL AND 
        t.GENERO_PACIENTE IS NOT NULL AND 
        t.FECHA_NACIMIENTO_PACIENTE IS NOT NULL AND
        t.ALTURA IS NOT NULL AND
        t.PESO IS NOT NULL;

-- Insertamos Los Tratamientos Disponibles
INSERT INTO tratamiento (
    nombre
)
SELECT DISTINCT
    t.TRATAMIENTO_APLICADO
FROM temporal t
WHERE t.TRATAMIENTO_APLICADO IS NOT NULL;

-- Insertamos Los Sintomas que han presentado los pacientes
INSERT INTO sintoma (
    nombre
)
SELECT DISTINCT
    t.SINTOMA_DEL_PACIENTE
FROM temporal t
WHERE t.SINTOMA_DEL_PACIENTE IS NOT NULL;

-- Insertamos Los Diagnosticos que se han  determinado 
INSERT INTO diagnostico (
    nombre
)
SELECT DISTINCT
    t.DIAGNOSTICO_DEL_SINTOMA
FROM temporal t
WHERE t.DIAGNOSTICO_DEL_SINTOMA IS NOT NULL;


-- Insertamos Las Evaluaciones conformadas por un Empleado y un paciente
INSERT INTO evaluacion (
    fecha,
    id_empleado,
    id_paciente
)
SELECT DISTINCT
    TO_CHAR(TO_DATE(t.FECHA_EVALUACION,'YYYY/MM/DD'),'DD/MM/YYYY'),
    e.id_empleado,
    p.id_paciente
FROM temporal t
    INNER JOIN empleado e ON t.NOMBRE_EMPLEADO = e.nombre AND t.APELLIDO_EMPLEADO = e.apellido AND t.DIRECCION_EMPLEADO = e.direccion
    INNER JOIN paciente p ON t.NOMBRE_PACIENTE = p.nombre AND t.APELLIDO_PACIENTE = p.apellido AND t.DIRECCION_PACIENTE = p.direccion
WHERE t.FECHA_EVALUACION IS NOT NULL AND
    t.NOMBRE_EMPLEADO IS NOT NULL AND
    t.APELLIDO_EMPLEADO IS NOT NULL AND 
    t.DIRECCION_EMPLEADO IS NOT NULL AND
    t.NOMBRE_PACIENTE IS NOT NULL AND
    t.APELLIDO_PACIENTE IS NOT NULL AND
    t.DIRECCION_PACIENTE IS NOT NULL;

-- Insertamos Los detalles de los tratamientos que esta siguiendo un paciente
INSERT INTO detalle_tratamiento (
    fecha,
    id_tratamiento,
    id_paciente
)
SELECT DISTINCT
    TO_CHAR(TO_DATE(t.FECHA_TRATAMIENTO,'YYYY/MM/DD'),'DD/MM/YYYY'),
    r.id_tratamiento,
    p.id_paciente
FROM temporal t
    INNER JOIN tratamiento r ON t.TRATAMIENTO_APLICADO = r.nombre
    INNER JOIN paciente p ON t.NOMBRE_PACIENTE = p.nombre AND t.APELLIDO_PACIENTE = p.apellido AND t.DIRECCION_PACIENTE = p.direccion
WHERE t.FECHA_TRATAMIENTO IS NOT NULL AND
    t.NOMBRE_PACIENTE IS NOT NULL AND
    t.APELLIDO_PACIENTE IS NOT NULL AND
    t.DIRECCION_PACIENTE IS NOT NULL AND
    t.TRATAMIENTO_APLICADO IS NOT NULL;

--Insertamos La relacion entre sintoma y diagnostico
INSERT INTO sintoma_diagnostico (
    rango,
    ID_SINTOMA,
    ID_DIAGNOSTICO
)
SELECT DISTINCT
    t.RANGO_DEL_DIAGNOSTICO,
    s.id_sintoma,
    d.id_diagnostico
FROM temporal t 
    INNER JOIN sintoma s ON t.SINTOMA_DEL_PACIENTE = s.nombre
    INNER JOIN diagnostico d ON t.DIAGNOSTICO_DEL_SINTOMA = d.nombre
WHERE t.RANGO_DEL_DIAGNOSTICO IS NOT NULL AND 
        t.SINTOMA_DEL_PACIENTE IS NOT NULL AND 
        t.DIAGNOSTICO_DEL_SINTOMA IS NOT NULL;

-- Insertamos Los detalles de los sintomas que presento un paciente en la evaluacion
INSERT INTO detalle_evaluacion(
    ID_EVALUACION,
    ID_SINTOMA
)
SELECT DISTINCT
    v.id_evaluacion,
    s.id_sintoma
    
FROM temporal t
    JOIN paciente p ON t.NOMBRE_PACIENTE = p.nombre AND t.APELLIDO_PACIENTE = p.apellido AND t.DIRECCION_PACIENTE = p.direccion
    JOIN empleado e ON t.NOMBRE_EMPLEADO = e.nombre AND t.APELLIDO_EMPLEADO = e.apellido AND t.DIRECCION_EMPLEADO = e.direccion
    JOIN evaluacion v ON p.id_paciente = v.id_paciente AND e.id_empleado = v.id_empleado AND TO_CHAR(TO_DATE(t.FECHA_EVALUACION,'YYYY/MM/DD'),'DD/MM/YYYY') = v.fecha
    JOIN sintoma s ON t.SINTOMA_DEL_PACIENTE = s.nombre
WHERE t.SINTOMA_DEL_PACIENTE IS NOT NULL AND 
    t.NOMBRE_EMPLEADO IS NOT NULL AND
    t.DIRECCION_EMPLEADO IS NOT NULL AND
    t.APELLIDO_EMPLEADO IS NOT NULL AND
    t.NOMBRE_PACIENTE IS NOT NULL AND
    t.APELLIDO_PACIENTE IS NOT NULL AND
    t.DIRECCION_PACIENTE IS NOT NULL;

    
--Muestra la Cantidad Total Despues de Hacer Todos Los Insert
SELECT 'PROFESIONES' AS TABLA, COUNT(*) AS TOTALES FROM profesion UNION
SELECT 'EMPLEADOS' AS TABLA, COUNT(*) AS TOTALES FROM empleado UNION
SELECT 'PACIENTES' AS TABLA, COUNT(*) AS TOTALES FROM paciente UNION
SELECT 'EVALUACIONES' AS TABLA, COUNT(*) AS TOTALES FROM evaluacion UNION
SELECT 'TRATAMIENTOS' AS TABLA, COUNT(*) AS TOTALES FROM tratamiento UNION
SELECT 'DETALLE_TRATAMIENTOS' AS TABLA, COUNT(*) AS TOTALES FROM detalle_tratamiento UNION
SELECT 'SINTOMAS' AS TABLA, COUNT(*) AS TOTALES FROM sintoma UNION
SELECT 'DIAGNOSTICOS' AS TABLA, COUNT(*) AS TOTALES FROM diagnostico UNION
SELECT 'SINTOMA_DIAGNOSTICO' AS TABLA, COUNT(*) AS TOTALES FROM sintoma_diagnostico UNION
SELECT 'DETALLE_EVALUACIONES' AS TABLA, COUNT(*) AS TOTALES FROM detalle_evaluacion;