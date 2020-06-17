--1. Mostrar el nombre, apellido y teléfono de todos los empleados y la cantidad de 
--   pacientes atendidos por cada empleado ordenados de mayor a menor.

SELECT e.nombre, e.apellido, e.telefono, COUNT(v.id_paciente) AS "PACIENTES ATENTIDOS" FROM evaluacion v 
INNER JOIN empleado e ON v.id_empleado = e.id_empleado
GROUP BY e.nombre, e.apellido, e.telefono
ORDER BY COUNT(v.id_paciente) DESC;

--Solo verifica la cantidad de registros de la consulta anterior
SELECT COUNT(*) AS "CANTIDAD DE PACIENTES QUE HAN ATENDIDO" 
FROM (SELECT e.nombre, e.apellido, e.telefono, COUNT(v.id_paciente) AS "PACIENTES ATENTIDOS" FROM evaluacion v 
INNER JOIN empleado e ON v.id_empleado = e.id_empleado
GROUP BY e.nombre, e.apellido, e.telefono
ORDER BY COUNT(v.id_paciente) DESC);

--2. Mostrar el nombre, apellido, dirección y título de todos los empleados de sexo 
--   masculino que atendieron a más de 3 pacientes en el año 2016.

SELECT e.nombre, e.apellido, e.genero, e.direccion, f.nombre, COUNT(*) AS PACIENTES FROM evaluacion v
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

SELECT p.nombre, p.apellido, p.direccion, COUNT(*) FROM detalle_tratamiento dt
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



--10. Mostrar el porcentaje del título de empleado más común de la siguiente manera: 
--    nombre del título, porcentaje de empleados que tienen ese título. 
--     Debe ordenar los resultados en base al porcentaje de mayor a menor.

--*EXTRA: Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y apellido 
--de los pacientes que más tratamientos se han aplicado y los que menos. (Todo en una sola consulta). 
-- Nota: debe tomar como cantidad mínima 1 tratamiento.--