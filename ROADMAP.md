# ROADMAP — esba-florida-panel

## Estado actual (2026-08-25, fin de jornada)

Rama de trabajo: **`sedes-fuente-individual`** (pusheada, preview activa, **NO mergeada a main**).
Preview: https://sedes-fuente-individual.esba-florida-panel.pages.dev

### Qué se hizo hoy

Se reemplazó la fuente de "Alumnos activos" — antes dependía de que Daniel consolidara a mano en la planilla "Resumen Sedes 2026" (y de sus solapas "Liquidación", con la misma fragilidad de rotación manual un nivel más adentro, ver hallazgo abajo). Ahora se lee en vivo, directo, de las planillas individuales de cada subsede (carpeta de Drive compartida por Guga: https://drive.google.com/drive/folders/1C4JO4wYoVc5js6F7YqKMLZ1r7-4Yr4kv).

**Commits de la rama** (orden cronológico):
1. `9a15594` — Lectura en vivo de 14 sedes/CADs individuales + fix de rotación de bimestre (6 bimestres reales, no 4 fijos).
2. `9eb1516` — Subtítulo de la sección "Red de Sedes" dinámico (antes decía "JUN-JUL en curso" fijo).
3. `0a22f7b` — Unificación: `calcularActivosGlobal_()` cachea una sola promesa para que "Resumen Ejecutivo" y "Red de Sedes" muestren siempre el mismo número (antes Resumen Ejecutivo calculaba el suyo aparte, hardcodeado a b4a).

**Criterio final de "activo"**: DNI único en las 4 solapas por modalidad (`Cursada`, `INTENSIVO`, `INTENSIVO ANUAL`, `REGULAR`) con el pago del mes/bimestre en curso tildado (`"Verdadero"`) o con monto en pesos > 0 en esa misma celda (checkbox en la mayoría de las sedes; monto en las que cobra la central, confirmado en Pilar y Mar del Plata). **No se usa STATUS=RA/RI** — se descartó porque San Isidro tiene 38.5% de sus alumnos con STATUS=RI pagando al día, así que RI no equivale a inactivo.

**Número actual (24-25/08/2026): 543** alumnos activos, vs. 573/579 que mostraba antes el número viejo (dato manual desactualizado).

### Detalles técnicos para retomar sin tener que re-descubrirlos

- El bloque de 12 columnas de pago mensual arranca siempre **5 columnas después de la columna `STATUS`** en cada solapa — esto vale incluso cuando no hay etiquetas de texto (Pilar) o cuando las etiquetas son un patrón distinto tipo `ENEMDP`/`FEBMDP`/... (Mar del Plata). No depender del texto del encabezado, depender de la posición relativa a `STATUS`.
- `gviz` con `sheet=<nombre>` cae **silenciosamente** a otra solapa si el nombre no matchea exacto (sin error) — por eso el parser exige encontrar la columna `STATUS` antes de confiar en cualquier solapa.
- Mar del Plata tiene calendario de bimestres corrido +1 mes (`Ene-Feb:B1` en vez de `Dic-Ene:B1`) — manejado con `offset:1` en `SEDES_INDIVIDUALES_`.
- La planilla "Resumen Sedes 2026" (y sus solapas "Liquidación" por sede) **sí tiene fórmulas reales** conectadas (`COUNTIF(Cursada!$AN$4:$AN$496,"RA")` + aportes de `Liq Nuevos Planes`), pero cada modalidad tiene su propia celda "Bim. Actual" que nadie rota a tiempo — confirmado que no es un atajo utilizable, por eso se abandonó esa vía.

## Pendiente para retomar mañana (martes, después de hablar con Daniel)

### 1. [PRIMERA TAREA] Comparación Jun-Jul: criterio viejo (STATUS=RA) vs criterio nuevo (pagó el bimestre)
**Pedido por Guga, todavía sin reportar.** Hay que explicar la caída de 979 (¿o 936? — confirmar cuál era el número base de referencia) a 573, y ahora a 543 con el criterio de pago. Correr ambos criterios sobre el mismo bimestre (JUN-JUL, ya cerrado) en las mismas sedes y mostrar la comparación lado a lado para que Daniel entienda de dónde sale cada diferencia — cuánto es rotación real de bimestre sin actualizar, cuánto es el cambio de criterio (RA→pagó), cuánto es sedes que directamente no cargaron nada.

### 2. Lanús y CAD Morón en 0 — sin confirmar
Ambos dieron 0 alumnos activos con el criterio de pago (mismo patrón que Mar del Plata, que sí es un caso confirmado de "no cargaron este bimestre todavía"). Estructuralmente el parser leyó bien (no hay error de solapa/columna) — falta que alguien con acceso a esas dos sedes confirme si es real o si falta cargar. Lanús además tiene el problema adicional de las 2 planillas en conflicto (`Subsede_Lanus_26` vieja, usada hoy porque matchea el histórico, vs `Subsede_Lanus_26_Nueva`, mucho más baja) — sin resolver cuál es la vigente.

### 3. Cómo se suma Olivos (sede central) al total
Olivos hoy queda completamente afuera del cálculo de "Alumnos activos" — tiene su propia fuente (`SEDE_CENTRAL_SHEET_ID`, formulario de inscripciones, ver comentario en el código junto a esa constante) que nunca se cruzó con el nuevo criterio de pago. Definir si Olivos debe sumarse al total de 543 y con qué criterio (no tiene la misma estructura de 4 solapas que el resto).

### 4. Generalizar a las sedes/CADs de las 19 totales que todavía no se probaron a mano
Ya validadas con datos reales: Escobar, Virtual, Mar del Plata, San Miguel, Barrio Norte, San Isidro (6 sedes con verificación manual profunda). El resto de las 14 individuales (Concepción, Lanús, Pilar, Rosario, Paraná, Santa Fe, Potenciar, CAD Morón) ya están *en el código* pero sin la misma verificación manual línea por línea — conviene revisar al menos 2-3 más antes de dar el número por cerrado. Las 4 sedes sin planilla propia (`aysa`, `Terminal Zarate`, `Buco`, `CADs` genérico) siguen sumando un valor fijo de Resumen Sedes porque no tienen fuente individual en la carpeta de Drive — confirmar con Guga si eso es correcto o si existen en algún otro lado.

## Regla del proyecto (recordatorio)

Todo cambio va primero a una rama de preview (Cloudflare) — la URL se comparte y se espera aprobación explícita antes de mergear a `main`. No mergear nada de `sedes-fuente-individual` todavía.
