# Resumen de Clases - Orden Cronológico (BDR 2026)

Este documento detalla el contenido visto en cada clase, los temas abordados y el desglose de cada archivo de la carpeta local, especificando a qué **Track** corresponde y qué **tema específico** toca.

---

### 📌 Referencia de Ejes Temáticos (Tracks)
* **Track 1:** El DBMS por dentro: arquitectura, almacenamiento e índices
* **Track 2:** Diseño de Bases de Datos Relacionales: modelado y normalización
* **Track 3:** Lenguajes relacionales: pensar en Álgebra Relacional, escribir en SQL
* **Track 4:** Seguridad, Transacciones y Concurrencia
* **Track 5:** Optimización

---

### Clase 1 (11/08)
**Temas vistos en clase:**
* Presentación de la materia, programa y metodología de cursada.
* Breve introducción a la gestión de datos (Parte 1 y 2).
* Preparación para la Sesión Fishbowl #1 (Características de los DBMS).
* Práctica: Instalación de PostgreSQL y herramientas de diagramación (Draw.io / Visio).

**Archivos en la carpeta `Clase 1_08-11`:**
* `001 - Clase Teórica #1 - Apunte 1 - Breve introduccion a la gestion de Datos - Parte 1.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Fundamentos de sistemas de datos: evolución histórica, limitaciones de los sistemas de archivos tradicionales (redundancia, inconsistencia, aislamiento) y objetivos de abstracción e independencia de datos de un DBMS.
* `002 - Visuals - Clase Teórica #1 - Breve Introducción a la Gestión de Datos Parte I.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Presentación visual con diagramas y conceptos clave de la Clase Teórica #1.
* `003 - Mindmap de la Clase Teórica #1 - Breve introducción a la gestión de Datos - Parte 1.png`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Mapa mental que estructura gráficamente los conceptos de la introducción a la gestión de datos.
* `007 - Prep. Fishbowl #1 - Apunte 2 - Breve introduccion a la gestion de Datos - Parte 2.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Características principales de un DBMS: diccionario de datos/catálogo, control de concurrencia, transacciones, lenguajes DDL/DML y perfiles de usuarios (material base para debatir en Fishbowl #1).
* `008 - Prep. Fishbowl #1 - Visuals - Breve Introducción a la Gestión de Datos Parte 2.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Diapositivas de soporte para el estudio de las características esenciales del DBMS.
* `009 - Prep. Fishbowl #1 - MindMap - Breve introduccion a la gestion de Datos - Parte 2.png`  
  * **Track:** **Track 1** (El DBMS por dentro: arquitectura)  
  * **Tema:** Mapa mental de las características del DBMS para fijar conceptos antes del debate Fishbowl #1.
* `01_BDR 11-08 (notas tomadas en clase, incompletas).docx`  
  * **Track:** **Transversal** (Track 1 y Setup Práctico)  
  * **Tema:** Apuntes tomados en vivo durante la clase inaugural (acuerdo de cursada, herramientas y primeros conceptos).

---

### Clase 2 (18/08)
**Temas vistos en clase:**
* Sesión Fishbowl #1 (debate sobre características del DBMS).
* Almacenamiento Físico y Sizing (Teoría).

**Archivos en la carpeta `Clase 2_08-18`:**
* `012 - Clase Teórica #2 - Almacenamiento fisico (1) (1).pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: almacenamiento)  
  * **Tema:** Estructura física en disco: bloques/páginas, tamaño de registros, buffers en memoria RAM y fundamentos del dimensionamiento (*Sizing*) para predecir el espacio en disco.
* `013 - Clase Teórica #2 - Visuals - Almacenamiento Físico y Sizing.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: almacenamiento)  
  * **Tema:** Diapositivas explicativas sobre la organización de registros en bloques, overhead y estimación de sizing.
* `014 - MindMap - Clase Teórica #2 - Almacenamiento Físico.png`  
  * **Track:** **Track 1** (El DBMS por dentro: almacenamiento)  
  * **Tema:** Mapa mental que resume visualmente los componentes del almacenamiento físico y sizing.
* `02_BDR 18-08 (notas tomadas en clase, incompletas).docx`  
  * **Track:** **Track 1** (El DBMS por dentro)  
  * **Tema:** Notas en vivo de la clase: intervenciones del Fishbowl #1 y apuntes de la teórica de almacenamiento.
* `Clase 2 transcripción.docx`  
  * **Track:** **Track 1** (El DBMS por dentro)  
  * **Tema:** Transcripción textual completa del audio de la Clase 2 para consulta detallada.

---

### Clase 3 (25/08)
**Temas vistos en clase:**
* Taller #1: Almacenamiento Físico y Sizing (Práctica de cálculo).
* Introducción al Modelo Relacional (Teoría).
* Taller #2: Modelado mediante Diagrama Entidad-Relación (DER).

**Archivos en la carpeta `Clase 3_08-25`:**
* `015 - Visuals - Taller de Sizing.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: almacenamiento)  
  * **Tema:** Guía paso a paso y fórmulas para calcular el tamaño de filas, cantidad de registros por bloque y sizing total de tablas e índices.
* `Taller de Sizing.docx`  
  * **Track:** **Track 1** (El DBMS por dentro: almacenamiento)  
  * **Tema:** Enunciados y ejercicios de Taller #1 para calcular en la práctica el volumen de almacenamiento requerido.
* `Metricas_Bases_de_Datos_relacionales.pdf`  
  * **Track:** **Track 1 / Track 2**  
  * **Tema:** Tabla de referencia con los tipos de datos comunes en motores relacionales y el consumo de bytes por columna (vital para el cálculo de sizing y diseño de tablas).
* `001 - Clase Teórica #3 - Apunte - Introduccion al Modelo Relacional.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: modelado)  
  * **Tema:** Teoría del Modelo Relacional: relaciones, tuplas, atributos, dominios, claves primarias (PK), foráneas (FK) y reglas de integridad (de entidad y referencial).
* `002 - Clase Teórica #3 - Visuals - Introducción al Modelo Relacional (1).pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: modelado)  
  * **Tema:** Diapositivas de soporte teórico sobre la estructura matemática y lógica del Modelo Relacional.
* `DER - Explicación.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: modelado)  
  * **Tema:** Guía conceptual y metodológica de Taller #2: elementos del DER (entidades, atributos, relaciones, cardinalidades 1:1, 1:N, N:M) y reglas de transformación del DER a tablas relacionales.
* `DER - Práctica 1 v2026.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: modelado)  
  * **Tema:** Enunciados prácticos de casos de negocio para modelar mediante Diagramas Entidad-Relación.
* `03_BDR 25-08 (notas tomadas en clase, incompletas).docx`  
  * **Track:** **Track 1 y Track 2**  
  * **Tema:** Notas en vivo tomadas durante la resolución del taller de sizing y los primeros ejercicios de modelado DER.

---

### Clase 4 (01/09)
**Temas vistos en clase:**
* Sesión Fishbowl #2: Índices y estructuras de acceso.
* Taller #4: Introducción al Álgebra Relacional.
* Taller #3: Introducción a la Normalización de esquemas.

**Archivos en la carpeta `Clase 4_09-01`:**
* `018 - Apunte de índices.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: índices)  
  * **Tema:** Estructuras de índices: árboles B y B+, índices primarios, secundarios, clustering, hash; costos de búsqueda vs. sobrecarga en inserción/actualización (base para Fishbowl #2).
* `019 - MindMap - Indices.png`  
  * **Track:** **Track 1** (El DBMS por dentro: índices)  
  * **Tema:** Mapa mental con la clasificación y ventajas/desventajas de los distintos tipos de índices.
* `Indices - Visuals.pdf`  
  * **Track:** **Track 1** (El DBMS por dentro: índices)  
  * **Tema:** Diapositivas gráficas sobre indexación física y navegación de nodos en árboles B+.
* `resumen.indices.fishbowl.md`  
  * **Track:** **Track 1** (El DBMS por dentro: índices)  
  * **Tema:** Síntesis y puntos de debate preparados específicamente para la dinámica del Fishbowl #2.
* `001 - Taller#3 - Apunte - Lenguajes relacionales.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: Álgebra Relacional)  
  * **Tema:** Álgebra Relacional formal: operadores unarios (selección $\sigma$, proyección $\pi$) y binarios (producto cartesiano $\times$, unión, diferencia, natural join $\bowtie$, join condicional).
* `002- Taller#3 - Visuals - Lenguajes Relacionales.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: Álgebra Relacional)  
  * **Tema:** Diapositivas didácticas con ejemplos visuales de evaluación de consultas en Álgebra Relacional.
* `Practica 1 - Algebra Relacional (1).pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: Álgebra Relacional)  
  * **Tema:** Ejercitación práctica de Taller #4: redacción de consultas teóricas sobre esquemas relacionales dados.
* `Apunte tomado en clase (incompleto).pdf`  
  * **Track:** **Track 1 y Track 3**  
  * **Tema:** Anotaciones de clase sobre el debate de índices y la resolución de ejercicios de álgebra.

---

### Clase 5 (08/09)
**Temas vistos en clase:**
* Taller #5: Práctica avanzada de Álgebra Relacional.
* Taller #6: SQL práctico (DDL y DML).
* Taller #7: Modelado y Normalización #1.

**Archivos en la carpeta `Clase 5_09-08`:**
* `006 - Algebra Relacional - Practica 2.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: Álgebra Relacional)  
  * **Tema:** Ejercitación de Taller #5: consultas de Álgebra Relacional de mayor complejidad (joins múltiples, agrupamientos lógicos y operaciones condicionales).
* `008 - Taller #6 - SQL DDL y DML.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: escribir en SQL)  
  * **Tema:** Taller #6: Creación y modificación de estructuras de tablas en SQL mediante DDL (`CREATE TABLE`, `ALTER TABLE`, restricciones `PK`, `FK`, `NOT NULL`, `CHECK`) y manipulación básica mediante DML (`INSERT`, `UPDATE`, `DELETE`).

---

### Clase 6 (15/09)
**Temas vistos en clase:**
* Teoría de Transacciones (Propiedades ACID).
* Mecanismos de Concurrencia y Recuperación ante fallos.
* Taller #7: Modelado y Normalización #2 (Formas Normales 1FN, 2FN, 3FN).

**Archivos en la carpeta `Clase 6_09-15`:**
* `Apunte 6 - Transacciones y concurrencia (1).pdf`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Concepto de transacción como unidad atómica de trabajo, detalle de las propiedades ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad) y estados de transacción (Commit, Rollback, Abort).
* `Transacciones y Concurrencia - Visuals.pdf`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Diapositivas sobre el ciclo de vida transaccional y los problemas del acceso concurrente sin control.
* `004 - Clase Teórica #4 - Recuperacion y Concurrencia.pdf`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Técnicas de recuperación ante caídas (WAL - Write-Ahead Logging, checkpoints) y control de concurrencia mediante bloqueos (Locks compartidos/exclusivos, 2PL) y niveles de aislamiento SQL.
* `FN Explicacion v2.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: normalización)  
  * **Tema:** Teoría y método de Normalización: concepto de dependencias funcionales, anomalías de redundancia y pasos para alcanzar 1FN (atomicidad), 2FN (dependencia total de la PK) y 3FN (eliminación de transitivas).
* `FN_Practica1.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: normalización)  
  * **Tema:** Taller #7: Guía de ejercicios prácticos para normalizar esquemas de datos desde tablas desnormalizadas hasta 3FN.
* `009 - Taller #8 - Visuals - De Algebra Relacional a SQL.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: pensar en Álgebra Relacional, escribir en SQL)  
  * **Tema:** Presentación visual oficial de la cátedra para el Taller #8: Correspondencia formal y sintáctica entre operadores del Álgebra Relacional y SQL (DDL, DML, proyecciones, selecciones, joins, divisiones y agregaciones).
* `Ticket de Salida Taller #5.md`  
  * **Track:** **Track 3** (Lenguajes relacionales: Álgebra Relacional)  
  * **Tema:** Resolución comentada y justificación formal de 4 ejercicios de Álgebra Relacional (división relacional para clientes que compraron todo con facturas pagadas, agregación con `COUNT_DISTINCT` sobre facturas, selecciones compuestas sobre morosos y resta de conjuntos).
* `Ticket Salida Taller #8.md`  
  * **Track:** **Track 3** (Lenguajes relacionales: escribir en SQL)  
  * **Tema:** Cuestionario evaluativo / ticket de salida del Taller #8 sobre consultas SQL con condiciones de igualdad entre código y descripción.

---

### Clase 7 (22/09)
**Temas vistos / preparación:**
* Sesión Fishbowl #3 (Transacciones Distribuidas, Modelo XA, 2PC vs. 3PC y Deadlocks).
* Taller #10: SQL #2 — "Proveedores – Partes – Catálogo" (Álgebra Relacional y SQL: consultas unarias, filtros por color, intersecciones, división relacional por doble `NOT EXISTS`, auto-joins comparativos sobre la misma tabla y agregaciones con `HAVING`).
* Taller #9: Revisión de la **Práctica 1 de Normalización** y resolución de la nueva **Práctica 2 de Normalización (FN)** (casos reales de reducción a 3FN y posterior reconstrucción del DER).

**Archivos en la carpeta `Clase 7_09-22`:**
* `011 - Taller #10 - SQL 2.pdf`  
  * **Track:** **Track 3** (Lenguajes relacionales: pensar en Álgebra Relacional, escribir en SQL)  
  * **Tema:** Diapositivas oficiales del Taller #10 de SQL dictado por la cátedra (Ricardo Di Pasquale, Alejandro Isidro, Edgardo Sanchez, Delfina Las Heras). Modelo relacional y DER de Proveedores, Partes y Catálogo, con consignas prácticas de consulta a – q.
* `FN - Practica 2.pdf`  
  * **Track:** **Track 2** (Diseño de BD Relacionales: modelado y normalización)  
  * **Tema:** Guía de ejercitación práctica del Taller #9 con 3 casos de estudio para normalizar tablas desnormalizadas a 3FN y graficar posteriormente su modelo DER: Carreras de Caballos, Habitaciones de Hotel y Empresa Farmacéutica/Lotes con inflación.

**Archivos en la subcarpeta `Clase 7_09-22/fishbowl 3`:**
* `005 - Sesión Fishbowl #3 - Resumen de Transacciones Distribuidas.pdf`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Apunte preparatorio para Fishbowl #3: problemática de transacciones en múltiples nodos, protocolo Two-Phase Commit (2PC) y consistencia distribuida.
* `006 - Sesión Fishbowl #3 - MindMap de Transacciones y Transacciones Distribuidas.png`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Mapa mental comparativo entre transacciones locales y transacciones distribuidas.
* `Resumen_Fishbowl_3_Transacciones_Distribuidas.md`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Guía maestra exhaustiva de preparación para el Fishbowl #3 con desarrollo teórico, diagramas de estados 2PC/3PC, análisis de fallos y preguntas típicas de debate.
* `Notas Fishbowl #3 (tomadas durante el fisbowl).pdf`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Anotaciones tomadas en vivo durante la dinámica de debate del Fishbowl #3 (schedules, locks, deadlocks, 2PC, 3PC y casos reales).
* `Deadlocks_en_bases_de_datos.png`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Infografía visual sobre interbloqueos (*deadlocks*): condiciones de ocurrencia, grafos de espera (*wait-for graph*) y técnicas de prevención y detección.
* `Infografía_sobre_transacciones_distribuidas.png`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Infografía explicativa del flujo del protocolo de compromiso en dos fases (2PC: fase de preparación y fase de confirmación).
* `Integridad_de_Datos_y_Transacciones.png`  
  * **Track:** **Track 4** (Seguridad, Transacciones y Concurrencia)  
  * **Tema:** Infografía esquemática sobre cómo interactúan las transacciones para asegurar la integridad física y lógica de la base de datos.
