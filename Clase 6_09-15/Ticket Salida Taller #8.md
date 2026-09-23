# Taller #8 - SQL 1

## Esquema Relacional

* **CLIENTES** (`N.º Cliente`, `Nombre`, `Dirección`, `Ciudad`)
* **PRODUCTO** (`Cód. Producto`, `Descripción`, `Precio`)
* **VENTA** (`N.º Cliente`, `Cód. Producto`, `Fecha`)

---

### Pregunta 1
**Consigna:** Obtener los códigos y descripciones de aquellos productos cuyo código coincide con su descripción.

**Opciones:**
- **a)**
  ```sql
  SELECT p."Cód. Producto", p.Descripción
  FROM PRODUCTO AS p
  WHERE p."Cód. Producto" = p.Descripción;