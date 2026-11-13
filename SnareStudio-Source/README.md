# Snare Studio · Código fuente para MATLAB

Esta edición contiene los archivos editables de Snare Studio, incluida la interfaz en HTML, CSS y JavaScript. El proyecto se desarrolló con **MATLAB R2020b**.

## Requisitos

- MATLAB de escritorio **R2020b (9.9)** con licencia.
- **Audio Toolbox** para utilizar las funciones de audio con dispositivos. En R2020b, Audio Toolbox requiere **DSP System Toolbox** y **Signal Processing Toolbox**. Podés comprobar los productos instalados con `ver` y localizar los componentes de audio con `which audioDeviceReader`, `which audioDeviceWriter` y `which audioPlayerRecorder`.
- Para la entrada en tiempo real, un dispositivo de audio con sus controladores instalados. En Windows, la configuración inicial selecciona DirectSound.

[Requisitos oficiales de productos de MathWorks para R2020b](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/2020b-product-availability.pdf)

## Inicio

1. Extraé la carpeta completa conservando su estructura.
2. En MATLAB, abrí [`PRINCIPAL.m`](PRINCIPAL.m) y pulsá **Run**. También podés seleccionar `SnareStudio-Source` como carpeta actual y ejecutar `PRINCIPAL` en la ventana de comandos.
3. Para una comprobación rápida, seleccioná **Demo** y pulsá **Iniciar**. Probá luego **WAV** con un archivo local. Usá **Tiempo real** cuando tengás configurados los dispositivos de entrada y salida.

`PRINCIPAL.m` registra las rutas de las clases y abre la interfaz en MATLAB. Conservá juntas las cuatro subcarpetas para que el controlador encuentre sus dependencias.

## Estructura

| Archivo o carpeta | Contenido |
| --- | --- |
| `PRINCIPAL.m` | Punto de entrada y despacho de acciones de la interfaz |
| `01_aplicacion/` | Controlador de la aplicación, presets, visualización y captura |
| `02_procesamiento/` | Filtros, ecualización y análisis de resonancias |
| `03_audio/` | Configuración, dispositivos y reproducción de audio |
| `04_interfaz/` | Interfaz HTML, CSS y JavaScript |

Para generar una distribución nueva de Windows se necesita **MATLAB Compiler**. La compilación existente de Windows V4.1 usa `SnareStudioMain.m` y otros módulos distintos a los de esta carpeta. Si compilás el código actual, comprobá primero el arranque, el modo Demo, la carga de WAV y el funcionamiento con un dispositivo de audio.
