# Resumen General y Guía Maestra: Bases de Datos Relacionales (Hasta Clase 7)

Este documento constituye la síntesis integral de la materia **Bases de Datos Relacionales** (Comisión Licenciatura en Ciencias de Datos / Ingeniería Informática — UCA 2026). Presenta los marcos teóricos fundamentales junto con **ejemplos concretos, ejercicios resueltos paso a paso, trazas de ejecución y casos prácticos** vistos en las clases 1 a 7.

---

## 📚 **Track 1: El DBMS por dentro: arquitectura, almacenamiento e índices**

> 📅 **Ruta de aprendizaje cursada:**
> * **Clase 1:** Introducción a la Gestión de Datos / Arquitectura del DBMS
> * **Clase 2:** Almacenamiento Físico y Sizing (Teórica) / Características del DBMS (Fishbowl #1)
> * **Clase 3:** Almacenamiento Físico y Sizing (Taller #1)
> * **Clase 4:** Índices y Estructuras de Acceso Físico (Fishbowl #2)

---

### 1. Fundamentos de Arquitectura e Independencia de Datos
Un Sistema de Gestión de Bases de Datos (**DBMS**) introduce una arquitectura en capas para superar las fallas estructurales de los sistemas de archivos tradicionales:
* **Independencia Física:** Permite migrar tablas a nuevos discos SSD, cambiar esquemas de particionado o reconstruir índices B+ sin alterar las consultas SQL ni las aplicaciones cliente.
* **Independencia Lógica:** Permite agregar columnas, relaciones o vistas sin romper el software que sólo consume un subconjunto de los atributos.
* **Catálogo del Sistema (Diccionario de Datos):** Conjunto de tablas del sistema que describen la estructura de la base (`pg_class`, `pg_attribute` en PostgreSQL; `sys.tables`, `sys.columns` en SQL Server).

---

### 2. Almacenamiento Físico: Bloques, Buffers y Metodología de Sizing

#### Conceptos Clave
* **Página / Bloque:** Unidad mínima de I/O entre disco y el *Buffer Pool* en RAM (8 KB en PostgreSQL y SQL Server; 16 KB en MySQL InnoDB).
* **Estructura del Bloque de 8 KB (8192 bytes):**
  * *Page Header:* ~96–132 bytes con metadatos de página, LSN (Log Sequence Number) y punteros a tuplas (*ItemIds* o ranuras).
  * *Espacio Útil Máximo:* En SQL Server, tras restar cabeceras de página y slots de punteros, el espacio útil disponible para almacenar filas es de **8060 bytes**.
  * Las filas crecen desde el final de la página hacia arriba, y los punteros crecen desde la cabecera hacia abajo.

```
+---------------------------------------------------------------+
|  Page Header (LSN, espacio libre, punteros a filas / slots)   |
+---------------------------------------------------------------+
|  Item 1 ptr  |  Item 2 ptr  |  Item 3 ptr  | ...              |
+---------------------------------------------------------------+
|                      <-- Espacio Libre -->                    |
+---------------------------------------------------------------+
| ...          | Fila 3       | Fila 2       | Fila 1           |
+---------------------------------------------------------------+
```

---

#### 🧮 Ejemplo Concreto Resuelto: Dimensionamiento Físico (Taller #1 — Sizing)

> **Enunciado de Cátedra:**  
> Se debe diseñar la persistencia para una tabla de telemetría de eventos con las siguientes características:
> * Volumen transaccional: **1.200.000 eventos por día**.
> * Bloques de disco de **8 KB** con **8060 bytes útiles**.
> * Durante **8 semanas al año**, el volumen sufre un pico estacional aumentando a **2,5 veces** el flujo habitual.

**Paso 1: Cálculo del tamaño promedio por fila ($R$)**  
Se calcula el ancho en bytes sumando tipos de datos y *overhead* de fila:

| Columna | Tipo de Dato | Consumo en Bytes |
| :--- | :--- | :---: |
| `id_evento` | `BIGINT` | 8 bytes |
| `timestamp_evento` | `TIMESTAMP` | 8 bytes |
| `id_dispositivo` | `INTEGER` | 4 bytes |
| `codigo_estado` | `CHAR(2)` | 2 bytes |
| `payload_datos` | `VARCHAR(400)` (promedio real) | 400 bytes |
| *Overhead de fila* | Cabecera de tupla, null bitmap, longitudes | 16 bytes |
| **Total Fila ($R$)** | | **438 bytes** |

**Paso 2: Filas útiles por bloque ($N_R$)**  
$$N_R = \left\lfloor \frac{\text{Espacio Útil}}{\text{Tamaño Fila}} \right\rfloor = \left\lfloor \frac{8060}{438} \right\rfloor = \lfloor 18,39 \rfloor = \mathbf{18 \text{ filas/bloque}}$$
*(Los 176 bytes restantes quedan como espacio libre de fragmentación interna en el bloque).*

**Paso 3: Bloques y Almacenamiento diario habitual**  
$$\text{Páginas por día} = \frac{1.200.000 \text{ eventos}}{18 \text{ filas/pág}} = \mathbf{66.667 \text{ páginas/día}}$$  
$$\text{Storage diario habitual} = 66.667 \times 8 \text{ KB} = 533.336 \text{ KB} \approx \mathbf{520,8 \text{ MB/día}}$$

**Paso 4: Proyección Anual con Picos de Carga (8 semanas al año = 56 días)**  
* Días habituales: $365 - 56 = 309 \text{ días}$
* Días de pico ($2,5\times$): $56 \text{ días}$
* Total almacenamiento en datos netos:
  $$\text{Días normales} = 309 \times 520,8 \text{ MB} \approx 160.927 \text{ MB} \ (160,9 \text{ GB})$$
  $$\text{Días pico} = 56 \times (520,8 \text{ MB} \times 2,5) \approx 72.912 \text{ MB} \ (72,9 \text{ GB})$$
  $$\text{Total Anual Datos} = 160,9 + 72,9 = \mathbf{233,8 \text{ GB/año}}$$
* **Reserva técnica (Overhead de Índices, Logs WAL y Crecimiento futuro):** Se proyecta un factor de resguardo del **40%**:
  $$\text{Storage Total Proyectado Anual} = 233,8 \text{ GB} \times 1,4 \approx \mathbf{327,3 \text{ GB}}$$

---

### 3. Índices: Estructuras B+ Tree vs. Bitmap

#### A. Árboles B+ (B+ Tree)
En un árbol B+, **todas las claves de datos y punteros a registros residen exclusivamente en los nodos hoja**, los cuales se encuentran interconectados horizontalmente mediante una lista doblemente enlazada. Los nodos raíz e internos sólo alojan claves separadoras y punteros a nodos hijos.

```
                    [ Root: 50 | 100 ]
                       /     |     \
         +------------+      |      +------------+
         v                   v                   v
     [ 20 | 35 ]        [ 65 | 80 ]        [ 120 | 150 ]   (Nodos Internos)
       /   |   \          /   |   \          /   |   \
      v    v    v        v    v    v        v    v    v
    [Hojas con datos/punteros RID] <== Doble Enlace ==> [Hojas ...]
```

* **Búsqueda puntual (`WHERE id = 65`):** Desde la raíz, desciende logarítmicamente requiriendo únicamente $3$ accesos a disco (raíz $\to$ nodo interno $\to$ nodo hoja).
* **Búsqueda por rango (`WHERE id BETWEEN 30 AND 75`):** Realiza la búsqueda puntual de la primera clave ($30$) y luego recorre linealmente las hojas enlazadas hacia la derecha, evitando volver a descender por la raíz.

#### B. Índices Bitmap
Indicados para columnas con **baja cardinalidad** (pocos valores distintos comparados con el volumen de tuplas).

* **Ejemplo Concreto:** Tabla `CLIENTES` con $6$ registros y columna `EstadoCivil` $\in \{\text{'S'}, \text{'C'}, \text{'D'}\}$:

| RID | Nombre | EstadoCivil |
| :---: | :--- | :---: |
| 1 | Ana | S |
| 2 | Bruno | C |
| 3 | Carla | C |
| 4 | Diego | S |
| 5 | Elena | D |
| 6 | Franco | S |

Vectores de bits generados:
* $\text{Bitmap}_{\text{'S'}} = [1, 0, 0, 1, 0, 1]$
* $\text{Bitmap}_{\text{'C'}} = [0, 1, 1, 0, 0, 0]$
* $\text{Bitmap}_{\text{'D'}} = [0, 0, 0, 0, 1, 0]$

Si se consulta `WHERE EstadoCivil = 'S' OR EstadoCivil = 'D'`, el motor evalúa la operación booleana a nivel de registro de CPU:
$$\text{Bitmap}_{\text{'S'}} \ \mathbf{OR} \ \text{Bitmap}_{\text{'D'}} = [1, 0, 0, 1, 0, 1] \vee [0, 0, 0, 0, 1, 0] = [\mathbf{1}, 0, 0, \mathbf{1}, \mathbf{1}, \mathbf{1}]$$
El DBMS accede únicamente a las filas con bit $1$ (RIDs 1, 4, 5 y 6) con mínimo consumo de CPU.

---

## 📐 **Track 2: Diseño de Bases de Datos Relacionales: modelado y normalización**

> 📅 **Ruta de aprendizaje cursada:**
> * **Clase 1:** Herramientas de diagramación (Draw.io / Visio)
> * **Clase 3:** Modelo Relacional y Entidad-Relación (Teórica) / Taller #2 (Modelado DER)
> * **Clase 4:** Introducción a la Normalización (Taller #3)
> * **Clases 5 y 6:** Modelado y Normalización #1 y #2 (Taller #7 — Práctica 1)
> * **Clase 7 (22/09):** Taller #9 — Revisión de **Práctica 1**, presentación de **Práctica 2** (`FN - Practica 2.pdf`) y evaluación del Ticket de Salida (`Ticket de Salida Taller #9 - FN 2.md`).

---

### 1. Reglas de Transformación del DER al Modelo Relacional
1. **Entidad Fuerte:** Se convierte en una tabla; sus atributos determinantes forman la `PRIMARY KEY (PK)`.
2. **Relación $1:1$:** La PK de una de las entidades migra como `FOREIGN KEY (FK)` a la otra, con restricción `UNIQUE`.
3. **Relación $1:N$:** La PK de la entidad del lado "$1$" migra obligatoriamente como clave foránea (`FK`) a la tabla del lado "$N$".
4. **Relación $N:M$:** No puede representarse directamente en una tabla. Se descompone generando una **tabla intermedia asociativa** que contiene:
   * Las FKs hacia ambas tablas participantes.
   * La clave primaria compuesta por ambas FKs (`PK(FK_1, FK_2)`).
   * Los atributos propios de la relación (ej. `fecha_inscripcion`, `calificacion`, `cantidad_vendida`).

---

### 2. Ejercicio Práctico Resuelto: Normalización Paso a Paso (1FN $\to$ 2FN $\to$ 3FN)

Tomemos el caso representativo de la **Práctica 2 de Normalización (`FN - Practica 2.pdf`)**:

#### Tabla Desnormalizada Original (Planilla de Carreras de Caballos)
Columnas presentes:
```
(Codigo_carrera, Nombre_carrera, Dia_carrera, Lugar_carrera,
 Cod_caballo, Nombre_caballo, Nacimiento_caballo, Cant_carreras_ganadas,
 Nro_afil_dueno, Nombre_dueno, Contacto_dueno, Cantidad_caballos_afiliados,
 Posicion_carrera)
```

Datos de muestra:
* Carrera $12$ (*Gran Rural*, 12/12/2019, Palermo) corren Caballo $C24$ (*Trueno*, dueño $14$ Juan) y Caballo $C35$ (*Rayo*, dueño $25$ Pedro).

---

#### 🟢 Paso 1: Primera Forma Normal (1FN)
* **Regla:** Todos los valores deben ser atómicos. No debe haber grupos repetitivos o listas en una celda.
* **Acción:** Se define formalmente la **Clave Primaria Candidata/Compuesta**: para identificar de forma unívoca a una fila en la competencia, la clave mínima es `(Codigo_carrera, Cod_caballo)`.

**Esquema en 1FN:**
$$\underline{\text{CARRERA\_CABALLO}}(\mathbf{\underline{Codigo\_carrera}}, \mathbf{\underline{Cod\_caballo}}, Nombre\_carrera, Dia\_carrera, Lugar\_carrera, Nombre\_caballo, Nacimiento\_caballo, Cant\_carreras\_ganadas, Nro\_afil\_dueno, Nombre\_dueno, Contacto\_dueno, Cantidad\_caballos\_afiliados, Posicion\_carrera)$$

* **Anomalías detectadas:**
  * *Redundancia:* Si $15$ caballos corren la carrera $12$, el nombre de la carrera, la fecha y el lugar se repiten $15$ veces.
  * *Anomalía de borrado:* Si eliminamos las participaciones de una carrera recién creada sin competidores, perdemos el registro de la carrera.

---

#### 🟡 Paso 2: Segunda Forma Normal (2FN)
* **Regla:** Cumplir 1FN y **eliminar las dependencias funcionales parciales**: ningún atributo no clave puede depender de sólo una parte de la clave primaria compuesta `(Codigo_carrera, Cod_caballo)`.

**Análisis de Dependencias Funcionales:**
1. Dependen únicamente de `Codigo_carrera` (fracción de la clave):  
   $$Codigo\_carrera \longrightarrow \{Nombre\_carrera, Dia\_carrera, Lugar\_carrera\}$$
2. Dependen únicamente de `Cod_caballo` (fracción de la clave):  
   $$Cod\_caballo \longrightarrow \{Nombre\_caballo, Nacimiento\_caballo, Cant\_carreras\_ganadas, Nro\_afil\_dueno, Nombre\_dueno, Contacto\_dueno, Cantidad\_caballos\_afiliados\}$$
3. Dependen de la clave completa `(Codigo_carrera, Cod_caballo)`:  
   $$(Codigo\_carrera, Cod\_caballo) \longrightarrow \{Posicion\_carrera\}$$

**Descomposición en 2FN:**
1. $\text{CARRERA}(\mathbf{\underline{Codigo\_carrera}}, Nombre\_carrera, Dia\_carrera, Lugar\_carrera)$
2. $\text{CABALLO}(\mathbf{\underline{Cod\_caballo}}, Nombre\_caballo, Nacimiento\_caballo, Cant\_carreras\_ganadas, Nro\_afil\_dueno, Nombre\_dueno, Contacto\_dueno, Cantidad\_caballos\_afiliados)$
3. $\text{PARTICIPACION}(\mathbf{\underline{Codigo\_carrera}}, \mathbf{\underline{Cod\_caballo}}, Posicion\_carrera)$  
   *(Claves foráneas: `FK Codigo_carrera REFERENCES CARRERA`, `FK Cod_caballo REFERENCES CABALLO`).*

---

#### 🔴 Paso 3: Tercera Forma Normal (3FN)
* **Regla:** Cumplir 2FN y **eliminar las dependencias transitivas**: ningún atributo no clave puede determinar funcionalmente a otro atributo no clave.

**Análisis de Transitivas en la tabla `CABALLO`:**
* La clave primaria es `Cod_caballo`.
* El atributo `Nro_afil_dueno` no es clave, pero determina funcionalmente a otros atributos no clave:
  $$Cod\_caballo \longrightarrow Nro\_afil\_dueno \longrightarrow \{Nombre\_dueno, Contacto\_dueno, Cantidad\_caballos\_afiliados\}$$
* Esto viola la 3FN, provocando anomalías si un dueño no tiene caballos asignados o si actualiza su teléfono.

**Descomposición Definitiva en 3FN:**
1. **$\text{DUENO}(\mathbf{\underline{Nro\_afil\_dueno}}, Nombre\_dueno, Contacto\_dueno, Cantidad\_caballos\_afiliados)$**
2. **$\text{CABALLO}(\mathbf{\underline{Cod\_caballo}}, Nombre\_caballo, Nacimiento\_caballo, Cant\_carreras\_ganadas, Nro\_afil\_dueno^{*})$**  
   *(FK: `Nro_afil_dueno` $\to$ `DUENO`).*
3. **$\text{CARRERA}(\mathbf{\underline{Codigo\_carrera}}, Nombre\_carrera, Dia\_carrera, Lugar\_carrera)$**
4. **$\text{PARTICIPACION}(\mathbf{\underline{Codigo\_carrera^{*}}}, \mathbf{\underline{Cod\_caballo^{*}}}, Posicion\_carrera)$**  
   *(Tabla intermedia asociativa con FKs a `CARRERA` y `CABALLO`).*

---

#### 📊 Reconstrucción del DER a partir del Esquema Normalizado en 3FN

```
+---------------+           +---------------+
|     DUENO     | 1       N |    CABALLO    |
|---------------|-----------|---------------|
| PK Nro_dueno  |           | PK Cod_caballo|
|    Nombre     |           |    Nombre     |
|    Contacto   |           | FK Nro_dueno  |
+---------------+           +---------------+
                                    | 1
                                    |
                                    | N
                            +------------------+
                            |  PARTICIPACION   |
                            |------------------|
                            | PK,FK Cod_carrera|
                            | PK,FK Cod_caballo|
                            |       Posicion   |
                            +------------------+
                                    | N
                                    |
                                    | 1
                            +------------------+
                            |     CARRERA      |
                            |------------------|
                            | PK Cod_carrera   |
                            |    Nombre        |
                            |    Dia           |
                            |    Lugar         |
                            +------------------+
```

---

### 3. Normalización vs. Desnormalización y Trade-Offs de Rendimiento
A partir de los conceptos evaluados en el **Ticket de Salida del Taller #9 (FN 2)**, se destacan los criterios de ingeniería sobre el esquema:
* **Beneficios de la Normalización (hasta 3FN):**
  1. *Integridad y Consistencia:* Erradica las anomalías de actualización y eliminación. Si un dato cambia, se modifica en un único lugar.
  2. *Optimización de Almacenamiento:* Elimina el desperdicio de bytes en disco generado por tuplas redundantes.
* **El Concepto de Desnormalización:**
  * Consiste en **introducir redundancia controlada de forma intencional y deliberada** en el esquema de tablas.
  * **Objetivo de ingeniería:** Mejorar el tiempo de respuesta y el *throughput* en **consultas de lectura frecuentes y de alto volumen**, evitando operaciones intensivas de `JOIN` entre tablas muy fragmentadas.
  * **Trade-off:** Beneficia las lecturas (`SELECT`), pero penaliza las escrituras (`INSERT`, `UPDATE`, `DELETE`) e incrementa el riesgo de inconsistencias si no se sincronizan rigurosamente los datos duplicados.

---

## 💻 **Track 3: Lenguajes relacionales: pensar en Álgebra Relacional, escribir en SQL**

> 📅 **Ruta de aprendizaje cursada:**
> * **Clase 4:** Introducción al Álgebra Relacional (Taller #4)
> * **Clase 5:** Álgebra Relacional Avanzada (Taller #5) / SQL: DDL y DML (Taller #6)
> * **Clase 6 (15/09):** **Taller #8 (SQL #1)** — "Del Álgebra Relacional al SQL" (`009 - Taller #8 - Visuals - De Algebra Relacional a SQL.pdf` y `Ticket Salida Taller #8.md`) / Ticket de Salida Taller #5
> * **Clase 7 (22/09):** **Taller #10 (SQL #2)** — Práctica intensiva de Álgebra Relacional a SQL sobre el modelo canónico **Proveedores – Partes – Catálogo** (`011 - Taller #10 - SQL 2.pdf` y evaluación del `Ticket de Salida Taller #10 - SQL 2.md`).

---

### 1. El Puente Formal: De los Operadores de Álgebra Relacional a las Cláusulas SQL
El álgebra relacional es el lenguaje procedimental que modela el procesamiento interno del motor; SQL es su implementación declarativa comercial:

| Operador de Álgebra Relacional | Símbolo | Cláusula SQL Equivalente | Comportamiento Técnico |
| :--- | :---: | :--- | :--- |
| **Proyección** | $\pi$ | `SELECT [DISTINCT] columnas` | En AR siempre elimina duplicados. En SQL se requiere `DISTINCT` para operar como conjunto puro. |
| **Selección** | $\sigma$ | `WHERE condición` | Filtro horizontal de filas mediante predicados booleanos (`AND`, `OR`, `NOT`). |
| **Renombrado** | $\rho$ / $\leftarrow$ | `AS alias` | Alias de tabla o columna (esencial para auto-juntas y desambiguación). |
| **Producto cartesiano** | $\times$ | `FROM a, b` o `CROSS JOIN` | Genera $\|A\| \cdot \|B\|$ tuplas sin condición de coincidencia. |
| **Junta natural** | $\bowtie$ | `NATURAL JOIN` | Junta implícita por todos los atributos homónimos. |
| **Junta interna (Theta)** | $\bowtie_{\theta}$ | `INNER JOIN ... ON condición` | Junta relacional con condición explícita (equijoin conserva ambas columnas). |
| **Junta externa** | $\bowtie_{\text{izq}}$ / $\bowtie_{\text{der}}$ | `LEFT JOIN` / `RIGHT JOIN ... ON` | Preserva tuplas sin correspondencia completando con valores `NULL`. |
| **Unión** | $\cup$ | `UNION` / `UNION ALL` | `UNION` elimina duplicados; `UNION ALL` conserva el multiconjunto. |
| **Intersección** | $\cap$ | `INTERSECT` (o subconsulta `IN`) | Identifica tuplas compartidas por ambos conjuntos. |
| **Diferencia** | $-$ | `EXCEPT` / `MINUS` | Tuplas en el primer conjunto que no están en el segundo (`WHERE NOT EXISTS`). |
| **Cociente (División)** | $/$ o $\div$ | **Doble `NOT EXISTS`** | Expresa la condición: *"No existe elemento en B que le falte a este X"*. |
| **Agregación** | $\mathcal{F}$ | `GROUP BY ... (COUNT, AVG, ...)` | Agrupa tuplas y evalúa métricas; el filtro sobre el grupo se aplica con `HAVING`. |

---

### 2. Modelo Relacional Oficial del Taller #10: Proveedores – Partes – Catálogo

```
PROVEEDORES ( pr_id: integer, nombre: string, ciudad: string )
PARTES      ( pa_id: integer, nombre: string, color: string )
CATALOGO    ( pr_id: integer, pa_id: integer, costo: double )
```
* **Diagrama Entidad-Relación:**  
  `PROVEEDORES` ($1$) <---> ($N$) `CATALOGO` ($N$) <---> ($1$) `PARTES`
* **Claves e Integridad:**  
  En `CATALOGO`, la clave primaria es compuesta `(pr_id, pa_id)` y ambas son claves foráneas (`pr_id` referencia a `PROVEEDORES`, `pa_id` referencia a `PARTES`). Resuelve la relación muchos a muchos ($M:N$). `costo` representa el precio al que un proveedor ofrece una parte ("fabricar/proveer" una pieza significa existir en `CATALOGO`).

---

### 3. Casos Prácticos Resueltos del Taller #10 (Álgebra Relacional vs. SQL)

#### A. Consulta (a): Proveedores que fabrican alguna pieza roja
* **Álgebra Relacional:**
  $$\pi_{\text{nombre}}\Big(\text{PROVEEDORES} \bowtie \big(\text{CATALOGO} \bowtie (\sigma_{\text{color = 'rojo'}}(\text{PARTES}))\big)\Big)$$
* **SQL:**
  ```sql
  SELECT DISTINCT pr.nombre
  FROM PROVEEDORES pr
  INNER JOIN CATALOGO c ON pr.pr_id = c.pr_id
  INNER JOIN PARTES pa ON pa.pa_id = c.pa_id
  WHERE pa.color = 'rojo';
  ```

---

#### B. Consulta (d): Proveedores que fabrican al menos una pieza roja Y al menos una pieza verde
* **Álgebra Relacional (Intersección):**
  $$\pi_{\text{nombre}}\Big(\text{PROVEEDORES} \bowtie (\text{CATALOGO} \bowtie \sigma_{\text{color='rojo'}}(\text{PARTES}))\Big) \ \cap \ \pi_{\text{nombre}}\Big(\text{PROVEEDORES} \bowtie (\text{CATALOGO} \bowtie \sigma_{\text{color='verde'}}(\text{PARTES}))\Big)$$
* **SQL (con `INTERSECT`):**
  ```sql
  SELECT pr.nombre
  FROM PROVEEDORES pr
  INNER JOIN CATALOGO c ON pr.pr_id = c.pr_id
  INNER JOIN PARTES pa ON pa.pa_id = c.pa_id
  WHERE pa.color = 'rojo'
  INTERSECT
  SELECT pr.nombre
  FROM PROVEEDORES pr
  INNER JOIN CATALOGO c ON pr.pr_id = c.pr_id
  INNER JOIN PARTES pa ON pa.pa_id = c.pa_id
  WHERE pa.color = 'verde';
  ```

---

#### C. Consulta (e): Proveedores que fabrican TODAS las piezas existentes (División Relacional)
* **Álgebra Relacional (Operador Cociente $\div$):**
  $$\pi_{\text{nombre}}\Bigg(\text{PROVEEDORES} \bowtie \Big( \pi_{\text{pr\_id, pa\_id}}(\text{CATALOGO}) \div \pi_{\text{pa\_id}}(\text{PARTES}) \Big)\Bigg)$$
* **SQL Estándar (Doble `NOT EXISTS`):**
  ```sql
  SELECT pr.nombre
  FROM PROVEEDORES pr
  WHERE NOT EXISTS (
      -- Conjunto de piezas que este proveedor NO fabrica
      SELECT 1 
      FROM PARTES pa
      WHERE NOT EXISTS (
          SELECT 1 
          FROM CATALOGO c
          WHERE c.pr_id = pr.pr_id 
            AND c.pa_id = pa.pa_id
      )
  );
  ```

---

#### D. Consulta (i): Pares únicos de proveedores distintos donde para una misma pieza uno cobra más caro que el otro (Auto-Join)
* **Requerimiento:** Pares `(pr_id1, pr_id2)` tales que para una misma parte, `pr_id1` la cataloga a mayor costo que `pr_id2`.
* **Álgebra Relacional:**
  $$\pi_{\text{C1.pr\_id, C2.pr\_id}}\Big(\sigma_{\text{C1.pa\_id = C2.pa\_id} \,\land\, \text{C1.costo > C2.costo} \,\land\, \text{C1.pr\_id} \ne \text{C2.pr\_id}}(\rho_{\text{C1}}(\text{CATALOGO}) \times \rho_{\text{C2}}(\text{CATALOGO}))\Big)$$
* **SQL:**
  ```sql
  SELECT DISTINCT c1.pr_id AS pr_id1, c2.pr_id AS pr_id2
  FROM CATALOGO c1
  INNER JOIN CATALOGO c2 ON c1.pa_id = c2.pa_id
  WHERE c1.costo > c2.costo 
    AND c1.pr_id <> c2.pr_id;
  ```

---

#### E. Consulta (j) y (o): Agregaciones y Cláusula `HAVING`
* **Piezas fabricadas por al menos 2 proveedores distintos:**
  ```sql
  SELECT pa.nombre
  FROM PARTES pa
  INNER JOIN CATALOGO c ON pa.pa_id = c.pa_id
  GROUP BY pa.pa_id, pa.nombre
  HAVING COUNT(DISTINCT c.pr_id) >= 2;
  ```
* **Nombre de cada proveedor y cantidad de piezas que provee:**
  ```sql
  SELECT pr.nombre, COUNT(c.pa_id) AS cant_piezas
  FROM PROVEEDORES pr
  LEFT JOIN CATALOGO c ON pr.pr_id = c.pr_id
  GROUP BY pr.pr_id, pr.nombre;
  ```

---

### 4. El Orden Lógico de Evaluación de una Consulta en el Motor
El DBMS evalúa la consulta en una secuencia estricta diferente al orden de redacción:

```
[1. FROM / JOIN]   --> Carga las tablas fuente y resuelve los productos cartesianos/joins.
       |
[2. WHERE]         --> Filtra tuplas individuales ANTES de cualquier agregación.
       |
[3. GROUP BY]      --> Agrupa las filas restantes por los atributos indicados.
       |
[4. HAVING]        --> Filtra los GRUPOS consolidados evaluando funciones agregadas.
       |
[5. SELECT]        --> Evalúa expresiones de columnas, alias y DISTINCT.
       |
[6. ORDER BY]      --> Ordena la salida final (consume recursos de sort en memoria/disco).
```

---

## 🔒 **Track 4: Seguridad, Transacciones y Concurrencia**

> 📅 **Ruta de aprendizaje cursada:**
> * **Clase 6:** Transacciones, Propiedades ACID, Concurrencia y Recuperación (Teórica #4 y Apunte 6)
> * **Clase 7 (22/09):** Sesión Fishbowl #3 (Transacciones Distribuidas, Modelo XA, 2PC vs. 3PC y Deadlocks)

---

### 1. El Paradigma Transaccional y Propiedades ACID

#### Caso Concreto: Transferencia Bancaria
Transferir \$5.000 de Armando ($A = \$20.000$) a Benito ($B = \$0$):
```sql
BEGIN TRANSACTION;
  -- Paso 1: Débito en Cuenta A
  UPDATE CUENTA SET saldo = saldo - 5000 WHERE titular = 'Armando';
  
  -- <--- FALLA DE SISTEMA / CORTE DE ENERGÍA AQUÍ --->
  
  -- Paso 2: Crédito en Cuenta B
  UPDATE CUENTA SET saldo = saldo + 5000 WHERE titular = 'Benito';
COMMIT;
```
* **Garantía ACID:**
  * **A (Atomicidad):** Ante la caída en la mitad del proceso, el log transaccional fuerza un `ROLLBACK`. Armando recupera sus \$20.000. No se volatiliza dinero.
  * **C (Consistencia):** La suma total $A + B = \$20.000$ antes y después de la transacción. Las restricciones de saldo no negativo (`CHECK saldo >= 0`) se preservan.
  * **I (Aislamiento):** Si un proceso auditor lee el saldo de Armando y Benito concurrentemente, verá (\$20.000, \$0) o (\$15.000, \$5.000), pero **jamás** (\$15.000, \$0).
  * **D (Durabilidad):** Al recibir el mensaje de `COMMIT`, los \$5.000 en la cuenta de Benito no pueden perderse ante una falla de hardware.

---

### 2. Anomalías de Concurrencia (Trazas de Ejecución)

#### A. Lectura Sucia (*Dirty Read*)
$T_2$ lee datos no confirmados por $T_1$, que luego aborta:

| Tiempo | Transacción $T_1$ | Transacción $T_2$ | Estado en Base de Datos |
| :---: | :--- | :--- | :--- |
| $t_1$ | `UPDATE CUENTA SET saldo = 15000 WHERE id = 1;` | | $saldo = 15.000$ (en Buffer RAM) |
| $t_2$ | | `SELECT saldo FROM CUENTA WHERE id = 1;` *(lee 15.000)* | $T_2$ opera con saldo irreal |
| $t_3$ | `ROLLBACK;` | | $saldo$ vuelve a $20.000$ |
| $t_4$ | | Emite reporte o transfiere usando \$15.000 | **¡Inconsistencia de Negocio!** |

#### B. Lectura No Repetible (*Non-Repeatable / Fuzzy Read*)
$T_1$ lee el mismo registro dos veces dentro de su transacción y obtiene valores distintos porque $T_2$ modificó y confirmó entre lecturas:

| Tiempo | Transacción $T_1$ | Transacción $T_2$ |
| :---: | :--- | :--- |
| $t_1$ | `SELECT stock FROM PRODUCTO WHERE id = 10;` *(retorna 50)* | |
| $t_2$ | | `UPDATE PRODUCTO SET stock = 10 WHERE id = 10; COMMIT;` |
| $t_3$ | `SELECT stock FROM PRODUCTO WHERE id = 10;` *(retorna 10)* | |

---

### 3. Protocolos de Bloqueo, Deadlocks y Grafos WFG

#### A. Strict Two-Phase Locking (S2PL)
* Regla 1: Para leer, solicita candado compartido ($S$). Múltiples transacciones pueden tener candado $S$ concurrente.
* Regla 2: Para escribir, solicita candado exclusivo ($X$). Ninguna otra transacción puede leer ni escribir.
* Regla Estricta: **Todos los candados ($S$ y $X$) se conservan retenidos hasta el fin de la transacción (`COMMIT` o `ROLLBACK`)**.

#### B. Escenario Concreto de Deadlock (Interbloqueo Mutuo)

| Tiempo | Transacción $T_1$ | Transacción $T_2$ |
| :---: | :--- | :--- |
| $t_1$ | Adquiere $X(A)$ con éxito | Adquiere $X(B)$ con éxito |
| $t_2$ | Intenta leer o escribir $B \implies$ Solicita $X(B)$ *(Bloqueada por $T_2$)* | |
| $t_3$ | *(Esperando a $T_2$)* | Intenta leer o escribir $A \implies$ Solicita $X(A)$ *(Bloqueada por $T_1$)* |
| **Fin** | **$T_1$ espera a $T_2$ y $T_2$ espera a $T_1$ $\implies$ ¡DEADLOCK!** | |

#### C. Detección por Grafo de Espera (*Wait-For Graph - WFG*)
* Nodos: $\{T_1, T_2\}$
* Arcos de espera: $T_1 \longrightarrow T_2$ (porque $T_1$ espera $B$) y $T_2 \longrightarrow T_1$ (porque $T_2$ espera $A$).
* Condición matemática: **Existe un ciclo dirigido ($T_1 \rightleftarrows T_2$)**.
* Resolución: El motor selecciona una **víctima** (por costo, tiempo activa o reintentos acumulados para evitar *inanición* o *starvation*), aborta esa transacción y libera sus recursos.

```
     +--------+
     |   T1   | <----+
     +--------+      |
         |           | (Espera candado A)
         |           |
(Espera  |           |
candado B)|      +--------+
         +-----> |   T2   |
                 +--------+
         [ CICLO DETECTADO ]
```

#### D. Prevención por Timestamps (Marcas de Tiempo)
Asumiendo que $T_{\text{vieja}}$ tiene timestamp $10$ y $T_{\text{nueva}}$ tiene timestamp $50$:
* **Wait-Die (No Expropiativo):**
  * Si $T_{\text{vieja}}$ pide recurso de $T_{\text{nueva}} \implies$ $T_{\text{vieja}}$ **espera**.
  * Si $T_{\text{nueva}}$ pide recurso de $T_{\text{vieja}} \implies$ $T_{\text{nueva}}$ **muere (aborta y reinicia)**.
* **Wound-Wait (Expropiativo):**
  * Si $T_{\text{vieja}}$ pide recurso de $T_{\text{nueva}} \implies$ $T_{\text{vieja}}$ **hiere a $T_{\text{nueva}}$ (la aborta y le saca el recurso)**.
  * Si $T_{\text{nueva}}$ pide recurso de $T_{\text{vieja}} \implies$ $T_{\text{nueva}}$ **espera**.

---

### 4. Técnicas de Recuperación ante Fallos (WAL y Checkpoints)

#### Regla WAL (*Write-Ahead Logging*)
Antes de que una página de datos modificada en RAM se guarde en disco, el registro del Log transaccional correspondiente debe haberse grabado forzadamente (*flushed*) en disco.

#### Traza de Recuperación tras Caída
Supongamos la siguiente cronología en el Log:
```
1. [START T1]
2. [WRITE T1, A, 100, 200]
3. [CHECKPOINT (T1)]
4. [START T2]
5. [WRITE T2, B, 50, 75]
6. [COMMIT T1]
7. [START T3]
8. [WRITE T3, C, 10, 20]
===> ¡CAÍDA DEL SERVIDOR (CRASH)! <===
```
* **Acción del DBMS al reiniciar:**
  * Revisa desde el último `CHECKPOINT`.
  * $T_1$ hizo `COMMIT` antes de la caída $\implies$ Aplica **REDO** (rehace las modificaciones para garantizar Durabilidad).
  * $T_2$ y $T_3$ quedaron activas sin confirmar $\implies$ Aplica **UNDO** en reversa (deshace los cambios con el valor anterior para garantizar Atomicidad).

---

### 5. Transacciones Distribuidas: Modelo X/Open XA y Consenso 2PC vs. 3PC

#### A. Arquitectura X/Open XA (DTP)
```
          +-------------------------------+
          |   Aplicación Cliente (AP)     |
          +-------------------------------+
                | (TX)               | (SQL)
                v                    v
          +-----------+        +------------+
          | Transaction| (XA)  |  Resource  | (Base de Datos A)
          |  Manager  |======> |  Manager   |
          | (TM/Coord)|        | (RM 1)     |
          +-----------+        +------------+
                |                    |
                | (XA)               v
                |              +------------+
                +============> |  Resource  | (Base de Datos B)
                               |  Manager   |
                               | (RM 2)     |
                               +------------+
```

---

#### B. Protocolo Two-Phase Commit (2PC) Paso a Paso

**Caso Exitoso (Commit Global):**
1. AP solicita cierre al **TM** (`tx_commit`). El TM genera un identificador global `GTRID = 901`.
2. **Fase 1 (Prepare):**
   * TM envía mensaje `xa_prepare` a **RM 1** y **RM 2**.
   * RM 1 verifica integridad, escribe sus modificaciones en su WAL local y responde `READY`.
   * RM 2 verifica integridad, fuerza su WAL y responde `READY`.
3. **Fase 2 (Commit):**
   * Al haber **unanimidad**, el TM escribe `GLOBAL_COMMIT` en su log y envía la orden `xa_commit` a ambos.
   * RM 1 y RM 2 aplican los cambios, liberan sus $X$-locks y devuelven `ACK`.
   * El TM asienta `END_OF_TRANSACTION`.

**Caso de Falla y el Problema del Bloqueo (*Blocking Problem*):**
* Si RM 1 vota `READY` y RM 2 vota `ABORT` (o da timeout), el TM envía `GLOBAL_ABORT` a todos.
* **Transacción en Duda (*In-Doubt*):** Si RM 1 vota `READY` y en ese instante **el TM se apaga o colapsa el enlace de red**, RM 1 **no puede decidir por sí mismo**:
  * Si hace commit y el TM decidió abortar $\implies$ Quiebre de Consistencia.
  * Si hace abort y el TM decidió commit $\implies$ Quiebre de Consistencia.
  * **Consecuencia:** RM 1 queda **bloqueado indefinidamente reteniendo los candados exclusivos ($X$)** sobre las filas de la base. Toda otra transacción del sistema que necesite esas filas queda frenada en cola.

---

#### C. Three-Phase Commit (3PC) y el "Talón de Aquiles" (Partición de Red)
* 3PC añade la fase intermedia **Pre-Commit** y timeouts deterministas. Si expira el tiempo en estado pendiente, el participante asume de forma segura que todos estaban vivos y hace `COMMIT`, evitando el bloqueo indefinido.
* **Talón de Aquiles (Split-Brain):**  
  Si la red se corta y divide a los servidores en dos mitades aisladas (Subred 1 y Subred 2):
  * Los nodos de la Subred 1, que estaban en fase *Pre-Commit*, llegan a timeout y deciden **`COMMIT`**.
  * Los nodos de la Subred 2, que no recibieron el mensaje y quedaron en espera, llegan a timeout y deciden **`ABORT`**.
  * **Resultado:** La misma transacción global quedó mitad confirmada y mitad abortada, **violando la Atomicidad Global**. Por este riesgo, la industria opta por 2PC o consensos basados en quórum mayoritario (Paxos / Raft).

---

## 📂 **Apéndice: Material de Referencia Exhaustivo por Carpeta**

### 📁 Raíz del Repositorio
* [Cronograma_2026.md](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Cronograma_2026.md) — Calendario oficial de cursada, horarios y tracks.
* [Listado_Cronologico_Archivos.md](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Listado_Cronologico_Archivos.md) — Inventario temático pormenorizado de cada archivo de la cursada.
* [Print Aula Virtual al 22.09.pdf](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Print%20Aula%20Virtual%20al%2022.09.pdf) — Estado actualizado del campus EVA al 22 de septiembre con competencias y syllabus.
* [deploy.bat](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/deploy.bat) — Script de automatización de commits y sincronización con GitHub.

### 📁 [Clase 1_08-11](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%201_08-11) (Track 1)
* `001 - Clase Teórica #1 - Apunte 1 - Breve introduccion a la gestion de Datos - Parte 1.pdf`
* `002 - Visuals - Clase Teórica #1 - Breve Introducción a la Gestión de Datos Parte I.pdf`
* `003 - Mindmap de la Clase Teórica #1 - Breve introducción a la gestión de Datos - Parte 1.png`
* `007 - Prep. Fishbowl #1 - Apunte 2 - Breve introduccion a la gestion de Datos - Parte 2.pdf`
* `008 - Prep. Fishbowl #1 - Visuals - Breve Introducción a la Gestión de Datos Parte 2.pdf`
* `009 - Prep. Fishbowl #1 - MindMap - Breve introduccion a la gestion de Datos - Parte 2.png`
* `01_BDR 11-08 (notas tomadas en clase, incompletas).docx`

### 📁 [Clase 2_08-18](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%202_08-18) (Track 1)
* `012 - Clase Teórica #2 - Almacenamiento fisico (1) (1).pdf`
* `013 - Clase Teórica #2 - Visuals - Almacenamiento Físico y Sizing.pdf`
* `014 - MindMap - Clase Teórica #2 - Almacenamiento Físico.png`
* `02_BDR 18-08 (notas tomadas en clase, incompletas).docx`
* `Clase 2 transcripción.docx`

### 📁 [Clase 3_08-25](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%203_08-25) (Track 1 y Track 2)
* `015 - Visuals - Taller de Sizing.pdf`
* `Taller de Sizing.docx`
* `Metricas_Bases_de_Datos_relacionales.pdf`
* `001 - Clase Teórica #3 - Apunte - Introduccion al Modelo Relacional.pdf`
* `002 - Clase Teórica #3 - Visuals - Introducción al Modelo Relacional (1).pdf`
* `DER - Explicación.pdf`
* `DER - Práctica 1 v2026.pdf`
* `03_BDR 25-08 (notas tomadas en clase, incompletas).docx`

### 📁 [Clase 4_09-01](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%204_09-01) (Track 1 y Track 3)
* `018 - Apunte de índices.pdf`
* `019 - MindMap - Indices.png`
* `Indices - Visuals.pdf`
* `resumen.indices.fishbowl.md`
* `001 - Taller#3 - Apunte - Lenguajes relacionales.pdf`
* `002- Taller#3 - Visuals - Lenguajes Relacionales.pdf`
* `Practica 1 - Algebra Relacional (1).pdf`
* `Apunte tomado en clase (incompleto).pdf`

### 📁 [Clase 5_09-08](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%205_09-08) (Track 2 y Track 3)
* `006 - Algebra Relacional - Practica 2.pdf`
* `008 - Taller #6 - SQL DDL y DML.pdf`

### 📁 [Clase 6_09-15](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%206_09-15) (Track 2, Track 3 y Track 4)
* `Apunte 6 - Transacciones y concurrencia (1).pdf`
* `004 - Clase Teórica #4 - Recuperacion y Concurrencia.pdf`
* `Transacciones y Concurrencia - Visuals.pdf`
* `FN Explicacion v2.pdf`
* `FN_Practica1.pdf`
* `009 - Taller #8 - Visuals - De Algebra Relacional a SQL.pdf` (Track 3 — Presentación visual oficial de la cátedra para el Taller #8: Correspondencia de Álgebra a SQL).
* `Ticket de Salida Taller #5.md` (Track 3 — Resolución detallada y justificación formal de ejercicios de Álgebra Relacional: división, agregaciones y filtros).
* `Ticket Salida Taller #8.md` (Track 3 — Cuestionario / ticket de salida del Taller #8 de SQL #1).

### 📁 [Clase 7_09-22](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Clase%207_09-22) (Track 2, Track 3 y Track 4)
* `011 - Taller #10 - SQL 2.pdf` (Track 3 — Presentación oficial del Taller de SQL #2: Proveedores – Partes – Catálogo, consignas a – q).
* `FN - Practica 2.pdf` (Track 2 — Guía de ejercitación de Normalización a 3FN y reconstrucción del DER).
* `Ticket de Salida Taller #9 - FN 2.md` (Track 2 — Evaluación calificada 10/10 sobre 1FN, 2FN, 3FN, dependencias transitivas y desnormalización intencional).
* `Ticket de Salida Taller #10 - SQL 2.md` (Track 3 — Banco de 10 consultas SQL avanzadas resueltas sobre Proveedores, Partes y Catálogo con EXISTS, NOT EXISTS, agregaciones y LEFT JOIN).
* Subcarpeta `fishbowl 3/`:
  * `005 - Sesión Fishbowl #3 - Resumen de Transacciones Distribuidas.pdf`
  * `006 - Sesión Fishbowl #3 - MindMap de Transacciones y Transacciones Distribuidas.png`
  * `Resumen_Fishbowl_3_Transacciones_Distribuidas.md` (Guía maestra y síntesis exhaustiva para el debate)
  * `Notas Fishbowl #3 (tomadas durante el fisbowl).pdf` (Anotaciones tomadas durante la sesión)
  * `Deadlocks_en_bases_de_datos.png` (Infografía de interbloqueos y WFG)
  * `Infografía_sobre_transacciones_distribuidas.png` (Infografía del protocolo 2PC)
  * `Integridad_de_Datos_y_Transacciones.png` (Infografía de consistencia y logs transaccionales)
