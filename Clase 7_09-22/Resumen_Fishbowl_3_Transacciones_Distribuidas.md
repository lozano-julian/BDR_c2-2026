# 🐟 Guía Maestra y Resumen Exhaustivo: Sesión Fishbowl #3 — Transacciones y Transacciones Distribuidas
**Materia:** Bases de Datos Relacionales (2026) — Comisión Ciencias de Datos / Ing. Informática  
**Fecha de la Sesión:** 22 de Septiembre de 2026 (Clase 7)  
**Track:** Track 4 — Seguridad, Transacciones y Concurrencia  
**Material Base:** Apunte 6, Clase Teórica #4, Presentación Fishbowl #3 (UCA), Infografías y MindMaps de la Cátedra.

---

## 📌 Índice de Contenidos para la Sesión Fishbowl
1. [Fundamentos de Transacciones y Propiedades ACID](#1-fundamentos-de-transacciones-y-propiedades-acid)
2. [Schedules, Anomalías de Concurrencia y Recuperabilidad](#2-schedules-anomalías-de-concurrencia-y-recuperabilidad)
3. [Control de Concurrencia Local: Protocolos de Bloqueo y Deadlocks](#3-control-de-concurrencia-local-protocolos-de-bloqueo-y-deadlocks)
4. [Técnicas de Recuperación Local (WAL, Checkpoints, Actualización Diferida e Inmediata)](#4-técnicas-de-recuperación-local)
5. [El Problema de las Transacciones Distribuidas (Del Centralizado al Distribuido)](#5-el-problema-de-las-transacciones-distribuidas)
6. [El Estándar de la Industria: Modelo X/Open XA (DTP)](#6-el-estándar-de-la-industria-modelo-xopen-xa-dtp)
7. [Commit en Dos Fases (2PC — Two-Phase Commit)](#7-commit-en-dos-fases-2pc--two-phase-commit)
8. [Problemas Críticos de 2PC: Transacciones en Duda y Bloqueo](#8-problemas-críticos-de-2pc-transacciones-en-duda-y-bloqueo)
9. [Variantes Optimizadas de 2PC: 2PC en Árbol y D2PC](#9-variantes-optimizadas-de-2pc-2pc-en-árbol-y-d2pc)
10. [Commit en Tres Fases (3PC — Three-Phase Commit) y el Talón de Aquiles](#10-commit-en-tres-fases-3pc--three-phase-commit)
11. [Cuadro Comparativo Definitivo: 2PC vs. 3PC](#11-cuadro-comparativo-definitivo-2pc-vs-3pc)
12. [Preguntas Típicas y Claves de Discusión en la Rueda Fishbowl](#12-preguntas-típicas-y-claves-de-discusión-en-la-rueda-fishbowl)

---

## 1. Fundamentos de Transacciones y Propiedades ACID

### 1.1. ¿Qué es una Transacción?
Una **transacción** es una unidad lógica de ejecución de un programa que accede y posiblemente actualiza varios elementos de datos. Aunque esté compuesta por múltiples operaciones elementales de lectura (`read`) y escritura (`write`), el sistema exige que se comporte como una **interacción atómica** indivisible: se aplica por completo o no se aplica en absoluto.

> **Ejemplo Clásico de la Cátedra (Transferencia Bancaria):**  
> Transferir \$5.000 de la cuenta de Armando ($A = \$20.000$) a la de Benito ($B = \$0$):
> 1. Verificar si en $A$ hay saldo suficiente ($\ge \$5.000$).
> 2. Restar \$5.000 a la cuenta $A \implies A = \$15.000$.
> 3. Sumar \$5.000 a la cuenta $B \implies B = \$5.000$.  
> 
> *Falla:* Si el sistema se cae entre el paso 2 y el 3, $A = \$15.000$ y $B = \$0$, volatilizando \$5.000. La transacción garantiza que el estado sea **"Todo o Nada"**.

---

### 1.2. El Acrónimo ACID en Detalle

* **A — Atomicidad (Atomicity):**  
  Principio del "Todo o Nada". Si la transacción se interrumpe por fallo de software, hardware o excepción de la aplicación, el DBMS debe revertir (*rollback/abort*) todos los cambios parciales para que la base quede como si la transacción nunca hubiera comenzado. Se garantiza mediante el **Log / Bitácora**.
* **C — Consistencia (Consistency):**  
  Una transacción debe llevar a la base de datos de un estado válido a otro estado válido, preservando todas las restricciones de integridad (*constraints*, claves foráneas, reglas de validación). Nota: la consistencia interna de negocio depende en parte de la lógica del programador.
* **I — Aislamiento (Isolation):**  
  El efecto de ejecutar $N$ transacciones concurrentemente debe ser idéntico al de ejecutarlas de forma secuencial una después de otra (**Serializabilidad**). Ninguna transacción debe ver los estados intermedios inconsistentes de otra transacción en progreso.
* **D — Durabilidad (Durability):**  
  Una vez que el DBMS emite la confirmación de éxito (**COMMIT**) al usuario, los cambios son irrevocables y deben persistir en el almacenamiento no volátil, incluso ante una caída total de energía inmediatamente posterior.

---

## 2. Schedules, Anomalías de Concurrencia y Recuperabilidad

### 2.1. Schedules (Planes de Ejecución)
* **Schedule:** Secuencia cronológica en la que se intercalan las operaciones de un conjunto de transacciones concurrentes, preservando el orden relativo interno de cada una.
* **Schedule Serial:** Las transacciones se ejecutan una después de la otra, sin intercalar operaciones (aislamiento perfecto, pero pésimo rendimiento en multiprocesamiento).
* **Schedule Serializable:** Un schedule intercalado cuyo resultado final sobre la base de datos es idéntico al de algún schedule serial.

### 2.2. Anomalías por Ejecuciones Entrelazadas
Si no se controla la concurrencia, ocurren tres fenómenos anómalos clásicos:

1. **Lectura Sucia (Dirty Read):**  
   La transacción $T_2$ lee un dato modificado por $T_1$ mientras $T_1$ aún está activa. Si luego $T_1$ hace `ROLLBACK`, $T_2$ trabajó sobre un dato que "nunca existió en la realidad".
2. **Lectura No Repetible (Non-Repeatable Read / Fuzzy Read):**  
   La transacción $T_1$ lee un registro $A$. Luego, $T_2$ modifica o borra $A$ y hace `COMMIT`. Si $T_1$ vuelve a leer $A$, encuentra un valor distinto o el registro ha desaparecido.
3. **Escritura No Confirmada / Actualización Perdida (Lost Update / Overwriting Uncommitted Data):**  
   $T_1$ escribe un valor en $A$, pero antes de confirmar, $T_2$ sobrescribe $A$. Se pierde la modificación de $T_1$ o se rompe la consistencia cruzada entre múltiples tuplas (como en el ejemplo de salarios del apunte).

### 2.3. Schedules Recuperables y Cascada de Abortos
* **Schedule No Recuperable:** Ocurre si $T_2$ lee un dato escrito por $T_1$, $T_2$ hace `COMMIT`, y posteriormente $T_1$ hace `ROLLBACK`. Como $T_2$ ya confirmó ante el usuario, no se puede deshacer $\implies$ La base de datos queda corrupta.
* **Schedule Recuperable:** Ninguna transacción $T_2$ puede hacer `COMMIT` hasta que todas las transacciones $T_1$ cuyos datos leyó hayan hecho `COMMIT`.
* **Evitar Abortos en Cascada (Cascadeless):** Para evitar que el aborto de una transacción obligue a abortar en cadena a múltiples transacciones dependientes, se exige que una transacción solo lea datos confirmados.

---

## 3. Control de Concurrencia Local: Protocolos de Bloqueo y Deadlocks

### 3.1. Bloqueo en Dos Fases Estricto (Strict 2-Phase Locking — S2PL)
Es el protocolo estándar de los motores relacionales para garantizar serializabilidad y recuperabilidad:
1. **Shared Lock ($S$):** Se solicita antes de leer un objeto. Múltiples transacciones pueden tener candados compartidos concurrentes.
2. **Exclusive Lock ($X$):** Se solicita antes de escribir un objeto. Es exclusivo: ninguna otra transacción puede leer ni escribir ese objeto.
3. **Regla Estricta (Strict):** **Todos los candados ($S$ y $X$) retenidos por la transacción se liberan ÚNICAMENTE al finalizar la transacción (en el `COMMIT` o `ROLLBACK`)**. Esto previene lecturas sucias y asegura recuperabilidad sin cascada.

---

### 3.2. Deadlocks (Bloqueos Mutuos) y Estrategias de Resolución
Un **deadlock** ocurre cuando dos o más transacciones están detenidas esperando por recursos que la otra tiene bloqueados en ciclo (abrazo mortal).

#### Métodos de Prevención:
* **S2PL Conservador:** La transacción debe solicitar y obtener *todos* los candados que necesitará al inicio de su ejecución. Si alguno no está disponible, no adquiere ninguno y espera. (Desventaja: limita fuertemente la concurrencia).
* **Ordenamiento Total de Recursos:** Obliga a pedir los recursos siempre en un orden jerárquico prefijado (poco práctico en sistemas dinámicos).
* **Basados en Timestamps (Marcas de Tiempo):**
  * **Wait-Die (Esperar-Morir — No Expropiativo):** Si la transacción vieja $T_{\text{vieja}}$ pide un recurso de $T_{\text{nueva}}$, $T_{\text{vieja}}$ **espera**. Si la nueva pide recurso de la vieja, la nueva **muere (aborta y se reinicia)**.
  * **Wound-Wait (Herir-Esperar — Expropiativo):** Si la vieja pide recurso de la nueva, la vieja **"hiere" (aborta y desaloja)** a la nueva. Si la nueva pide recurso de la vieja, la nueva **espera**.
* **Técnicas sin Timestamps:**
  * **No Waiting (NW):** Si un candado no está disponible, la transacción aborta inmediatamente y reintenta tras un tiempo aleatorio.
  * **Cautious Waiting (CW):** Si $T_i$ quiere bloquear un recurso ocupado por $T_j$, solo espera si $T_j$ no está a su vez bloqueada. Si $T_j$ está bloqueada, $T_i$ aborta inmediatamente para evitar formar un ciclo.

#### Métodos de Detección:
* **Grafo de Espera (Wait-For Graph — WFG):**
  * Nodos: Transacciones activas.
  * Arcos: $T_i \to T_j$ si $T_i$ espera un candado que tiene $T_j$.
  * **Condición de Deadlock:** Existencia de un **ciclo** en el grafo dirigido.
* **Selección de Víctima:** Al detectar un ciclo, se selecciona una transacción para abortarla.
  * *Riesgos:* **Inanición (Starvation)** si siempre se elige a la misma víctima, o **Reinicio Cíclico** (entrar en deadlock repetidamente). Se soluciona asignando prioridades mediante colas FIFO o contando la cantidad de reinicios.

---

### 3.3. Control de Concurrencia por Marcas de Tiempo (Timestamp Ordering)
A cada elemento $X$ se le asocian dos valores:
* $\text{ReadTS}(X)$: Mayor timestamp de transacciones que leyeron $X$.
* $\text{WriteTS}(X)$: Mayor timestamp de transacciones que escribieron $X$.

Si una transacción $T$ intenta leer o escribir a destiempo violando el orden cronológico estricto, es abortada y reiniciada con un timestamp más nuevo.
* **Regla de Escritura de Thomas (Thomas Write Rule):** Optimización donde una escritura obsoleta ($\text{WriteTS}(X) > TS(T)$) simplemente se **ignora en silencio** en lugar de abortar la transacción, aprovechando que el valor ya fue sobrescrito por una transacción posterior válida.

---

## 4. Técnicas de Recuperación Local

Para soportar caídas de energía, fallas del SO o rollbacks, el DBMS utiliza el **Log Transaccional** bajo la regla **WAL (Write-Ahead Logging)**: ninguna página de datos modificada se escribe a disco antes de que el registro correspondiente en el log haya sido forzado a disco (*flush*).

* **Checkpoints (Puntos de Control):** Momentos periódicos en los que el DBMS vuelca a disco los buffers sucios de datos y escribe un registro especial en el log. Permite acotar el análisis de recuperación sin tener que leer el log desde el inicio de los tiempos.
* **Actualización Diferida (Deferred Update — NO-UNDO / REDO):**
  Los cambios NO se escriben en las tablas en disco hasta que la transacción hace `COMMIT`. 
  * *Recuperación:* Solo se necesita **REDO** (rehacer) de las transacciones confirmadas desde el último checkpoint. No requiere UNDO porque las transacciones activas nunca tocaron el disco.
* **Actualización Inmediata (Immediate Update — UNDO / REDO):**
  Las modificaciones pueden escribirse en disco antes del `COMMIT`.
  * *Recuperación:* Requiere **REDO** para transacciones confirmadas y **UNDO** (deshacer en orden inverso) para las transacciones que quedaron activas sin confirmar al momento de la caída.
* **Paginación de Sombra (Shadow Paging):**
  Se mantienen dos tablas de páginas: la tabla actual (en memoria) y la tabla sombra (en disco). Las escrituras se hacen en páginas nuevas sin tocar las originales. En el commit, el puntero del disco se actualiza atómicamente a la nueva tabla. Si falla antes, se descartan las páginas nuevas y se mantiene la sombra (recuperación instantánea, pero genera fragmentación de disco).

---

## 5. El Problema de las Transacciones Distribuidas

### 5.1. Del Centralizado al Distribuido
Cuando el volumen de datos o la naturaleza del negocio impide un único servidor centralizado, los datos se distribuyen entre múltiples instalaciones independientes (distintos DBMS, distintas ubicaciones geográficas o diferentes microservicios).

Una **Transacción Distribuida** es una transacción global que involucra operaciones sobre dos o más gestores de recursos independientes comunicados por red.
* **Desafío Principal:** Garantizar el **ACID Global**.
* Si el DBMS 1 resta el dinero de Armando y confirma localmente, pero el DBMS 2 falla antes de acreditarle a Benito, la base queda inconsistente a nivel global.
* El mecanismo de commit local (`COMMIT;`) ya no alcanza: **hace falta un protocolo de consenso distribuido**.

---

## 6. El Estándar de la Industria: Modelo X/Open XA (DTP)

Creado por el consorcio **Open Group**, el modelo **DTP (Distributed Transaction Processing)** define la arquitectura estándar que adoptan tecnologías como Java EE (JTA / EJB), Microsoft MTS / COM+ y servidores de aplicaciones modernos.

```
       +---------------------------------------------+
       |          Application Program (AP)           |
       +---------------------------------------------+
               | (TX)                 | (AP-RM / SQL)
               v                      v
       +-------------------+       +--------------------+
       |Transaction Manager|=====> |Resource Manager(RM)|
       |   (TM / Coord)    | (XA)  |      (DBMS 1)      |
       +-------------------+       +--------------------+
               |                      |
               | (XA+)                | (XA)
               v                      v
       +-------------------+       +--------------------+
       | Communications RM |       |Resource Manager(RM)|
       |       (CRM)       |       |      (DBMS 2)      |
       +-------------------+       +--------------------+
```

### 6.1. Componentes del Modelo X/Open XA
1. **Application Program (AP):** Define la lógica del negocio y delimita el inicio y fin de la transacción global.
2. **Transaction Manager (TM):** Es el software **Coordinador**. Asigna a la transacción un identificador global unívoco (**GTRID**), orquesta las ramas locales y ejecuta los protocolos de consenso (2PC).
3. **Resource Manager (RM):** Administrador del recurso compartido (típicamente el motor de Base de Datos relacional, pero también puede ser un broker de mensajería como colas JMS o RabbitMQ). Actúa como **Participante**.
4. **Communications Resource Manager (CRM):** Componente especializado en la comunicación de transacciones entre distintas plataformas o procesos a través de la red.

### 6.2. Interfaces de la API DTP
* **`AP-RM` (SQL):** Interfaz estándar para que la aplicación ejecute sentencias DML/SQL directamente sobre el recurso.
* **`TX`:** Interfaz entre la aplicación y el TM para iniciar (`tx_begin`), confirmar (`tx_commit`) o abortar (`tx_rollback`) transacciones globales.
* **`XA`:** La interfaz crítica y bidireccional entre el **TM y los RMs**. Permite que el coordinador ordene a los motores de base de datos preparar (`xa_prepare`), confirmar (`xa_commit`) o recuperar transacciones. Habilita el protocolo 2PC.
* **`XA+`:** Interfaz entre el TM y el CRM para coordinar transacciones distribuidas entre múltiples computadoras remotas.
* **`CM`:** Interfaz de comunicación entre la aplicación y el CRM (RPC, cliente/servidor, P2P).

---

## 7. Commit en Dos Fases (2PC — Two-Phase Commit)

Es el protocolo de consenso por excelencia para coordinar el commit atómico entre un **Coordinador (TM)** y múltiples **Participantes (RMs)**.

### 7.1. Dinámica de las Fases

#### Fase 1: Petición / Votación (Prepare Phase)
1. La aplicación solicita el cierre de la transacción global al TM.
2. El Coordinador escribe en su log (**TLog**) el registro `START_2PC` y envía un mensaje `PREPARE(GTRID)` a todos los participantes.
3. Cada Participante ejecuta localmente todas las verificaciones (integridad, concurrencia, bloqueo de filas) y fuerza la escritura de sus registros en su log local.
4. Cada Participante vota:
   * **`READY` (Voto Positivo):** Garantiza que tiene todo bloqueado y listo en disco para hacer commit sin fallar, pase lo que pase.
   * **`ABORT` (Voto Negativo):** Si no puede asegurar el éxito (por conflicto de candados, violación de regla o fallo interno).

#### Fase 2: Decisión / Ejecución (Commit / Abort Phase)
* **Regla de Unanimidad:**
  * **Si TODOS los participantes votaron `READY`:** El coordinador escribe `GLOBAL_COMMIT` en su TLog y envía la orden `COMMIT` a todos los participantes.
  * **Si al menos UN participante votó `ABORT` (o no responde por timeout):** El coordinador escribe `GLOBAL_ABORT` en su TLog y envía la orden `ABORT` a todos los participantes.
* Los participantes reciben la orden, aplican el commit/abort local, liberan todos los bloqueos retenidos y envían un mensaje de acuse de recibo (**`ACK`**) al coordinador.
* Al recibir todos los `ACK`, el coordinador escribe `END_OF_TRANSACTION` en su log y da por concluido el ciclo.

---

## 8. Problemas Críticos de 2PC: Transacciones en Duda y Bloqueo

A pesar de su elegancia conceptual, 2PC presenta dos vulnerabilidades operativas fundamentales que son el eje de debate en la sesión Fishbowl:

### 8.1. Transacciones "En Duda" (In-Doubt Transactions)
Ocurre cuando un participante votó `READY` en la Fase 1, pero la orden de Fase 2 nunca le llega debido a una caída de la red o del coordinador.
* El participante **no puede decidir por su cuenta**:
  * Si decide hacer `COMMIT` unilateralmente, y el coordinador había ordenado abortar a los demás $\implies$ inconsistencia global.
  * Si decide hacer `ABORT` unilateralmente, y el coordinador ordenó commit $\implies$ inconsistencia global.
* El participante queda en un estado suspendido (*in-doubt*) hasta que el coordinador se recupere o un administrador resuelva manualmente la heurística.

### 8.2. El 2PC es un Protocolo Bloqueante (The Blocking Problem)
* **¿Por qué es bloqueante?:**  
  Porque si el Coordinador falla de manera permanente justo después de que los participantes votaron `READY`, **los participantes quedan bloqueados indefinidamente**.
* **Impacto sistémico:**  
  Un participante bloqueado **debe retener todos sus bloqueos exclusivos ($X$-locks)** sobre las filas afectadas. Toda otra transacción del sistema que intente acceder a esos mismos registros quedará encolada indefinidamente, provocando un efecto dominó que puede paralizar el motor de base de datos completo.

---

## 9. Variantes Optimizadas de 2PC: 2PC en Árbol y D2PC

Para mitigar la sobrecarga de red y mejorar la escalabilidad, se desarrollaron variantes:

### 9.1. Commit en Dos Fases en Árbol (Tree 2PC)
* Se organiza a los nodos en una jerarquía de árbol:
  * **Nodo Raíz:** Coordinador supremo.
  * **Nodos Intermedios:** Actúan como coordinadores locales de sus subordinados y participantes frente a su superior.
  * **Nodos Hoja:** Participantes puros.
* **Propagación:** Los mensajes de `PREPARE` bajan por el árbol. Los votos y `ACK` suben recolectándose en cada nivel.
* **Optimización de Aborto Rápido:** Si cualquier nodo decide abortar, la orden de `ABORT` sube inmediatamente sin esperar al resto de las ramas subordinadas.

### 9.2. Commit en Dos Fases Dinámico (Dynamic 2PC — D2PC)
* **Sin coordinador fijo predeterminado:** No existe un nodo raíz asignado a priori.
* **Mecanismo:** Los mensajes de confirmación (`ACK`) se inician en todas las hojas a medida que terminan sus tareas locales y "compiten en carrera" viajando por los canales de comunicación.
* El nodo o canal donde se concentran los mensajes es elegido **dinámicamente como Coordinador**.
* **Ventaja:** Minimiza la latencia de red y permite una **liberación temprana de los recursos bloqueados**.

---

## 10. Commit en Tres Fases (3PC — Three-Phase Commit) y el Talón de Aquiles

El protocolo **3PC** (desarrollado por Skeen) fue diseñado con un objetivo matemático concreto: **eliminar la naturaleza bloqueante del 2PC ante caídas del coordinador**.

### 10.1. ¿Cómo elimina el bloqueo?
Introduce dos conceptos clave:
1. **Una fase intermedia adicional:** La fase de **"Preparados" (Pre-Commit)** entre la votación y el commit final.
2. **Cotas superiores de tiempo (Timeouts asincrónicos):** Reglas deterministas de transición en cada estado. Si se vence un temporizador, los nodos pueden tomar una decisión autónoma segura sin esperar eternamente.

### 10.2. Máquina de Estados del Coordinador en 3PC
* **$q_1$ (Inicial):** Recibe la petición. Envía inicio a los participantes y pasa a $e_1$.
* **$e_1$ (En Espera):** Espera los votos.
  * *Si hay fallo, timeout o algún voto NO:* Envía `ABORT` a todos y pasa a $a_1$ (Abortado).
  * *Si todos votaron OK:* Envía `PRE-COMMIT` ("preparados") a todos y pasa a $p_1$.
* **$p_1$ (Preparados):** Espera los acuses de recibo de pre-commit.
  * *Si todos responden ACK:* Envía la orden definitiva `COMMIT` y pasa a $c_1$ (Confirmado).
  * *Si se vence el timeout:* Aborta la transacción.
* **$c_1$ (Commit) / $a_1$ (Abort):** Estados terminales.

```
       [ q1: Inicial ]
             |
             | (Envía Prepare)
             v
       [ e1: En Espera ] ------------------------> [ a1: Abortar ]
             |                                    ^
             | (Todos OK -> Envía Pre-Commit)     | (Timeout / Fallo)
             v                                    |
       [ p1: Preparados ] ------------------------+
             |
             | (Todos ACK -> Envía Commit)
             v
       [ c1: Commit ]
```

### 10.3. Máquina de Estados del Participante en 3PC
1. Recibe mensaje de inicio: si está listo contesta `OK` y pasa a **En Espera**; si no, aborta.
2. Estando en **En Espera**: si recibe `ABORT` o expira el timeout sin noticias, **aborta** (decisión segura, porque sabe que nadie pudo haber hecho commit). Si recibe `PRE-COMMIT`, envía `ACK` y pasa a **Pendiente**.
3. Estando en **Pendiente**: sabe con total certeza que *todos los demás participantes votaron positivo* y están vivos. Si el coordinador se cae o expira el timeout, el participante puede proceder a ejecutar **`COMMIT` de forma autónoma**.

### 10.4. El Talón de Aquiles de 3PC: La Partición de Red (Network Partitioning)
Aunque 3PC es formalmente no bloqueante bajo caídas de nodos en una red ideal, tiene una vulnerabilidad letal en el mundo real:
> **⚠️ El Talón de Aquiles:**  
> Si la red se segmenta físicamente en dos subredes aisladas (**Network Partition / Split-Brain**), los timeouts causarán que **un subgrupo de nodos avance a `COMMIT` (en estado pendiente) mientras el otro subgrupo decida `ABORT` (en estado de espera)**.  
> Esto viola directamente la **Atomicidad** y corrompe la base de datos distribuida de forma irremediable. Por esta razón práctica, la industria prefiere asumir el riesgo de bloqueo de 2PC (o usar algoritmos modernos de consenso por quórum como Raft/Paxos) antes que implementar 3PC en redes WAN.

---

## 11. Cuadro Comparativo Definitivo: 2PC vs. 3PC

| Dimensión Analítica | Commit en Dos Fases (2PC) | Commit en Tres Fases (3PC) |
| :--- | :--- | :--- |
| **Número de Fases** | **2 fases** (Prepare $\to$ Commit/Abort) | **3 fases** (Prepare $\to$ Pre-Commit $\to$ Commit) |
| **¿Es Bloqueante?** | **SÍ.** Si el coordinador cae tras el voto, los participantes en duda quedan congelados. | **NO.** Los timeouts permiten resolver estados sin bloqueo indefinido. |
| **Comportamiento ante caída de un nodo** | Los participantes que votaron `ready` mantienen los locks (*in-doubt*). | Los nodos liberan candados y progresan al vencer el timeout. |
| **Complejidad y Latencia** | Menor tráfico de mensajes de red y menor latencia de confirmación. | Mayor sobrecarga de mensajes ($3$ rondas completas de ida y vuelta). |
| **Vulnerabilidad Principal** | El **bloqueo indefinido** ante fallo del coordinador central. | **Partición de red (Split-Brain):** Si la red se corta, puede romper la consistencia global. |
| **Uso en la Industria** | **Ampliamente adoptado** (Estándar X/Open XA en Oracle, Postgres, Java/JTA). | **Casi nulo en producción** (reemplazado por consensos tipo Paxos/Raft). |

---

## 12. Preguntas Típicas y Claves de Discusión en la Rueda Fishbowl

Para intervenir con solvencia y criterio técnico durante la dinámica Fishbowl, tené presentes estos ejes de debate:

1. **¿Por qué una transferencia bancaria entre dos bases no se puede resolver con dos sentencias `COMMIT` secuenciales?**  
   *R:* Porque si el segundo commit falla, el primero ya fue persistido y no se puede deshacer con un rollback estándar. Se requiere un protocolo de commit atómico coordinado (como 2PC) que preserve ACID de punta a punta.
2. **¿Cuál es el rol del `GTRID` en el modelo XA?**  
   *R:* El `GTRID` (Global Transaction Identifier) permite que el Transaction Manager etiquete todas las operaciones de la transacción global para que los múltiples Resource Managers puedan diferenciar las ramas de esa transacción distribuida de sus transacciones locales ordinarias.
3. **¿Por qué se dice que el 2PC es conservador?**  
   *R:* Porque ante la mínima duda, timeout en la fase de votación o falta de respuesta de un único nodo, el coordinador se predispone por defecto a abortar toda la transacción global.
4. **¿Por qué un participante de 2PC no puede decidir por sí mismo abortar si tarda en llegar la orden de la fase 2?**  
   *R:* Porque al haber votado `READY` en la fase 1, cedió su autonomía al coordinador. Existe la posibilidad de que el coordinador haya recibido todos los votos positivos y haya enviado `COMMIT` a los demás participantes. Si este nodo aborta por su cuenta, se rompería la atomicidad.
5. **¿Qué diferencia conceptual hay entre el 2PC en árbol y el D2PC?**  
   *R:* El 2PC en árbol tiene una jerarquía estática predefinida con una raíz fija; D2PC no tiene coordinador predeterminado, sino que los mensajes de confirmación viajan desde las hojas y el coordinador se elige dinámicamente donde convergen los mensajes.
6. **¿Por qué 3PC no se usa masivamente en la industria si resuelve el bloqueo de 2PC?**  
   *R:* Porque el costo de fallar ante una partición de red (inconsistencia de datos por Split-Brain) es inaceptable para sistemas bancarios o transaccionales críticos. En esos casos, se prefiere la disponibilidad comprometida (bloqueo) de 2PC o soluciones basadas en quórums (Paxos/Raft).

