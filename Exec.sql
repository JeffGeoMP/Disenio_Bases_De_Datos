--Ejecuta La Carga hacia la tabla temporal creada en el IntruccionesDDL.sql
--sqlldr userid=system control='[BD1]ArchivoControl.ctl'

SELECT * FROM PROFESION;
SELECT * FROM EMPLEADO;

SELECT DISTINCT
t.NOMBRE_EMPLEADO, t.APELLIDO_EMPLEADO, t.DIRECCION_EMPLEADO, t.TELEFONO_EMPLEADO,
t.GENERO_EMPLEADO, t.FECHA_NACIMIENTO_EMPLEADO, t.TITULO_DEL_EMPLEADO
FROM Temporal t;

SELECT COUNT(*) FROM  (SELECT DISTINCT
t.NOMBRE_EMPLEADO, t.APELLIDO_EMPLEADO, t.DIRECCION_EMPLEADO, t.TELEFONO_EMPLEADO,
t.GENERO_EMPLEADO, t.FECHA_NACIMIENTO_EMPLEADO, t.TITULO_DEL_EMPLEADO
FROM Temporal t
WHERE hubiera  IS NOT NULL
);
select * from detalle_evaluacion;
select * from sintoma;
select * from evaluacion;
select * from paciente;
select * from empleado;

SELECT rango, 

INSERT INTO detalle_evaluacion (
    rango,
    id_evaluacion,
    id_sintoma,
    id_diagnostico
)
SELECT DISTINCT
    t.RANGO_DEL_DIAGNOSTICO,    
    (SELECT id_evaluacion FROM evaluacion e WHERE e.ID_EMPLEADO = (SELECT id_empleado FROM empleado a WHERE t.NOMBRE_EMPLEADO = a.nombre AND
                                                                    t.APELLIDO_EMPLEADO = a.apellido AND
                                                                    t.DIRECCION_EMPLEADO = a.direccion) AND
    
                                                    e.ID_PACIENTE = (SELECT id_paciente FROM paciente b WHERE t.NOMBRE_PACIENTE = b.nombre AND
                                                                    t.APELLIDO_PACIENTE = b.apellido AND
                                                                    t.DIRECCION_PACIENTE = b.direccion) AND
     
                                                 e.FECHA= TO_CHAR(TO_DATE(t.FECHA_EVALUACION,'YYYY/MM/DD'),'DD/MM/YYYY')
    ),
    (SELECT id_sintoma FROM sintoma s WHERE s.nombre=t.SINTOMA_DEL_PACIENTE),
    (SELECT id_diagnostico FROM diagnostico d WHERE d.nombre = t.DIAGNOSTICO_DEL_SINTOMA)
    
FROM temporal t
WHERE t.FECHA_EVALUACION IS NOT NULL AND
    t.NOMBRE_EMPLEADO IS NOT NULL AND
    t.APELLIDO_EMPLEADO IS NOT NULL AND 
    t.DIRECCION_EMPLEADO IS NOT NULL AND
    t.NOMBRE_PACIENTE IS NOT NULL AND
    t.APELLIDO_PACIENTE IS NOT NULL AND
    t.DIRECCION_PACIENTE IS NOT NULL AND
    t.RANGO_DEL_DIAGNOSTICO IS NOT NULL AND
    t.SINTOMA_DEL_PACIENTE IS NOT NULL AND
    t.DIAGNOSTICO_DEL_SINTOMA IS NOT NULL;