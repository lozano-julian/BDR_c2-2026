# Taller de SQL #2 — Proveedores, Partes y Catálogo
## Resolución y Guía Práctica Oficial (Álgebra Relacional & SQL)

> **Nota metodológica:** Las resoluciones siguen estrictamente las convenciones de orden, símbolos, calificación de atributos y sintaxis exigidas por la cátedra (documentadas en [Convenciones_Algebra_Relacional_y_SQL.md](file:///c:/Users/user2/OneDrive/Documents/02_UCA/BDR/Convenciones_Algebra_Relacional_y_SQL.md)).

---

### 📌 Esquema Relacional de Referencia
* **`Proveedores`** (`Pr`): (**`pr_id`**: integer, `nombre`: varchar, `ciudad`: varchar)
* **`Partes`** (`Pa`): (**`pa_id`**: integer, `nombre`: varchar, `color`: varchar)
* **`Catalogo`** (`C`): (**`pr_id`**: integer, **`pa_id`**: integer, `costo`: numeric)
  * *Clave Primaria compuesta:* `(pr_id, pa_id)`
  * *Claves Foráneas:* `pr_id` $\to$ `Proveedores`, `pa_id` $\to$ `Partes`
  * *Semántica:* Tener un registro en `Catalogo` significa que dicho proveedor fabrica/suministra esa pieza.

---

## Ejercicio a

### 1. Enunciado
> **a)** nombres de los proveedores que fabrican alguna pieza roja

---

### 2. Explicación
1. **Paso lógico relacional:** Necesitamos encontrar los nombres de aquellos proveedores que tengan al menos una pieza catalogada cuyo color sea `'Rojo'`.
2. **Vinculación:** 
   * Se relacionan las tuplas de `Proveedores` (`Pr`) con `Catalogo` (`C`) mediante la clave `pr_id`.
   * Se relaciona `Catalogo` (`C`) con `Partes` (`Pa`) mediante la clave `pa_id`.
   * Se filtra el conjunto resultante aplicando la condición `pa.color = 'Rojo'`.
3. **Proyección y Duplicados:**
   * En **Álgebra Relacional**, la proyección $\pi_{\text{pr.nombre}}$ elimina automáticamente los duplicados por definición de conjunto.
   * En **SQL**, dado que un mismo proveedor puede suministrar más de una pieza roja distinta, el producto de los `INNER JOIN` generaría filas repetidas con el mismo nombre. Por lo tanto, es **estrictamente obligatorio** utilizar `SELECT DISTINCT` para cumplir con la semántica del álgebra relacional.

---

### 3. Solución en Álgebra Relacional

$$\pi_{\text{pr.nombre}}\Big(\sigma_{\text{pa.color = 'Rojo'}}\big(Pr \bowtie_{\text{pr.pr\_id = c.pr\_id}} C \bowtie_{\text{c.pa\_id = pa.pa\_id}} Pa\big)\Big)$$

*(Variante con empuje de selección / selección temprana sobre la relación base `Pa`:)*
$$\pi_{\text{pr.nombre}}\Big(Pr \bowtie_{\text{pr.pr\_id = c.pr\_id}} C \bowtie_{\text{c.pa\_id = pa.pa\_id}} (\sigma_{\text{pa.color = 'Rojo'}}(Pa))\Big)$$

$$\Downarrow$$

---

### 4. Query (SQL)

```sql
SELECT DISTINCT pr.nombre
FROM Proveedores Pr INNER JOIN
     Catalogo C ON Pr.pr_id = C.pr_id INNER JOIN
     Partes Pa ON C.pa_id = Pa.pa_id
WHERE pa.color = 'Rojo';
```

