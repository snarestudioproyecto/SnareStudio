# Snare Studio V4.1 · Windows x64

Edición para ejecutar Snare Studio en Windows de 64 bits. El programa fue compilado con **MATLAB Compiler R2020b** (9.9.0.1467703). Para usarlo necesitás **MATLAB Runtime R2020b (9.9) para Windows de 64 bits**. El Runtime es gratuito y funciona sin una instalación de MATLAB ni una licencia de Audio Toolbox.

## Cómo abrirlo

1. Descargá [MATLAB Runtime desde MathWorks](https://www.mathworks.com/products/compiler/matlab-runtime.html). En la tabla elegí **R2020b (9.9)** y **Windows 64-bit**. Usá la actualización más reciente que MathWorks ofrezca para esa edición.
2. Instalá el Runtime. Si ya lo tenés instalado, podés pasar al siguiente paso.
3. Extraé `SnareStudio-Windows-x64` en una carpeta fija y abrí `SnareStudio.exe`. La descarga del programa se distribuye como carpeta comprimida y el Runtime se obtiene por separado.
4. Si querés un acceso directo, podés crearlo desde el Explorador de Windows o ejecutar `CREAR_ACCESO_ESCRITORIO.vbs` dentro de la carpeta del programa. Si movés la carpeta, recreá el acceso directo.

## Primer uso

- **Demo.** Seleccioná la fuente de demostración y pulsá **Iniciar**. Empezá con `MAIN` bajo.
- **WAV.** Cargá un archivo WAV y seleccioná esa fuente.
- **Tiempo real.** Conectá tu interfaz o micrófono, seleccioná la entrada y la salida en **AUDIO I/O** y luego iniciá el procesamiento.
- **Señales.** Usá la vista de etapas para comparar las señales. Detené la sesión antes de cambiar los dispositivos.

## Si no inicia

Si el programa pide MATLAB Runtime o indica que falta `mclmcrrt9_9.dll`, comprobá que esté instalado **R2020b (9.9), Windows x64**. Si abre y no se oye, verificá la salida seleccionada, `MAIN` y `MUTE` y probá primero el modo **Demo**.

El ejecutable existente V4.1 y el código con `PRINCIPAL.m` proceden de compilaciones o estructuras distintas. En la distribución Windows, el archivo `SHA256SUMS.txt` permite comprobar la integridad del ejecutable recibido.
