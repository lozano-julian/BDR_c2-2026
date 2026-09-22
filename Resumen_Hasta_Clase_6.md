# Resumen General: Bases de Datos Relacionales (Hasta Clase 6)

## **Track 1: El DBMS por dentro: arquitectura, almacenamiento e índices**
> 📅 **Ruta de aprendizaje cursada:**
> *   **Clase 1:** Introducción a la Gestión de Datos (Teórica)
> *   **Clase 2:** Almacenamiento Físico y Sizing (Teórica) / Características del DBMS (Fishbowl #1)
> *   **Clase 3:** Almacenamiento Físico (Taller #1)
> *   **Clase 4:** Índices (Fishbowl #2)

### 1. Fundamentos de Gestión de Datos
Un Sistema de Gestión de Bases de Datos (DBMS) surge como evolución a los sistemas de archivos tradicionales para resolver problemas críticos: redundancia de datos, aislamiento, anomalías de acceso concurrente y problemas de seguridad. Un DBMS provee una capa de abstracción entre los datos físicos y la aplicación, garantizando la independencia de los datos.

Entre sus **características principales** destacan el control de concurrencia, el manejo de transacciones, la gestión de almacenamiento y la existencia de un catálogo (diccionario de datos) que describe la estructura de la base.

### 2. Almacenamiento Físico y Sizing
Las bases de datos no guardan la información mágicamente; la persisten en disco (almacenamiento secundario). 
*   **Páginas y Bloques:** El disco se divide en páginas (o bloques), que son la unidad mínima de transferencia entre el disco y la memoria RAM (Buffer Pool). Leer una fila requiere traer a RAM toda la página que la contiene.
*   **Sizing (Estimación de tamaño):** Es el proceso matemático para predecir cuánto pesará una tabla o una base de datos entera. Implica calcular el tamaño de los metadatos de las columnas, estimar la cantidad de registros esperados y considerar el "overhead" (espacio de control) que usa el DBMS por cada página y fila.

### 3. Índices (Estructuras de Acceso)
Buscar datos recorriendo todas las páginas de un disco (Full Table Scan) es extremadamente costoso. Los índices son estructuras de datos adicionales (frecuentemente Árboles B o B+) que permiten localizar registros rápidamente sin leer toda la tabla.
*   Aceleran las consultas (`SELECT`), pero ralentizan las operaciones de escritura (`INSERT`, `UPDATE`, `DELETE`) ya que el árbol debe rebalancearse cada vez que los datos cambian.
*   Es vital indexar columnas que se usan frecuentemente en cláusulas `WHERE`, o para unir tablas (`JOIN`).

---

## **Track 2: Diseño de Bases de Datos Relacionales: modelado y normalización**
> 📅 **Ruta de aprendizaje cursada:**
> *   **Clase 1:** Setup de herramientas gráficas (Visio/Draw.io)
> *   **Clase 3:** Modelo Relacional y Entidad-Relación (Teórica) / DER (Taller #2)
> *   **Clase 4:** Normalización (Taller #3)
> *   **Clases 5 y 6:** Modelado y Normalización #1 y #2 (Taller #7)

### 1. El Diseño Conceptual (Modelo Entidad-Relación - DER)
Es el primer paso: traducir el problema del mundo real a un esquema que podamos entender independientemente de la tecnología.
*   **Entidades:** Objetos del mundo real distinguibles (ej. *Alumno*, *Materia*).
*   **Atributos:** Características de la entidad (ej. *Legajo*, *Nombre*). Un atributo debe ser identificador unívoco.
*   **Relaciones y Cardinalidad:** Cómo se conectan las entidades. Las cardinalidades (1:1, 1:N, N:M) definen las reglas de negocio (ej. "Un alumno puede cursar muchas materias, y una materia tiene muchos alumnos").

### 2. El Modelo Relacional (Diseño Lógico)
Es la traducción del DER a la estructura matemática que soporta el motor de BD, basada en la teoría de conjuntos.
*   **Tablas (Relaciones):** Las entidades se convierten en tablas. Sus filas son las "tuplas" (registros) y sus columnas los atributos.
*   **Clave Primaria (PK):** Identificador único, no nulo, de cada fila.
*   **Clave Foránea (FK):** Atributo en una tabla que hace referencia a la PK de otra tabla, garantizando la **Integridad Referencial** (evitar datos huérfanos). *Nota clave:* Las relaciones N:M en el DER siempre generan una tabla intermedia en el modelo relacional.

### 3. Normalización
Es una técnica de refactorización de tablas paso a paso para **eliminar la redundancia** de datos y **evitar anomalías** (de inserción, modificación o borrado). Se basa en el concepto de *dependencias funcionales* (qué atributo determina el valor de otro).
*   **1FN (Primera Forma Normal):** Todos los atributos deben ser atómicos (indivisibles). No se permiten grupos repetidos ni arrays en una celda.
*   **2FN:** Cumple 1FN y todos los atributos no clave dependen de la clave primaria **completa** (crítico en claves primarias compuestas por múltiples columnas).
*   **3FN:** Cumple 2FN y no hay dependencias transitivas (ningún atributo no clave depende de otro atributo no clave).
*   En la práctica, iteramos este proceso en múltiples talleres para iterar desde un diseño deficiente hasta un esquema relacional robusto.

---

## **Track 3: Lenguajes relacionales: Álgebra y SQL**
> 📅 **Ruta de aprendizaje cursada:**
> *   **Clase 4:** Álgebra Relacional (Taller #4)
> *   **Clase 5:** Álgebra Relacional (Taller #5) / SQL: DDL y DML (Taller #6)

### 1. Álgebra Relacional (La teoría detrás de la consulta)
El álgebra relacional es el lenguaje teórico de procedimientos genéricos. Entenderlo es fundamental para pensar *cómo* el DBMS va a ejecutar nuestra consulta. Opera tomando relaciones (tablas) como entrada y devolviendo relaciones como salida.
*   **Selección (σ):** Filtra filas (tuplas) que cumplen una condición.
*   **Proyección (π):** Filtra columnas (atributos).
*   **Producto Cartesiano (✕):** Combina todas las filas de la tabla A con todas las de la tabla B.
*   **Join (⨝):** Es un Producto Cartesiano seguido de una Selección por coincidencia de campos (suele ser FK = PK). Es la base para relacionar tablas cruzadas.

### 2. SQL: El Lenguaje Práctico
Structured Query Language es el lenguaje declarativo estándar ("le decimos qué queremos, no cómo hacerlo").
*   **DDL (Data Definition Language):** Usado para definir la estructura vista en el Track 2.
    *   Comandos principales: `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`. 
    *   Incluye la definición de los Tipos de Datos (INT, VARCHAR, DATE) y Restricciones (*Constraints* como PRIMARY KEY, FOREIGN KEY, NOT NULL).
*   **DML (Data Manipulation Language):** Usado para manipular los datos alojados.
    *   Comandos principales para modificación: `INSERT INTO`, `UPDATE`, `DELETE`.
    *   *(Nota: La sintaxis compleja de extracción con `SELECT` será el enfoque de los próximos talleres)*.

---

## **Track 4: Seguridad, Transacciones y Concurrencia**
> 📅 **Ruta de aprendizaje cursada:**
> *   **Clase 6:** Transacciones (Teórica) / Concurrencia (Práctica)

### 1. Transacciones y Propiedades ACID
Una transacción es una unidad lógica de trabajo que agrupa múltiples operaciones DML en un solo bloque. Si tu sistema tiene que transferir dinero de la cuenta A a la cuenta B, tanto la resta en A como la suma en B deben ocurrir, o ninguna de las dos.
Las transacciones deben garantizar el estándar **ACID**:
*   **Atomicity (Atomicidad):** Todo o nada (Commit o Rollback).
*   **Consistency (Consistencia):** La base pasa de un estado válido a otro, cumpliendo todas las *constraints*.
*   **Isolation (Aislamiento):** Las operaciones simultáneas no deben interferirse entre sí hasta estar terminadas.
*   **Durability (Durabilidad):** Una vez confirmada (Commit), la transacción sobrevive incluso a fallos eléctricos (usualmente gracias al *Transaction Log* en disco).

### 2. Introducción a la Concurrencia
¿Qué ocurre cuando dos transacciones intentan modificar la misma fila al mismo tiempo? Empiezan a surgir "fenómenos de lectura" (Lecturas Sucias, Lecturas No Repetibles, Lecturas Fantasmas). Para mitigarlos, el DBMS implementa bloqueos (*Locks*) y niveles de aislamiento que balancean consistencia de datos vs. rendimiento del sistema.

---

## **Apéndice: Material de Referencia por Track**

### Track 1: El DBMS por dentro: arquitectura, almacenamiento e índices
* **Clase 1 (Teórica):** `001 - Clase Teórica #1 - Apunte 1 - Breve introduccion a la gestion de Datos - Parte 1.pdf`
* **Clase 1 (Fishbowl #1):** `007 - Prep. Fishbowl #1 - Apunte 2 - Breve introduccion a la gestion de Datos - Parte 2.pdf`
* **Clase 2 (Teórica):** `012 - Clase Teórica #2 - Almacenamiento fisico (1) (1).pdf`
* **Clase 3 (Taller #1):** `Taller de Sizing.docx`
* **Clase 4 (Fishbowl #2):** `018 - Apunte de índices.pdf`

### Track 2: Diseño de Bases de Datos Relacionales: modelado y normalización
* **Clase 3 (Teórica):** `001 - Clase Teórica #3 - Apunte - Introduccion al Modelo Relacional.pdf`
* **Clase 3 (Taller #2):** `DER - Explicación.pdf`
* **Clase 6 (Taller #3 - Normalización):** `FN Explicacion v2.pdf`
* **Clase 6 (Taller #7 - Práctica FN):** `FN_Practica1.pdf`

### Track 3: Lenguajes relacionales: Álgebra y SQL
* **Clase 4 (Taller #4 - Álgebra Relacional):** `001 - Taller#3 - Apunte - Lenguajes relacionales.pdf`
* **Clase 5 (Taller #5 - Álgebra Relacional Práctica):** `006 - Algebra Relacional - Practica 2.pdf`
* **Clase 5 (Taller #6 - SQL DDL y DML):** `008 - Taller #6 - SQL DDL y DML.pdf`

### Track 4: Seguridad, Transacciones y Concurrencia
* **Clase 6 (Teórica - Transacciones):** `Apunte 6 - Transacciones y concurrencia (1).pdf`
* **Clase 6 (Práctica - Concurrencia y Recuperación):** `004 - Clase Teórica #4 - Recuperacion y Concurrencia.pdf`
