# Material de Finales

## 1. Introducción y Contenidos
Este archivo consolida y describe el material preparatorio para las mesas de examen final de Bases de Datos Relacionales ubicado en la carpeta `Material Estudio/Final`. Incluye recopilaciones de preguntas tomadas en instancias finales de años anteriores y resúmenes elaborados por alumnos para preparar el examen oral o escrito.

## 2. Análisis Descriptivo
A diferencia de los parciales, el material de finales se concentra fuertemente en el **conocimiento teórico avanzado, la arquitectura del DBMS y el razonamiento analítico**.
- **Enfoque de los archivos:** En su mayoría, son documentos de texto (`.docx`, `.pdf`) que listan preguntas directas y sus respuestas detalladas, divididas por ejes temáticos (Sizing, Índices, Transacciones, Optimización).
- **Mecánica del examen:** El final abandona en gran parte la escritura masiva de código SQL para evaluar el conocimiento del "motor bajo el capó". Exige que el alumno justifique *por qué* el motor toma ciertas decisiones.

## 3. Análisis Predictivo (¿Cómo será el examen final?)
Al observar la estructura del `Preguntas Final BD.pdf` y `Final DB I.pdf`, podemos anticipar que el examen final exigirá explicaciones verbales o redactadas detalladas con soporte gráfico.
- **Predicción de Contenidos Clave:**
  - *Arquitectura y Optimización:* Se pedirá explicar exhaustivamente el rol del **Optimizador** basado en costos. Será vital conocer la complejidad y justificar matemáticamente la elección entre métodos de JOIN (Hash Join, Sort-Merge, Nested Loops) de acuerdo a la disponibilidad de índices (clusterizados o multinivel). Esto se vio evaluado al milímetro en exámenes previos.
  - *Transacciones Distribuidas y Fallos:* A diferencia del parcial que se centra en 2PL, el final pondrá foco en el **Commit de 2 Fases (2PC)** para arquitecturas distribuidas, y demandará conocer a fondo las estrategias de recuperación de logs transaccionales (paginación de sombra vs. actualización diferida/inmediata).
  - *Seguridad (DCL):* Es casi seguro que se evalúe el entendimiento del flag `WITH GRANT OPTION` y la diferencia entre la propagación o eliminación en cascada (`CASCADE`) vs la restricción (`RESTRICT`).
  - *Álgebra Relacional en profundidad:* Pueden aparecer preguntas tramposas sobre operadores implícitos (e.g. "¿Por qué no existe el operador DISTINCT en álgebra relacional?" - debido a que matemáticamente es un conjunto, no puede tener tuplas repetidas).

## 4. Guía de Contenidos y Resoluciones

A continuación se detalla el contenido específico de la carpeta de exámenes finales:

*   **`Preguntas Final BD.pdf`** y **`Preguntas Final.docx`**
    *   **Contenido:** Es la "Biblia" de preparación para el final. Es un cuestionario recopilado y resuelto exhaustivamente con las preguntas más exigentes y comunes.
    *   **Temas resueltos:** Justificación de árboles B+ vs. Bitmaps, diferencias entre integridad y consistencia, generador de código, el problema de inanición en la prevención de deadlocks (Wait-Die / Wound-Wait), y la selección del algoritmo más barato para cruzar tablas dadas sus estadísticas y cardinalidad.
*   **`Final DB I.pdf`** y **`6CB42D5A-7A76-42F4-AB21-933E311EB723.pdf`**
    *   **Contenido:** Exámenes finales reales y escaneos (en formato PDF). Muestran el nivel de exigencia y la distribución de puntos oficial.
*   **`Preguntas teoricas Base de datos.pdf`**
    *   **Contenido:** Un resumen complementario enfocado en las definiciones duras (formas normales, arquitecturas) necesarias para un examen oral.
*   **`WhatsApp Image 2024-12-10 at 21.13.55.jpeg`**
    *   **Contenido:** Captura informal proveniente de un grupo de estudio con un esquema o respuesta compartida tras rendir la mesa de diciembre de 2024.

