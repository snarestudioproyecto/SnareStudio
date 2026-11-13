%% PRINCIPAL — INICIO Y COORDINACIÓN DE SNARE STUDIO
% PRINCIPAL.m es el único punto de entrada: abre este archivo y pulsa Ejecutar.
% Para explicarlo por secciones, ejecuta las secciones 1 a 5 en orden y una sola vez.
% La sección 6 define la función de eventos: se activa desde los botones, no como paso manual.
% Este es el archivo que conviene presentar primero al explicar el proyecto.
% Las secciones 1 a 5 se ejecutan una sola vez al abrir el programa.
% La sección 6 recibe después las acciones del usuario y llama a los otros .m.
% Organización: 01_aplicacion coordina; 02_procesamiento calcula; 03_audio gestiona dispositivos.
% 04_interfaz conserva la página, los estilos y JavaScript sin modificaciones.
% Cada clase reúne en su propio .m las propiedades y todos sus métodos.
% No hay otros scripts de arranque ni scripts de prueba dentro de esta entrega.

%% 1. LOCALIZAR EL PROYECTO Y PREPARAR LAS RUTAS
% Obtiene la carpeta de PRINCIPAL.m para encontrar los archivos que lo acompañan.
carpetaProyecto = fileparts(mfilename('fullpath'));
% Registra 01_aplicacion para encontrar la clase que coordina la ventana y el audio.
addpath(fullfile(carpetaProyecto, '01_aplicacion'), '-begin');
% Registra 02_procesamiento para encontrar los filtros y el análisis de resonancias.
addpath(fullfile(carpetaProyecto, '02_procesamiento'), '-begin');
% Registra 03_audio para encontrar la configuración y las clases de dispositivos.
addpath(fullfile(carpetaProyecto, '03_audio'), '-begin');
% 04_interfaz no se añade a la búsqueda de funciones: el controlador abre su HTML por ruta.
% Estas tres carpetas contienen clases completas; no se necesitan carpetas con prefijo @.

%% 2. OBTENER LOS AJUSTES INICIALES DEL PROCESAMIENTO
% Llama a parametrosIniciales, en ProcesadorAudio.m, y recibe los ajustes de filtros y niveles.
% LLAMADA a ProcesadorAudio.m → parametrosIniciales: define los ajustes con los que comienza una sesión.
parametros = ProcesadorAudio.parametrosIniciales();
% Instancia la configuración como una estructura con las mismas opciones iniciales de audio.
% Se conserva este formato porque los métodos y los mensajes de la interfaz utilizan sus campos.
configuracion = struct('mode', 'Demo', 'driver', 'DirectSound', ...
                      'input', 'Default', 'output', 'Default', 'fs', 48000, 'block', 256, ... % Selecciona dispositivos automáticos, 48000 muestras por segundo y bloques de 256 muestras.
                      'inCh', 0, 'outCh', 1, 'stereo', true, 'loop', false); % Usa selección automática de canal de entrada, salida desde el canal 1 y duplicación mono; no repite WAV.

%% 3. PREPARAR EL OBJETO QUE COORDINA EL AUDIO
% Llama al constructor de 01_aplicacion/ControladorEstudio.m; app conserva los datos y recursos de la sesión.
% LLAMADA a ControladorEstudio.m → ControladorEstudio: crea el objeto que conserva los datos de este módulo.
app = ControladorEstudio(parametros, configuracion);

%% 4. CREAR LA VENTANA Y CONECTAR SUS BOTONES CON ESTE ARCHIVO
% Llama a crearVentana, en ControladorEstudio.m, para construir la ventana de MATLAB.
% LLAMADA a ControladorEstudio.m → crearVentana: realiza el paso de inicio indicado.
app.crearVentana();
% Llama a conectarInterfaz, en ControladorEstudio.m, y entrega el enlace a la función de la sección 6.
% LLAMADA a ControladorEstudio.m → conectarInterfaz: realiza el paso de inicio indicado.
app.conectarInterfaz(@(src, ~)atenderComandoPrincipal(app, src.Data));
% El enlace anterior se ejecutará cuando la interfaz envíe una acción; todavía no inicia el audio.

%% 5. MOSTRAR LA INTERFAZ Y ESPERAR LAS ACCIONES DEL USUARIO
% Llama a mostrarInterfaz, en ControladorEstudio.m, que abre estudio.html y carga estilos.css e interfaz.js.
% LLAMADA a ControladorEstudio.m → mostrarInterfaz: realiza el paso de inicio indicado.
app.mostrarInterfaz();
% A partir de aquí, los botones activan la sección 6; el programa no procesa audio hasta pulsar Iniciar.

%% 6. DECIDIR QUÉ FUNCIÓN LLAMAR SEGÚN LA ACCIÓN DEL USUARIO
% interfaz.js envía el nombre de la acción; el componente HTML entrega esos datos a esta función.
% o es el mismo objeto app creado en la sección 3; d contiene el comando y sus ajustes.
% Ejemplo: Iniciar llama a ControladorEstudio.iniciarProcesamiento; este crea ProcesadorAudio,
% SelectorEntrada y AnalizadorResonancias, y llama a sus métodos para cada bloque de audio.
% La cadena completa y sus llamadas reales se pueden seguir dentro de iniciarProcesamiento.
function atenderComandoPrincipal(o, d)
    % Los mensajes de MATLAB llevan kind, los del UI llevan action/id.
    % Ejecuta el bloque siguiente únicamente si se cumple «~isstruct(d) || ~isfield(d, 'action') || ~isfield(d, 'id')».
    if ~isstruct(d) || ~isfield(d, 'action') || ~isfield(d, 'id')
        % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
        return
    % Termina el bloque de instrucciones anterior.
    end
    % Ejecuta el bloque siguiente únicamente si se cumple «d.id <= o.LastCommand».
    if d.id <= o.LastCommand
        % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
        return
    % Termina el bloque de instrucciones anterior.
    end
    % Actualiza el identificador del último comando atendido con el resultado de la expresión indicada.
    o.LastCommand = d.id;
    % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
    try
        % Ejecuta el bloque siguiente únicamente si se cumple «isfield(d, 'stageView')».
        if isfield(d, 'stageView')
            % Actualiza la visibilidad del panel de etapas con el resultado de la expresión indicada.
            o.StageView = logical(d.stageView);
        % Termina el bloque de instrucciones anterior.
        end
        % Ejecuta el bloque siguiente únicamente si se cumple «isfield(d, 'p')».
        if isfield(d, 'p')
            % Comprueba los ajustes de los filtros y prepara su aplicación al audio.
            % LLAMADA a ControladorEstudio.m → establecerParametros: comprueba los ajustes de los filtros y prepara su aplicación al audio.
            o.establecerParametros(d.p);
        % Termina el bloque de instrucciones anterior.
        end
        % Ejecuta el bloque siguiente únicamente si se cumple «isfield(d, 'config') && ~o.Running».
        if isfield(d, 'config') && ~o.Running
            % Valida la fuente, el dispositivo y los tamaños usados para recibir audio.
            % LLAMADA a ControladorEstudio.m → establecerConfiguracion: valida la fuente, el dispositivo y los tamaños usados para recibir audio.
            o.establecerConfiguracion(d.config);
        % Termina el bloque de instrucciones anterior.
        end
        % Selecciona la operación correspondiente al valor de «char(d.action)».
        switch char(d.action)
            % La interfaz terminó de cargar: consulta los dispositivos de audio.
            case 'ready'
                % Consulta las entradas y salidas disponibles y conserva la selección válida.
                % LLAMADA a ControladorEstudio.m → consultarDispositivos: consulta las entradas y salidas disponibles y conserva la selección válida.
                o.consultarDispositivos();
            % El usuario cambia la vista: actualiza las gráficas.
            case 'view'
                % Reúne mediciones, espectros y estados para actualizar los controles visibles.
                % LLAMADA a ControladorEstudio.m → actualizarPantalla: reúne mediciones, espectros y estados para actualizar los controles visibles.
                o.actualizarPantalla();
            % El usuario modifica un filtro o nivel: recalcula la curva de respuesta.
            case 'params'
                % Calcula la respuesta de los filtros para representarla en la pantalla.
                % LLAMADA a ControladorEstudio.m → actualizarCurva: calcula la respuesta de los filtros para representarla en la pantalla.
                o.actualizarCurva();
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('curve', struct('curve', o.LastCurve, 'freq', o.ViewFreq));
            % El usuario actualiza o cambia dispositivos: vuelve a consultar la lista.
            case 'devices'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Consulta las entradas y salidas disponibles y conserva la selección válida.
                    % LLAMADA a ControladorEstudio.m → consultarDispositivos: consulta las entradas y salidas disponibles y conserva la selección válida.
                    o.consultarDispositivos();
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario pulsa Cargar WAV: abre el archivo de audio.
            case 'load'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Abre un archivo WAV, prepara su señal y solicita el análisis de resonancias.
                    % LLAMADA a ControladorEstudio.m → cargarArchivoWav: abre un archivo wav, prepara su señal y solicita el análisis de resonancias.
                    o.cargarArchivoWav();
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario pulsa Iniciar: comienza la lectura, el procesamiento y la salida del audio.
            case 'start'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % El controlador llama después a ProcesadorAudio.m para filtrar, a SelectorEntrada.m para elegir canal y a AnalizadorResonancias.m para analizar.
                    % LLAMADA a ControladorEstudio.m → iniciarProcesamiento: coordina la captura, el filtrado, la reproducción y las gráficas durante una toma.
                    o.iniciarProcesamiento();
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario pulsa Detener: solicita salir del bucle y detiene la escucha.
            case 'stop'
                % La siguiente vuelta del bucle de iniciarProcesamiento detecta false y finaliza la toma.
                o.Running = false;
                % Detiene los recursos usados para escuchar una grabación.
                % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
                o.detenerEscucha();
            % El usuario solicita detectar resonancias: analiza la señal disponible.
            case 'detect'
                % Solicita sugerencias de resonancias a partir del archivo o de la toma actual.
                % LLAMADA a ControladorEstudio.m → iniciarDeteccion: solicita sugerencias de resonancias a partir del archivo o de la toma actual.
                o.iniciarDeteccion();
            % El usuario solicita exportar: guarda la grabación en WAV.
            case 'export'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Guarda un WAV con el original a la izquierda y el procesado a la derecha.
                    % LLAMADA a ControladorEstudio.m → exportarGrabacion: guarda un wav con el original a la izquierda y el procesado a la derecha.
                    o.exportarGrabacion();
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario pide escuchar el original: selecciona la columna 1 de la captura.
            case 'listenIn'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Selecciona la versión original o procesada de la grabación para reproducirla.
                    % LLAMADA a ControladorEstudio.m → escucharToma: selecciona la versión original o procesada de la grabación para reproducirla.
                    o.escucharToma(1);
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario pide escuchar el procesado: selecciona la columna 2 de la captura.
            case 'listenOut'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Selecciona la versión original o procesada de la grabación para reproducirla.
                    % LLAMADA a ControladorEstudio.m → escucharToma: selecciona la versión original o procesada de la grabación para reproducirla.
                    o.escucharToma(2);
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario detiene la escucha A/B.
            case 'stopListen'
                % Detiene los recursos usados para escuchar una grabación.
                % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
                o.detenerEscucha();
            % El usuario guarda un ajuste de filtros y niveles.
            case 'savePreset'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Guarda los parámetros y las bandas activas en un archivo JSON.
                    % LLAMADA a ControladorEstudio.m → guardarAjuste: guarda los parámetros y las bandas activas en un archivo json.
                    o.guardarAjuste(d);
                % Termina el bloque de instrucciones anterior.
                end
            % El usuario recupera un ajuste guardado.
            case 'loadPreset'
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running».
                if ~o.Running
                    % Lee un ajuste guardado, verifica su compatibilidad y recupera sus parámetros.
                    % LLAMADA a ControladorEstudio.m → cargarAjuste: lee un ajuste guardado, verifica su compatibilidad y recupera sus parámetros.
                    o.cargarAjuste();
                % Termina el bloque de instrucciones anterior.
                end
        % Termina el bloque de instrucciones anterior.
        end
    % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
    catch ME
        % Actualiza el mensaje de estado con el resultado de la expresión indicada.
        o.Message = ME.message;
        % Comunica resultados y avisos desde MATLAB hacia la interfaz.
        % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
        o.enviarMensaje('error', struct('message', ME.message));
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
