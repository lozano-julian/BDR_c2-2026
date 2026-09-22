# Índices en Bases de Datos

## Conceptos Fundamentales
* **Búsquedas y Predicados**
  * Toda búsqueda evalúa un predicado lógico.
  * Sin índices (peor escenario):
    * Se debe recorrer el archivo completo secuencialmente.
    * Genera un costo altísimo de accesos a disco (I/O).
* **Ordenamiento de Datos**
  * Ordenar por una clave reduce la complejidad promedio de la búsqueda.
* **Restricción de Clúster (Agrupamiento Físico)**
  * **Límite:** Máximo 1 (un) índice clúster por tabla, o ninguno.
  * **Motivo:** La disposición física en disco de los datos sólo admite un único orden.
  * Se admite una cantidad acotada de otros índices no agrupados.
* **Estructuras Auxiliares**
  * Se almacenan en disco.
  * Están diseñadas para usarse directamente en memoria principal (evita I/O).
  * **Composición de la estructura:**
    * Atributo de búsqueda.
    * Identificador del ítem.
    * Puntero a la posición en disco.

## Clasificación General

### Según Cantidad de Entradas
* **Denso**
  * Cantidad de entradas del índice = Cantidad de entradas del archivo de datos.
  * *Ejemplo:* Índice armado para la clave primaria.
* **No Denso**
  * Cantidad de entradas del índice < Cantidad de entradas del archivo de datos.

### Según Ordenamiento
* **Agrupados (Clustered)**
  * El orden de los archivos de datos coincide exactamente con el atributo indexado.
* **No Agrupados**
  * El orden físico de los datos es independiente del índice.

## Tipos de Índices de Un Nivel

### Primario
* Archivo ordenado.
* **Formato:** `(id, puntero al registro)`.
* **Clasificación:** No denso.
  * Sus entradas equivalen al número de bloques, no a los registros individuales.
* **Desventaja:** Inserción muy costosa.
  * Es una estructura lineal; insertar en el medio obliga a mover todos los elementos siguientes.

### Agrupamiento
* Ordenado por campo **no clave**.
  * Busca por valor de atributo, no por id.
  * Genera "sinónimos" (valores iguales o repetidos).
* **Clasificación:** No denso.
  * Hay un bloque en disco por cada valor almacenado.
* **Similitud:** Parecido al Hashing, pero operando con el valor del atributo en vez del ID del ítem.

### Secundario
* Archivo ordenado.
* **Formato:** `(campo de no ordenamiento, bloque/registro)`.
* **Variantes:**
  * Si es por **campo clave**: Denso (valores únicos).
  * Si es por **campo no clave**, tiene 3 implementaciones posibles:
    1. 1 clave y *n* entradas (Denso).
    2. 1 clave y una lista variable con los links a los datos (No denso).
    3. Nivel de indirección (el elemento apunta a un contenedor con los links).

## Tipos de Índices de Múltiples Niveles

### Árboles B
* Estructuras dinámicas.
  * Optimizan operaciones de inserción y eliminación.
* **Complejidad:** Logarítmica.
  * Se calcula respecto a la cardinalidad del dominio del atributo indexado (no respecto a la población total).
* **Punteros:** Todos los nodos referencian al archivo de datos.

### Árboles B+
* **Enlaces a datos:** Exclusivos de los nodos hoja.
* **Nodos intermedios:** Sólo guardan links entre nodos y claves.
  * Tienen mayor capacidad para almacenar claves.
  * Mayor grado.
  * Menor altura del árbol.
* **Carga Masiva (Bulk Load)**
  * Operación ideal para tablas ya pobladas masivamente.
  * Ordena los atributos en una lista (hojas) y va creando/balanceando los nodos hacia la raíz.
  * Mucho más barato que insertar registro por registro.

## Otros Tipos

### Bitmaps
* Arreglos con cadenas de bits.
  * Representan qué valor del dominio de la clave tiene cada ítem.
* **Longitud del arreglo:** Equivalente al tamaño de la población (cantidad de ítems).
* **Uso recomendado:**
  * Atributos con cardinalidad baja.
  * *Excepción:* Oracle soporta cantidades medianas y almacenamiento de claves principales.
* **Desventaja:** Mal rendimiento ante inserciones y eliminaciones.
  * Requiere regenerar o reubicar gran parte del índice.

## Productos Comerciales (Casos Concretos)

### Microsoft SQL Server
* **Almacenamiento Base:** Bloques de 8kB (páginas).
* **Límite de Fila:** 8060 bytes máximo (restando headers y links).
* **Extents:** Bloques mínimos de I/O de 64kB (agrupan 8 páginas).
* **Tipos de Tablas:**
  * **Clustered:** Archivo ordenado por clave (Índice = Árbol B).
  * **Heaps:** Sin orden, sin índice agrupado.
* **Límites de Índices:** 1 Clustered + hasta 249 no agrupados (Árboles B).
* **Datos Especiales:** Text, NText e imágenes se guardan en un storage único llamado "colección".

### Oracle
* **Tipos de índices soportados:**
  * Árbol B
  * Bitmap
  * Partitioned indexes
  * Function-based indexes (basados en expresiones)
  * Domain indexes

### MySQL
* **Motor InnoDB:**
  * Estructura: Árboles binarios (B-trees).
  * Tamaño de página predeterminado: 16KB.
  * Llenado con inserción secuencial: Aproximadamente 15/16 de capacidad.
  * Llenado con inserción aleatoria: Entre 1/2 y 15/16 de capacidad.
* **Motor MEMORY/HEAP:**
  * Soporta: Árbol B y Hash.
  * Uso: Para tablas que entran completas en memoria principal.
* **Motor MyISAM:**
  * Soporta: Árbol B.

## Bibliografía y Referencias
* "Sistemas de Bases de Datos - Conceptos fundamentales" - Elmasri/Navathe (Segunda Edición).
* "Sistemas de Gestión de Bases de Datos" - Ramakrishnan/Gehrke (Tercera edición).
* "Introducción a las bases de datos Relacionales" - Mendelzohn/Ale.
