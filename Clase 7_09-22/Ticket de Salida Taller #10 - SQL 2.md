# Taller #10 - Ticket de Salida - SQL 2

## Esquema Relacional de Referencia
* **Proveedores** (**pr_id**: integer, nombre: varchar, direccion: varchar, ciudad: varchar)
* **Partes** (**pa_id**: integer, nombre: varchar, color: varchar)
* **Catalogo** (**pr_id**: integer, **pa_id**: integer, costo: real)

---

### Pregunta 1
**Enunciado:**  
Encontrar los identificadores de las piezas suministradas por el proveedor 'Sony' que sean más caras que las de todos los demás proveedores que suministran esa misma pieza, sin incluir las piezas en las que 'Sony' es el único proveedor.

* a)
  ```sql
  SELECT DISTINCT Cs.pa_id FROM Catalogo Cs
  INNER JOIN Proveedores S ON S.pr_id = Cs.pr_id AND S.nombre = 'Sony'
  WHERE EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id)
  AND NOT EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id AND Co.costo > Cs.costo);
  ```
* b)
  ```sql
  SELECT DISTINCT Cs.pa_id FROM Catalogo Cs
  INNER JOIN Proveedores S ON S.pr_id = Cs.pr_id AND S.nombre = 'Sony'
  WHERE EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id AND Cs.costo > Co.costo);
  ```
* c) *(Correcta)*
  ```sql
  SELECT DISTINCT Cs.pa_id FROM Catalogo Cs
  INNER JOIN Proveedores S ON S.pr_id = Cs.pr_id AND S.nombre = 'Sony'
  WHERE EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id)
  AND NOT EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id AND Co.costo >= Cs.costo);
  ```
* d)
  ```sql
  SELECT DISTINCT Cs.pa_id FROM Catalogo Cs
  INNER JOIN Proveedores S ON S.pr_id = Cs.pr_id AND S.nombre = 'Sony'
  WHERE NOT EXISTS (SELECT 1 FROM Catalogo Co
    WHERE Co.pa_id = Cs.pa_id AND Co.pr_id <> Cs.pr_id AND Co.costo >= Cs.costo);
  ```

**Respuesta correcta:** `c`  
*Justificación:* Exige que exista al menos otro proveedor (`EXISTS (...) AND Co.pr_id <> Cs.pr_id`) y que no exista ninguno con un costo mayor o igual (`NOT EXISTS (...) AND Co.costo >= Cs.costo`), asegurando que Sony sea estrictamente más caro sin empates.

---

### Pregunta 2
**Enunciado:**  
Encontrar los identificadores de los proveedores que suministran al menos una pieza roja y al menos una pieza verde.

* a) *(Correcta)*
  ```sql
  SELECT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color IN ('rojo','verde')
  GROUP BY C.pr_id
  HAVING COUNT(DISTINCT Pt.color) = 2;
  ```
* b)
  ```sql
  SELECT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color IN ('rojo','verde')
  GROUP BY C.pr_id
  HAVING COUNT(C.pa_id) >= 2;
  ```
* c)
  ```sql
  SELECT DISTINCT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' AND Pt.color = 'verde';
  ```
* d)
  ```sql
  SELECT DISTINCT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' OR Pt.color = 'verde';
  ```

**Respuesta correcta:** `a`  
*Justificación:* Agrupa por proveedor tras filtrar los dos colores y requiere `COUNT(DISTINCT Pt.color) = 2`, asegurando la presencia de ambos.

---

### Pregunta 3
**Enunciado:**  
Para cada proveedor, listar su nombre y la cantidad total de piezas que suministra (mostrando 0 si no suministra ninguna).

* a)
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* b)
  ```sql
  SELECT Pv.nombre, COUNT(DISTINCT C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* c) *(Correcta)*
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  LEFT JOIN Catalogo C ON C.pr_id = Pv.pr_id
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* d)
  ```sql
  SELECT Pv.nombre, COUNT(DISTINCT Pv.pr_id)
  FROM Proveedores Pv
  LEFT JOIN Catalogo C ON C.pr_id = Pv.pr_id
  GROUP BY Pv.pr_id, Pv.nombre;
  ```

**Respuesta correcta:** `c`  
*Justificación:* Usa `LEFT JOIN` para conservar a los proveedores sin registros en `Catalogo`, y `COUNT(C.pa_id)` devuelve 0 para ellos al no encontrar valores no nulos.

---

### Pregunta 4
**Enunciado:**  
Para cada pieza, listar su nombre y el costo promedio considerando únicamente los proveedores radicados en 'Buenos Aires'.

* a) *(Correcta)*
  ```sql
  SELECT Pt.nombre, AVG(C.costo)
  FROM Partes Pt
  INNER JOIN Catalogo C ON C.pa_id = Pt.pa_id
  INNER JOIN Proveedores Pv ON Pv.pr_id = C.pr_id
  WHERE Pv.ciudad = 'Buenos Aires'
  GROUP BY Pt.pa_id, Pt.nombre;
  ```
* b)
  ```sql
  SELECT Pt.nombre, AVG(C.costo)
  FROM Partes Pt
  INNER JOIN Catalogo C ON C.pa_id = Pt.pa_id
  GROUP BY Pt.pa_id, Pt.nombre;
  ```
* c)
  ```sql
  SELECT Pt.nombre, SUM(C.costo)
  FROM Partes Pt
  INNER JOIN Catalogo C ON C.pa_id = Pt.pa_id
  INNER JOIN Proveedores Pv ON Pv.pr_id = C.pr_id
  WHERE Pv.ciudad = 'Buenos Aires'
  GROUP BY Pt.pa_id, Pt.nombre;
  ```
* d)
  ```sql
  SELECT Pt.nombre, COUNT(C.costo)
  FROM Partes Pt
  INNER JOIN Catalogo C ON C.pa_id = Pt.pa_id
  INNER JOIN Proveedores Pv ON Pv.pr_id = C.pr_id
  WHERE Pv.ciudad = 'Buenos Aires'
  GROUP BY Pt.pa_id, Pt.nombre;
  ```

**Respuesta correcta:** `a`  
*Justificación:* Realiza el join con `Proveedores` para filtrar por `Pv.ciudad = 'Buenos Aires'`, utiliza `AVG(C.costo)` para el promedio y agrupa por identificador y nombre de pieza.

---

### Pregunta 5
**Enunciado:**  
Encontrar los identificadores de los proveedores que suministran todas las piezas rojas y todas las piezas verdes.

* a)
  ```sql
  (SELECT DISTINCT C1.pr_id FROM Catalogo C1
   WHERE NOT EXISTS (SELECT 1 FROM Partes Pt WHERE Pt.color = 'rojo'
     AND NOT EXISTS (SELECT 1 FROM Catalogo C2 WHERE C2.pr_id = C1.pr_id AND C2.pa_id = Pt.pa_id)))
  UNION
  (SELECT DISTINCT C1.pr_id FROM Catalogo C1
   WHERE NOT EXISTS (SELECT 1 FROM Partes Pt WHERE Pt.color = 'verde'
     AND NOT EXISTS (SELECT 1 FROM Catalogo C2 WHERE C2.pr_id = C1.pr_id AND C2.pa_id = Pt.pa_id)));
  ```
* b)
  ```sql
  SELECT DISTINCT C1.pr_id FROM Catalogo C1
  WHERE EXISTS (SELECT 1 FROM Catalogo C2, Partes Pt
    WHERE C1.pr_id = C2.pr_id AND Pt.color IN ('rojo','verde')
      AND C3.pa_id = Pt.pa_id);
  ```
* c) *(Correcta)*
  ```sql
  SELECT DISTINCT C1.pr_id FROM Catalogo C1
  WHERE NOT EXISTS (SELECT 1 FROM Catalogo C2, Partes Pt
    WHERE C1.pr_id = C2.pr_id AND Pt.color IN ('rojo','verde')
      AND NOT EXISTS (SELECT 1 FROM Catalogo C3 WHERE C3.pr_id = C2.pr_id AND C3.pa_id = Pt.pa_id));
  ```
* d)
  ```sql
  SELECT DISTINCT C1.pr_id FROM Catalogo C1
  WHERE NOT EXISTS (SELECT 1 FROM Catalogo C2, Partes Pt
    WHERE C1.pr_id = C2.pr_id
      AND NOT EXISTS (SELECT 1 FROM Catalogo C3 WHERE C3.pr_id = C2.pr_id AND C3.pa_id = Pt.pa_id));
  ```

**Respuesta correcta:** `c`  
*Justificación:* Aplica división relacional mediante doble negación sobre el conjunto de piezas donde `Pt.color IN ('rojo','verde')`: no existe ninguna pieza roja o verde que el proveedor no fabrique.

---

### Pregunta 6
**Enunciado:**  
Encontrar los identificadores de las piezas que son suministradas por al menos 2 proveedores diferentes.

* a)
  ```sql
  SELECT C.pr_id
  FROM Catalogo C
  GROUP BY C.pr_id
  HAVING COUNT(DISTINCT C.pa_id) >= 2;
  ```
* b) *(Correcta)*
  ```sql
  SELECT C.pa_id
  FROM Catalogo C
  GROUP BY C.pa_id
  HAVING COUNT(DISTINCT C.pr_id) >= 2;
  ```
* c)
  ```sql
  SELECT C.pa_id
  FROM Catalogo C
  GROUP BY C.pa_id
  HAVING COUNT(DISTINCT C.pr_id) > 2;
  ```
* d)
  ```sql
  SELECT C.pa_id
  FROM Catalogo C
  GROUP BY C.pa_id
  HAVING COUNT(DISTINCT C.pa_id) >= 2;
  ```

**Respuesta correcta:** `b`  
*Justificación:* Agrupa por pieza (`C.pa_id`) y aplica `HAVING COUNT(DISTINCT C.pr_id) >= 2` para verificar que al menos dos proveedores distintos la suministren.

---

### Pregunta 7
**Enunciado:**  
Encontrar los identificadores de los proveedores que suministran alguna pieza roja o que están radicados en 'Buenos Aires'.

* a)
  ```sql
  SELECT DISTINCT Pv.pr_id
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' OR Pt.ciudad = 'Buenos Aires';
  ```
* b) *(Correcta)*
  ```sql
  SELECT DISTINCT Pv.pr_id
  FROM Proveedores Pv
  LEFT JOIN Catalogo C ON C.pr_id = Pv.pr_id
  LEFT JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' OR Pv.ciudad = 'Buenos Aires';
  ```
* c)
  ```sql
  SELECT DISTINCT Pv.pr_id
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' AND Pv.ciudad = 'Buenos Aires';
  ```
* d)
  ```sql
  SELECT DISTINCT Pv.pr_id
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' OR Pv.ciudad = 'Buenos Aires';
  ```

**Respuesta correcta:** `b`  
*Justificación:* Emplea `LEFT JOIN` para no descartar a los proveedores radicados en 'Buenos Aires' que aún no registren piezas fabricadas en el catálogo.

---

### Pregunta 8
**Enunciado:**  
Encontrar los identificadores de los proveedores que suministran alguna pieza roja o verde.

* a)
  ```sql
  SELECT COUNT(C.pa_id)
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color IN ('rojo','verde');
  ```
* b)
  ```sql
  SELECT DISTINCT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color NOT IN ('rojo','verde');
  ```
* c) *(Correcta)*
  ```sql
  SELECT DISTINCT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color IN ('rojo','verde');
  ```
* d)
  ```sql
  SELECT DISTINCT C.pr_id
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo' AND Pt.color = 'verde';
  ```

**Respuesta correcta:** `c`  
*Justificación:* Conecta `Catalogo` con `Partes`, filtra los colores mediante `IN ('rojo','verde')` y extrae los proveedores sin duplicados (`DISTINCT C.pr_id`).

---

### Pregunta 9
**Enunciado:**  
Encontrar la cantidad de piezas rojas suministradas por el proveedor 'Sony'.

* a)
  ```sql
  SELECT COUNT(DISTINCT C.pr_id)
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  INNER JOIN Proveedores S ON S.pr_id = C.pr_id
  WHERE S.nombre = 'Sony' AND Pt.color = 'rojo';
  ```
* b)
  ```sql
  SELECT COUNT(C.pa_id)
  FROM Catalogo C
  INNER JOIN Proveedores S ON S.pr_id = C.pr_id
  WHERE S.nombre = 'Sony';
  ```
* c) *(Correcta)*
  ```sql
  SELECT COUNT(C.pa_id)
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  INNER JOIN Proveedores S ON S.pr_id = C.pr_id
  WHERE S.nombre = 'Sony' AND Pt.color = 'rojo';
  ```
* d)
  ```sql
  SELECT COUNT(C.pa_id)
  FROM Catalogo C
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'rojo';
  ```

**Respuesta correcta:** `c`  
*Justificación:* Filtra tanto el proveedor (`S.nombre = 'Sony'`) como el color (`Pt.color = 'rojo'`) y contabiliza las piezas resultantes con `COUNT(C.pa_id)`.

---

### Pregunta 10
**Enunciado:**  
Para cada proveedor radicado en 'Rosario', listar su nombre y la cantidad de piezas verdes que suministra.

* a) *(Correcta)*
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pv.ciudad = 'Rosario' AND Pt.color = 'verde'
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* b)
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.ciudad = 'Rosario' AND Pt.color = 'verde'
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* c)
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pt.color = 'verde'
  GROUP BY Pv.pr_id, Pv.nombre;
  ```
* d)
  ```sql
  SELECT Pv.nombre, COUNT(C.pa_id)
  FROM Proveedores Pv
  INNER JOIN Catalogo C ON C.pr_id = Pv.pr_id
  INNER JOIN Partes Pt ON Pt.pa_id = C.pa_id
  WHERE Pv.ciudad = 'Rosario'
  GROUP BY Pv.pr_id, Pv.nombre;
  ```

**Respuesta correcta:** `a`  
*Justificación:* Aplica la condición de localidad al campo correspondiente del proveedor (`Pv.ciudad = 'Rosario'`), el filtro de color a la pieza (`Pt.color = 'verde'`) y agrupa por proveedor.