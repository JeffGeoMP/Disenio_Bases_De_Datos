--1. Mostrar el nombre, apellido y teléfono de todos los empleados y la cantidad de 
--   pacientes atendidos por cada empleado ordenados de mayor a menor.

SELECT e.nombre, e.apellido, e.telefono,(SELECT COUNT(*) FROM evaluacion v WHERE v.id_empleado = e.id_empleado) AS PACIENTES
FROM empleado e 
ORDER BY PACIENTES DESC;

--2. Mostrar el nombre, apellido, dirección y título de todos los empleados de sexo 
--   masculino que atendieron a más de 3 pacientes en el año 2016.

SELECT e.nombre, e.apellido, e.direccion, f.nombre AS TITULO, e.genero, COUNT(*) AS "PACIENTES ATENDIDOS" FROM evaluacion v
INNER JOIN empleado e ON v.id_empleado = e.id_empleado
INNER JOIN profesion f ON e.id_profesion = f.id_profesion
WHERE TO_CHAR(v.fecha,'YYYY')='2016' AND e.genero = 'M'
GROUP BY e.nombre, e.apellido, e.genero, e.direccion, f.nombre
HAVING COUNT(*)>3
ORDER BY COUNT(*) DESC;

--3. Mostrar el nombre y apellido de todos los pacientes que se están aplicando el 
--   tratamiento “Tabaco en polvo” y  que tuvieron el síntoma “Dolor de cabeza”.

SELECT DISTINCT p.nombre, p.apellido, s.nombre AS SINTOMA, t.nombre AS TRATAMIENTO FROM detalle_evaluacion de
INNER JOIN sintoma s ON de.id_sintoma = s.id_sintoma 
INNER JOIN evaluacion e ON de.id_evaluacion = e.id_evaluacion
INNER JOIN paciente p ON e.id_paciente = p.id_paciente
INNER JOIN detalle_tratamiento dt ON p.id_paciente = dt.id_paciente
INNER JOIN tratamiento t ON dt.id_tratamiento = t.id_tratamiento
WHERE s.nombre = 'Dolor de cabeza' AND t.nombre = 'Tabaco en polvo';

--4. Top 5 de pacientes que más tratamientos se han aplicado del tratamiento “Antidepresivos”. 
--    Mostrar nombre, apellido  y la cantidad de tratamientos.

SELECT * FROM (
    SELECT p.nombre, p.apellido, COUNT(*) FROM detalle_tratamiento dt
    INNER JOIN paciente p ON dt.id_paciente=p.id_paciente
    INNER JOIN tratamiento t ON dt.id_tratamiento = t.id_tratamiento
    WHERE t.nombre = 'Antidepresivos'
    GROUP BY  p.nombre, p.apellido
    ORDER BY COUNT(*) DESC) temp
WHERE ROWNUM<=5;

--5. Mostrar el nombre, apellido y dirección de todos los pacientes que se hayan 
--   aplicado más de 3 tratamientos y no hayan sido atendidos por un empleado.    
--   Debe mostrar la cantidad de tratamientos que se aplicó el paciente.
--   Ordenar los resultados de mayor a menor utilizando la cantidad de tratamientos. 

SELECT p.nombre, p.apellido, p.direccion, COUNT(*) AS "TRATAMIENTOS APLICADOS" FROM detalle_tratamiento dt
INNER JOIN paciente p ON dt.id_paciente = p.id_paciente
WHERE NOT EXISTS (SELECT * FROM evaluacion v WHERE v.id_paciente=p.id_paciente)
GROUP BY p.nombre, p.apellido, p.direccion
HAVING COUNT(*)>3
ORDER BY COUNT(*) DESC;

--6. Mostrar el nombre del diagnóstico y la cantidad de síntomas a los que ha sido  
--   asignado donde el rango ha sido de 9. Ordene sus resultados de mayor a menor en 
--   base a la cantidad de síntomas.

SELECT d.nombre, COUNT(id_sintoma) AS "CANTIDAD DE SINTOMAS" FROM sintoma_diagnostico sd
INNER JOIN diagnostico d ON sd.id_diagnostico=d.id_diagnostico
WHERE sd.rango =9
GROUP BY d.nombre
ORDER BY COUNT(id_sintoma) DESC;

--7. Mostrar el nombre, apellido y dirección de todos los pacientes que presentaron un 
--   síntoma  que al que le fue  asignado un diagnóstico con un rango mayor a 5.  Debe   
--   mostrar los resultados en orden alfabético tomando en cuenta el nombre y apellido 
--   del paciente.

SELECT DISTINCT p.nombre, p.apellido, p.direccion FROM detalle_evaluacion dt
INNER JOIN evaluacion v ON dt.id_evaluacion= v.id_evaluacion
INNER JOIN paciente p ON v.id_paciente = p.id_paciente
INNER JOIN sintoma s ON dt.id_sintoma = s.id_sintoma
INNER JOIN sintoma_diagnostico sd ON s.id_sintoma = sd.id_sintoma
WHERE (SELECT COUNT(a.id_diagnostico) SINTOMA FROM sintoma_diagnostico a
INNER JOIN diagnostico b ON a.id_diagnostico = b.id_diagnostico
INNER JOIN sintoma c ON sd.id_sintoma = c.id_sintoma
WHERE a.rango>5 AND c.nombre=s.nombre)>0
ORDER BY p.nombre, p.apellido ASC;

--8. Mostrar el nombre, apellido y fecha de nacimiento de todos los empleados de sexo 
--   femenino cuya dirección es “1475 Dryden Crossing” y hayan atendido por lo menos 
--   a 2 pacientes.  Mostrar la cantidad de pacientes atendidos por el empleado y 
--   ordénelos de mayor a menor.

SELECT e.nombre, e.apellido, e.fecha_nacimiento, e.genero, COUNT(id_paciente) AS "PACIENTES ATENDIDOS" FROM evaluacion v
INNER JOIN empleado e ON v.id_empleado = e.id_empleado
WHERE e.direccion='1475 Dryden Crossing' AND e.genero='F'
GROUP BY e.nombre, e.apellido, e.fecha_nacimiento, e.genero
HAVING COUNT(id_paciente)>=2
ORDER BY COUNT(id_paciente) DESC;

--9. Mostrar el porcentaje de pacientes que ha atendido cada empleado a partir del año 
--    2017 y mostrarlos de mayor a menor en base al porcentaje calculado.

SELECT e.nombre, e.apellido, ROUND((COUNT(v.id_evaluacion)/(SELECT COUNT(*) FROM evaluacion v
                            WHERE TO_CHAR(v.fecha,'YYYY')>='2017'))*100,2) AS PORCENTAJE
FROM empleado e
INNER JOIN evaluacion v ON e.id_empleado = v.id_empleado
WHERE TO_CHAR(v.fecha,'YYYY')>='2017'
GROUP BY e.nombre, e.apellido
ORDER BY PORCENTAJE DESC;

--10. Mostrar el porcentaje del título de empleado más común de la siguiente manera: 
--    nombre del título, porcentaje de empleados que tienen ese título. 
--     Debe ordenar los resultados en base al porcentaje de mayor a menor.

SELECT p.nombre, (COUNT(e.id_profesion)/(SELECT COUNT(e.id_profesion) 
                FROM profesion p INNER JOIN empleado e ON p.id_profesion = e.id_profesion))*100 AS PORCENTAJE
FROM profesion p
INNER JOIN empleado e ON p.id_profesion = e.id_profesion
GROUP BY p.nombre
ORDER BY PORCENTAJE DESC;

--*EXTRA: Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y apellido 
--de los pacientes que más tratamientos se han aplicado y los que menos. (Todo en una sola consulta). 
-- Nota: debe tomar como cantidad mínima 1 tratamiento.--
--DUDA

SELECT TO_CHAR(v.fecha,'YYYY') AS AÑO, TO_CHAR(v.fecha,'MONTH') AS MES, p.nombre, p.apellido, COUNT(*) AS TRATAMIENTOS 
FROM paciente p
INNER JOIN detalle_tratamiento dt ON p.id_paciente = dt.id_paciente
INNER JOIN evaluacion v ON p.id_paciente = v.id_paciente 
GROUP BY TO_CHAR(v.fecha,'YYYY'), TO_CHAR(v.fecha,'MONTH'), p.nombre, p.apellido
HAVING COUNT(*)=(SELECT MAX(TRATAMIENTOS) FROM (SELECT p.nombre, p.apellido, COUNT(*) AS TRATAMIENTOS FROM paciente p
                INNER JOIN detalle_tratamiento dt ON p.id_paciente = dt.id_paciente
                GROUP BY p.nombre, p.apellido))
UNION
SELECT TO_CHAR(v.fecha,'YYYY') AS AÑO, TO_CHAR(v.fecha,'MONTH') AS MES, p.nombre, p.apellido, COUNT(*) AS TRATAMIENTOS 
FROM paciente p
INNER JOIN detalle_tratamiento dt ON p.id_paciente = dt.id_paciente
INNER JOIN evaluacion v ON p.id_paciente = v.id_paciente 
GROUP BY TO_CHAR(v.fecha,'YYYY'), TO_CHAR(v.fecha,'MONTH'), p.nombre, p.apellido
HAVING COUNT(*)=(SELECT MIN(TRATAMIENTOS) FROM (SELECT p.nombre, p.apellido, COUNT(*) AS TRATAMIENTOS FROM paciente p
                INNER JOIN detalle_tratamiento dt ON p.id_paciente = dt.id_paciente
                GROUP BY p.nombre, p.apellido))
ORDER BY TRATAMIENTOS DESC;


SELECT f.año, f.mes, p.nombre, p.apellido, c.tratamientos
FROM paciente p
INNER JOIN (SELECT TO_CHAR(v.fecha, 'YYYY') AS AÑO, TO_CHAR(v.fecha, 'MONTH') AS MES, id_paciente FROM evaluacion v) f ON f.id_paciente = p.id_paciente
INNER JOIN (SELECT id_paciente, COUNT(*) AS tratamientos FROM detalle_tratamiento dt GROUP BY id_paciente) c ON f.id_paciente = c.id_paciente
INNER JOIN (SELECT f.año, f.mes, MAX(c.tratamientos) AS MAXI, MIN(c.tratamientos) AS MINI
            FROM (SELECT DISTINCT TO_CHAR(v.fecha, 'YYYY') AS AÑO, TO_CHAR(v.fecha, 'MONTH') AS MES, id_paciente FROM evaluacion v) f
            INNER JOIN (SELECT id_paciente, COUNT(*) AS tratamientos
                        FROM detalle_tratamiento
                        GROUP BY id_paciente) c ON f.id_paciente = c.id_paciente
            GROUP BY f.AÑO, f.MES) M ON M.AÑO = F.AÑO AND M.MES = F.MES AND (M.MAXI = c.tratamientos OR M.MINI = c.tratamientos)
ORDER BY f.AÑO, F.MES, c.tratamientos DESC;
            
