# Actualizar Snare Studio

1. Creá una rama desde `main`, cambiá los archivos en `SnareStudio-Source/` y abrí un pull request. Los cambios de documentación también se pueden hacer desde GitHub.
2. Probá el código en MATLAB R2020b. Revisá que `PRINCIPAL` abra la interfaz y comprobá Demo, WAV y el audio en tiempo real.
3. Para actualizar la descarga de Windows, compilá el código de esa versión con MATLAB Compiler R2020b. Incluí los archivos de la interfaz y revisá que el paquete no incluya preferencias con rutas locales. Probá el ejecutable en Windows x64 con MATLAB Runtime R2020b (9.9).
4. Desde la raíz de la carpeta de Windows, generá `SHA256SUMS.txt` y comprimí la carpeta con el ejecutable y su README. Usá un nombre que incluya la versión, por ejemplo `SnareStudio-Windows-x64-v4.1.1.zip`.

   ```powershell
   $sha = (Get-FileHash -Algorithm SHA256 -LiteralPath '.\SnareStudio.exe').Hash.ToLowerInvariant()
   "$sha  SnareStudio.exe" | Set-Content -Encoding ascii -LiteralPath '.\SHA256SUMS.txt'
   ```

5. En **Releases → Draft a new release**, creá una etiqueta nueva sobre el commit que se va a distribuir, por ejemplo `v4.1.1`. Indicá los cambios y requisitos, adjuntá el ZIP, revisá el borrador y publicalo. Conservá las releases anteriores para que se puedan seguir descargando.

La primera entrega conserva el ejecutable V4.1 recibido. Su implementación empaquetada difiere del código fuente incluido en el repositorio. En futuras compilaciones, etiquetá el mismo commit que utilizaste para crear el ejecutable.
