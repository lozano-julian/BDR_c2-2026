# FN 2 - Ticket de Salida - Cuestionario

**Calificación obtenida:** 10,00 / 10,00 (100 %)  
**Fecha:** 23 de septiembre de 2026  

---

### Pregunta 1
**Enunciado:** ¿Cuáles condiciones debe cumplir una tabla para estar en 3FN? (Selecciona 2)  
- [x] **c.** Estar en 2FN  
- [x] **d.** No tener dependencias transitivas (los atributos no clave dependen solo de la clave)  

---

### Pregunta 2
**Enunciado:** La desnormalización consiste en:  
- [x] **c.** Introducir redundancia controlada a propósito para mejorar el rendimiento de las consultas  

---

### Pregunta 3
**Enunciado:** Dada la tabla `Detalle(id_pedido, id_producto, cantidad, nombre_producto)`, donde la PK es `(id_pedido, id_producto)`, ¿qué forma normal viola?  
- [x] **d.** 2FN  

---

### Pregunta 4
**Enunciado:** En la tabla `Factura(id_factura, fecha, id_cliente, nombre_cliente, ciudad_cliente)`, ¿qué problema existe?  
- [x] **b.** Viola la 3FN: nombre_cliente y ciudad_cliente dependen de id_cliente, no directamente de id_factura (dependencia transitiva)  

---

### Pregunta 5
**Enunciado:** Sobre la desnormalización, ¿cuáles afirmaciones son correctas? (Selecciona 2)  
- [x] **d.** Se usa para mejorar el rendimiento en consultas de lectura frecuentes  
- [x] **e.** Introduce redundancia controlada de forma intencional  

---

### Pregunta 6
**Enunciado:** ¿Cuáles son requisitos para que una tabla esté en 1FN? (Selecciona 2)  
- [x] **b.** Cada fila tiene una clave primaria única (no se repite)  
- [x] **d.** Cada celda contiene un solo valor atómico  

---

### Pregunta 7
**Enunciado:** ¿Cuáles son consecuencias de NO normalizar una base de datos? (Selecciona 2)  
- [x] **a.** Redundancia de datos (información repetida)  
- [x] **c.** Riesgo de inconsistencias al actualizar datos repetidos  

---

### Pregunta 8
**Enunciado:** ¿Cuáles son beneficios de la normalización? (Selecciona 2)  
- [x] **c.** Reducción del espacio desperdiciado por datos repetidos  
- [x] **e.** Integridad y consistencia de los datos  

---

### Pregunta 9
**Enunciado:** Dada la tabla `Empleado(id_emp, nombre, id_depto, nombre_depto, ubicacion_depto)`, ¿cuáles afirmaciones son correctas? (Selecciona 2)  
- [x] **a.** Tiene una dependencia transitiva (nombre_depto y ubicacion_depto dependen de id_depto)  
- [x] **c.** Se debería crear una tabla Departamento separada  

---

### Pregunta 10
**Enunciado:** ¿Cuáles condiciones debe cumplir una tabla para estar en 2FN? (Selecciona 2)  
- [x] **a.** Que ningún atributo no clave dependa solo de una parte de la clave primaria (sin dependencias parciales)  
- [x] **c.** Estar en 1FN