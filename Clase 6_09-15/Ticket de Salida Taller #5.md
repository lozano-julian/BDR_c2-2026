# Taller #5 - Ticket de Salida - Práctica 2 - Álgebra Relacional

## Esquema de la Base de Datos

* **CLIENTES**(<u>N.º Cliente</u>, Nombre, Dirección, Teléfono, Ciudad)
* **PRODUCTO**(<u>Cód. Producto</u>, Descripción, Precio)
* **FACTURA**(<u>N.º Factura</u>, Fecha, Pagada, *N.º Cliente*)
  * *Nota:* `Pagada = 1` indica factura pagada; `Pagada = 0` indica factura impaga.
* **VENTA**(<u>Id Venta</u>, *Cód. Producto*, *N.º Factura*, Cantidad)

---

### Pregunta 1
**Consigna:** Obtener los clientes que han comprado todos los productos disponibles a través de facturas pagadas.

* **Expresiones previas dadas:**
  * $P = \pi_{\text{Cód. Producto}}(\text{PRODUCTO})$
  * $CP = \pi_{\text{FACTURA.N.º Cliente},\, \text{VENTA.Cód. Producto}}\left(\sigma_{\text{FACTURA.Pagada} = 1}(\text{FACTURA} \bowtie \text{VENTA})\right)$

* **Opción correcta:** **b**

$$\pi_{\text{CLIENTES.Nombre}}\left(\text{CLIENTES} \bowtie_{\text{CLIENTES.N.º Cliente} = X\text{.N.º Cliente}} \rho_{X}(CP \div P)\right)$$

* **Justificación:**
  1. $CP$ relaciona cada cliente con los productos que compró en facturas pagadas.
  2. $P$ contiene el universo completo de códigos de producto.
  3. El operador de división relacional ($CP \div P$) selecciona únicamente a los clientes que figuran vinculados a **todos** los productos de $P$.
  4. Finalmente, se hace el join con `CLIENTES` (renombrando el resultado intermedio a $X$) para proyectar el `Nombre`.

---

### Pregunta 2
**Consigna:** Obtener los números de factura que contienen al menos 3 productos distintos.

* **Opción correcta:** **a**

$$\pi_{\text{N.º Factura}}\left(\sigma_{\text{CantProductos} \ge 3}\left(\gamma_{\text{N.º Factura};\, \text{COUNT\_DISTINCT}(\text{Cód. Producto}) \rightarrow \text{CantProductos}}(\text{VENTA})\right)\right)$$

* **Justificación:**
  1. La función agregada debe ser `COUNT_DISTINCT(Cód. Producto)` agrupando por `N.º Factura` para contar ítems distintos y no filas repetidas.
  2. La condición "al menos tres" requiere un operador de desigualdad amplia ($\ge 3$). La igualdad exacta ($= 3$) excluiría facturas con 4 o más productos.
  3. No corresponde usar `SUM(Cantidad)` (unidades físicas) ni `COUNT(Id Venta)` (cantidad de renglones/ventas).

---

### Pregunta 3
**Consigna:** Obtener el número y la fecha de las facturas impagas correspondientes a clientes de la ciudad de Buenos Aires.

* **Opción correcta:** **b**

$$\pi_{\text{FACTURA.N.º Factura},\, \text{FACTURA.Fecha}}\left(\sigma_{\text{CLIENTES.Ciudad} = \text{'Buenos Aires'} \,\land\, \text{FACTURA.Pagada} = 0}\left(\text{CLIENTES} \bowtie_{\text{CLIENTES.N.º Cliente} = \text{FACTURA.N.º Cliente}} \text{FACTURA}\right)\right)$$

* **Justificación:**
  1. Se combinan `CLIENTES` y `FACTURA` por su clave foránea común (`N.º Cliente`).
  2. Ambas condiciones deben cumplirse de forma simultánea, requiriendo una conjunción lógica ($\land$): pertenecer a `'Buenos Aires'` y tener `Pagada = 0`.
  3. La proyección ($\pi$) se limita estrictamente a los atributos pedidos: `N.º Factura` y `Fecha`.

---

### Pregunta 4
**Consigna:** Obtener los nombres de los clientes que tienen facturas registradas y tienen todas sus facturas pagadas.

* **Expresiones previas dadas:**
  * $CF = \pi_{\text{CLIENTES.N.º Cliente},\, \text{CLIENTES.Nombre}}(\text{CLIENTES} \bowtie \text{FACTURA})$
  * $CI = \pi_{\text{CLIENTES.N.º Cliente},\, \text{CLIENTES.Nombre}}\left(\sigma_{\text{FACTURA.Pagada} = 0}(\text{CLIENTES} \bowtie \text{FACTURA})\right)$

* **Opción correcta:** **c**

$$\pi_{\text{Nombre}}(CF - CI)$$

* **Justificación:**
  1. $CF$ contiene el conjunto de clientes que tienen al menos una factura.
  2. $CI$ reúne a los clientes que poseen al menos una factura adeudada ($\text{Pagada} = 0$).
  3. La resta de conjuntos $CF - CI$ elimina del grupo de facturados a cualquiera que deba facturas, dejando exactamente a los clientes que tienen facturas y las tienen todas al día.
  4. Partir de $C - CI$ (todos los clientes menos los deudores) sería erróneo porque incluiría a clientes que nunca registraron compras.