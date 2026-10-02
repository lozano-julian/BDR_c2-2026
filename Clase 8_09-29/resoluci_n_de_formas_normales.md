# Bases de Datos Relacionales: Guía Integral de Normalización (1FN, 2FN, 3FN)

El diseño relacional óptimo minimiza la redundancia, previene anomalías de inserción, modificación y borrado, y garantiza la integridad de los datos mediante el análisis riguroso de dependencias funcionales (DF).

---

## 📘 BLOQUE 1: Práctica 1 — Conceptos Teóricos y Ejemplos de Modelado

---

### Ejercicio a
> **Consigna Original:**  
> *Describir con tus palabras 1FN.*

* **Explicación y Paso a Paso:**
  * Una relación está en **Primera Forma Normal (1FN)** si y sólo si:
    1. Todos los atributos contienen valores **atómicos** (indivisibles dentro del dominio del negocio). No se permiten listas, conjuntos, tuplas anidadas ni campos multivaluados en una sola celda.
    2. No existen **grupos repetitivos** (columnas del estilo `telefono1`, `telefono2`, `telefono3`).
    3. Cada tupla se identifica unívocamente mediante una **clave primaria (PK)** bien definida.
  * *Objetivo:* Establecer la estructura tabular básica donde cada intersección de fila y columna contiene exactamente un único valor escalar.

---

### Ejercicio b
> **Consigna Original:**  
> *Describir con tus palabras 2FN.*

* **Explicación y Paso a Paso:**
  * Una relación está en **Segunda Forma Normal (2FN)** si y sólo si:
    1. Se encuentra previamente en **1FN**.
    2. **No contiene dependencias parciales:** Ningún atributo no clave depende funcionalmente de una parte propia de una clave primaria compuesta.
  * *Regla formal:* Todo atributo no primo debe depender de la clave primaria **completa** ($X \to Y$ donde $X$ es toda la PK, no un subconjunto de ella).
  * *Propiedad clave:* Si una tabla está en 1FN y su **clave primaria es simple** (formada por un solo atributo), entonces **automáticamente ya está en 2FN**.

---

### Ejercicio c
> **Consigna Original:**  
> *Describir con tus palabras 3FN.*

* **Explicación y Paso a Paso:**
  * Una relación está en **Tercera Forma Normal (3FN)** si y sólo si:
    1. Se encuentra previamente en **2FN**.
    2. **No contiene dependencias transitivas:** Ningún atributo no clave puede depender funcionalmente de otro atributo no clave.
  * *Regla formal:* Para toda dependencia no trivial $X \to Y$, o bien $X$ es una superclave, o bien $Y$ es un atributo primo (parte de alguna clave candidata).
  * *Objetivo:* Asegurar que cada dato describa estrictamente a la clave primaria ("la clave, toda la clave y nada más que la clave"), eliminando redundancias cruzadas entre campos descriptivos.

---

### Ejercicio d
> **Consigna Original:**  
> *Construir un ejemplo de una tabla que no esté en 1FN y aplicarla, armando el resultado en la computadora para poder compartirla.*

* **Análisis y Violación de 1FN:**
  * Supongamos la tabla no normalizada:
    $$\text{CLIENTE\_TEL}(\mathbf{\underline{id\_cliente}}, nombre, telefonos)$$
  * Si un cliente posee múltiples líneas (`id_cliente = 1, nombre = 'Ana', telefonos = '11-4567, 11-9876'`), el campo `telefonos` viola la atomicidad y constituye un atributo multivaluado / grupo repetitivo.
* **Paso a Paso de Normalización:**
  1. Identificar el atributo no atómico (`telefonos`).
  2. Extraer los valores repetidos a una nueva relación donde cada fila almacene un único número telefónico.
  3. Formar la clave primaria de la tabla hija combinando la clave de origen y el valor atómico: `(id_cliente, telefono)`.
* **Esquema Resultante en 1FN:**
  * **$\text{CLIENTE}(\mathbf{\underline{id\_cliente}}, nombre)$**
  * **$\text{TELEFONO\_CLIENTE}(\mathbf{\underline{id\_cliente^{*}}}, \mathbf{\underline{telefono}})$** *(FK: `id_cliente` $\to$ `CLIENTE`)*

---

### Ejercicio e
> **Consigna Original:**  
> *Construir un ejemplo de una tabla que no esté en 2FN y aplicarla, armando el resultado en la computadora para poder compartirla.*

* **Análisis y Violación de 2FN:**
  * Supongamos una tabla de inscripciones a cursos:
    $$\text{INSCRIPCION}(\mathbf{\underline{id\_alumno}}, \mathbf{\underline{id\_curso}}, nota\_final, nombre\_curso, carga\_horaria)$$
  * La clave primaria es compuesta: `(id_alumno, id_curso)`.
  * Dependencias funcionales presentes:
    * $\{id\_alumno, id\_curso\} \longrightarrow nota\_final$ *(Dependencia completa).*
    * $id\_curso \longrightarrow \{nombre\_curso, carga\_horaria\}$ *(Dependencia parcial: depende de solo un fragmento de la PK).*
* **Paso a Paso de Normalización:**
  1. Aislar los atributos que dependen exclusivamente de una parte de la clave compuesta (`nombre_curso`, `carga_horaria`).
  2. Crear una nueva tabla cuya PK sea la subclave determinante (`id_curso`).
  3. Mantener en la tabla asociativa original únicamente los atributos que dependen de la combinación total de claves (`nota_final`).
* **Esquema Resultante en 2FN:**
  * **$\text{CURSO}(\mathbf{\underline{id\_curso}}, nombre\_curso, carga\_horaria)$**
  * **$\text{INSCRIPCION\_ALUMNO}(\mathbf{\underline{id\_alumno}}, \mathbf{\underline{id\_curso^{*}}}, nota\_final)$** *(FK: `id_curso` $\to$ `CURSO`)*

---

### Ejercicio f
> **Consigna Original:**  
> *Construir un ejemplo de una tabla que no esté en 3FN y aplicarla, armando el resultado en la computadora para poder compartirla.*

* **Análisis y Violación de 3FN:**
  * Supongamos una tabla de inventario editorial:
    $$\text{LIBRO}(\mathbf{\underline{cod\_libro}}, titulo, anio\_edicion, cod\_editorial, nombre\_editorial, pais\_editorial)$$
  * La clave primaria es simple: `cod_libro` (por lo que está en 2FN).
  * Cadena de dependencias transitivas:
    $$cod\_libro \longrightarrow cod\_editorial \longrightarrow \{nombre\_editorial, pais\_editorial\}$$
    `nombre_editorial` y `pais_editorial` son atributos no clave determinados por otro atributo no clave (`cod_editorial`).
* **Paso a Paso de Normalización:**
  1. Identificar el determinante no clave (`cod_editorial`) y los atributos dependientes de él.
  2. Extraerlos a una nueva entidad independiente (`EDITORIAL`), donde `cod_editorial` sea la PK.
  3. Dejar en `LIBRO` a `cod_editorial` como clave foránea (FK) para preservar el vínculo relacional.
* **Esquema Resultante en 3FN:**
  * **$\text{EDITORIAL}(\mathbf{\underline{cod\_editorial}}, nombre\_editorial, pais\_editorial)$**
  * **$\text{LIBRO}(\mathbf{\underline{cod\_libro}}, titulo, anio\_edicion, cod\_editorial^{*})$** *(FK: `cod_editorial` $\to$ `EDITORIAL`)*

---
---

## 🛠️ BLOQUE 2: Práctica 1 — Ejercicios de Aplicación de Formas Normales

---

### Ejercicio g
> **Consigna Original:**  
> *Dada la siguiente tabla, aplicar las 3FN e indicar el resultado:*  
>  
> | Codigo_articulo | Descripcion_articulo | Precio_articulo | Cantidad_disponible | Umbral_minimo |
> | :--- | :--- | :---: | :---: | :---: |
> | T23 | Tornillo | 3 | 500 | 100 |
> | P11 | Pinza | 340 | 50 | 10 |
> | M14 | Martillo | 310 | 15 | 10 |
> | L100 | Lija | 15 | 200 | 100 |

* **Paso a Paso y Justificación:**
  1. **Análisis de 1FN:** Todas las celdas contienen valores atómicos únicos, no existen grupos repetitivos y existe un identificador unívoco: `Codigo_articulo`. Cumple 1FN.
  2. **Análisis de 2FN:** La clave primaria es simple (`Codigo_articulo`). Al no existir clave compuesta, no pueden existir dependencias parciales. Cumple 2FN directamente.
  3. **Análisis de 3FN:** Las dependencias funcionales son:
     $$Codigo\_articulo \longrightarrow \{Descripcion\_articulo, Precio\_articulo, Cantidad\_disponible, Umbral\_minimo\}$$
     Ningún atributo no clave determina a otro (el precio, el stock y el umbral describen exclusivamente al artículo). No hay dependencias transitivas.
* **Esquema Resultante (ya se encuentra en 3FN):**
  * **$\text{ARTICULO}(\mathbf{\underline{Codigo\_articulo}}, Descripcion\_articulo, Precio\_articulo, Cantidad\_disponible, Umbral\_minimo)$**

---

### Ejercicio h
> **Consigna Original:**  
> *Dada la siguiente tabla, aplicar 1FN e indicar el resultado:*  
> * *Todos los empleados tienen beneficios.*  
> * *Cada empleado puede tener 1 o más beneficios.*  
>  
> | Cod_empleado | Nombre_empleado | F_nacimiento_empleado | cod_beneficio | Desc_beneficio |
> | :--- | :--- | :---: | :--- | :--- |
> | Emp_1111 | Jorge | 10/10/1986 | Bene_auto | Otorgamiento de un automóvil |
> | Emp_1111 | Jorge | 10/10/1986 | Bene_HW | Beneficio de Home Working |
> | Emp_1122 | Pedro | 09/09/1980 | Bene_HW | Beneficio de Home Working |
> | Emp_1133 | Carlos | 11/11/1975 | Bene_TC_corpo | Entrega de TC corporativa |

* **Paso a Paso y Justificación:**
  1. **Detección del problema:** Como un empleado puede tener múltiples beneficios, `Cod_empleado` no puede ser clave única por sí solo en una tabla plana (se repite `Emp_1111`). Hay un grupo repetitivo conceptual que asocia beneficios a empleados.
  2. **Resolución en 1FN:** Para lograr atomicidad y unicidad de tuplas sin repetición de entidades, separamos la entidad principal del empleado de la lista de sus beneficios asignados.
  3. **Clave primaria de la relación intermedia:** La relación `EMPLEADO_BENEFICIO` toma como clave primaria la composición $(\mathbf{Cod\_empleado}, \mathbf{cod\_beneficio})$.
* **Esquema Resultante en 1FN:**
  * **$\text{EMPLEADO}(\mathbf{\underline{Cod\_empleado}}, Nombre\_empleado, F\_nacimiento\_empleado)$**
  * **$\text{EMPLEADO\_BENEFICIO}(\mathbf{\underline{Cod\_empleado^{*}}}, \mathbf{\underline{cod\_beneficio}}, Desc\_beneficio)$** *(FK: `Cod_empleado` $\to$ `EMPLEADO`)*

---

### Ejercicio i
> **Consigna Original:**  
> *Dada la siguiente tabla, aplicar 2FN e indicar el resultado:*  
> * *Cada profesor puede trabajar en una o más escuelas.*  
> * *Cada escuela tiene varios profesores trabajando en dicho establecimiento.*  
> * *El ministerio de educación cuenta con los siguientes datos en su tabla:*  
>  
> | Cod_escuela | Cod_profesor | Nombre_profesor | Horario_laboral | Fecha_nacimiento | Dir_profesor |
> | :--- | :--- | :--- | :--- | :---: | :--- |
> | E25_de3 | Prof_00012 | Andrea | 9 a 13 | 12/12/1980 | Cabildo 108 |
> | E25_de3 | Prof_99915 | Carla | 9 a 13 | 11/11/1977 | Peru 512 |
> | E22_de1 | Prof_88888 | Juan | 9 a 13 | 03/03/1970 | Serrano 1414 |
> | E12_de14 | Prof_88888 | Juan | 15 a 18 | 03/03/1970 | Serrano 1414 |

* **Paso a Paso y Justificación:**
  1. **Determinación de la PK original:** Dado que la relación es de muchos a muchos ($M:N$) entre escuelas y profesores, la clave primaria es compuesta: $(\mathbf{Cod\_escuela}, \mathbf{Cod\_profesor})$.
  2. **Identificación de Dependencias Parciales (Violación de 2FN):**
     * $Cod\_profesor \longrightarrow \{Nombre\_profesor, Fecha\_nacimiento, Dir\_profesor\}$ *(Depende de una parte de la PK).*
     * $\{Cod\_escuela, Cod\_profesor\} \longrightarrow Horario\_laboral$ *(Depende de la clave completa: un profesor tiene un horario específico en cada escuela).*
  3. **Descomposición:** Se extraen los atributos del profesor a su propia tabla con PK simple `Cod_profesor`. La tabla de asignación conserva únicamente la clave compuesta y el atributo dependiente completo `Horario_laboral`.
* **Esquema Resultante en 2FN:**
  * **$\text{PROFESOR}(\mathbf{\underline{Cod\_profesor}}, Nombre\_profesor, Fecha\_nacimiento, Dir\_profesor)$**
  * **$\text{ASIGNACION\_DOCENTE}(\mathbf{\underline{Cod\_escuela}}, \mathbf{\underline{Cod\_profesor^{*}}}, Horario\_laboral)$** *(FK: `Cod_profesor` $\to$ `PROFESOR`)*

---

### Ejercicio j
> **Consigna Original:**  
> *Dada la siguiente tabla, aplicar 3FN e indicar el resultado:*  
> * *Para poder tener un mejor precio de compra al proveedor, cada artículo solo es comprado a un proveedor.*  
>  
> | Codigo_articulo | Descripcion_articulo | Precio_articulo | Cantidad_disponible | Código_proveedor | Teléfono_proveedor | costo_articulo |
> | :--- | :--- | :---: | :---: | :--- | :--- | :---: |
> | T23 | Tornillo | 3 | 500 | P_1515 | 11-1234-5678 | 2 |
> | P11 | Pinza | 340 | 50 | P_2000 | 11-4444-7777 | 280 |
> | M14 | Martillo | 310 | 15 | P_1515 | 11-1234-5678 | 250 |
> | L100 | Lija | 15 | 200 | P_3400 | 11-5555-6666 | 10 |

* **Paso a Paso y Justificación:**
  1. **Clave primaria y 2FN:** Como cada artículo se compra a un único proveedor, la clave primaria es simple: `Codigo_articulo`. Por ende, la tabla ya se encuentra en 2FN.
  2. **Identificación de Dependencias Transitivas (Violación de 3FN):**
     * $Codigo\_articulo \longrightarrow Código\_proveedor$
     * $Código\_proveedor \longrightarrow Teléfono\_proveedor$
     * Cadena: $Codigo\_articulo \longrightarrow Código\_proveedor \longrightarrow Teléfono\_proveedor$.
     * `Teléfono_proveedor` depende funcionalmente de `Código_proveedor` (atributo no clave) y no del artículo. Si un proveedor cambia de teléfono, habría que modificarlo en cada artículo que le compremos (anomalía de modificación).
  3. **Descomposición:** Se extrae `PROVEEDOR` dejando `Código_proveedor` como FK en `ARTICULO`.
* **Esquema Resultante en 3FN:**
  * **$\text{PROVEEDOR}(\mathbf{\underline{Código\_proveedor}}, Teléfono\_proveedor)$**
  * **$\text{ARTICULO}(\mathbf{\underline{Codigo\_articulo}}, Descripcion\_articulo, Precio\_articulo, Cantidad\_disponible, costo\_articulo, Código\_proveedor^{*})$** *(FK: `Código_proveedor` $\to$ `PROVEEDOR`)*

---

### Ejercicio k
> **Consigna Original:**  
> *Dada la siguiente tabla, aplicar las 3FN e indicar el resultado:*  
> * *La siguiente tabla corresponde a un supermercado.*  
> * *Se dispone de la información de cada uno de los tickets generados.*  
> * *Cada Ticket cuenta con los artículos comprados por el cliente.*  
> * *Para mantener un historial de ventas, además se mantiene la información del cajero que realizó el ticket.*  
>  
> Columnas: `Nro_ticket, Fecha_compra, Cod_articulo, Des_articulo, Precio_articulo, Cant_comprada, Precio_articulo (total renglón), monto_ticket, Nombre_cajero, Ingreso_empresa, fecha_nacimiento, hs_trabaja, evaluacion_cajero`

* **Paso a Paso y Justificación Integral (1FN $\to$ 2FN $\to$ 3FN):**
  1. **Paso 1 (1FN):**
     * En un mismo ticket se compran múltiples artículos (grupo repetitivo).
     * Se define la clave compuesta de la línea de venta: $(\mathbf{Nro\_ticket}, \mathbf{Cod\_articulo})$.
     * Se descarta el atributo calculado derivado `Precio_total_renglon = Cant_comprada * Precio_articulo`.
  2. **Paso 2 (2FN - Eliminación de Dependencias Parciales):**
     * $Nro\_ticket \longrightarrow \{Fecha\_compra, monto\_ticket, Nombre\_cajero, Ingreso\_empresa, fecha\_nacimiento, hs\_trabaja, evaluacion\_cajero\}$
     * $Cod\_articulo \longrightarrow \{Des\_articulo, Precio\_articulo\}$
     * $\{Nro\_ticket, Cod\_articulo\} \longrightarrow Cant\_comprada$
     * *Se separan:* Cabecera de ticket, Catálogo de artículos y Detalle de ticket.
  3. **Paso 3 (3FN - Eliminación de Dependencias Transitivas):**
     * En la cabecera del ticket:
       $$Nro\_ticket \longrightarrow Nombre\_cajero \longrightarrow \{Ingreso\_empresa, fecha\_nacimiento, hs\_trabaja, evaluacion\_cajero\}$$
     * Los datos personales y laborales del cajero no dependen de la transacción del ticket, sino de la persona del cajero. Se extrae la entidad `CAJERO`.
* **Esquema Resultante en 3FN:**
  * **$\text{CAJERO}(\mathbf{\underline{Nombre\_cajero}}, Ingreso\_empresa, fecha\_nacimiento, hs\_trabaja, evaluacion\_cajero)$**
  * **$\text{TICKET}(\mathbf{\underline{Nro\_ticket}}, Fecha\_compra, monto\_ticket, Nombre\_cajero^{*})$** *(FK: `Nombre_cajero` $\to$ `CAJERO`)*
  * **$\text{ARTICULO}(\mathbf{\underline{Cod\_articulo}}, Des\_articulo, Precio\_articulo)$**
  * **$\text{DETALLE\_TICKET}(\mathbf{\underline{Nro\_ticket^{*}}}, \mathbf{\underline{Cod\_articulo^{*}}}, Cant\_comprada)$** *(FKs hacia `TICKET` y `ARTICULO`)*

---
---

## 🏛️ BLOQUE 3: Práctica 2 — Casos de Estudio Integrales y Modelado DER

---

### Caso a: Carreras de Caballos e Hipódromo
> **Consigna Original:**  
> *Aplicar las FN en la siguiente tabla que contiene información de Carreras de Caballos:*  
> *Columnas: `Código_carrera, Nombre_carrera, dia_carrera, cod_caballo, nombre_caballo, nacimiento_caballo, cant_carreras_ganadas, Nro_afil_dueno, nombre_dueno, contacto_Dueno, cantidad_caballos_afiliados, posicion_carrera, lugar_carrera`.*  
> *Una vez obtenidas las FN representar las tablas obtenidas en gráfico de DER.*

* **Paso a Paso y Justificación:**
  1. **1FN:** Clave primaria compuesta $(\mathbf{Código\_carrera}, \mathbf{cod\_caballo})$.
  2. **2FN (Eliminación de dependencias parciales):**
     * $cod\_caballo \longrightarrow \{nombre\_caballo, nacimiento\_caballo, cant\_carreras\_ganadas, Nro\_afil\_dueno, nombre\_dueno, contacto\_Dueno, cantidad\_caballos\_afiliados\}$
     * $Código\_carrera \longrightarrow \{Nombre\_carrera, dia\_carrera, lugar\_carrera\}$
     * $\{Código\_carrera, cod\_caballo\} \longrightarrow posicion\_carrera$
  3. **3FN (Eliminación de dependencias transitivas):**
     * En los datos del caballo, el dueño determina sus datos de afiliación:
       $$cod\_caballo \longrightarrow Nro\_afil\_dueno \longrightarrow \{nombre\_dueno, contacto\_Dueno, cantidad\_caballos\_afiliados\}$$
     * Se extrae `DUENO` vinculándolo con `CABALLO` por clave foránea.
* **Esquema Resultante en 3FN:**
  * **$\text{DUENO}(\mathbf{\underline{Nro\_afil\_dueno}}, nombre\_dueno, contacto\_Dueno, cant\_caballos\_afiliados)$**
  * **$\text{CABALLO}(\mathbf{\underline{cod\_caballo}}, nombre\_caballo, nacimiento\_caballo, cant\_carreras\_ganadas, Nro\_afil\_dueno^{*})$** *(FK: `Nro_afil_dueno` $\to$ `DUENO`)*
  * **$\text{CARRERA}(\mathbf{\underline{Código\_carrera}}, Nombre\_carrera, dia\_carrera, lugar\_carrera)$**
  * **$\text{PARTICIPACION}(\mathbf{\underline{Código\_carrera^{*}}}, \mathbf{\underline{cod\_caballo^{*}}}, posicion\_carrera)$** *(FKs hacia `CARRERA` y `CABALLO`)*

#### Gráfico de DER Resultante:
```text
+---------------+            +---------------+
|     DUENO     | 1        N |    CABALLO    |
|---------------|------------|---------------|
| PK Nro_dueno  |            | PK cod_caballo|
|    nombre     |            |    nombre     |
|    contacto   |            | FK Nro_dueno  |
+---------------+            +---------------+
                                     | 1
                                     |
                                     | N
                             +------------------+
                             |  PARTICIPACION   |
                             |------------------|
                             | PK,FK Cod_carrera|
                             | PK,FK cod_caballo|
                             |       posicion   |
                             +------------------+
                                     | N
                                     |
                                     | 1
                             +------------------+
                             |     CARRERA      |
                             |------------------|
                             | PK Cod_carrera   |
                             |    Nombre        |
                             |    dia           |
                             |    lugar         |
                             +------------------+
```

---

### Caso b: Gestión de Habitaciones de Hotel
> **Consigna Original:**  
> *Aplicar las FN en la siguiente tabla que contiene información de las habitaciones de hotel:*  
> *Relevamiento:*  
> * *El tipo de habitación agrupa todas las habitaciones similares para poder encontrar y ofrecer de manera más simple la disponibilidad según las necesidades de los huéspedes.*  
> * *La empleada responsable es la única que se encarga de mantener a la habitación ordenada y limpia, es la responsable por los objetos de la habitación.*  
> * *El Hotel no trabaja con solo 1 obra social, sino que cada empleada tiene derecho a elegir su obra social.*  
> *Columnas: `tipo_habitacion, num_habitacion, cod_empleada_resp_habitacion, nombre_empleada, tel_empleada, obra_social_empleada, dir_obra_social, tel_obra_social, piso_habitacion, cant_cuartos, cant_camas_2plazas, cant_camas_1plaza, cant_baños`.*  
> *Una vez obtenidas las FN representar las tablas obtenidas en gráfico de DER.*

* **Paso a Paso y Justificación:**
  1. **1FN y Clave Primaria:** La entidad principal es la habitación física individual: PK = `num_habitacion`. Todos los atributos son atómicos.
  2. **2FN:** Al poseer una clave primaria simple (`num_habitacion`), no pueden existir dependencias parciales. La tabla está en 2FN.
  3. **3FN (Eliminación de dependencias transitivas en cascada):**
     * Cadena 1 (Tipo de habitación):
       $$num\_habitacion \longrightarrow tipo\_habitacion \longrightarrow \{cant\_cuartos, cant\_camas\_2plazas, cant\_camas\_1plaza, cant\_baños\}$$
       El número de camas y baños describe al *tipo de habitación*, no al número de habitación específico.
     * Cadena 2 (Empleada responsable y Obra Social):
       $$num\_habitacion \longrightarrow cod\_empleada\_resp \longrightarrow \{nombre\_empleada, tel\_empleada, obra\_social\_empleada\}$$
       Y a su vez:
       $$obra\_social\_empleada \longrightarrow \{dir\_obra\_social, tel\_obra\_social\}$$
     * Se descompone en 4 relaciones enlazadas jerárquicamente.
* **Esquema Resultante en 3FN:**
  * **$\text{OBRA\_SOCIAL}(\mathbf{\underline{obra\_social}}, dir\_obra\_social, tel\_obra\_social)$**
  * **$\text{EMPLEADA}(\mathbf{\underline{cod\_empleada}}, nombre\_empleada, tel\_empleada, obra\_social^{*})$** *(FK: `obra_social` $\to$ `OBRA_SOCIAL`)*
  * **$\text{TIPO\_HABITACION}(\mathbf{\underline{tipo\_habitacion}}, cant\_cuartos, cant\_camas\_2plazas, cant\_camas\_1plaza, cant\_baños)$**
  * **$\text{HABITACION}(\mathbf{\underline{num\_habitacion}}, piso\_habitacion, tipo\_habitacion^{*}, cod\_empleada\_resp^{*})$** *(FKs: `tipo_habitacion` $\to$ `TIPO_HABITACION`, `cod_empleada_resp` $\to$ `EMPLEADA`)*

#### Gráfico de DER Resultante:
```text
+-------------------+           +------------------+
|    OBRA_SOCIAL    | 1       N |     EMPLEADA     |
|-------------------|-----------|------------------|
| PK obra_social    |           | PK cod_empleada  |
|    direccion      |           |    nombre        |
|    telefono       |           | FK obra_social   |
+-------------------+           +------------------+
                                         | 1
                                         |
                                         | N
+-------------------+           +------------------+
|  TIPO_HABITACION  | 1       N |    HABITACION    |
|-------------------|-----------|------------------|
| PK tipo_habitacion|           | PK num_habitacion|
|    cant_cuartos   |           |    piso          |
|    cant_camas     |           | FK tipo_habit    |
|    cant_banos     |           | FK cod_empleada  |
+-------------------+           +------------------+
```

---

### Caso c: Industria Farmacéutica, Lotes y Drogas
> **Consigna Original:**  
> *Empresa de productos farmacéuticos.*  
> *Relevamiento:*  
> * *La empresa XXX se encarga de producir y vender productos farmacéuticos.*  
> * *Para ello necesita saber las drogas que cada producto tiene.*  
> * *Una determinada droga (id_droga) es siempre comprada al mismo proveedor, si se cambia de proveedor, entonces también se cambiará de id_droga y de id_producto.*  
> * *El número de Lote depende de cada producto, es decir puede haber 2 productos con el mismo nro de lote.*  
> * *El precio del producto va a depender del Lote ya que al haber inflación, el costo del producto se va a calcular al momento de elaborarlo.*  
> *Columnas: `id_producto, nombre_producto, desc_poducto, id_droga, nombre_droga, porcentaje_droga, cant_drogas_usadas, precio_producto, id_proveedor_droga, contacto_prov_droga, Lote, fecha_elaboracion, fecha_expiracion`.*  
> *Una vez obtenidas las FN representar las tablas obtenidas en gráfico de DER.*

* **Paso a Paso y Justificación:**
  1. **1FN:** Clave primaria compuesta general para cubrir lotes y composición química: $(\mathbf{id\_producto}, \mathbf{Lote}, \mathbf{id\_droga})$.
  2. **2FN (Eliminación de dependencias parciales):**
     * Del producto en general: $id\_producto \longrightarrow \{nombre\_producto, desc\_producto, cant\_drogas\_usadas\}$
     * De la fórmula química: $\{id\_producto, id\_droga\} \longrightarrow porcentaje\_droga$
     * Del lote y su precio histórico: $\{id\_producto, Lote\} \longrightarrow \{precio\_producto, fecha\_elaboracion, fecha\_expiracion\}$
     * De la droga en sí: $id\_droga \longrightarrow \{nombre\_droga, id\_proveedor\_droga, contacto\_prov\_droga\}$
  3. **3FN (Eliminación de dependencias transitivas):**
     * En los datos de la droga:
       $$id\_droga \longrightarrow id\_proveedor\_droga \longrightarrow contacto\_prov\_droga$$
     * El contacto describe al proveedor, no a la sustancia activa. Se extrae `PROVEEDOR_DROGA`.
* **Esquema Resultante en 3FN:**
  * **$\text{PROVEEDOR\_DROGA}(\mathbf{\underline{id\_proveedor\_droga}}, contacto\_prov\_droga)$**
  * **$\text{DROGA}(\mathbf{\underline{id\_droga}}, nombre\_droga, id\_proveedor\_droga^{*})$** *(FK: `id_proveedor_droga` $\to$ `PROVEEDOR_DROGA`)*
  * **$\text{PRODUCTO}(\mathbf{\underline{id\_producto}}, nombre\_producto, desc\_producto, cant\_drogas\_usadas)$**
  * **$\text{FORMULA\_PRODUCTO}(\mathbf{\underline{id\_producto^{*}}}, \mathbf{\underline{id\_droga^{*}}}, porcentaje\_droga)$** *(FKs hacia `PRODUCTO` y `DROGA`)*
  * **$\text{LOTE\_PRODUCTO}(\mathbf{\underline{id\_producto^{*}}}, \mathbf{\underline{Lote}}, precio\_producto, fecha\_elaboracion, fecha\_expiracion)$** *(FK: `id_producto` $\to$ `PRODUCTO`)*

#### Gráfico de DER Resultante:
```text
+-------------------+           +-------------------+
|  PROVEEDOR_DROGA  | 1       N |       DROGA       |
|-------------------|-----------|-------------------|
| PK id_prov_droga  |           | PK id_droga       |
|    contacto       |           |    nombre_droga   |
+-------------------+           | FK id_prov_droga  |
                                +-------------------+
                                          | 1
                                          |
                                          | N
                                +-------------------+
                                | FORMULA_PRODUCTO  |
                                |-------------------|
                                | PK,FK id_producto |
                                | PK,FK id_droga    |
                                |       porcentaje  |
                                +-------------------+
                                          | N
                                          |
                                          | 1
+-------------------+ 1       N +-------------------+
|   LOTE_PRODUCTO   |-----------|     PRODUCTO      |
|-------------------|           |-------------------|
| PK,FK id_producto |           | PK id_producto    |
| PK    Lote        |           |    nombre         |
|       precio      |           |    descripcion    |
|       fecha_elab  |           |    cant_drogas    |
|       fecha_exp   |           +-------------------+
+-------------------+
```