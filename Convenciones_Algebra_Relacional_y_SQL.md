# Guía de Convenciones Oficiales de Cátedra: Álgebra Relacional y SQL

> **Fuente de referencia:** Cuaderno oficial de cursada `Material Estudio/Notas hasta sep-29.pdf` (especialmente páginas 7, 8, 9 y 10: Taller SQL #2 y Álgebra Relacional).
> 
> Este documento sistematiza con precisión quirúrgica las convenciones de orden, símbolos, nomenclatura y sintaxis que el profesor utiliza en el pizarrón y exige en parciales y exámenes finales.

---

## 1. Mapeo Conceptual y Relación entre Lenguajes

* **Símbolo de Transición:** El docente utiliza sistemáticamente una **flecha doble gruesa (`==>`)** para conectar la expresión formal en Álgebra Relacional con su implementación en SQL:
  $$\text{Expresión en Álgebra Relacional} \quad \Longrightarrow \quad \text{Query en SQL}$$
* **Filosofía pedagógica:** Se piensa primero en Álgebra Relacional (enfoque algebraico / de conjuntos) y luego se transcribe de forma directa y declarativa a SQL.

---

## 2. Convenciones para Álgebra Relacional (AR)

### A. Nomenclatura y Calificación de Atributos
1. **Prefijos y Calificación obligatoria:** Se debe desambiguar siempre el origen de cada atributo anteponiendo el alias de la tabla y un punto:  
   * `pr.nombre`, `pr.pr_id` (de Proveedores)
   * `pa.color`, `pa.pa_id`, `pa.nombre` (de Partes)
   * `c.pr_id`, `c.pa_id`, `c.costo` (de Catálogo)
2. **Alias de Tablas:** Usa mayúsculas o notación corta tipo PascalCase para representar las relaciones:
   * `Pr` = Proveedores
   * `C` = Catálogo
   * `Pa` = Partes

---

### B. Operadores y su Notación Gráfica

#### 1. Proyección ($\pi$)
* **Sintaxis:** $\pi_{\text{atributos}}(\text{Relación})$
* **Comportamiento de Conjunto:** Opera por definición matemática sobre conjuntos puros; **no genera tuplas duplicadas**.
* **Anotaciones de soporte:** En resoluciones manuscritas, el profesor suele anotar debajo del operador $\pi$ los atributos intermedios que necesita preservar para las siguientes juntas.

#### 2. Selección ($\sigma$)
* **Sintaxis:** $\sigma_{\text{condición}}(\text{Relación})$
* **Cadenas de texto:** Las constantes de texto se escriben entre comillas simples y respetando mayúsculas iniciales tal cual el enunciado: `'Rojo'`, `'Verde'`, `'Flores'`.
* **Ubicación de la selección:**
  * En consultas simples con pocos joins, suele envolver la junta completa:  
    $$\pi_{\text{pr.nombre}}\Big(\sigma_{\text{pa.color = 'Rojo'}}\big(Pr \bowtie C \bowtie Pa\big)\Big)$$
  * En optimización o consultas complejas, aplica **empuje de selección** filtrando la tabla base antes de la junta:  
    $$Pr \bowtie C \bowtie \sigma_{\text{color = 'Rojo'}}(Pa)$$

#### 3. Juntas / Joins ($\bowtie$)
* **Theta Join / Equi-Join con condición explícita:** Se escribe el símbolo $\bowtie$ con la condición de igualdad en el **subíndice inferior del moño**:
  $$Pr \bowtie_{\text{pr.pr\_id = c.pr\_id}} C \bowtie_{\text{c.pa\_id = pa.pa\_id}} Pa$$
* **Left Outer Join:** Utiliza el símbolo de junta externa con barra vertical a la izquierda: $\bowtie]$ o $\rtimes$ / $\ltimes$.

#### 4. División Relacional ($/$)
Es uno de los operadores más evaluados por la cátedra (ejercicios del tipo *"que fabrican todas las piezas..."*):
* **Notación en la resolución:** Utiliza la barra de fracción grande o la barra diagonal:
  $$\pi_{\text{pr.nombre}}\left( \frac{\pi_{\text{pr.pr\_id, c.pa\_id}}(Pr \bowtie C)}{\pi_{\text{pa.pa\_id}}(\sigma_{\text{pa.color = 'Rojo'}}(Pa))} \right)$$
* **Estructura matemática de los operandos:**
  * **Numerador (Relación $A$):** Debe proyectar exactamente los atributos de agrupamiento ($X$) y los atributos a contrastar ($Y$). Ej: $\pi_{\text{pr.pr\_id, c.pa\_id}}(Pr \bowtie C)$.
  * **Denominador (Relación $B$):** Debe proyectar únicamente los atributos del conjunto universal a cumplir ($Y$). Ej: $\pi_{\text{pa.pa\_id}}(\sigma_{\dots}(Pa))$.
  * **Envoltura externa:** Una proyección final sobre $X$ para recuperar la clave o el nombre deseado.
* **Definición formal completa:** En el cuaderno (pág. 7 y 10) el profesor destaca la equivalencia sin el operador primitivo de división:
  $$A / B = \pi_X\Big(A - \big( (\pi_X(A) \times B) - A \big)\Big)$$

#### 5. Funciones de Agregación ($\mathcal{F}$ Gótica / Caligráfica)
Para operaciones como `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`:
* **Símbolo:** Utiliza una $\mathcal{F}$ caligráfica estilizada (`\mathcal{F}`).
* **Subíndice izquierdo (Agrupador):** Contiene los atributos por los cuales se agrupa (equivalente a `GROUP BY`):  
  $${}_{\text{pa\_id}}\mathcal{F}$$
* **Subíndice derecho (Métrica):** Contiene la función y la columna calculada:  
  $$\mathcal{F}_{\text{COUNT(pr\_id)}}(\text{Tabla})$$
* **Filtros sobre agregaciones (`HAVING`):** Se expresa aplicando una selección $\sigma$ por fuera de la función de agregación:
  $$\sigma_{\text{COUNT(pr\_id)} \ge 2}\Big({}_{\text{pa\_id}}\mathcal{F}_{\text{COUNT(pr\_id)}}(C)\Big)$$

---

## 3. Convenciones para SQL

### A. Palabras Reservadas y Formato de Código
* **Palabras reservadas en MAYÚSCULAS:** `SELECT`, `DISTINCT`, `FROM`, `INNER JOIN`, `ON`, `WHERE`, `GROUP BY`, `HAVING`, `NOT EXISTS`, `CREATE VIEW`.
* **Uso estricto de `DISTINCT`:** Como SQL opera sobre multiconjuntos (bolsas), cualquier consulta donde un `JOIN` pueda duplicar filas de la entidad consultada **debe llevar `SELECT DISTINCT`**. El profesor penaliza la omisión de `DISTINCT` cuando el resultado conceptual es una lista única de nombres o IDs.

### B. Formato de JOINs y Disposición de Cláusulas
El profesor escribe los `INNER JOIN` de manera encadenada con salto de línea específico:
```sql
SELECT DISTINCT pr.nombre
FROM Proveedores Pr INNER JOIN
     Catalogo C ON Pr.pr_id = C.pr_id INNER JOIN
     Partes Pa ON C.pa_id = Pa.pa_id
WHERE pa.color = 'Rojo';
```
* **Alias de Tablas:** Usa la inicial en mayúscula de la entidad (`Proveedores Pr`, `Catalogo C`, `Partes Pa`).
* **Terminación de sentencia:** Siempre finaliza con punto y coma (`;`).

### C. Estrategias Oficiales para la División Relacional en SQL
Para resolver consultas de "todos" en SQL, el profesor admite y enseña dos caminos:

#### Método 1: Mediante Vistas Auxiliares (`CREATE VIEW`)
Descompone el numerador y denominador en vistas limpias:
```sql
CREATE VIEW A AS
SELECT Pr.pr_id, Pr.nombre, C.pa_id
FROM Proveedores Pr INNER JOIN Catalogo C ON Pr.pr_id = C.pr_id;

CREATE VIEW B AS
SELECT Pa.pa_id
FROM Partes Pa
WHERE Pa.color = 'Rojo';
```

#### Método 2: Mediante Doble `NOT EXISTS` Correlacionado
En una única sentencia sin crear objetos en la base de datos:
```sql
SELECT DISTINCT pr.nombre
FROM Proveedores Pr
WHERE NOT EXISTS (
    SELECT 1
    FROM Partes Pa
    WHERE pa.color = 'Rojo'
      AND NOT EXISTS (
          SELECT 1
          FROM Catalogo C
          WHERE C.pr_id = Pr.pr_id
            AND C.pa_id = Pa.pa_id
      )
);
```
*(Lógica: "No existe ninguna parte roja que NO sea fabricada por este proveedor").*

### D. Agregaciones y Filtros con `HAVING`
Para consultas con conteos y umbrales (ej. ejercicio j):
```sql
SELECT pa.nombre
FROM Catalogo C INNER JOIN Partes Pa ON C.pa_id = Pa.pa_id
GROUP BY C.pa_id, pa.nombre
HAVING COUNT(C.pr_id) >= 2;
```
* Todas las columnas no agregadas del `SELECT` deben figurar en el `GROUP BY`.

