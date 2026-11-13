% CONTROLADORESTUDIO: Crea la ventana y conecta sus eventos con los módulos de audio y procesamiento.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «ControladorEstudio» y los datos que conserva durante la sesión.
% Heredar de handle permite compartir una referencia al mismo objeto entre funciones.
% Así, los métodos trabajan sobre el mismo estado y se evitan copias innecesarias del
% objeto y de sus buffers de audio al modificarlo desde distintas partes del programa.
% Esto reduce el uso innecesario de RAM; no elimina todas las asignaciones de memoria.
classdef ControladorEstudio < handle
    % UI HTML local dentro de MATLAB. El audio siempre se procesa en MATLAB.
    % Agrupa los datos que pertenecen al módulo y que se conservan entre llamadas.
    properties
        % Conserva la ventana principal para las operaciones de este módulo.
        Figure
        % Conserva el componente que muestra la interfaz para las operaciones de este módulo.
        HTML
        % Conserva los parámetros de procesamiento para las operaciones de este módulo.
        P
        % Inicializa el motor de procesamiento de audio como vacío hasta que se disponga de datos.
        Engine = []
        % Conserva la configuración de entrada y salida para las operaciones de este módulo.
        Config
        % Desactiva el indicador de procesamiento activo.
        Processing = false
        % Desactiva el indicador que mantiene la ejecución.
        Running = false
        % Desactiva la solicitud de cierre.
        Closing = false
        % Desactiva la existencia de ajustes pendientes.
        Pending = false
        % Establece el identificador del último comando atendido en 0.
        LastCommand = 0
        % Inicializa el lector del dispositivo de entrada como vacío hasta que se disponga de datos.
        Reader = []
        % Inicializa el reproductor de Audio Toolbox como vacío hasta que se disponga de datos.
        Writer = []
        % Inicializa la salida continua alternativa como vacío hasta que se disponga de datos.
        BaseWriter = []
        % Inicializa el dispositivo compartido de captura y reproducción como vacío hasta que se disponga de datos.
        Duplex = []
        % Inicializa el reproductor de escucha como vacío hasta que se disponga de datos.
        Player = []
        % Actualiza el último mensaje de error con el resultado de la expresión indicada.
        LastError = ''
        % Establece la frecuencia de muestreo en 48000.
        FS = 48000
        % Establece el tamaño de bloque o ventana en 256.
        N = 256
        % Inicializa las muestras del archivo cargado como vacío hasta que se disponga de datos.
        FileAudio = []
        % Establece la frecuencia de muestreo del archivo en 48000.
        FileFS = 48000
        % Actualiza el nombre del archivo cargado con el resultado de la expresión indicada.
        FileName = 'Ningun WAV cargado'
        % Actualiza las muestras recientes para las gráficas mediante una operación que reserva memoria inicializada en cero.
        % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
        % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
        Scope = zeros(8192, 2)
        % Actualiza las muestras recientes de las tres etapas mediante una operación que reserva memoria inicializada en cero.
        % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
        % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
        StageScope = zeros(8192, 3)
        % Conserva las muestras de entrada y salida de la ventana más representativa de la toma en vivo.
        VentanaConservada = []
        % Conserva las tres etapas del mismo instante para mantener una comparación coherente.
        EtapasConservadas = []
        % Guarda la energía de la ventana elegida; el silencio posterior no puede sustituirla.
        EnergiaConservada = 0
        % Da mayor importancia al centro de las 2048 muestras, igual que la ventana de la gráfica FFT.
        PesosGrafica = (.5 - .5 * cos(2 * pi * (0:2047)' / 2048)).^2
        % Inicializa la memoria circular de las etapas como vacío hasta que se disponga de datos.
        StageCapture = []
        % Desactiva la visibilidad del panel de etapas.
        StageView = false
        % Inicializa la memoria circular de entrada y salida como vacío hasta que se disponga de datos.
        Capture = []
        % Establece la posición de escritura en la captura en 1.
        CapturePos = 1
        % Establece el número de muestras disponibles en la captura en 0.
        CaptureCount = 0
        % Establece el total de muestras capturadas en 0.
        TotalCaptured = 0
        % Inicializa el reloj de actualización de pantalla como vacío hasta que se disponga de datos.
        DisplayClock = []
        % Establece la frecuencia de muestreo de la captura en 48000.
        CaptureFS = 48000
        % Establece las muestras perdidas en la entrada en 0.
        TotalOver = 0
        % Establece las muestras perdidas en la salida en 0.
        TotalUnder = 0
        % Establece la cantidad acumulada de muestras que alcanzaron el tope en 0.
        TotalClip = 0
        % Actualiza las mediciones del bloque mediante una operación que agrupa campos relacionados en una estructura.
        Stats = struct('inputPeak', -120, 'outputPeak', -120, 'compression', 0, 'clipped', 0)
        % Actualiza el mensaje de estado con el resultado de la expresión indicada.
        Message = 'Listo. Carga un WAV o usa Demo y pulsa Iniciar.'
        % Inicializa la última respuesta de los filtros como vacío hasta que se disponga de datos.
        LastCurve = []
        % Actualiza las frecuencias usadas para dibujar mediante una operación que distribuye frecuencias en escala logarítmica.
        % logspace distribuye las frecuencias en una escala logarítmica: intervalos con
        % la misma proporción ocupan espacios iguales en el eje de la gráfica de audio.
        % Esta malla sirve para representar la respuesta junto al espectro FFT; no calcula
        % la FFT ni cambia la separación lineal de sus frecuencias de análisis.
        ViewFreq = logspace(log10(20), log10(20000), 480)
        % Desactiva la activación del análisis de resonancias.
        Detection = false
        % Inicializa el analizador de resonancias como vacío hasta que se disponga de datos.
        Analyzer = []
        % Inicializa las sugerencias del análisis como vacío hasta que se disponga de datos.
        Suggestions = []
        % Establece el número de revisión de las sugerencias en 0.
        SuggestionVersion = 0
        % Inicializa el selector automático de canal como vacío hasta que se disponga de datos.
        InputSelector = []
        % Establece el canal de entrada seleccionado en 0.
        ActiveInputChannel = 0
        % Desactiva la presencia de señal en la entrada.
        InputHasSignal = false
        % Actualiza el nombre de la ruta de entrada con el resultado de la expresión indicada.
        InputRoute = ''
        % Actualiza el nombre de la ruta de salida con el resultado de la expresión indicada.
        OutputRoute = ''
        % Inicializa los datos de dispositivos enviados a la interfaz como vacío hasta que se disponga de datos.
        DevicePayload = []
        % Establece las muestras acumuladas desde el último análisis en 0.
        DetectionSamples = 0
        % Actualiza la lista de entradas disponibles con el resultado de la expresión indicada.
        InputDevices = {'Default'}
        % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
        OutputDevices = {'Default'}
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo.
    methods

        % Recibe los ajustes del archivo principal y prepara los datos que compartirán las operaciones.
        function o = ControladorEstudio(parametros, configuracion)
            % Recibe de PRINCIPAL.m los ajustes calculados en ProcesadorAudio.m.
            o.P = parametros;
            % Conserva las opciones de audio que PRINCIPAL.m definió para la sesión.
            o.Config = configuracion;
        % Termina la preparación de los datos; PRINCIPAL.m ordena después crear la ventana.
        end

        %% crearVentana: PRINCIPAL.m llama aquí después de preparar los datos.
        % Crea el contenedor de la interfaz con las mismas dimensiones y opciones originales.
        function crearVentana(o)
            % Consulta el tamaño de la pantalla para ajustar la ventana al equipo.
            screen = get(groot, 'ScreenSize');
            % Calcula el ancho de la ventana dentro de los límites originales.
            w = min(1440, max(900, screen(3) - 50));
            % Calcula la altura de la ventana dentro de los límites originales.
            h = min(900, max(640, screen(4) - 100));
            % Crea la ventana y registra el método que atiende su cierre.
            o.Figure = uifigure('Name', 'SNARE STUDIO V4.1 | Ancho, curvas y tiempo real', ...
                              'Position', [max(10, (screen(3) - w) / 2) max(20, (screen(4) - h) / 2) w h], ... % Sitúa la ventana aproximadamente en el centro de la pantalla.
                              'Color', [.035 .05 .06], 'CloseRequestFcn', @(~, ~)o.cerrarAplicacion()); % Al cerrar, llama a cerrarAplicacion en este archivo para liberar los recursos. % LLAMADA a ControladorEstudio.m → cerrarAplicacion: solicita la detención del audio y cierra la ventana cuando es posible.
        % Devuelve el control a PRINCIPAL.m después de crear la ventana.
        end

        %% conectarInterfaz: PRINCIPAL.m entrega la función que recibirá los botones.
        % Crea el componente HTML y conecta sus mensajes con la función del archivo principal.
        function conectarInterfaz(o, alRecibirComando)
            % Crea una distribución de una fila y una columna dentro de la ventana.
            g = uigridlayout(o.Figure, [1 1]);
            % Elimina los márgenes para que la interfaz ocupe el área disponible.
            g.Padding = [0 0 0 0];
            % Cuando HTML envía datos, MATLAB ejecuta el enlace recibido de PRINCIPAL.m.
            o.HTML = uihtml(g, 'DataChangedFcn', alRecibirComando);
        % Termina la conexión; la página se carga en el paso siguiente.
        end

        %% mostrarInterfaz: PRINCIPAL.m llama aquí una vez conectados los eventos.
        % Carga la página que contiene los controles y pone en marcha su inicialización.
        function mostrarInterfaz(o)
            % Busca estudio.html en 04_interfaz, desde la carpeta raíz, y lo presenta en la ventana.
            o.HTML.HTMLSource = fullfile(fileparts(fileparts(mfilename('fullpath'))), '04_interfaz', 'estudio.html');
        % Finaliza el inicio visual; las siguientes acciones dependen del usuario.
        end



        %% establecerConfiguracion: Valida la fuente, el dispositivo y los tamaños usados para recibir audio
        function establecerConfiguracion(o, c)
            % Adapta los nombres de modos antiguos a la configuración actual de Tiempo real.
            % LLAMADA a ConfiguracionAudio.m → normalizarConfiguracion: convierte los nombres antiguos de fuentes al modo unificado tiempo real.
            c = ConfiguracionAudio.normalizarConfiguracion(c);
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(char(c.mode), {'Demo', 'WAV', 'Tiempo real'}), 'Fuente no valida.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(c.fs, [44100 48000]), 'Fs debe ser 44100 o 48000 Hz.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(c.block, [64 128 256 512 1024]), 'Bloque no valido.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(char(c.driver), {'ASIO', 'WASAPI', 'DirectSound'}), 'Controlador no valido.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(isscalar(c.inCh) && c.inCh >= 0 && c.inCh <= 64 && c.inCh == fix(c.inCh), 'Canal IN no valido.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(c.outCh >= 1 && c.outCh <= 64 && c.outCh == fix(c.outCh), 'Canal OUT no valido.');
            % Ejecuta el bloque siguiente únicamente si se cumple «isfield(c, 'monitor')».
            if isfield(c, 'monitor')
                % Adapta los nombres de modos antiguos a la configuración actual de Tiempo real.
                c = rmfield(c, 'monitor');
            % Completa la operación de «establecerConfiguracion» con los argumentos o valores indicados.
            end % compatibilidad con mensajes antiguos
            % Actualiza la configuración de entrada y salida con el resultado de la expresión indicada.
            o.Config = c;
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.FS = c.fs;
            % Actualiza el tamaño de bloque o ventana con el resultado de la expresión indicada.
            o.N = c.block;
        % Termina el bloque de instrucciones anterior.
        end


        %% establecerParametros: Comprueba los ajustes de los filtros y prepara su aplicación al audio
        function establecerParametros(o, p)
            % Ejecuta el bloque siguiente únicamente si se cumple «~isfield(p, 'notchTypes')».
            if ~isfield(p, 'notchTypes')
                % Selecciona notch en las tres bandas; el valor uno seleccionaría campana.
                p.notchTypes = [0 0 0];
            % Termina el bloque de instrucciones anterior.
            end
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(numel(p.notchTypes) == 3 && all(ismember(p.notchTypes(:), [0 1])), 'Forma no valida.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(isequal(size(p.eq), [4 3]) && isequal(size(p.notches), [3 4]), 'Preset incompatible.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(isfinite(p.eq(:))) && all(isfinite(p.notches(:))), 'Parametros no finitos.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(p.eq(:, 1) >= 30 & p.eq(:, 1) <= 18000), 'Frecuencia EQ fuera de rango.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(abs(p.eq(:, 2)) <= 18) && all(p.eq(:, 3) > 0), 'Ganancia/Q EQ fuera de rango.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(p.notches(:, 2) >= 40 & p.notches(:, 2) <= 18000), 'Frecuencia notch fuera de rango.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(p.notches(:, 3) > 0), 'Q notch fuera de rango.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(p.notches(:, 4) >= 0 & p.notches(:, 4) <= 40), 'Profundidad fuera de rango.');
            % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
            names = {'inputDB', 'outputDB', 'hpHz', 'gateThreshold', 'gateRange', 'gateAttack', ...
                   'gateRelease', 'gateHold', 'compThreshold', 'ratio', 'compAttack', 'compRelease', 'passes'}; % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Actualiza el valor de «lo» con el resultado de la expresión indicada.
            lo = [-24 -60 20 -80 0 .1 10 0 -60 1 .1 10 1];
            % Actualiza el valor de «hi» con el resultado de la expresión indicada.
            hi = [24 12 300 -5 80 50 1500 1000 0 20 100 1500 3];
            % Recorre los valores indicados en «k = 1:numel(names)» para procesarlos en orden.
            for k = 1:numel(names)
                % Actualiza el valor de «v» con el resultado de la expresión indicada.
                v = p.(names{k});
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(isscalar(v) && isfinite(v) && v >= lo(k) && v <= hi(k), 'Parametro fuera de rango.');
            % Termina el bloque de instrucciones anterior.
            end
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(p.passes == fix(p.passes), 'Pasadas deben ser enteras.');
            % Actualiza el valor de «flags» con el resultado de la expresión indicada.
            flags = {'mute', 'bypass', 'hpOn', 'gateOn', 'compOn'};
            % Recorre los valores indicados en «k = 1:numel(flags)» para procesarlos en orden.
            for k = 1:numel(flags)
                % Actualiza el valor de «v» con el resultado de la expresión indicada.
                v = p.(flags{k});
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(isscalar(v) && ismember(v, [0 1]), 'Activacion no valida.');
            % Termina el bloque de instrucciones anterior.
            end
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(all(ismember(p.notches(:, 1), [0 1])), 'Activacion notch no valida.');
            % Construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            % LLAMADA a ProcesadorAudio.m → disenarCadena: construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            ProcesadorAudio.disenarCadena(o.FS, p); % Rechaza extremos no representables/inestables antes de cambiar audio.
            % Actualiza los parámetros de procesamiento con el resultado de la expresión indicada.
            o.P = p;
            % Activa la existencia de ajustes pendientes.
            o.Pending = true;
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Engine)».
            if ~isempty(o.Engine)
                % Actualiza los parámetros de procesamiento con el resultado de la expresión indicada.
                o.Engine.P = p;
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% enviarMensaje: Comunica resultados y avisos desde MATLAB hacia la interfaz
        function enviarMensaje(o, kind, s)
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(o.HTML) || ~isvalid(o.HTML)».
            if isempty(o.HTML) || ~isvalid(o.HTML)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «s.kind» con el resultado de la expresión indicada.
            s.kind = kind;
            % Actualiza el valor de «o.HTML.Data» con el resultado de la expresión indicada.
            o.HTML.Data = s;
        % Termina el bloque de instrucciones anterior.
        end


        %% consultarDispositivos: Consulta las entradas y salidas disponibles y conserva la selección válida
        function consultarDispositivos(o, notify)
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 2».
            if nargin < 2
                % Activa el valor de «notify».
                notify = true;
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Running».
            if o.Running
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «errors» con el resultado de la expresión indicada.
            errors = {};
            % Actualiza el valor de «defaultIn» con el resultado de la expresión indicada.
            defaultIn = 'no disponible';
            % Actualiza el valor de «defaultOut» con el resultado de la expresión indicada.
            defaultOut = 'no disponible';
            % Entrada y salida se consultan por separado: un micro ausente no
            % debe ocultar altavoces validos. No se captura audio al enumerar.
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Completa la operación de «consultarDispositivos» con los argumentos o valores indicados.
                audiodevreset;
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «ConfiguracionAudio.esDuplex(o.Config)».
            % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
            if ConfiguracionAudio.esDuplex(o.Config)
                % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                try
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
                    assert(UtilidadesAudio.estaDisponible('audioPlayerRecorder'), ...
                           'Tiempo real dúplex requiere Audio Toolbox; usa WAV o Demo para escuchar sin ese toolbox.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                    % Actualiza los parámetros de la banda actual con el resultado de la expresión indicada.
                    r = audioPlayerRecorder;
                    % Actualiza el valor de «cleanup» mediante una operación que garantiza la liberación de recursos al terminar o producirse un error.
                    cleanup = onCleanup(@()release(r)); %#ok<NASGU>
                    % Actualiza los nombres de dispositivos mediante una operación que incluye la selección automática y elimina nombres repetidos.
                    % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
                    names = SelectorEntrada.agregarPredeterminado(getAudioDevices(r));
                    % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                    details = info(r);
                    % Actualiza la lista de entradas disponibles con el resultado de la expresión indicada.
                    o.InputDevices = names;
                    % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
                    o.OutputDevices = names;
                    % Actualiza el valor de «defaultIn» con el resultado de la expresión indicada.
                    defaultIn = details.DeviceName;
                    % Actualiza el valor de «defaultOut» con el resultado de la expresión indicada.
                    defaultOut = defaultIn;
                    % Actualiza el valor de «o.Config.input» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                    % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                    o.Config.input = SelectorEntrada.conservarSeleccion(o.Config.input, names);
                    % Actualiza el valor de «o.Config.output» con el resultado de la expresión indicada.
                    o.Config.output = o.Config.input;
                    % Libera la variable o el protector de recursos indicado al terminar su uso.
                    clear cleanup;
                % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                catch ME
                    % Actualiza el valor de «errors{end + 1}» con el resultado de la expresión indicada.
                    errors{end + 1} = ['Duplex: ' ME.message];
                    % Actualiza la lista de entradas disponibles mediante una operación que incluye la selección automática y elimina nombres repetidos.
                    % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
                    o.InputDevices = SelectorEntrada.agregarPredeterminado({char(o.Config.input)});
                    % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
                    o.OutputDevices = o.InputDevices;
                % Termina el bloque de instrucciones anterior.
                end
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Recorre los valores indicados en «input = [true false]» para procesarlos en orden.
                for input = [true false]
                    % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                    try
                        % Ejecuta el bloque siguiente únicamente si se cumple «input».
                        if input
                            % Actualiza el valor de «type» con el resultado de la expresión indicada.
                            type = 'audioDeviceReader';
                        % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                        else
                            % Actualiza el valor de «type» con el resultado de la expresión indicada.
                            type = 'audioDeviceWriter';
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Ejecuta el bloque siguiente únicamente si se cumple «~UtilidadesAudio.estaDisponible(type)».
                        % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
                        if ~UtilidadesAudio.estaDisponible(type)
                            % Ejecuta el bloque siguiente únicamente si se cumple «input».
                            if input
                                % Actualiza los nombres de dispositivos mediante una operación que obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                % LLAMADA a UtilidadesAudio.m → listarDispositivos: obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                names = UtilidadesAudio.listarDispositivos(true);
                            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                            else
                                % Actualiza los nombres de dispositivos mediante una operación que obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                % LLAMADA a ConexionAudioJava.m → listarDispositivos: obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                names = ConexionAudioJava.listarDispositivos();
                            % Termina el bloque de instrucciones anterior.
                            end
                            % Ejecuta el bloque siguiente únicamente si se cumple «input».
                            if input
                                % Actualiza la lista de entradas disponibles con el resultado de la expresión indicada.
                                o.InputDevices = names;
                                % Actualiza el valor de «defaultIn» con el resultado de la expresión indicada.
                                defaultIn = 'sistema (MATLAB base)';
                                % Actualiza el valor de «o.Config.input» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                o.Config.input = SelectorEntrada.conservarSeleccion(o.Config.input, names);
                            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                            else
                                % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
                                o.OutputDevices = names;
                                % Actualiza el valor de «defaultOut» con el resultado de la expresión indicada.
                                defaultOut = 'sistema (salida continua)';
                                % Actualiza el valor de «o.Config.output» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                o.Config.output = SelectorEntrada.conservarSeleccion(o.Config.output, names);
                            % Termina el bloque de instrucciones anterior.
                            end
                            % Pasa al siguiente elemento del recorrido sin ejecutar el resto de esta vuelta.
                            continue
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Ejecuta el bloque siguiente únicamente si se cumple «input».
                        if input
                            % Actualiza el valor de «device» con el resultado de la expresión indicada.
                            device = audioDeviceReader;
                        % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                        else
                            % Actualiza el valor de «device» con el resultado de la expresión indicada.
                            device = audioDeviceWriter;
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Actualiza el valor de «cleanup» mediante una operación que garantiza la liberación de recursos al terminar o producirse un error.
                        cleanup = onCleanup(@()release(device)); %#ok<NASGU>
                        % Ejecuta el bloque siguiente únicamente si se cumple «ispc».
                        if ispc
                            % Actualiza el valor de «device.Driver» con el resultado de la expresión indicada.
                            device.Driver = char(o.Config.driver);
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Actualiza los nombres de dispositivos mediante una operación que incluye la selección automática y elimina nombres repetidos.
                        % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
                        names = SelectorEntrada.agregarPredeterminado(getAudioDevices(device));
                        % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                        details = info(device);
                        % Ejecuta el bloque siguiente únicamente si se cumple «input».
                        if input
                            % Actualiza la lista de entradas disponibles con el resultado de la expresión indicada.
                            o.InputDevices = names;
                            % Actualiza el valor de «defaultIn» con el resultado de la expresión indicada.
                            defaultIn = details.DeviceName;
                            % Actualiza el valor de «o.Config.input» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                            % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                            o.Config.input = SelectorEntrada.conservarSeleccion(o.Config.input, names);
                        % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                        else
                            % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
                            o.OutputDevices = names;
                            % Actualiza el valor de «defaultOut» con el resultado de la expresión indicada.
                            defaultOut = details.DeviceName;
                            % Actualiza el valor de «o.Config.output» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                            % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                            o.Config.output = SelectorEntrada.conservarSeleccion(o.Config.output, names);
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Libera la variable o el protector de recursos indicado al terminar su uso.
                        clear cleanup;
                    % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                    catch ME
                        % Libera la variable o el protector de recursos indicado al terminar su uso.
                        clear cleanup;
                        % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                        try
                            % Ejecuta el bloque siguiente únicamente si se cumple «input».
                            if input
                                % Actualiza los nombres de dispositivos mediante una operación que obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                % LLAMADA a UtilidadesAudio.m → listarDispositivos: obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                names = UtilidadesAudio.listarDispositivos(true);
                            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                            else
                                % Actualiza los nombres de dispositivos mediante una operación que obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                % LLAMADA a ConexionAudioJava.m → listarDispositivos: obtiene los nombres de los dispositivos disponibles para esta vía de audio.
                                names = ConexionAudioJava.listarDispositivos();
                            % Termina el bloque de instrucciones anterior.
                            end
                            % Ejecuta el bloque siguiente únicamente si se cumple «input».
                            if input
                                % Actualiza la lista de entradas disponibles con el resultado de la expresión indicada.
                                o.InputDevices = names;
                                % Actualiza el valor de «defaultIn» con el resultado de la expresión indicada.
                                defaultIn = 'sistema (MATLAB base)';
                                % Actualiza el valor de «o.Config.input» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                o.Config.input = SelectorEntrada.conservarSeleccion(o.Config.input, names);
                            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                            else
                                % Actualiza la lista de salidas disponibles con el resultado de la expresión indicada.
                                o.OutputDevices = names;
                                % Actualiza el valor de «defaultOut» con el resultado de la expresión indicada.
                                defaultOut = 'sistema (salida continua)';
                                % Actualiza el valor de «o.Config.output» mediante una operación que mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                % LLAMADA a SelectorEntrada.m → conservarSeleccion: mantiene el dispositivo elegido si aún aparece entre los disponibles.
                                o.Config.output = SelectorEntrada.conservarSeleccion(o.Config.output, names);
                            % Termina el bloque de instrucciones anterior.
                            end
                        % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                        catch
                            % Actualiza el valor de «errors{end + 1}» con el resultado de la expresión indicada.
                            errors{end + 1} = ME.message; %#ok<AGROW>
                            % Ejecuta el bloque siguiente únicamente si se cumple «input».
                            if input
                                % Actualiza la lista de entradas disponibles mediante una operación que incluye la selección automática y elimina nombres repetidos.
                                % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
                                o.InputDevices = SelectorEntrada.agregarPredeterminado({char(o.Config.input)});
                            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                            else
                                % Actualiza la lista de salidas disponibles mediante una operación que incluye la selección automática y elimina nombres repetidos.
                                % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
                                o.OutputDevices = SelectorEntrada.agregarPredeterminado({char(o.Config.output)});
                            % Termina el bloque de instrucciones anterior.
                            end
                        % Termina el bloque de instrucciones anterior.
                        end
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «message» con el resultado de la expresión indicada.
            message = sprintf('Automatico: entrada %s; salida %s. Canal IN 0 busca la senal activa.', defaultIn, defaultOut);
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(errors)».
            if ~isempty(errors)
                % Actualiza el valor de «message» con el resultado de la expresión indicada.
                message = [message ' Aviso: ' strjoin(errors, ' | ')];
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los datos de dispositivos enviados a la interfaz mediante una operación que agrupa campos relacionados en una estructura.
            o.DevicePayload = struct('inputs', {o.InputDevices}, 'outputs', {o.OutputDevices}, ...
                                   'input', o.Config.input, 'output', o.Config.output, 'defaultInput', defaultIn, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                   'defaultOutput', defaultOut, 'mode', o.Config.mode, 'driver', o.Config.driver, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                   'requestId', o.LastCommand, 'message', message); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Ejecuta el bloque siguiente únicamente si se cumple «notify».
            if notify
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('devices', o.DevicePayload);
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% cargarArchivoWav: Abre un archivo WAV, prepara su señal y solicita el análisis de resonancias
        function cargarArchivoWav(o)
            % Actualiza el valor de «[f, p]» mediante una operación que solicita al usuario un archivo.
            [f, p] = uigetfile('*.wav', 'Selecciona un audio de redoblante');
            % Ejecuta el bloque siguiente únicamente si se cumple «isequal(f, 0)».
            if isequal(f, 0)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza la información del archivo WAV mediante una operación que consulta las características del archivo.
            meta = audioinfo(fullfile(p, f));
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(meta.Duration <= 600, 'Utiliza una toma de hasta 10 minutos.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(meta.SampleRate, [44100 48000]), 'Usa un WAV a 44.1 o 48 kHz.');
            % Actualiza el valor de «[x, fs]» mediante una operación que lee las muestras del WAV.
            [x, fs] = audioread(fullfile(p, f));
            % Detiene los recursos usados para escuchar una grabación.
            % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
            o.detenerEscucha();
            % Conserva el primer canal, salvo si esta completamente en silencio.
            % Un WAV mono grabado en el canal derecho no debe quedar mudo.
            % Establece el canal seleccionado en 1.
            channel = 1;
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(x) && ~any(x(:, 1))».
            if ~isempty(x) && ~any(x(:, 1))
                % Actualiza el valor de «[~, channel]» mediante una operación que limita el resultado por abajo o toma el mayor valor.
                [~, channel] = max(max(abs(x), [], 1));
            % Termina el bloque de instrucciones anterior.
            end
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(~isempty(x) && all(isfinite(x(:))), 'El WAV no contiene audio valido.');
            % Actualiza las muestras del archivo cargado con el resultado de la expresión indicada.
            o.FileAudio = x(:, channel);
            % Actualiza la frecuencia de muestreo del archivo con el resultado de la expresión indicada.
            o.FileFS = fs;
            % Actualiza el nombre del archivo cargado con el resultado de la expresión indicada.
            o.FileName = f;
            % Establece el número de muestras disponibles en la captura en 0.
            o.CaptureCount = 0;
            % LLAMADA a reiniciarGraficaConservada: descarta la imagen de la toma anterior al cargar otro audio.
            o.reiniciarGraficaConservada();
            % Actualiza las muestras recientes para las gráficas mediante una operación que reserva memoria inicializada en cero.
            % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
            % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
            o.Scope = zeros(8192, 2);
            % Actualiza el valor de «o.Config.mode» con el resultado de la expresión indicada.
            o.Config.mode = 'WAV';
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.Config.fs = fs;
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.FS = fs;
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('file', struct('name', f, 'fs', fs, 'duration', meta.Duration, ...
                                          'message', sprintf('WAV listo (canal %d). Analizando frecuencias automaticamente.', channel))); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Completa la operación de «cargarArchivoWav» con los argumentos o valores indicados.
            drawnow;
            % Entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente.
            % LLAMADA a ControladorEstudio.m → publicarAnalisis: entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente. LLAMADA a AnalizadorResonancias.m → analizarGrabacion: analiza ventanas repartidas por una grabación sin cambiar la señal original.
            o.publicarAnalisis(AnalizadorResonancias.analizarGrabacion(o.FileAudio, o.FileFS), false);
        % Termina el bloque de instrucciones anterior.
        end


        %% iniciarProcesamiento: Coordina la captura, el filtrado, la reproducción y las gráficas durante una toma
        function iniciarProcesamiento(o)
            % Detiene los recursos usados para escuchar una grabación.
            % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
            o.detenerEscucha();
            % Actualiza el último mensaje de error con el resultado de la expresión indicada.
            o.LastError = '';
            % Consulta las entradas y salidas disponibles y conserva la selección válida.
            % LLAMADA a ControladorEstudio.m → consultarDispositivos: consulta las entradas y salidas disponibles y conserva la selección válida.
            o.consultarDispositivos(false);
            % Copia la configuración de la toma para mantener estables sus opciones de audio.
            c = o.Config;
            % Ejecuta el bloque siguiente únicamente si se cumple «ConfiguracionAudio.esDuplex(c)».
            % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
            if ConfiguracionAudio.esDuplex(c)
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
                assert(UtilidadesAudio.estaDisponible('audioPlayerRecorder'), ...
                       'Tiempo real dúplex requiere Audio Toolbox. Para escuchar sin ese toolbox, usa WAV o Demo.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Evalúa una condición alternativa: «ConfiguracionAudio.esTiempoReal(c)».
            % LLAMADA a ConfiguracionAudio.m → esTiempoReal: indica si la fuente seleccionada corresponde a captura en vivo.
            elseif ConfiguracionAudio.esTiempoReal(c)
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
                assert(UtilidadesAudio.estaDisponible('audioDeviceReader'), ...
                       'Tiempo real requiere Audio Toolbox. WAV, Demo y la escucha A/B funcionan sin ese toolbox.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «strcmp(c.mode, 'WAV')».
            if strcmp(c.mode, 'WAV')
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(~isempty(o.FileAudio), 'Carga un WAV primero.');
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(c.fs == o.FileFS, 'La Fs seleccionada debe coincidir con el WAV.');
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.FS = c.fs;
            % Actualiza el tamaño de bloque o ventana con el resultado de la expresión indicada.
            o.N = c.block;
            % Actualiza el motor de procesamiento de audio mediante una operación que crea el motor de filtros y reserva la memoria necesaria entre bloques.
            % LLAMADA a ProcesadorAudio.m → ProcesadorAudio: crea el objeto que conserva los datos de este módulo.
            o.Engine = ProcesadorAudio(o.FS, o.P);
            % Desactiva la existencia de ajustes pendientes.
            o.Pending = false;
            % LLAMADA a reiniciarGraficaConservada: cada toma comienza sin una gráfica heredada de la anterior.
            o.reiniciarGraficaConservada();
            % Actualiza las muestras recientes para las gráficas mediante una operación que reserva memoria inicializada en cero.
            % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
            % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
            o.Scope = zeros(8192, 2);
            % Actualiza la memoria circular de entrada y salida mediante una operación que reserva memoria inicializada en cero.
            % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
            % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
            o.Capture = zeros(60 * o.FS, 2, 'single');
            % Actualiza las muestras recientes de las tres etapas mediante una operación que reserva memoria inicializada en cero.
            % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
            % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
            o.StageScope = zeros(8192, 3);
            % Actualiza la memoria circular de las etapas mediante una operación que reserva memoria inicializada en cero.
            % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
            % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
            o.StageCapture = zeros(60 * o.FS, 3, 'single');
            % Establece el número de muestras disponibles en la captura en 0.
            o.CaptureCount = 0;
            % Establece la posición de escritura en la captura en 1.
            o.CapturePos = 1;
            % Actualiza la frecuencia de muestreo de la captura con el resultado de la expresión indicada.
            o.CaptureFS = o.FS;
            % Establece el total de muestras capturadas en 0.
            o.TotalCaptured = 0;
            % Actualiza el reloj de actualización de pantalla con el resultado de la expresión indicada.
            o.DisplayClock = [];
            % Establece las muestras perdidas en la entrada en 0.
            o.TotalOver = 0;
            % Establece las muestras perdidas en la salida en 0.
            o.TotalUnder = 0;
            % Establece la cantidad acumulada de muestras que alcanzaron el tope en 0.
            o.TotalClip = 0;
            % Activa la activación del análisis de resonancias.
            o.Detection = true;
            % Establece las muestras acumuladas desde el último análisis en 0.
            o.DetectionSamples = 0;
            % Actualiza el analizador de resonancias mediante una operación que prepara la ventana y los acumuladores del análisis de frecuencias.
            % LLAMADA a AnalizadorResonancias.m → AnalizadorResonancias: crea el objeto que conserva los datos de este módulo.
            o.Analyzer = AnalizadorResonancias(o.FS);
            % Actualiza las sugerencias del análisis con el resultado de la expresión indicada.
            o.Suggestions = [];
            % Actualiza el número de revisión de las sugerencias con el resultado de la expresión indicada.
            o.SuggestionVersion = o.SuggestionVersion + 1;
            % Actualiza el selector automático de canal mediante una operación que inicializa el seguimiento de energía para elegir una entrada mono.
            % LLAMADA a SelectorEntrada.m → SelectorEntrada: crea el objeto que conserva los datos de este módulo.
            o.InputSelector = SelectorEntrada(o.FS);
            % Establece el canal de entrada seleccionado en 0.
            o.ActiveInputChannel = 0;
            % Desactiva la presencia de señal en la entrada.
            o.InputHasSignal = false;
            % Actualiza el nombre de la ruta de entrada con el resultado de la expresión indicada.
            o.InputRoute = c.mode;
            % Actualiza el nombre de la ruta de salida con el resultado de la expresión indicada.
            o.OutputRoute = 'Iniciando salida';
            % Actualiza las mediciones del bloque mediante una operación que agrupa campos relacionados en una estructura.
            o.Stats = struct('inputPeak', -120, 'outputPeak', -120, 'compression', 0, 'clipped', 0);
            % Activa el indicador que mantiene la ejecución.
            o.Running = true;
            % Activa el indicador de procesamiento activo.
            o.Processing = true;
            % Actualiza el valor de «cleanup» mediante una operación que termina la captura, publica el último análisis y libera los dispositivos.
            % LLAMADA a ControladorEstudio.m → finalizarProcesamiento: termina la captura, publica el último análisis y libera los dispositivos.
            cleanup = onCleanup(@()o.finalizarProcesamiento()); %#ok<NASGU>
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
                out = c.outCh;
                % Ejecuta el bloque siguiente únicamente si se cumple «c.stereo».
                if c.stereo
                    % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
                    out = [out out + 1];
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «ConfiguracionAudio.esDuplex(c)».
                % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
                if ConfiguracionAudio.esDuplex(c)
                    % Actualiza el dispositivo compartido de captura y reproducción con el resultado de la expresión indicada.
                    o.Duplex = audioPlayerRecorder('SampleRate', o.FS);
                    % Ejecuta el bloque siguiente únicamente si se cumple «~strcmp(c.input, 'Default')».
                    if ~strcmp(c.input, 'Default')
                        % Actualiza el valor de «o.Duplex.Device» con el resultado de la expresión indicada.
                        o.Duplex.Device = char(c.input);
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                    details = info(o.Duplex);
                    % Actualiza el nombre de la ruta de entrada con el resultado de la expresión indicada.
                    o.InputRoute = details.DeviceName;
                    % Actualiza el nombre de la ruta de salida con el resultado de la expresión indicada.
                    o.OutputRoute = o.InputRoute;
                    % Actualiza la cantidad de entradas del dispositivo mediante una operación que obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    % LLAMADA a SelectorEntrada.m → limiteDeCanales: obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    maxIn = SelectorEntrada.limiteDeCanales(details, true);
                    % Actualiza la cantidad de salidas del dispositivo mediante una operación que obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    % LLAMADA a SelectorEntrada.m → limiteDeCanales: obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    maxOut = SelectorEntrada.limiteDeCanales(details, false);
                    % Ejecuta el bloque siguiente únicamente si se cumple «maxOut == 1 && c.outCh == 1».
                    if maxOut == 1 && c.outCh == 1
                        % Establece los canales elegidos para reproducir en 1.
                        out = 1;
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(max(out) <= maxOut, 'Los canales de salida exceden los del dispositivo.');
                    % Ejecuta el bloque siguiente únicamente si se cumple «c.inCh == 0».
                    if c.inCh == 0
                        % Actualiza la correspondencia entre canales físicos y muestras con el resultado de la expresión indicada.
                        mapping = 1:maxIn;
                    % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                    else
                        % Actualiza la correspondencia entre canales físicos y muestras con el resultado de la expresión indicada.
                        mapping = c.inCh;
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(max(mapping) <= maxIn, 'El canal de entrada no existe en este dispositivo.');
                    % Actualiza el valor de «o.Duplex.RecorderChannelMapping» con el resultado de la expresión indicada.
                    o.Duplex.RecorderChannelMapping = mapping;
                    % Actualiza el valor de «o.Duplex.PlayerChannelMapping» con el resultado de la expresión indicada.
                    o.Duplex.PlayerChannelMapping = out;
                    % Prepara un dispositivo de Audio Toolbox.
                    setup(o.Duplex, zeros(o.N, numel(out)));
                % Evalúa una condición alternativa: «ConfiguracionAudio.esTiempoReal(c)».
                % LLAMADA a ConfiguracionAudio.m → esTiempoReal: indica si la fuente seleccionada corresponde a captura en vivo.
                elseif ConfiguracionAudio.esTiempoReal(c)
                    % Actualiza el lector del dispositivo de entrada con el resultado de la expresión indicada.
                    o.Reader = audioDeviceReader;
                    % Ejecuta el bloque siguiente únicamente si se cumple «ispc».
                    if ispc
                        % Actualiza el valor de «o.Reader.Driver» con el resultado de la expresión indicada.
                        o.Reader.Driver = char(c.driver);
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Ejecuta el bloque siguiente únicamente si se cumple «~strcmp(c.input, 'Default')».
                    if ~strcmp(c.input, 'Default')
                        % Actualiza el valor de «o.Reader.Device» con el resultado de la expresión indicada.
                        o.Reader.Device = char(c.input);
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Actualiza el valor de «o.Reader.SampleRate» con el resultado de la expresión indicada.
                    o.Reader.SampleRate = o.FS;
                    % Actualiza el valor de «o.Reader.SamplesPerFrame» con el resultado de la expresión indicada.
                    o.Reader.SamplesPerFrame = o.N;
                    % Actualiza el valor de «o.Reader.ChannelMappingSource» con el resultado de la expresión indicada.
                    o.Reader.ChannelMappingSource = 'Property';
                    % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                    details = info(o.Reader);
                    % Actualiza el nombre de la ruta de entrada con el resultado de la expresión indicada.
                    o.InputRoute = details.DeviceName;
                    % Actualiza la cantidad de entradas del dispositivo mediante una operación que obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    % LLAMADA a SelectorEntrada.m → limiteDeCanales: obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    maxIn = SelectorEntrada.limiteDeCanales(details, true);
                    % Ejecuta el bloque siguiente únicamente si se cumple «c.inCh == 0».
                    if c.inCh == 0
                        % Actualiza la correspondencia entre canales físicos y muestras con el resultado de la expresión indicada.
                        mapping = 1:maxIn;
                    % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                    else
                        % Actualiza la correspondencia entre canales físicos y muestras con el resultado de la expresión indicada.
                        mapping = c.inCh;
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(max(mapping) <= maxIn, 'El canal de entrada no existe en este dispositivo.');
                    % Actualiza el valor de «o.Reader.ChannelMapping» con el resultado de la expresión indicada.
                    o.Reader.ChannelMapping = mapping;
                    % Prepara un dispositivo de Audio Toolbox.
                    setup(o.Reader);
                    % Actualiza los canales elegidos para reproducir mediante una operación que prepara la reproducción con audio toolbox o con la alternativa continua de java.
                    % LLAMADA a ControladorEstudio.m → crearSalida: prepara la reproducción con audio toolbox o con la alternativa continua de java.
                    out = o.crearSalida(out);
                % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                else
                    % Actualiza los canales elegidos para reproducir mediante una operación que prepara la reproducción con audio toolbox o con la alternativa continua de java.
                    % LLAMADA a ControladorEstudio.m → crearSalida: prepara la reproducción con audio toolbox o con la alternativa continua de java.
                    out = o.crearSalida(out);
                % Termina el bloque de instrucciones anterior.
                end
                % Calcula la respuesta de los filtros para representarla en la pantalla.
                % LLAMADA a ControladorEstudio.m → actualizarCurva: calcula la respuesta de los filtros para representarla en la pantalla.
                o.actualizarCurva();
                % Ejecuta el bloque siguiente únicamente si se cumple «o.P.mute».
                if o.P.mute
                    % Actualiza el mensaje de estado con el resultado de la expresión indicada.
                    o.Message = 'Procesando con MUTE: desactiva MUTE para obtener audio de salida.';
                % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                else
                    % Actualiza el mensaje de estado con el resultado de la expresión indicada.
                    o.Message = 'Procesando y enviando audio al dispositivo de salida.';
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter)».
                if ~isempty(o.BaseWriter)
                    % Actualiza el mensaje de estado con el resultado de la expresión indicada.
                    o.Message = [o.Message sprintf(' Salida PCM continua; buffer del dispositivo %.0f ms.', o.BaseWriter.BufferMS)];
                % Termina el bloque de instrucciones anterior.
                end
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('state', struct('running', true, 'message', o.Message, 'devices', o.DevicePayload, ...
                                               'suggestions', o.Suggestions, 'suggestionVersion', o.SuggestionVersion)); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                % Completa la operación de «iniciarProcesamiento» con los argumentos o valores indicados.
                drawnow;
                % Establece la posición de lectura del archivo en 1.
                position = 1;
                % Establece la posición temporal de la demostración en 0.
                demoPosition = 0;
                % Actualiza el bloque pendiente de envío por dúplex mediante una operación que reserva memoria inicializada en cero.
                previous = zeros(o.N, numel(out));
                % Repite el bloque mientras se cumpla «o.Running && isvalid(o.Figure)».
                while o.Running && isvalid(o.Figure)
                    % Ejecuta el bloque siguiente únicamente si se cumple «o.Pending && o.Engine.Fade == 0».
                    if o.Pending && o.Engine.Fade == 0
                        % Diseña los nuevos filtros y prepara una transición breve desde los anteriores.
                        % LLAMADA a ProcesadorAudio.m → configurarFiltros: diseña los nuevos filtros y prepara una transición breve desde los anteriores.
                        o.Engine.configurarFiltros(o.P);
                        % Desactiva la existencia de ajustes pendientes.
                        o.Pending = false;
                        % Calcula la respuesta de los filtros para representarla en la pantalla.
                        % LLAMADA a ControladorEstudio.m → actualizarCurva: calcula la respuesta de los filtros para representarla en la pantalla.
                        o.actualizarCurva();
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Desactiva el indicador del último bloque.
                    last = false;
                    % Establece las pérdidas de entrada del bloque en 0.
                    over = 0;
                    % Establece las pérdidas de salida del bloque en 0.
                    under = 0;
                    % Actualiza la cantidad de elementos que se utilizarán con el resultado de la expresión indicada.
                    count = o.N;
                    % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Duplex)».
                    if ~isempty(o.Duplex)
                        % Actualiza el valor de «[x, under, over]» con el resultado de la expresión indicada.
                        [x, under, over] = o.Duplex(previous);
                    % Evalúa una condición alternativa: «~isempty(o.Reader)».
                    elseif ~isempty(o.Reader)
                        % Actualiza el valor de «[x, over]» con el resultado de la expresión indicada.
                        [x, over] = o.Reader();
                    % Evalúa una condición alternativa: «strcmp(c.mode, 'WAV')».
                    elseif strcmp(c.mode, 'WAV')
                        % Actualiza la cantidad de elementos que se utilizarán mediante una operación que limita el resultado por arriba o toma el menor valor.
                        count = min(o.N, size(o.FileAudio, 1) - position + 1);
                        % Actualiza las muestras de entrada mediante una operación que reserva memoria inicializada en cero.
                        x = zeros(o.N, 1);
                        % Actualiza las muestras de entrada con el resultado de la expresión indicada.
                        x(1:count) = o.FileAudio(position:position + count - 1);
                        % Actualiza la posición de lectura del archivo con el resultado de la expresión indicada.
                        position = position + count;
                        % Actualiza el indicador del último bloque mediante una operación que consulta las dimensiones.
                        last = position > size(o.FileAudio, 1);
                        % Ejecuta el bloque siguiente únicamente si se cumple «last && c.loop».
                        if last && c.loop
                            % Establece la posición de lectura del archivo en 1.
                            position = 1;
                            % Desactiva el indicador del último bloque.
                            last = false;
                        % Termina el bloque de instrucciones anterior.
                        end
                    % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                    else
                        % Calcula el instante de cada muestra de la demostración.
                        t = (demoPosition + (0:o.N - 1)') / o.FS;
                        % Calcula el tiempo desde el inicio de cada golpe simulado, repetido cada 0.65 segundos.
                        ph = mod(t, .65);
                        % Actualiza las muestras de entrada mediante una operación que calcula el seno de la señal o del filtro.
                        x = .32 * sin(2 * pi * 180 * t) .* exp(-ph / .04) + ...
                            .22 * sin(2 * pi * 340 * t) .* exp(-ph / .22) + ... % Calcula el seno de la señal o del filtro.
                            .10 * sin(2 * pi * 720 * t) .* exp(-ph / .13) + ... % Calcula el seno de la señal o del filtro.
                            .14 * randn(o.N, 1) .* exp(-ph / .012); % Calcula un factor exponencial de suavización.
                        % Actualiza la posición temporal de la demostración con el resultado de la expresión indicada.
                        demoPosition = demoPosition + o.N;
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Reader) || ~isempty(o.Duplex)».
                    if ~isempty(o.Reader) || ~isempty(o.Duplex)
                        % Ejecuta el bloque siguiente únicamente si se cumple «c.inCh == 0».
                        if c.inCh == 0
                            % Actualiza el valor de «[x, o.ActiveInputChannel, switched, o.InputHasSignal]» mediante una operación que elige un canal con señal y exige persistencia antes de cambiar a otro.
                            % LLAMADA a SelectorEntrada.m → seleccionarCanal: elige un canal con señal y exige persistencia antes de cambiar a otro.
                            [x, o.ActiveInputChannel, switched, o.InputHasSignal] = o.InputSelector.seleccionarCanal(x);
                            % Ejecuta el bloque siguiente únicamente si se cumple «switched».
                            if switched
                                % LLAMADA a reiniciarGraficaConservada: la gráfica conservada debe pertenecer al nuevo canal.
                                o.reiniciarGraficaConservada();
                                % Actualiza el motor de procesamiento de audio mediante una operación que crea el motor de filtros y reserva la memoria necesaria entre bloques.
                                % LLAMADA a ProcesadorAudio.m → ProcesadorAudio: crea el objeto que conserva los datos de este módulo.
                                o.Engine = ProcesadorAudio(o.FS, o.P);
                                % Actualiza las muestras recientes para las gráficas mediante una operación que reserva memoria inicializada en cero.
                                % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
                                % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
                                o.Scope = zeros(8192, 2);
                                % Mantiene las etapas alineadas con la entrada al cambiar automáticamente de canal.
                                o.StageScope = zeros(8192, 3);
                                % Actualiza el analizador de resonancias mediante una operación que prepara la ventana y los acumuladores del análisis de frecuencias.
                                % LLAMADA a AnalizadorResonancias.m → AnalizadorResonancias: crea el objeto que conserva los datos de este módulo.
                                o.Analyzer = AnalizadorResonancias(o.FS);
                                % Establece las muestras acumuladas desde el último análisis en 0.
                                o.DetectionSamples = 0;
                                % Actualiza las sugerencias del análisis con el resultado de la expresión indicada.
                                o.Suggestions = [];
                                % Actualiza el número de revisión de las sugerencias con el resultado de la expresión indicada.
                                o.SuggestionVersion = o.SuggestionVersion + 1;
                            % Termina el bloque de instrucciones anterior.
                            end
                        % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                        else
                            % Actualiza el canal de entrada seleccionado con el resultado de la expresión indicada.
                            o.ActiveInputChannel = c.inCh;
                            % Actualiza la presencia de señal en la entrada mediante una operación que obtiene la raíz cuadrada.
                            o.InputHasSignal = sqrt(mean(x.^2)) > 10^(-65 / 20);
                        % Termina el bloque de instrucciones anterior.
                        end
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Actualiza el valor de «[y, o.Stats, stages]» mediante una operación que procesa un bloque conservando la memoria de filtros, puerta y compresor.
                    % LLAMADA a ProcesadorAudio.m → procesarBloque: procesa un bloque conservando la memoria de filtros, puerta y compresor.
                    [y, o.Stats, stages] = o.Engine.procesarBloque(x);
                    % Actualiza la señal mono duplicada en los canales de salida mediante una operación que repite la señal para distribuirla entre canales.
                    stereo = repmat(y, 1, numel(out));
                    % Actualiza las muestras perdidas en la entrada mediante una operación que convierte los datos a precisión doble.
                    o.TotalOver = o.TotalOver + double(over);
                    % Actualiza las muestras perdidas en la salida mediante una operación que convierte los datos a precisión doble.
                    o.TotalUnder = o.TotalUnder + double(under);
                    % Actualiza la cantidad acumulada de muestras que alcanzaron el tope con el resultado de la expresión indicada.
                    o.TotalClip = o.TotalClip + o.Stats.clipped;
                    % Actualiza los índices de las muestras seleccionadas mediante una operación que calcula la posición cíclica de la memoria.
                    ix = mod(o.CapturePos - 1 + (0:count - 1), size(o.Capture, 1)) + 1;
                    % Actualiza la memoria circular de entrada y salida mediante una operación que convierte los datos a precisión simple.
                    o.Capture(ix, :) = single([x(1:count) y(1:count)]);
                    % Actualiza la memoria circular de las etapas mediante una operación que convierte los datos a precisión simple.
                    o.StageCapture(ix, :) = single(stages(1:count, :));
                    % Actualiza la posición de escritura en la captura mediante una operación que calcula la posición cíclica de la memoria.
                    o.CapturePos = mod(o.CapturePos - 1 + count, size(o.Capture, 1)) + 1;
                    % Actualiza el número de muestras disponibles en la captura mediante una operación que limita el resultado por arriba o toma el menor valor.
                    o.CaptureCount = min(size(o.Capture, 1), o.CaptureCount + count);
                    % Actualiza el total de muestras capturadas con el resultado de la expresión indicada.
                    o.TotalCaptured = o.TotalCaptured + count;
                    % Actualiza las muestras recientes para las gráficas con el resultado de la expresión indicada.
                    o.Scope = [o.Scope(o.N + 1:end, :); x y];
                    % Actualiza las muestras recientes de las tres etapas con el resultado de la expresión indicada.
                    o.StageScope = [o.StageScope(o.N + 1:end, :); stages];
                    % Conserva una ventana únicamente al grabar desde un dispositivo en tiempo real.
                    if ConfiguracionAudio.esTiempoReal(c)
                        % LLAMADA a conservarGrafica: guarda los golpes sin alterar las muestras grabadas ni los filtros.
                        o.conservarGrafica();
                    % Termina la selección de la ventana para la toma en vivo.
                    end
                    % Capturar antes de esperar al reproductor: frame() consulta
                    % exclusivamente las muestras que ya se estan reproduciendo.
                    % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Duplex)».
                    if ~isempty(o.Duplex)
                        % Actualiza el bloque pendiente de envío por dúplex con el resultado de la expresión indicada.
                        previous = stereo;
                    % Evalúa una condición alternativa: «~isempty(o.Writer)».
                    elseif ~isempty(o.Writer)
                        % Actualiza las muestras perdidas en la salida mediante una operación que convierte los datos a precisión doble.
                        o.TotalUnder = o.TotalUnder + double(o.Writer(stereo));
                    % Evalúa una condición alternativa: «~isempty(o.BaseWriter)».
                    elseif ~isempty(o.BaseWriter)
                        % Convierte el bloque a audio de 16 bits y lo envía sin reiniciar la reproducción.
                        % LLAMADA a SalidaContinua.m → escribirBloque: convierte el bloque a audio de 16 bits y lo envía sin reiniciar la reproducción.
                        o.BaseWriter.escribirBloque(stereo(1:count, :));
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Ejecuta el bloque siguiente únicamente si se cumple «o.Detection && o.Running».
                    if o.Detection && o.Running
                        % Incorpora un bloque de audio al análisis periódico de resonancias.
                        % LLAMADA a ControladorEstudio.m → analizarBloque: incorpora un bloque de audio al análisis periódico de resonancias.
                        o.analizarBloque(x(1:count));
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Limita la actualización gráfica para compartir el tiempo de trabajo con el audio.
                    % LLAMADA a ControladorEstudio.m → sincronizarPantalla: limita la actualización gráfica para compartir el tiempo de trabajo con el audio.
                    o.sincronizarPantalla();
                    % Ejecuta el bloque siguiente únicamente si se cumple «last».
                    if last
                        % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter) && o.Running».
                        if ~isempty(o.BaseWriter) && o.Running
                            % Espera a que termine el audio enviado mientras atiende la interfaz.
                            % LLAMADA a SalidaContinua.m → esperarReproduccion: espera a que termine el audio enviado mientras atiende la interfaz.
                            o.BaseWriter.esperarReproduccion();
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Desactiva el indicador que mantiene la ejecución.
                        o.Running = false;
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Duplex) && isvalid(o.Figure) && ~o.Closing».
                if ~isempty(o.Duplex) && isvalid(o.Figure) && ~o.Closing
                    % Entrega la ultima trama pendiente del esquema duplex.
                    % Completa la operación de «iniciarProcesamiento» con los argumentos o valores indicados.
                    o.Duplex(previous);
                % Termina el bloque de instrucciones anterior.
                end
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch ME
                % Actualiza el mensaje de estado con el resultado de la expresión indicada.
                o.Message = ['Audio detenido: ' ME.message];
                % Actualiza el último mensaje de error con el resultado de la expresión indicada.
                o.LastError = o.Message;
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('error', struct('message', o.Message));
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% crearSalida: Prepara la reproducción con Audio Toolbox o con la alternativa continua de Java
        function out = crearSalida(o, out)
            % Ejecuta el bloque siguiente únicamente si se cumple «UtilidadesAudio.estaDisponible('audioDeviceWriter')».
            % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
            if UtilidadesAudio.estaDisponible('audioDeviceWriter')
                % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                try
                    % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
                    o.Writer = audioDeviceWriter;
                    % Ejecuta el bloque siguiente únicamente si se cumple «ispc».
                    if ispc
                        % Actualiza el valor de «o.Writer.Driver» con el resultado de la expresión indicada.
                        o.Writer.Driver = char(o.Config.driver);
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Ejecuta el bloque siguiente únicamente si se cumple «~strcmp(o.Config.output, 'Default')».
                    if ~strcmp(o.Config.output, 'Default')
                        % Actualiza el valor de «o.Writer.Device» con el resultado de la expresión indicada.
                        o.Writer.Device = char(o.Config.output);
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Actualiza el valor de «o.Writer.SampleRate» con el resultado de la expresión indicada.
                    o.Writer.SampleRate = o.FS;
                    % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                    details = info(o.Writer);
                    % Actualiza el nombre de la ruta de salida con el resultado de la expresión indicada.
                    o.OutputRoute = details.DeviceName;
                    % Actualiza la cantidad de salidas del dispositivo mediante una operación que obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    % LLAMADA a SelectorEntrada.m → limiteDeCanales: obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                    maxOut = SelectorEntrada.limiteDeCanales(details, false);
                    % Ejecuta el bloque siguiente únicamente si se cumple «maxOut == 1 && out(1) == 1».
                    if maxOut == 1 && out(1) == 1
                        % Establece los canales elegidos para reproducir en 1.
                        out = 1;
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(max(out) <= maxOut, 'Los canales de salida no existen en este dispositivo.');
                    % Actualiza el valor de «o.Writer.ChannelMappingSource» con el resultado de la expresión indicada.
                    o.Writer.ChannelMappingSource = 'Property';
                    % Actualiza el valor de «o.Writer.ChannelMapping» con el resultado de la expresión indicada.
                    o.Writer.ChannelMapping = out;
                    % Prepara un dispositivo de Audio Toolbox.
                    setup(o.Writer, zeros(o.N, numel(out)));
                    % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                    return
                % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                catch
                    % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Writer)».
                    if ~isempty(o.Writer)
                        % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                        try
                            % Libera un dispositivo de Audio Toolbox.
                            release(o.Writer);
                        % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                        catch
                        % Termina el bloque de instrucciones anterior.
                        end
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
                    o.Writer = [];
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Sin toolbox (o sin licencia), el procesamiento y los controles
            % siguen activos; solo cambia el mecanismo de salida.
            % Actualiza la salida continua alternativa mediante una operación que abre la salida de audio y define la cantidad inicial de muestras que se acumularán.
            % LLAMADA a SalidaContinua.m → SalidaContinua: crea el objeto que conserva los datos de este módulo.
            o.BaseWriter = SalidaContinua(o.FS, o.Config.output, out, @()o.Running && isvalid(o.Figure));
            % Actualiza la función de actualización de pantalla mediante una operación que limita la actualización gráfica para compartir el tiempo de trabajo con el audio.
            % LLAMADA a ControladorEstudio.m → sincronizarPantalla: limita la actualización gráfica para compartir el tiempo de trabajo con el audio.
            o.BaseWriter.OnTick = @()o.sincronizarPantalla();
            % Actualiza el nombre de la ruta de salida con el resultado de la expresión indicada.
            o.OutputRoute = [char(o.Config.output) ' (PCM continuo)'];
        % Termina el bloque de instrucciones anterior.
        end


        %% actualizarCurva: Calcula la respuesta de los filtros para representarla en la pantalla
        function actualizarCurva(o)
            % Actualiza las frecuencias usadas para dibujar mediante una operación que añade puntos alrededor de cada banda para dibujar con detalle su respuesta.
            % LLAMADA a ProcesadorAudio.m → frecuenciasDeGrafica: añade puntos alrededor de cada banda para dibujar con detalle su respuesta.
            o.ViewFreq = ProcesadorAudio.frecuenciasDeGrafica(o.P);
            % Evalúa la respuesta compleja de toda la cadena en las frecuencias de dibujo.
            % LLAMADA a ProcesadorAudio.m → respuestaEnFrecuencia: evalúa cuánto modifica la cadena cada frecuencia solicitada. LLAMADA a ProcesadorAudio.m → disenarCadena: construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            h = ProcesadorAudio.respuestaEnFrecuencia(ProcesadorAudio.disenarCadena(o.FS, o.P), o.ViewFreq, o.FS);
            % Actualiza la última respuesta de los filtros mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
            o.LastCurve = 20 * log10(max(abs(h), 1e-8))';
        % Termina el bloque de instrucciones anterior.
        end


        %% reiniciarGraficaConservada: Prepara una nueva toma sin conservar resultados anteriores
        function reiniciarGraficaConservada(o)
            % Libera la referencia a las muestras de entrada y salida de la toma anterior.
            o.VentanaConservada = [];
            % Libera las muestras de las etapas asociadas a aquella ventana.
            o.EtapasConservadas = [];
            % Reinicia la comparación para que la próxima señal pueda seleccionarse.
            o.EnergiaConservada = 0;
        % Termina la preparación de la gráfica conservada.
        end


        %% conservarGrafica: Selecciona una ventana representativa sin detener la gráfica en vivo
        function conservarGrafica(o)
            % Examina las mismas 2048 muestras de entrada que utiliza calcularEspectro.
            entrada = o.Scope(end - 2047:end, 1);
            % Calcula su energía dando más importancia al centro; no depende de la ganancia de salida.
            energia = sum(entrada.^2 .* o.PesosGrafica);
            % Sustituye la selección solo cuando llega una ventana con mayor energía de entrada.
            if energia > o.EnergiaConservada
                % Conserva juntas la señal original y la procesada del mismo instante.
                o.VentanaConservada = o.Scope;
                % Conserva las tres etapas de ese instante, incluso si su panel está oculto.
                o.EtapasConservadas = o.StageScope;
                % Registra la energía elegida para que el silencio posterior no borre el golpe.
                o.EnergiaConservada = energia;
            % Termina la comparación de las ventanas de la toma.
            end
        % Termina la conservación de la gráfica; la grabación continúa normalmente.
        end


        %% calcularEspectro: Obtiene las frecuencias presentes y sus niveles a partir de las muestras recientes
        function [f, db] = calcularEspectro(o, scope)
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 2».
            if nargin < 2
                % Actualiza la ventana de muestras para la gráfica con el resultado de la expresión indicada.
                scope = o.Scope;
            % Termina el bloque de instrucciones anterior.
            end
            % Ventana visual corta. El detector mantiene su FFT de 8192.
            % Define una ventana de 2048 muestras para actualizar con rapidez el espectro.
            n = 2048;
            % Construye una ventana de Hann para reducir el efecto de los extremos del bloque.
            w = .5 - .5 * cos(2 * pi * (0:n - 1)' / n);
            % Calcula la amplitud de las frecuencias de la ventana y conserva la mitad no negativa.
            a = abs(fft(scope(end - n + 1:end, :) .* w, n)) * 2 / sum(w);
            % Calcula la amplitud de las frecuencias de la ventana y conserva la mitad no negativa.
            a = a(1:n / 2 + 1, :);
            % Actualiza los coeficientes del denominador o el factor de mezcla según el cálculo con el resultado de la expresión indicada.
            a([1 end], :) = a([1 end], :) / 2;
            % Asigna a cada punto de la FFT su frecuencia en Hz.
            f = (0:n / 2)' * o.FS / n;
            % Convierte las amplitudes en niveles dBFS, evitando tomar el logaritmo de cero.
            db = 20 * log10(max(a, 1e-6));
        % Termina el bloque de instrucciones anterior.
        end


        %% sincronizarPantalla: Limita la actualización gráfica para compartir el tiempo de trabajo con el audio
        function sincronizarPantalla(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(o.DisplayClock) || toc(o.DisplayClock) >= .04».
            if isempty(o.DisplayClock) || toc(o.DisplayClock) >= .04
                % Actualiza el reloj de actualización de pantalla con el resultado de la expresión indicada.
                o.DisplayClock = tic;
                % Reúne mediciones, espectros y estados para actualizar los controles visibles.
                % LLAMADA a ControladorEstudio.m → actualizarPantalla: reúne mediciones, espectros y estados para actualizar los controles visibles.
                o.actualizarPantalla();
                % Completa la operación de «sincronizarPantalla» con los argumentos o valores indicados.
                drawnow limitrate;
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% actualizarPantalla: Reúne mediciones, espectros y estados para actualizar los controles visibles
        function actualizarPantalla(o)
            % Actualiza la ventana de muestras para la gráfica con el resultado de la expresión indicada.
            scope = o.Scope;
            % Actualiza las muestras recientes de las etapas con el resultado de la expresión indicada.
            stageScope = o.StageScope;
            % Actualiza los niveles y la saturación del bloque con el resultado de la expresión indicada.
            stats = o.Stats;
            % Actualiza la duración mostrada en segundos con el resultado de la expresión indicada.
            seconds = o.CaptureCount / o.CaptureFS;
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter) && o.Processing && o.CaptureCount > 0».
            if ~isempty(o.BaseWriter) && o.Processing && o.CaptureCount > 0
                % Actualiza las muestras ya reproducidas mediante una operación que consulta cuántas muestras ya han sido reproducidas.
                % LLAMADA a SalidaContinua.m → posicionReproducida: consulta cuántas muestras ya han sido reproducidas.
                played = min(o.TotalCaptured, o.BaseWriter.posicionReproducida());
                % Actualiza la ventana de muestras para la gráfica mediante una operación que extrae de la memoria circular una ventana alineada con el audio reproducido.
                % LLAMADA a VentanaReproduccion.m → extraerVentana: extrae de la memoria circular una ventana alineada con el audio reproducido.
                scope = VentanaReproduccion.extraerVentana(o.Capture, o.TotalCaptured, played, 8192);
                % Ejecuta el bloque siguiente únicamente si se cumple «o.StageView».
                if o.StageView
                    % Actualiza las muestras recientes de las etapas mediante una operación que extrae de la memoria circular una ventana alineada con el audio reproducido.
                    % LLAMADA a VentanaReproduccion.m → extraerVentana: extrae de la memoria circular una ventana alineada con el audio reproducido.
                    stageScope = VentanaReproduccion.extraerVentana(o.StageCapture, o.TotalCaptured, played, 8192);
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza los índices de los picos elegidos mediante una operación que limita el resultado por abajo o toma el mayor valor.
                peaks = max(abs(scope(end - 1023:end, :)), [], 1);
                % Actualiza el valor de «stats.inputPeak» mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
                stats.inputPeak = 20 * log10(max(peaks(1), 1e-12));
                % Actualiza el valor de «stats.outputPeak» mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
                stats.outputPeak = 20 * log10(max(peaks(2), 1e-12));
                % Actualiza la duración mostrada en segundos mediante una operación que limita el resultado por arriba o toma el menor valor.
                seconds = min(played, size(o.Capture, 1)) / o.CaptureFS;
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «[f, db]» mediante una operación que obtiene las frecuencias presentes y sus niveles a partir de las muestras recientes.
            % LLAMADA a ControladorEstudio.m → calcularEspectro: obtiene las frecuencias presentes y sus niveles a partir de las muestras recientes.
            [f, db] = o.calcularEspectro(scope);
            % Actualiza la variable auxiliar «a» de esta función mediante una operación que interpola los valores en las frecuencias de la gráfica.
            a = interp1(f, db, o.ViewFreq(:), 'linear', -120);
            % Actualiza los datos de comparación entre etapas con el resultado de la expresión indicada.
            stageData = [];
            % Ejecuta el bloque siguiente únicamente si se cumple «o.StageView && o.CaptureCount > 0».
            if o.StageView && o.CaptureCount > 0
                % Actualiza los datos de comparación entre etapas mediante una operación que compara la señal antes del banco de resonancias, después del banco y después del ecualizador.
                % LLAMADA a ControladorEstudio.m → medirEtapas: compara la señal antes del banco de resonancias, después del banco y después del ecualizador.
                stageData = o.medirEtapas(stageScope);
            % Termina el bloque de instrucciones anterior.
            end
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('frame', struct('stages', stageData, 'freq', o.ViewFreq, 'input', a(:, 1)', ...
                                           'output', a(:, 2)', 'curve', o.LastCurve, 'inPeak', stats.inputPeak, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'outPeak', stats.outputPeak, 'compression', stats.compression, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'over', o.TotalOver, 'under', o.TotalUnder, 'clip', o.TotalClip, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'seconds', seconds, 'running', o.Running, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'suggestions', o.Suggestions, 'suggestionVersion', o.SuggestionVersion, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'activeInput', o.ActiveInputChannel, 'inputHasSignal', o.InputHasSignal, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                           'inputRoute', o.InputRoute, 'outputRoute', o.OutputRoute)); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
        % Termina el bloque de instrucciones anterior.
        end


        %% medirEtapas: Compara la señal antes del banco de resonancias, después del banco y después del ecualizador
        function data = medirEtapas(o, scope)
            % Misma ventana, FFT y escala en las tres etapas; sin normalizacion individual.
            % Usa 8192 muestras para comparar las tres etapas con la misma resolución.
            n = 8192;
            % Construye la misma ventana de Hann para todas las etapas.
            w = .5 - .5 * cos(2 * pi * (0:n - 1)' / n);
            % Calcula la magnitud de la FFT de cada etapa con la misma corrección de amplitud.
            a = abs(fft(double(scope(end - n + 1:end, :)) .* w, n)) * 2 / sum(w);
            % Calcula la magnitud de la FFT de cada etapa con la misma corrección de amplitud.
            a = a(1:n / 2 + 1, :);
            % Actualiza los coeficientes del denominador o el factor de mezcla según el cálculo con el resultado de la expresión indicada.
            a([1 end], :) = a([1 end], :) / 2;
            % Construye el eje de frecuencias compartido por las tres señales.
            f = (0:n / 2)' * o.FS / n;
            % Convierte las amplitudes a decibelios usando una referencia común.
            db = 20 * log10(max(a, 1e-6));
            % Actualiza el valor de «values» mediante una operación que interpola los valores en las frecuencias de la gráfica.
            values = interp1(f, db, o.ViewFreq(:), 'linear', -120);
            % Selecciona las muestras recientes que se mostrarán en la vista temporal.
            wave = double(scope(end - 511:end, :));
            % Actualiza el valor de «data» mediante una operación que agrupa campos relacionados en una estructura.
            data = struct('freq', o.ViewFreq, 'before', values(:, 1)', ...
                        'notch', values(:, 2)', 'eq', values(:, 3)', ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                        'time', (-511:0) / o.FS * 1000, 'waveBefore', wave(:, 1)', ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                        'waveNotch', wave(:, 2)', 'waveEQ', wave(:, 3)', ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                        'live', logical(o.Running && o.Processing), 'windowMS', 1000 * n / o.FS, 'bypass', logical(o.P.bypass), ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                        'retained', logical(~o.Processing && ~isempty(o.VentanaConservada))); % Indica que las etapas muestran la ventana representativa conservada.
        % Termina el bloque de instrucciones anterior.
        end


        %% iniciarDeteccion: Solicita sugerencias de resonancias a partir del archivo o de la toma actual
        function iniciarDeteccion(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Running».
            if o.Running
                % Actualiza el analizador de resonancias mediante una operación que prepara la ventana y los acumuladores del análisis de frecuencias.
                % LLAMADA a AnalizadorResonancias.m → AnalizadorResonancias: crea el objeto que conserva los datos de este módulo.
                o.Analyzer = AnalizadorResonancias(o.FS);
                % Establece las muestras acumuladas desde el último análisis en 0.
                o.DetectionSamples = 0;
                % Activa la activación del análisis de resonancias.
                o.Detection = true;
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('notice', struct('message', 'Analisis automatico reiniciado. Toca varios golpes y deja sonar la cola.'));
            % Evalúa una condición alternativa: «o.CaptureCount > 0».
            elseif o.CaptureCount > 0
                % Actualiza las muestras de entrada mediante una operación que recupera en orden temporal las muestras conservadas en la memoria circular.
                % LLAMADA a ControladorEstudio.m → recuperarCaptura: recupera en orden temporal las muestras conservadas en la memoria circular.
                x = o.recuperarCaptura();
                % Entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente.
                % LLAMADA a ControladorEstudio.m → publicarAnalisis: entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente. LLAMADA a AnalizadorResonancias.m → analizarGrabacion: analiza ventanas repartidas por una grabación sin cambiar la señal original.
                o.publicarAnalisis(AnalizadorResonancias.analizarGrabacion(x(:, 1), o.CaptureFS), true);
            % Evalúa una condición alternativa: «~isempty(o.FileAudio)».
            elseif ~isempty(o.FileAudio)
                % Entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente.
                % LLAMADA a ControladorEstudio.m → publicarAnalisis: entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente. LLAMADA a AnalizadorResonancias.m → analizarGrabacion: analiza ventanas repartidas por una grabación sin cambiar la señal original.
                o.publicarAnalisis(AnalizadorResonancias.analizarGrabacion(o.FileAudio, o.FileFS), true);
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                o.enviarMensaje('notice', struct('message', 'Carga un WAV o inicia Demo / Tiempo real antes de detectar.'));
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% analizarBloque: Incorpora un bloque de audio al análisis periódico de resonancias
        function analizarBloque(o, x)
            % Acumula muestras y analiza ventanas sucesivas con solapamiento.
            % LLAMADA a AnalizadorResonancias.m → acumularMuestras: acumula muestras y analiza ventanas sucesivas con solapamiento.
            o.Analyzer.acumularMuestras(x);
            % Actualiza las muestras acumuladas desde el último análisis mediante una operación que cuenta los elementos.
            o.DetectionSamples = o.DetectionSamples + numel(x);
            % Ejecuta el bloque siguiente únicamente si se cumple «o.DetectionSamples >= 4 * o.FS».
            if o.DetectionSamples >= 4 * o.FS
                % Actualiza las sugerencias del análisis mediante una operación que elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
                % LLAMADA a AnalizadorResonancias.m → obtenerSugerencias: elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
                o.Suggestions = o.Analyzer.obtenerSugerencias();
                % Actualiza el número de revisión de las sugerencias con el resultado de la expresión indicada.
                o.SuggestionVersion = o.SuggestionVersion + 1;
                % Actualiza el analizador de resonancias mediante una operación que prepara la ventana y los acumuladores del análisis de frecuencias.
                % LLAMADA a AnalizadorResonancias.m → AnalizadorResonancias: crea el objeto que conserva los datos de este módulo.
                o.Analyzer = AnalizadorResonancias(o.FS);
                % Establece las muestras acumuladas desde el último análisis en 0.
                o.DetectionSamples = 0;
                % El siguiente frame transporta resultados y medidores juntos.
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% publicarAnalisis: Entrega a la interfaz las frecuencias sugeridas sin aplicarlas automáticamente
        function publicarAnalisis(o, result, openPanel)
            % Actualiza las sugerencias del análisis con el resultado de la expresión indicada.
            o.Suggestions = result;
            % Actualiza el número de revisión de las sugerencias con el resultado de la expresión indicada.
            o.SuggestionVersion = o.SuggestionVersion + 1;
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('candidates', struct('suggestions', result, 'suggestionVersion', o.SuggestionVersion, ...
                                                'openPanel', openPanel, 'message', result.message)); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
        % Termina el bloque de instrucciones anterior.
        end


        %% recuperarCaptura: Recupera en orden temporal las muestras conservadas en la memoria circular
        function x = recuperarCaptura(o)
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(o.CaptureCount > 0, 'Todavia no hay audio procesado.');
            % Ejecuta el bloque siguiente únicamente si se cumple «o.CaptureCount < size(o.Capture, 1)».
            if o.CaptureCount < size(o.Capture, 1)
                % Actualiza las muestras de entrada con el resultado de la expresión indicada.
                x = o.Capture(1:o.CaptureCount, :);
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza las muestras de entrada con el resultado de la expresión indicada.
                x = o.Capture([o.CapturePos:end 1:o.CapturePos - 1], :);
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% exportarGrabacion: Guarda un WAV con el original a la izquierda y el procesado a la derecha
        function exportarGrabacion(o)
            % Actualiza las muestras de entrada mediante una operación que recupera en orden temporal las muestras conservadas en la memoria circular.
            % LLAMADA a ControladorEstudio.m → recuperarCaptura: recupera en orden temporal las muestras conservadas en la memoria circular.
            x = o.recuperarCaptura();
            % Actualiza el valor de «[f, p]» mediante una operación que solicita el nombre del archivo de salida.
            [f, p] = uiputfile('*.wav', 'L=original / R=procesado', 'Snare_AB.wav');
            % Ejecuta el bloque siguiente únicamente si se cumple «isequal(f, 0)».
            if isequal(f, 0)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Guarda las muestras en un archivo de audio.
            audiowrite(fullfile(p, f), x, o.CaptureFS, 'BitsPerSample', 24);
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('notice', struct('message', 'A/B guardado: L original, R procesado. Incluye master y MUTE.'));
        % Termina el bloque de instrucciones anterior.
        end


        %% escucharToma: Selecciona la versión original o procesada de la grabación para reproducirla
        function escucharToma(o, column)
            % Detiene los recursos usados para escuchar una grabación.
            % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
            o.detenerEscucha();
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(column, [1 2]), 'Canal de escucha no valido.');
            % Ejecuta el bloque siguiente únicamente si se cumple «o.CaptureCount > 0».
            if o.CaptureCount > 0
                % Actualiza las muestras de entrada mediante una operación que recupera en orden temporal las muestras conservadas en la memoria circular.
                % LLAMADA a ControladorEstudio.m → recuperarCaptura: recupera en orden temporal las muestras conservadas en la memoria circular.
                x = double(o.recuperarCaptura());
                % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
                fs = o.CaptureFS;
            % Evalúa una condición alternativa: «~isempty(o.FileAudio) && strcmp(o.Config.mode, 'WAV')».
            elseif ~isempty(o.FileAudio) && strcmp(o.Config.mode, 'WAV')
                % Escuchar un WAV recien cargado no requiere una captura previa.
                % Actualiza las muestras de entrada mediante una operación que convierte los datos a precisión doble.
                x = [double(o.FileAudio) zeros(size(o.FileAudio))];
                % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
                fs = o.FileFS;
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Detiene esta operación e informa la causa.
                error('SnareStudioV4:NoAudio', 'Carga un WAV o procesa unos segundos de Demo / Tiempo real antes de escuchar.');
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «message» con el resultado de la expresión indicada.
            message = 'Reproduciendo la toma.';
            % Ejecuta el bloque siguiente únicamente si se cumple «column == 2».
            if column == 2
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(~o.P.mute, 'MUTE esta activado. Desactivalo antes de escuchar el procesado.');
                % Ejecuta el bloque siguiente únicamente si se cumple «o.CaptureCount == 0 || (~any(x(:, 2)) && any(x(:, 1)))».
                if o.CaptureCount == 0 || (~any(x(:, 2)) && any(x(:, 1)))
                    % MUTE se guarda en la captura. Desmutear despues no recupera
                    % esas muestras: hay que procesar de nuevo la entrada guardada.
                    % Actualiza las muestras de entrada mediante una operación que aplica el mismo procesamiento a todos los bloques de una grabación.
                    % LLAMADA a ProcesadorAudio.m → procesarGrabacion: aplica el mismo procesamiento a todos los bloques de una grabación.
                    x(:, 2) = ProcesadorAudio.procesarGrabacion(x(:, 1), fs, o.P, o.N);
                    % Actualiza el valor de «message» con el resultado de la expresión indicada.
                    message = [message ' Procesado regenerado con los ajustes actuales.'];
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza las muestras preparadas para reproducción con el resultado de la expresión indicada.
            audio = x(:, column);
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(~isempty(audio) && all(isfinite(audio)), 'No hay muestras de audio validas para reproducir.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(any(audio), 'La toma seleccionada contiene silencio. Revisa la fuente y vuelve a procesar.');
            % Ejecuta el bloque siguiente únicamente si se cumple «UtilidadesAudio.estaDisponible('audioDeviceWriter') && ...».
            % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
            if UtilidadesAudio.estaDisponible('audioDeviceWriter') && ...
                    (~strcmp(o.Config.output, 'Default') || o.Config.outCh ~= 1 || ... % Actualiza el valor de «(~strcmp(o.Config.output, 'Default') || o.Config.outCh ~» con el resultado de la expresión indicada.
                     ConfiguracionAudio.esDuplex(o.Config) || (ispc && ~strcmp(o.Config.driver, 'DirectSound'))) % Indica si entrada y salida deben compartir un dispositivo ASIO. % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
                % Reproduce la toma respetando el dispositivo y los canales seleccionados.
                % LLAMADA a ControladorEstudio.m → reproducirConDispositivo: reproduce la toma respetando el dispositivo y los canales seleccionados.
                o.reproducirConDispositivo(audio, fs);
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Reproduce bloques sucesivos manteniendo abierta una única salida de audio.
            % LLAMADA a ControladorEstudio.m → reproducirConSalidaContinua: reproduce bloques sucesivos manteniendo abierta una única salida de audio.
            o.reproducirConSalidaContinua(audio, fs, message);
        % Termina el bloque de instrucciones anterior.
        end


        %% reproducirConSalidaContinua: Reproduce bloques sucesivos manteniendo abierta una única salida de audio
        function reproducirConSalidaContinua(o, audio, fs, message)
            % Actualiza el valor de «device» con el resultado de la expresión indicada.
            device = o.Config.output;
            % Ejecuta el bloque siguiente únicamente si se cumple «ConfiguracionAudio.esDuplex(o.Config)».
            % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
            if ConfiguracionAudio.esDuplex(o.Config)
                % Actualiza el valor de «device» con el resultado de la expresión indicada.
                device = o.Config.input;
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
            out = o.Config.outCh;
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Config.stereo».
            if o.Config.stereo
                % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
                out = [out out + 1];
            % Termina el bloque de instrucciones anterior.
            end
            % Activa el indicador que mantiene la ejecución.
            o.Running = true;
            % Actualiza el valor de «cleanup» mediante una operación que libera los recursos de reproducción y comunica que la escucha terminó.
            % LLAMADA a ControladorEstudio.m → finalizarEscucha: libera los recursos de reproducción y comunica que la escucha terminó.
            cleanup = onCleanup(@()o.finalizarEscucha()); %#ok<NASGU>
            % Actualiza la salida continua alternativa mediante una operación que abre la salida de audio y define la cantidad inicial de muestras que se acumularán.
            % LLAMADA a SalidaContinua.m → SalidaContinua: crea el objeto que conserva los datos de este módulo.
            o.BaseWriter = SalidaContinua(fs, device, out, @()o.Running && isvalid(o.Figure));
            % Actualiza la función de actualización de pantalla mediante una operación que permite que MATLAB atienda y actualice la interfaz.
            o.BaseWriter.OnTick = @()drawnow('limitrate');
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('state', struct('running', true, 'message', [message ' Salida PCM continua: ' char(device)]));
            % Completa la operación de «reproducirConSalidaContinua» con los argumentos o valores indicados.
            drawnow;
            % Recorre los valores indicados en «first = 1:o.N:numel(audio)» para procesarlos en orden.
            for first = 1:o.N:numel(audio)
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running || ~isvalid(o.Figure)».
                if ~o.Running || ~isvalid(o.Figure)
                    % Termina este recorrido porque ya se alcanzó la condición de salida.
                    break
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza el valor de «block» mediante una operación que limita el resultado por arriba o toma el menor valor.
                block = audio(first:min(first + o.N - 1, end));
                % Convierte el bloque a audio de 16 bits y lo envía sin reiniciar la reproducción.
                % LLAMADA a SalidaContinua.m → escribirBloque: convierte el bloque a audio de 16 bits y lo envía sin reiniciar la reproducción.
                o.BaseWriter.escribirBloque(repmat(block, 1, numel(out)));
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Running».
            if o.Running
                % Espera a que termine el audio enviado mientras atiende la interfaz.
                % LLAMADA a SalidaContinua.m → esperarReproduccion: espera a que termine el audio enviado mientras atiende la interfaz.
                o.BaseWriter.esperarReproduccion();
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% detenerEscucha: Detiene los recursos usados para escuchar una grabación
        function detenerEscucha(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Player)».
            if ~isempty(o.Player)
                % Detiene el reproductor.
                stop(o.Player);
                % Actualiza el reproductor de escucha con el resultado de la expresión indicada.
                o.Player = [];
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter)».
            if ~isempty(o.BaseWriter)
                % Marca la salida como cerrada y libera su conexión de audio.
                % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
                o.BaseWriter.liberarSalida();
                % Actualiza la salida continua alternativa con el resultado de la expresión indicada.
                o.BaseWriter = [];
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% reproducirConDispositivo: Reproduce la toma respetando el dispositivo y los canales seleccionados
        function reproducirConDispositivo(o, audio, fs)
            % La escucha A/B tambien respeta dispositivos/canales manuales.
            % Actualiza el valor de «c» con el resultado de la expresión indicada.
            c = o.Config;
            % Ejecuta el bloque siguiente únicamente si se cumple «~UtilidadesAudio.estaDisponible('audioDeviceWriter')».
            % LLAMADA a UtilidadesAudio.m → estaDisponible: comprueba si matlab puede localizar una función o clase requerida.
            if ~UtilidadesAudio.estaDisponible('audioDeviceWriter')
                % Reproduce bloques sucesivos manteniendo abierta una única salida de audio.
                % LLAMADA a ControladorEstudio.m → reproducirConSalidaContinua: reproduce bloques sucesivos manteniendo abierta una única salida de audio.
                o.reproducirConSalidaContinua(audio, fs, 'Reproduciendo la toma.');
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
                o.Writer = audioDeviceWriter('SampleRate', fs);
                % Actualiza el valor de «device» con el resultado de la expresión indicada.
                device = c.output;
                % Actualiza el valor de «driver» con el resultado de la expresión indicada.
                driver = c.driver;
                % Ejecuta el bloque siguiente únicamente si se cumple «ConfiguracionAudio.esDuplex(c)».
                % LLAMADA a ConfiguracionAudio.m → esDuplex: indica si entrada y salida deben compartir un dispositivo asio.
                if ConfiguracionAudio.esDuplex(c)
                    % Actualiza el valor de «device» con el resultado de la expresión indicada.
                    device = c.input;
                    % Actualiza el valor de «driver» con el resultado de la expresión indicada.
                    driver = 'ASIO';
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «ispc».
                if ispc
                    % Actualiza el valor de «o.Writer.Driver» con el resultado de la expresión indicada.
                    o.Writer.Driver = char(driver);
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «~strcmp(device, 'Default')».
                if ~strcmp(device, 'Default')
                    % Actualiza el valor de «o.Writer.Device» con el resultado de la expresión indicada.
                    o.Writer.Device = char(device);
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza la información proporcionada por el dispositivo con el resultado de la expresión indicada.
                details = info(o.Writer);
                % Actualiza la cantidad de salidas del dispositivo mediante una operación que obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                % LLAMADA a SelectorEntrada.m → limiteDeCanales: obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse.
                maxOut = SelectorEntrada.limiteDeCanales(details, false);
                % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
                out = c.outCh;
                % Ejecuta el bloque siguiente únicamente si se cumple «c.stereo && maxOut > 1».
                if c.stereo && maxOut > 1
                    % Actualiza los canales elegidos para reproducir con el resultado de la expresión indicada.
                    out = [out out + 1];
                % Termina el bloque de instrucciones anterior.
                end
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(max(out) <= maxOut, 'Los canales de salida no existen en este dispositivo.');
                % Actualiza el valor de «o.Writer.ChannelMappingSource» con el resultado de la expresión indicada.
                o.Writer.ChannelMappingSource = 'Property';
                % Actualiza el valor de «o.Writer.ChannelMapping» con el resultado de la expresión indicada.
                o.Writer.ChannelMapping = out;
                % Prepara un dispositivo de Audio Toolbox.
                setup(o.Writer, zeros(o.N, numel(out)));
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch
                % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Writer)».
                if ~isempty(o.Writer)
                    % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                    try
                        % Libera un dispositivo de Audio Toolbox.
                        release(o.Writer);
                    % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                    catch
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
                o.Writer = [];
                % Reproduce bloques sucesivos manteniendo abierta una única salida de audio.
                % LLAMADA a ControladorEstudio.m → reproducirConSalidaContinua: reproduce bloques sucesivos manteniendo abierta una única salida de audio.
                o.reproducirConSalidaContinua(audio, fs, 'Reproduciendo la toma.');
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Activa el indicador que mantiene la ejecución.
            o.Running = true;
            % Actualiza el valor de «cleanup» mediante una operación que libera los recursos de reproducción y comunica que la escucha terminó.
            % LLAMADA a ControladorEstudio.m → finalizarEscucha: libera los recursos de reproducción y comunica que la escucha terminó.
            cleanup = onCleanup(@()o.finalizarEscucha()); %#ok<NASGU>
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('state', struct('running', true, 'message', ...
                                           ['Escuchando en ' details.DeviceName '. Usa Detener para parar.'])); % Completa la operación de «reproducirConDispositivo» con los argumentos o valores indicados.
            % Completa la operación de «reproducirConDispositivo» con los argumentos o valores indicados.
            drawnow;
            % Actualiza el valor de «listenClock» con el resultado de la expresión indicada.
            listenClock = tic;
            % Recorre los valores indicados en «first = 1:o.N:numel(audio)» para procesarlos en orden.
            for first = 1:o.N:numel(audio)
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Running || ~isvalid(o.Figure)».
                if ~o.Running || ~isvalid(o.Figure)
                    % Termina este recorrido porque ya se alcanzó la condición de salida.
                    break
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza la cantidad de elementos que se utilizarán mediante una operación que limita el resultado por arriba o toma el menor valor.
                count = min(o.N, numel(audio) - first + 1);
                % Actualiza el valor de «block» mediante una operación que reserva memoria inicializada en cero.
                block = zeros(o.N, 1);
                % Actualiza el valor de «block(1:count)» con el resultado de la expresión indicada.
                block(1:count) = audio(first:first + count - 1);
                % Repite la señal para distribuirla entre canales.
                o.Writer(repmat(block, 1, numel(out)));
                % Ejecuta el bloque siguiente únicamente si se cumple «toc(listenClock) > .05».
                if toc(listenClock) > .05
                    % Completa la operación de «reproducirConDispositivo» con los argumentos o valores indicados.
                    drawnow limitrate;
                    % Actualiza el valor de «listenClock» con el resultado de la expresión indicada.
                    listenClock = tic;
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% finalizarEscucha: Libera los recursos de reproducción y comunica que la escucha terminó
        function finalizarEscucha(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter)».
            if ~isempty(o.BaseWriter)
                % Marca la salida como cerrada y libera su conexión de audio.
                % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
                o.BaseWriter.liberarSalida();
                % Actualiza la salida continua alternativa con el resultado de la expresión indicada.
                o.BaseWriter = [];
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.Writer)».
            if ~isempty(o.Writer)
                % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                try
                    % Libera un dispositivo de Audio Toolbox.
                    release(o.Writer);
                % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                catch
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
            o.Writer = [];
            % Desactiva el indicador que mantiene la ejecución.
            o.Running = false;
            % Ejecuta el bloque siguiente únicamente si se cumple «isvalid(o.Figure)».
            if isvalid(o.Figure)
                % Ejecuta el bloque siguiente únicamente si se cumple «o.Closing».
                if o.Closing
                    % Libera la salida al destruir el objeto; MATLAB exige conservar el nombre delete.
                    delete(o.Figure);
                % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                else
                    % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                    % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                    o.enviarMensaje('state', struct('running', false, 'message', 'Escucha terminada.'));
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% guardarAjuste: Guarda los parámetros y las bandas activas en un archivo JSON
        function guardarAjuste(o, command)
            % Actualiza el valor de «[f, d]» mediante una operación que solicita el nombre del archivo de salida.
            [f, d] = uiputfile('*.json', 'Guardar ajuste', 'Snare_ajuste.json');
            % Ejecuta el bloque siguiente únicamente si se cumple «isequal(f, 0)».
            if isequal(f, 0)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «fid» mediante una operación que construye una ruta válida.
            fid = fopen(fullfile(d, f), 'w', 'n', 'UTF-8');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(fid ~= -1, 'No se pudo guardar.');
            % Actualiza el valor de «closer» mediante una operación que garantiza la liberación de recursos al terminar o producirse un error.
            closer = onCleanup(@()fclose(fid)); %#ok<NASGU>
            % Recupera los parámetros del mensaje conservando también las bandas desactivadas.
            p = command.p;
            % Actualiza las cuatro bandas del ecualizador con el resultado de la expresión indicada.
            p.eq = command.ui.eq;
            % Escribe el texto del ajuste en el archivo.
            fwrite(fid, jsonencode(struct('version', 4, 'p', p, 'eqOn', command.ui.eqOn)), 'char');
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('notice', struct('message', 'Ajuste guardado.'));
        % Termina el bloque de instrucciones anterior.
        end


        %% cargarAjuste: Lee un ajuste guardado, verifica su compatibilidad y recupera sus parámetros
        function cargarAjuste(o)
            % Actualiza el valor de «[f, d]» mediante una operación que solicita al usuario un archivo.
            [f, d] = uigetfile('*.json', 'Cargar ajuste');
            % Ejecuta el bloque siguiente únicamente si se cumple «isequal(f, 0)».
            if isequal(f, 0)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Lee la estructura guardada en JSON y comprueba su versión.
            s = jsondecode(fileread(fullfile(d, f)));
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(ismember(s.version, [3 4]), 'Version incompatible.');
            % Ejecuta el bloque siguiente únicamente si se cumple «~isfield(s.p, 'notchTypes')».
            if ~isfield(s.p, 'notchTypes')
                % Actualiza la forma notch o campana de cada corte con el resultado de la expresión indicada.
                s.p.notchTypes = [0 0 0];
            % Termina el bloque de instrucciones anterior.
            end
            % Comprueba los ajustes de los filtros y prepara su aplicación al audio.
            % LLAMADA a ControladorEstudio.m → establecerParametros: comprueba los ajustes de los filtros y prepara su aplicación al audio.
            o.establecerParametros(s.p);
            % Actualiza las bandas del ecualizador activas con el resultado de la expresión indicada.
            enabled = true(4, 1);
            % Ejecuta el bloque siguiente únicamente si se cumple «isfield(s, 'eqOn')».
            if isfield(s, 'eqOn')
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(numel(s.eqOn) == 4 && all(ismember(s.eqOn(:), [0 1])), 'Activacion EQ no valida.');
                % Actualiza las bandas del ecualizador activas con el resultado de la expresión indicada.
                enabled = logical(s.eqOn(:));
            % Termina el bloque de instrucciones anterior.
            end
            % Copia los ajustes y anula la ganancia de las bandas de ecualización desactivadas.
            effective = s.p;
            % Actualiza las cuatro bandas del ecualizador con el resultado de la expresión indicada.
            effective.eq(~enabled, 2) = 0;
            % Comprueba los ajustes de los filtros y prepara su aplicación al audio.
            % LLAMADA a ControladorEstudio.m → establecerParametros: comprueba los ajustes de los filtros y prepara su aplicación al audio.
            o.establecerParametros(effective);
            % Comunica resultados y avisos desde MATLAB hacia la interfaz.
            % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
            o.enviarMensaje('preset', struct('p', s.p, 'eqOn', enabled, 'message', 'Ajuste cargado.'));
        % Termina el bloque de instrucciones anterior.
        end


        %% finalizarProcesamiento: Termina la captura, publica el último análisis y libera los dispositivos
        function finalizarProcesamiento(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Detection && ~isempty(o.Analyzer) && o.DetectionSamples > 0 && ...».
            if o.Detection && ~isempty(o.Analyzer) && o.DetectionSamples > 0 && ...
                    (isempty(o.Suggestions) || o.DetectionSamples >= .5 * o.FS) % Actualiza el valor de «(isempty(o.Suggestions) || o.DetectionSamples >» con el resultado de la expresión indicada.
                % Ejecuta el bloque siguiente únicamente si se cumple «o.Analyzer.Count == 0 && numel(o.Analyzer.Buffer) >= 512».
                if o.Analyzer.Count == 0 && numel(o.Analyzer.Buffer) >= 512
                    % Mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                    % LLAMADA a AnalizadorResonancias.m → analizarVentana: mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                    o.Analyzer.analizarVentana(o.Analyzer.Buffer);
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza las sugerencias del análisis mediante una operación que elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
                % LLAMADA a AnalizadorResonancias.m → obtenerSugerencias: elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
                o.Suggestions = o.Analyzer.obtenerSugerencias();
                % Actualiza el número de revisión de las sugerencias con el resultado de la expresión indicada.
                o.SuggestionVersion = o.SuggestionVersion + 1;
            % Termina el bloque de instrucciones anterior.
            end
            % Desactiva el indicador que mantiene la ejecución.
            o.Running = false;
            % Desactiva el indicador de procesamiento activo.
            o.Processing = false;
            % Desactiva la activación del análisis de resonancias.
            o.Detection = false;
            % Al terminar una toma en vivo, recupera el golpe seleccionado en lugar del silencio final.
            if ~isempty(o.VentanaConservada)
                % Usa la misma ventana para las gráficas de entrada y salida, sin modificar la grabación A/B.
                o.Scope = o.VentanaConservada;
                % Recupera las etapas correspondientes al mismo instante del golpe.
                o.StageScope = o.EtapasConservadas;
            % Termina la recuperación de las gráficas conservadas.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.BaseWriter)».
            if ~isempty(o.BaseWriter)
                % Marca la salida como cerrada y libera su conexión de audio.
                % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
                o.BaseWriter.liberarSalida();
                % Actualiza la salida continua alternativa con el resultado de la expresión indicada.
                o.BaseWriter = [];
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «objects» con el resultado de la expresión indicada.
            objects = {o.Reader, o.Writer, o.Duplex};
            % Recorre los valores indicados en «k = 1:3» para procesarlos en orden.
            for k = 1:3
                % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(objects{k})».
                if ~isempty(objects{k})
                    % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                    try
                        % Libera un dispositivo de Audio Toolbox.
                        release(objects{k});
                    % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                    catch
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el lector del dispositivo de entrada con el resultado de la expresión indicada.
            o.Reader = [];
            % Actualiza el reproductor de Audio Toolbox con el resultado de la expresión indicada.
            o.Writer = [];
            % Actualiza el dispositivo compartido de captura y reproducción con el resultado de la expresión indicada.
            o.Duplex = [];
            % Ejecuta el bloque siguiente únicamente si se cumple «isvalid(o.Figure)».
            if isvalid(o.Figure)
                % Ejecuta el bloque siguiente únicamente si se cumple «o.Closing».
                if o.Closing
                    % Libera la salida al destruir el objeto; MATLAB exige conservar el nombre delete.
                    delete(o.Figure);
                % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                else
                    % Prepara un aviso adicional solo cuando existe una gráfica conservada de la toma en vivo.
                    avisoGrafica = '';
                    % Comprueba si la toma incluyó una ventana con señal de entrada.
                    if ~isempty(o.VentanaConservada)
                        % Explica que la gráfica permanece disponible después de los golpes.
                        avisoGrafica = ' Grafica del golpe conservada.';
                    % Termina la preparación del aviso de conservación.
                    end
                    % Reúne mediciones, espectros y estados para actualizar los controles visibles.
                    % LLAMADA a ControladorEstudio.m → actualizarPantalla: reúne mediciones, espectros y estados para actualizar los controles visibles.
                    o.actualizarPantalla();
                    % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                    % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                    o.enviarMensaje('state', struct('running', false, 'message', sprintf( ...
                                                                                     'Detenido. %.1f s A/B disponibles. Perdidas IN/OUT: %d/%d muestras.%s', ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                                                                                     o.CaptureCount / o.CaptureFS, o.TotalOver, o.TotalUnder, avisoGrafica), ... % Continúa la expresión anterior con sus condiciones o valores complementarios.
                                                   'suggestions', o.Suggestions, 'suggestionVersion', o.SuggestionVersion)); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                    % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.LastError)».
                    if ~isempty(o.LastError)
                        % Completa la operación de «finalizarProcesamiento» con los argumentos o valores indicados.
                        drawnow;
                        % Comunica resultados y avisos desde MATLAB hacia la interfaz.
                        % LLAMADA a ControladorEstudio.m → enviarMensaje: comunica resultados y avisos desde matlab hacia la interfaz.
                        o.enviarMensaje('error', struct('message', o.LastError));
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end


        %% cerrarAplicacion: Solicita la detención del audio y cierra la ventana cuando es posible
        function cerrarAplicacion(o)
            % Detiene los recursos usados para escuchar una grabación.
            % LLAMADA a ControladorEstudio.m → detenerEscucha: detiene los recursos usados para escuchar una grabación.
            o.detenerEscucha();
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Running».
            if o.Running
                % Activa la solicitud de cierre.
                o.Closing = true;
                % Desactiva el indicador que mantiene la ejecución.
                o.Running = false;
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Libera la salida al destruir el objeto; MATLAB exige conservar el nombre delete.
                delete(o.Figure);
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
