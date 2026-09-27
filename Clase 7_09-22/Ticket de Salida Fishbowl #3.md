# Clase Teórica #4 - Ticket de Salida - Cuestionario Recuperación

## Pregunta 1
**Enunciado:** La *escritura anticipada en el log (WAL)* de la actualización inmediata significa que…
**Respuesta correcta:** d. El registro en el log se escribe antes que los datos en el almacenamiento físico.
**Justificación:** El protocolo WAL (Write-Ahead Logging) exige que cualquier modificación se registre y confirme primero en el log transaccional en disco antes de escribir los datos en el almacenamiento físico. Esto permite que el sistema gestor de base de datos pueda aplicar los procesos de Rehacer (Redo) y Deshacer (Undo) en caso de una falla del sistema, garantizando la consistencia.

## Pregunta 2
**Enunciado:** ¿Cuál de estas fallas es de tipo *catastrófico (de medios)* y exige recurrir a backups físicos?
**Respuesta correcta:** d. Falla de disco / catástrofe física.
**Justificación:** Las fallas de medios implican daño en el hardware (como la rotura de un disco), lo que destruye los archivos físicos de la base de datos. A diferencia de los errores del sistema o abortos de transacciones (que el motor resuelve de forma automática leyendo el log), una catástrofe física no se puede recuperar automáticamente y exige la intervención humana para restaurar backups físicos.

## Pregunta 3
**Enunciado:** Para restaurar hasta el instante de una *falla catastrófica*, el esquema de backups requiere…
**Respuesta correcta:** c. El último backup full + su último diferencial + el log transaccional (roll-forward).
**Justificación:** Para lograr una recuperación a un punto en el tiempo (Point-in-Time Recovery) garantizando cero pérdida de datos, es necesario reconstruir el estado aplicando: 1) el último backup completo como base, 2) el último diferencial para incorporar todos los bloques modificados desde ese backup full, y 3) los registros del log transaccional (roll-forward) generados después del diferencial, para rehacer las operaciones hasta el milisegundo exacto previo a la caída.