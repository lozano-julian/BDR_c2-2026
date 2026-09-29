# Material de Parciales

## 1. Introducción y Contenidos
Este archivo consolida y describe todo el material de evaluaciones parciales históricas (años 2020 a 2025) recopiladas en la carpeta `Material Estudio/Parcial`. Incluye tanto enunciados de exámenes completos como resoluciones (muchas de ellas elaboradas a mano o en planillas) orientadas a preparar el examen de mitad o fin de cursada de Bases de Datos Relacionales.

## 2. Análisis Descriptivo
Los archivos presentan una gran variedad de formatos: exámenes digitalizados en PDF (como el de 2023), documentos de texto con parciales de pandemia (2020), planillas Excel (`.xlsx`) útiles para diagramar paso a paso las Formas Normales, e imágenes sueltas de resoluciones en papel correspondientes al 2022.
- **Distribución de puntajes típica:** Históricamente, el examen parcial se divide en tres secciones fuertes:
  1. **Modelado y Normalización (30%):** A partir de un escenario de negocio no normalizado, se pide llevar a Tercera Forma Normal (3FN) indicando claves, dependencias, y luego graficar el DER resultante.
  2. **Teoría (20%):** Preguntas de desarrollo corto sobre Concurrencia (ej. Deadlocks, Locking en 2 Fases) o fallos de transacciones (Logs, Backups).
  3. **Lenguajes Relacionales (50%):** Es el grueso del examen. Dado un esquema de datos complejo, se pide resolver consultas avanzadas escribiéndolas simultáneamente en Álgebra Relacional (AR) y en SQL.

## 3. Análisis Predictivo (¿Cómo será el próximo parcial?)
A partir de la tendencia observada en los exámenes (especialmente evaluando el `parcial_2023.pdf` y la estructura de años anteriores), se puede proyectar que el próximo parcial **estará fuertemente sesgado hacia las consultas de división relacional y los JOINs anidados**.
- **Predicción de Ejercicios:** 
  - *Álgebra Relacional y SQL:* Con seguridad incluirá un ejercicio del tipo "Clientes que hayan comprado TODOS los productos" o "Entidades que NO tengan relación con ninguna entidad que cumpla X condición". Aquí será vital dominar la operación de **división relacional en AR** y su equivalente en SQL (doble `NOT EXISTS`). Esto pesará alrededor del 50% de la nota, tal como se evaluó en 2023.
  - *Normalización:* La evaluación de normalización (30% de la nota) requerirá detallar el paso a paso: definir 1FN, eliminar dependencias parciales para 2FN y eliminar dependencias transitivas para 3FN, demostrando el proceso completo tal como se resuelve en el archivo `Parcial_Normalizacion.xlsx`.
  - *Teoría:* De acuerdo a exámenes pasados, la teoría apuntará a las justificaciones de performance: ¿Por qué es insuficiente o ineficiente Strict 2PL para evitar Deadlocks por sí solo? ¿Qué pasa si no se ejecuta el Backup en un entorno OLTP transaccional intenso?

## 4. Guía de Contenidos y Resoluciones

A continuación se detalla el contenido específico de la carpeta de parciales:

*   **`parcial_2023.pdf`**
    *   **Contenido:** El parcial más reciente y completo (tomado el 07/11/2023). Incluye el enunciado íntegro y **fotos adjuntas de la resolución manuscrita del alumno** (con calificación y correcciones en tinta roja).
    *   **Ejercicios:** Normalización de un salón de ventas (30 pts), Teoría sobre 2PL y Logs (20 pts), y AR/SQL sobre un modelo de Compras/Clientes/Oficinas (50 pts). Incluye resolución de división relacional por doble `NOT EXISTS`.
*   **`parcial BD 2020 cuatrimestre2.docx`**
    *   **Contenido:** Examen de la etapa virtual. Contiene escenarios largos orientados a la justificación teórica y al modelado analítico a distancia.
*   **`PARCIAL.xlsx`** y **`Parcial_Normalizacion.xlsx`**
    *   **Contenido:** Plantillas y ejercicios resueltos en Excel, que es la forma óptima de tabular los atributos y marcar dependencias funcionales para derivar las tablas en 1FN, 2FN y 3FN.
*   **`Algebra Relacional Parcial.pdf`** y **`DER Parcial.pdf`**
    *   **Contenido:** Hojas de práctica pura enfocadas exclusivamente en dominar la sintaxis del Álgebra Relacional para consultas complejas y la correcta notación del Diagrama Entidad-Relación (patas de gallo, identificadores fuertes/débiles).
*   **`parcial 2025 parte FN.pdf`**
    *   **Contenido:** Examen reciente o de prueba focalizado específicamente en el módulo de Formas Normales.
*   **Carpeta `2022/`**
    *   **Contenido:** Incluye múltiples fotografías (`IMG-*.jpg` y `Parcial_2022.jpg`) con hojas de resolución a mano del parcial tomado en 2022, útil para ver el estilo de corrección del docente y cómo presentar las respuestas. También incluye un `TpFinalBaseDeDatos_Barrionuevo.pdf` con un trabajo integral.

