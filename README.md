# Antena QFH para recepción de METEOR

Construcción y pruebas de una antena QFH para la banda de 137 MHz, con alambre de cobre esmaltado de 2,05 mm y soportes de PVC. La antena está construida y el equipo está preparado; todavía no se han obtenido imágenes de METEOR. Queda pendiente completar una recepción con buena señal y documentar la decodificación.

## Simulaciones

Proyectos de CST Studio Suite 2025 en `pruebas_simulacion/`. Cada prueba incluye su curva S11 en CSV. Las carpetas del mismo nombre contienen datos necesarios de CST y deben conservarse junto al archivo `.cst`.

| Archivo | Descripción | Mínimo de S11 |
|---|---|---|
| [prueba1.cst](pruebas_simulacion/prueba1.cst) | Diseño manual original. | −9,39 dB a 126,972 MHz |
| [prueba2.cst](pruebas_simulacion/prueba2.cst) | Primer ajuste con hilos de cobre de 2,00 mm. | −28,04 dB a 137,925 MHz |
| [prueba3.cst](pruebas_simulacion/prueba3.cst) | Hilos de 2,05 mm con dobleces exteriores. | −21,81 dB a 137,900 MHz |
| [prueba4.cst](pruebas_simulacion/prueba4.cst) | Repetición de la prueba 3 para comprobar el resultado. | −21,81 dB a 137,900 MHz |

Las pruebas 3 y 4 representan cobre en aire con alimentación ideal; no incluyen el esmalte, el PVC ni el coaxial. S11 permite evaluar la adaptación, pero no confirma por sí solo la polarización ni el rendimiento de recepción. Las mediciones físicas se documentarán aparte en [imagenes](imagenes/README.md).

## Recepción y decodificación

Para recibir y decodificar se utilizará [SatDump](https://www.satdump.org/download.htm), que integra captura, demodulación y procesamiento de LRPT. METEOR transmite datos digitales: se procesa la señal I/Q, no una grabación de audio APT. El movimiento del satélite produce un desplazamiento Doppler de varios kHz en esta banda. El demodulador recupera la portadora mediante un lazo de Costas y sigue variaciones de frecuencia dentro de su margen de enganche; la señal debe permanecer dentro del ancho de banda capturado. Hay que seleccionar la frecuencia y el modo LRPT vigentes. Véanse la [documentación oficial](https://github.com/SatDump/SatDump.Docs/blob/master/pipelines.rst) y la [implementación del demodulador](https://github.com/SatDump/SatDump/blob/master/src-core/pipeline/modules/demod/module_psk_demod.cpp).

Los NOAA-15, NOAA-18 y NOAA-19 de la antigua constelación POES fueron retirados en 2025, según el [estado oficial de NOAA](https://ospo.noaa.gov/operations/poes/status.html). El proyecto se orienta a METEOR. Los pases se consultan en N2YO para [METEOR M2-3, NORAD 57166](https://www.n2yo.com/passes/?s=57166&a=1) y [METEOR M2-4, NORAD 59051](https://www.n2yo.com/passes/?s=59051&a=1), configurando la ubicación de recepción. La elevación y las condiciones locales determinan qué pases resultan aprovechables.

## Referencias de construcción

- Medidas iniciales: [calculadora QFH de J. Coppens, copia archivada](https://web.archive.org/web/20260210194949/jcoppens.com/ant/qfh/calc.en.php).
- Soportes para impresión 3D: [QFH Antenna 137.5 MHz en Printables](https://www.printables.com/model/973557-qfh-antenna-1375-mhz/files). Se modificaron las dimensiones para este montaje; su prueba está pendiente.
