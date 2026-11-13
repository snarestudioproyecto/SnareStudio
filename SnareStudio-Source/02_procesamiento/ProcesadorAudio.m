% PROCESADORAUDIO: Crea el motor de filtros y reserva la memoria necesaria entre bloques.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «ProcesadorAudio» y los datos que conserva durante la sesión.
% Heredar de handle permite compartir una referencia al mismo objeto entre funciones.
% Así, los métodos trabajan sobre el mismo estado y se evitan copias innecesarias del
% objeto y de sus buffers de audio al modificarlo desde distintas partes del programa.
% Esto reduce el uso innecesario de RAM; no elimina todas las asignaciones de memoria.
classdef ProcesadorAudio < handle
    % Motor causal mono. MATLAB base; Audio Toolbox solo para E/S en la app.
    % Agrupa los datos que pertenecen al módulo y que se conservan entre llamadas.
    properties
        % Conserva la frecuencia de muestreo para las operaciones de este módulo.
        Fs
        % Conserva los parámetros de procesamiento para las operaciones de este módulo.
        P
        % Conserva los coeficientes de los filtros en cascada para las operaciones de este módulo.
        SOS
        % Conserva los estados internos de los filtros para las operaciones de este módulo.
        Z
        % Actualiza los límites entre etapas de la cadena con el resultado de la expresión indicada.
        Boundaries = [0 0]
        % Actualiza los límites de la cadena anterior con el resultado de la expresión indicada.
        OldBoundaries = [0 0]
        % Inicializa los coeficientes de la cadena anterior como vacío hasta que se disponga de datos.
        OldSOS = []
        % Inicializa los estados de los filtros anteriores como vacío hasta que se disponga de datos.
        OldZ = []
        % Establece las muestras pendientes de la transición en 0.
        Fade = 0
        % Actualiza las muestras previas que preparan los nuevos filtros mediante una operación que reserva memoria inicializada en cero.
        % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
        % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
        History = zeros(8192, 1)
        % Establece la ganancia suavizada de entrada en 1.
        InputGain = 1
        % Establece la ganancia suavizada de salida en 0.
        OutputGain = 0
        % Establece la proporción de señal procesada en 1.
        Wet = 1
        % Establece el nivel instantáneo suavizado de la señal en 0.
        Envelope = 0
        % Establece la ganancia aplicada por la puerta en 1.
        GateGain = 1
        % Establece la reducción del compresor en decibelios en 0.
        CompDB = 0
        % Establece el tiempo restante de mantenimiento de la puerta en 0.
        GateHold = 0
        % Desactiva el estado abierto o cerrado de la puerta.
        GateOpen = false
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo.
    methods

        % Crea el motor de filtros y reserva la memoria necesaria entre bloques.
        function obj = ProcesadorAudio(fs, p)
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 1».
            if nargin < 1
                % Establece la frecuencia de muestreo en 48000.
                fs = 48000;
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 2».
            if nargin < 2
                % Actualiza los parámetros del procesamiento mediante una operación que define los ajustes con los que comienza una sesión.
                % LLAMADA a ProcesadorAudio.m → parametrosIniciales: define los ajustes con los que comienza una sesión.
                p = ProcesadorAudio.parametrosIniciales();
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            obj.Fs = fs;
            % Actualiza los parámetros de procesamiento con el resultado de la expresión indicada.
            obj.P = p;
            % Actualiza el valor de «[obj.SOS, obj.Boundaries]» mediante una operación que construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            % LLAMADA a ProcesadorAudio.m → disenarCadena: construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            [obj.SOS, obj.Boundaries] = ProcesadorAudio.disenarCadena(fs, p);
            % Actualiza los estados internos de los filtros mediante una operación que reserva memoria inicializada en cero.
            obj.Z = zeros(2, size(obj.SOS, 1));
        % Termina el bloque de instrucciones anterior.
        end


        %% configurarFiltros: Diseña los nuevos filtros y prepara una transición breve desde los anteriores
        function configurarFiltros(obj, p)
            % Actualiza el valor de «[s, boundaries]» mediante una operación que construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            % LLAMADA a ProcesadorAudio.m → disenarCadena: construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador.
            [s, boundaries] = ProcesadorAudio.disenarCadena(obj.Fs, p);
            % Ejecuta el bloque siguiente únicamente si se cumple «~isequal(s, obj.SOS) || ~isequal(boundaries, obj.Boundaries)».
            if ~isequal(s, obj.SOS) || ~isequal(boundaries, obj.Boundaries)
                % Actualiza los coeficientes de la cadena anterior con el resultado de la expresión indicada.
                obj.OldSOS = obj.SOS;
                % Actualiza los estados de los filtros anteriores con el resultado de la expresión indicada.
                obj.OldZ = obj.Z;
                % Actualiza los límites de la cadena anterior con el resultado de la expresión indicada.
                obj.OldBoundaries = obj.Boundaries;
                % Actualiza los coeficientes de los filtros en cascada con el resultado de la expresión indicada.
                obj.SOS = s;
                % Actualiza los límites entre etapas de la cadena con el resultado de la expresión indicada.
                obj.Boundaries = boundaries;
                % Actualiza el valor de «[~, obj.Z]» mediante una operación que aplica los filtros uno después de otro y conserva sus estados entre bloques.
                % LLAMADA a ProcesadorAudio.m → aplicarCascada: aplica los filtros uno después de otro y conserva sus estados entre bloques.
                [~, obj.Z] = ProcesadorAudio.aplicarCascada(obj.History, s, zeros(2, size(s, 1)));
                % Establece una transición de 30 ms para pasar de los filtros anteriores a los nuevos.
                obj.Fade = round(0.03 * obj.Fs);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los parámetros de procesamiento con el resultado de la expresión indicada.
            obj.P = p;
        % Termina el bloque de instrucciones anterior.
        end

        %% procesarBloque: Procesa un bloque conservando la memoria de filtros, puerta y compresor
        function [y, stats, stages] = procesarBloque(obj, x)
            % Actualiza las muestras de entrada mediante una operación que convierte los datos a precisión doble.
            x = double(x(:));
            % Cuenta las muestras de este bloque.
            n = numel(x);
            % Toma una copia local de los parámetros para procesar el bloque.
            p = obj.P;
            % Actualiza el valor de «[g, obj.InputGain]» mediante una operación que acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            % LLAMADA a ProcesadorAudio.m → suavizarCambio: acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            [g, obj.InputGain] = ProcesadorAudio.suavizarCambio(obj.InputGain, 10^(p.inputDB / 20), n, obj.Fs);
            % Aplica a la entrada la ganancia suavizada, muestra por muestra.
            dry = x .* g;
            % Actualiza el valor de «[wet, obj.Z, stages]» mediante una operación que aplica los filtros uno después de otro y conserva sus estados entre bloques.
            % LLAMADA a ProcesadorAudio.m → aplicarCascada: aplica los filtros uno después de otro y conserva sus estados entre bloques.
            [wet, obj.Z, stages] = ProcesadorAudio.aplicarCascada(dry, obj.SOS, obj.Z, obj.Boundaries);
            % Ejecuta el bloque siguiente únicamente si se cumple «obj.Fade > 0».
            if obj.Fade > 0
                % Actualiza el valor de «[old, obj.OldZ, oldStages]» mediante una operación que aplica los filtros uno después de otro y conserva sus estados entre bloques.
                % LLAMADA a ProcesadorAudio.m → aplicarCascada: aplica los filtros uno después de otro y conserva sus estados entre bloques.
                [old, obj.OldZ, oldStages] = ProcesadorAudio.aplicarCascada(dry, obj.OldSOS, obj.OldZ, obj.OldBoundaries);
                % Convierte los 30 ms de transición a un número de muestras.
                total = round(0.03 * obj.Fs);
                % Calcula el avance de la transición entre filtros, desde cero hasta uno.
                a = min(1, (total - obj.Fade + (1:n)') / total);
                % Aplica la misma transición a las mediciones de las etapas para que sigan el audio.
                stages = (1 - a) .* oldStages + a .* stages;
                % Mezcla gradualmente el filtro anterior con el nuevo durante la transición de 30 ms.
                wet = (1 - a) .* old + a .* wet;
                % Actualiza las muestras pendientes de la transición mediante una operación que limita el resultado por abajo o toma el mayor valor.
                obj.Fade = max(0, obj.Fade - n);
            % Termina el bloque de instrucciones anterior.
            end
            % Une el historial anterior con la señal de entrada actual.
            h = [obj.History; dry];
            % Conserva las últimas 8192 muestras para preparar cambios de filtro sin comenzar desde silencio.
            obj.History = h(end - 8191:end);
            % Envolvente pico y dinamica con estados persistentes entre bloques.
            % Actualiza la suavización del ataque de la envolvente mediante una operación que calcula un factor exponencial de suavización.
            envA = exp(-1 / (0.0005 * obj.Fs));
            % Actualiza la suavización de la caída de la envolvente mediante una operación que calcula un factor exponencial de suavización.
            envR = exp(-1 / (0.05 * obj.Fs));
            % Actualiza la suavización de apertura de puerta mediante una operación que calcula un factor exponencial de suavización.
            ga = exp(-1 / (p.gateAttack * 0.001 * obj.Fs));
            % Actualiza la suavización de cierre de puerta mediante una operación que calcula un factor exponencial de suavización.
            gr = exp(-1 / (p.gateRelease * 0.001 * obj.Fs));
            % Actualiza la suavización del ataque del compresor mediante una operación que calcula un factor exponencial de suavización.
            ca = exp(-1 / (p.compAttack * 0.001 * obj.Fs));
            % Actualiza la suavización de recuperación del compresor mediante una operación que calcula un factor exponencial de suavización.
            cr = exp(-1 / (p.compRelease * 0.001 * obj.Fs));
            % Actualiza el nivel instantáneo suavizado de la señal con el resultado de la expresión indicada.
            Envelope = obj.Envelope;
            % Actualiza la ganancia aplicada por la puerta con el resultado de la expresión indicada.
            GateGain = obj.GateGain;
            % Actualiza el tiempo restante de mantenimiento de la puerta con el resultado de la expresión indicada.
            GateHold = obj.GateHold;
            % Actualiza el estado abierto o cerrado de la puerta con el resultado de la expresión indicada.
            GateOpen = obj.GateOpen;
            % Actualiza la reducción del compresor en decibelios con el resultado de la expresión indicada.
            CompDB = obj.CompDB;
            % Actualiza la duración de mantenimiento de puerta en muestras mediante una operación que redondea el resultado.
            holdSamples = round(0.001 * p.gateHold * obj.Fs);
            % Actualiza la ganancia de la puerta cerrada con el resultado de la expresión indicada.
            closedGain = 10^(-p.gateRange / 20);
            % Recorre los valores indicados en «k = 1:n» para procesarlos en orden.
            for k = 1:n
                % Obtiene la amplitud absoluta de la muestra que controla la dinámica.
                v = abs(wet(k));
                % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                c = envR;
                % Ejecuta el bloque siguiente únicamente si se cumple «v > Envelope».
                if v > Envelope
                    % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                    c = envA;
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza una estimación suave del nivel para que puerta y compresor no reaccionen bruscamente.
                Envelope = c * Envelope + (1 - c) * v;
                % Actualiza el nivel detectado mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
                level = 20 * log10(max(Envelope, 1e-12));
                % Ejecuta el bloque siguiente únicamente si se cumple «level >= p.gateThreshold».
                if level >= p.gateThreshold
                    % Activa el estado abierto o cerrado de la puerta.
                    GateOpen = true;
                    % Actualiza el tiempo restante de mantenimiento de la puerta con el resultado de la expresión indicada.
                    GateHold = holdSamples;
                % Evalúa una condición alternativa: «level < p.gateThreshold - 3».
                elseif level < p.gateThreshold - 3
                    % Consume una muestra del tiempo de mantenimiento sin permitir valores negativos.
                    GateHold = max(0, GateHold - 1);
                    % Ejecuta el bloque siguiente únicamente si se cumple «GateHold == 0».
                    if GateHold == 0
                        % Desactiva el estado abierto o cerrado de la puerta.
                        GateOpen = false;
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
                % Establece el valor de ganancia hacia el que se realiza la transición en 1.
                target = 1;
                % Ejecuta el bloque siguiente únicamente si se cumple «p.gateOn && ~GateOpen».
                if p.gateOn && ~GateOpen
                    % Actualiza el valor de ganancia hacia el que se realiza la transición con el resultado de la expresión indicada.
                    target = closedGain;
                % Termina el bloque de instrucciones anterior.
                end
                % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                c = gr;
                % Ejecuta el bloque siguiente únicamente si se cumple «target > GateGain».
                if target > GateGain
                    % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                    c = ga;
                % Termina el bloque de instrucciones anterior.
                end
                % Acerca la ganancia de la puerta a su objetivo usando el tiempo de apertura o cierre.
                GateGain = c * GateGain + (1 - c) * target;
                % Establece la reducción solicitada al compresor en 0.
                reduction = 0;
                % Ejecuta el bloque siguiente únicamente si se cumple «p.compOn».
                if p.compOn
                    % Calcula la reducción en dB solo cuando el nivel supera el umbral del compresor.
                    reduction = -(1 - 1 / p.ratio) * max(0, level - p.compThreshold);
                % Termina el bloque de instrucciones anterior.
                end
                % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                c = cr;
                % Ejecuta el bloque siguiente únicamente si se cumple «reduction < CompDB».
                if reduction < CompDB
                    % Selecciona el factor de suavización que corresponde al ataque o a la recuperación.
                    c = ca;
                % Termina el bloque de instrucciones anterior.
                end
                % Suaviza la reducción del compresor respetando sus tiempos de ataque y recuperación.
                CompDB = c * CompDB + (1 - c) * reduction;
                % Aplica a esta muestra la puerta y convierte la reducción del compresor de dB a ganancia lineal.
                wet(k) = wet(k) * GateGain * 10^(CompDB / 20);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el nivel instantáneo suavizado de la señal con el resultado de la expresión indicada.
            obj.Envelope = Envelope;
            % Actualiza la ganancia aplicada por la puerta con el resultado de la expresión indicada.
            obj.GateGain = GateGain;
            % Actualiza el tiempo restante de mantenimiento de la puerta con el resultado de la expresión indicada.
            obj.GateHold = GateHold;
            % Actualiza el estado abierto o cerrado de la puerta con el resultado de la expresión indicada.
            obj.GateOpen = GateOpen;
            % Actualiza la reducción del compresor en decibelios con el resultado de la expresión indicada.
            obj.CompDB = CompDB;
            % Actualiza el valor de «[mix, obj.Wet]» mediante una operación que acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            % LLAMADA a ProcesadorAudio.m → suavizarCambio: acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            [mix, obj.Wet] = ProcesadorAudio.suavizarCambio(obj.Wet, double(~p.bypass), n, obj.Fs);
            % Combina la señal directa y la procesada según la transición del botón BYPASS.
            y = dry .* (1 - mix) + wet .* mix;
            % Actualiza el valor de ganancia hacia el que se realiza la transición mediante una operación que convierte los datos a precisión doble.
            target = 10^(p.outputDB / 20) * double(~p.mute);
            % Actualiza el valor de «[g, obj.OutputGain]» mediante una operación que acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            % LLAMADA a ProcesadorAudio.m → suavizarCambio: acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos.
            [g, obj.OutputGain] = ProcesadorAudio.suavizarCambio(obj.OutputGain, target, n, obj.Fs);
            % Aplica la ganancia final suavizada, incluyendo el estado de MUTE.
            y = y .* g;
            % Ejecuta el bloque siguiente únicamente si se cumple «any(~isfinite(y))».
            if any(~isfinite(y))
                % Detiene esta operación e informa la causa.
                error('SnareDSPV4:NonFinite', 'Salida no finita; audio detenido.');
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «stats.clipped» mediante una operación que obtiene la magnitud.
            stats.clipped = sum(abs(y) > 10^(-1 / 20));
            % Tope de seguridad de muestras a -1 dBFS. NO es limitador true-peak.
            % Recorta las muestras al tope de −1 dBFS; esta protección no mide picos entre muestras.
            y = max(-10^(-1 / 20), min(10^(-1 / 20), y));
            % Actualiza el valor de «stats.inputPeak» mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
            stats.inputPeak = 20 * log10(max(max(abs(x)), 1e-12));
            % Actualiza el valor de «stats.outputPeak» mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
            stats.outputPeak = 20 * log10(max(max(abs(y)), 1e-12));
            % Actualiza el valor de «stats.compression» con el resultado de la expresión indicada.
            stats.compression = -obj.CompDB;
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% procesarGrabacion: Aplica el mismo procesamiento a todos los bloques de una grabación
        function y = procesarGrabacion(x, fs, p, block)
            % Escucha de archivo/captura usando el mismo DSP y sus estados.
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 4».
            if nargin < 4
                % Establece el valor de «block» en 256.
                block = 256;
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «engine» mediante una operación que crea el motor de filtros y reserva la memoria necesaria entre bloques.
            % LLAMADA a ProcesadorAudio.m → ProcesadorAudio: crea el objeto que conserva los datos de este módulo.
            engine = ProcesadorAudio(fs, p);
            % Actualiza las muestras de entrada mediante una operación que convierte los datos a precisión doble.
            x = double(x(:));
            % Actualiza las muestras de salida mediante una operación que reserva memoria inicializada en cero.
            y = zeros(size(x));
            % Recorre los valores indicados en «first = 1:block:numel(x)» para procesarlos en orden.
            for first = 1:block:numel(x)
                % Actualiza los índices de las muestras seleccionadas mediante una operación que limita el resultado por arriba o toma el menor valor.
                ix = first:min(first + block - 1, numel(x));
                % Actualiza las muestras de salida mediante una operación que procesa un bloque conservando la memoria de filtros, puerta y compresor.
                % LLAMADA a ProcesadorAudio.m → procesarBloque: procesa un bloque conservando la memoria de filtros, puerta y compresor.
                y(ix) = engine.procesarBloque(x(ix));
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% parametrosIniciales: Define los ajustes con los que comienza una sesión
        function p = parametrosIniciales()
            % Establece la ganancia de entrada en dB en 0.
            p.inputDB = 0;
            % Establece la ganancia de salida en dB en -12.
            p.outputDB = -12;
            % Desactiva el silencio de la salida.
            p.mute = false;
            % Desactiva la comparación con el procesamiento omitido.
            p.bypass = false;
            % Activa la activación del pasaaltos.
            p.hpOn = true;
            % Establece la frecuencia de corte del pasaaltos en 60.
            p.hpHz = 60;
            % columnas: activo, frecuencia Hz, Q, atenuacion positiva dB/pasada
            % Define cada resonancia como [activa, frecuencia Hz, Q, corte dB]; solo la primera comienza activa.
            p.notches = [1 340 15 12; 0 520 15 12; 0 720 15 12];
            % Establece el número de pasadas del banco en 1.
            p.passes = 1;
            % Selecciona notch en las tres bandas; el valor uno seleccionaría campana.
            p.notchTypes = [0 0 0];
            % graves shelf, medios bajos peak, presencia peak, brillo shelf
            % Define graves, medios, presencia y brillo como [frecuencia Hz, ganancia dB, Q].
            p.eq = [120 0 0.707; 500 0 1.5; 2500 0 1.2; 8000 0 0.707];
            % Desactiva la activación de la puerta.
            p.gateOn = false;
            % Establece el umbral de la puerta en -45.
            p.gateThreshold = -45;
            % Establece la atenuación de la puerta cerrada en 30.
            p.gateRange = 30;
            % Establece el tiempo de apertura de la puerta en 1.
            p.gateAttack = 1;
            % Establece el tiempo de cierre de la puerta en 150.
            p.gateRelease = 150;
            % Establece el tiempo de mantenimiento de la puerta en 80.
            p.gateHold = 80;
            % Desactiva la activación del compresor.
            p.compOn = false;
            % Establece el umbral del compresor en -18.
            p.compThreshold = -18;
            % Establece la proporción de compresión en 3.
            p.ratio = 3;
            % Establece el tiempo de ataque del compresor en 10.
            p.compAttack = 10;
            % Establece el tiempo de recuperación del compresor en 100.
            p.compRelease = 100;
        % Termina el bloque de instrucciones anterior.
        end

        %% disenarCadena: Construye los filtros en el orden pasaaltos, banco de resonancias y ecualizador
        function [s, boundaries] = disenarCadena(fs, p)
            % Reserva o amplía la matriz donde cada fila contiene los seis coeficientes de un filtro.
            s = zeros(0, 6);
            % Ejecuta el bloque siguiente únicamente si se cumple «p.hpOn».
            if p.hpOn
                % Actualiza los coeficientes de la cadena mediante una operación que calcula los coeficientes de un filtro digital de segundo orden.
                % LLAMADA a ProcesadorAudio.m → calcularFiltro: calcula los coeficientes de un filtro digital de segundo orden.
                s(end + 1, :) = ProcesadorAudio.calcularFiltro('hp', fs, p.hpHz, 1 / sqrt(2), 0);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza la cantidad de filtros anteriores al banco de resonancias mediante una operación que consulta las dimensiones.
            beforeNotch = size(s, 1);
            % Recorre los valores indicados en «j = 1:p.passes» para procesarlos en orden.
            for j = 1:p.passes
                % Recorre los valores indicados en «k = 1:size(p.notches, 1)» para procesarlos en orden.
                for k = 1:size(p.notches, 1)
                    % Lee los parámetros de la banda que se está diseñando.
                    r = p.notches(k, :);
                    % Ejecuta el bloque siguiente únicamente si se cumple «r(1)».
                    if r(1)
                        % Actualiza la selección de la forma campana con el resultado de la expresión indicada.
                        bell = isfield(p, 'notchTypes') && p.notchTypes(k) == 1;
                        % Ejecuta el bloque siguiente únicamente si se cumple «bell».
                        if bell
                            % Calcula los seis coeficientes de la forma de corte seleccionada.
                            % LLAMADA a ProcesadorAudio.m → calcularFiltro: calcula los coeficientes de un filtro digital de segundo orden.
                            v = ProcesadorAudio.calcularFiltro('peak', fs, r(2), r(3), -r(4));
                        % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                        else
                            % Calcula los seis coeficientes de la forma de corte seleccionada.
                            % LLAMADA a ProcesadorAudio.m → calcularFiltro: calcula los coeficientes de un filtro digital de segundo orden.
                            v = ProcesadorAudio.calcularFiltro('notch', fs, r(2), r(3), 0);
                            % Convierte la profundidad de corte en dB a una proporción de amplitud lineal.
                            d = 10^(-r(4) / 20);
                            % Mezcla el notch con una vía directa para fijar una profundidad finita de corte por pasada.
                            v(1:3) = d * v(4:6) + (1 - d) * v(1:3);
                        % Termina el bloque de instrucciones anterior.
                        end
                        % Actualiza los coeficientes de la cadena con el resultado de la expresión indicada.
                        s(end + 1, :) = v; %#ok<AGROW>
                    % Termina el bloque de instrucciones anterior.
                    end
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Guarda las posiciones que permiten medir antes y después del banco de resonancias.
            boundaries = [beforeNotch size(s, 1)];
            % Actualiza los tipos de las cuatro bandas del ecualizador con el resultado de la expresión indicada.
            types = {'low', 'peak', 'peak', 'high'};
            % Recorre los valores indicados en «k = 1:4» para procesarlos en orden.
            for k = 1:4
                % Lee los parámetros de la banda que se está diseñando.
                r = p.eq(k, :);
                % Actualiza los coeficientes de la cadena mediante una operación que calcula los coeficientes de un filtro digital de segundo orden.
                % LLAMADA a ProcesadorAudio.m → calcularFiltro: calcula los coeficientes de un filtro digital de segundo orden.
                s(end + 1, :) = ProcesadorAudio.calcularFiltro(types{k}, fs, r(1), r(3), r(2)); %#ok<AGROW>
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% calcularFiltro: Calcula los coeficientes de un filtro digital de segundo orden
        function s = calcularFiltro(type, fs, f, q, g)
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(isfinite(f) && f > 0 && f < fs / 2, 'Frecuencia fuera de Nyquist.');
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(isfinite(q) && q > 0 && isfinite(g), 'Q/ganancia no validos.');
            % Convierte la frecuencia central de Hz a radianes por muestra.
            w = 2 * pi * f / fs;
            % Calcula el coseno de la frecuencia angular para formar los coeficientes.
            c = cos(w);
            % Relaciona el seno de la frecuencia con Q; un Q mayor produce una banda más estrecha.
            al = sin(w) / (2 * q);
            % Convierte la ganancia en dB al factor de amplitud utilizado por estas ecuaciones.
            A = 10^(g / 40);
            % Selecciona la operación correspondiente al valor de «type».
            switch type
                % Diseña el pasaaltos, que reduce las frecuencias por debajo del corte.
                case 'hp'
                    % Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
                    b = [(1 + c) / 2 -(1 + c) (1 + c) / 2];
                    % Define los coeficientes que realimentan las muestras de salida anteriores.
                    a = [1 + al -2 * c 1 - al];
                % Diseña la muesca que atenúa una frecuencia central y deja pasar las frecuencias alejadas.
                case 'notch'
                    % Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
                    b = [1 -2 * c 1];
                    % Define los coeficientes que realimentan las muestras de salida anteriores.
                    a = [1 + al -2 * c 1 - al];
                % Diseña la banda de campana, que aumenta o reduce una zona alrededor de la frecuencia central.
                case 'peak'
                    % Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
                    b = [1 + al * A -2 * c 1 - al * A];
                    % Define los coeficientes que realimentan las muestras de salida anteriores.
                    a = [1 + al / A -2 * c 1 - al / A];
                % Diseña la banda de graves con ganancia tipo estantería y pendiente fija.
                case 'low'
                    % Shelf slope S=1; Q no se utiliza en shelves.
                    % Calcula el término auxiliar de las bandas de graves y brillo con pendiente fija.
                    t = sqrt(2 * A) * sin(w);
                    % Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
                    b = A * [(A + 1) - (A - 1) * c + t 2 * ((A - 1) - (A + 1) * c) (A + 1) - (A - 1) * c - t];
                    % Define los coeficientes que realimentan las muestras de salida anteriores.
                    a = [(A + 1) + (A - 1) * c + t -2 * ((A - 1) + (A + 1) * c) (A + 1) + (A - 1) * c - t];
                % Diseña la banda de brillo con ganancia tipo estantería y pendiente fija.
                case 'high'
                    % Calcula el término auxiliar de las bandas de graves y brillo con pendiente fija.
                    t = sqrt(2 * A) * sin(w);
                    % Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
                    b = A * [(A + 1) + (A - 1) * c + t -2 * ((A - 1) + (A + 1) * c) (A + 1) + (A - 1) * c - t];
                    % Define los coeficientes que realimentan las muestras de salida anteriores.
                    a = [(A + 1) - (A - 1) * c + t 2 * ((A - 1) - (A + 1) * c) (A + 1) - (A - 1) * c - t];
                % Atiende una opción no contemplada en los casos anteriores.
                otherwise
                    % Detiene esta operación e informa la causa.
                    error('Tipo de filtro desconocido.');
            % Termina el bloque de instrucciones anterior.
            end
            % Normaliza todos los coeficientes para que el primer coeficiente del denominador sea uno.
            s = [b / a(1) a / a(1)];
            % Verifica que los polos estén dentro del círculo unitario para mantener estable el filtro.
            assert(all(abs(roots(s(4:6))) < 1), 'Filtro inestable.');
        % Termina el bloque de instrucciones anterior.
        end

        %% aplicarCascada: Aplica los filtros uno después de otro y conserva sus estados entre bloques
        function [y, z, taps] = aplicarCascada(x, s, z, boundaries)
            % Actualiza las muestras de salida con el resultado de la expresión indicada.
            y = x;
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 4».
            if nargin < 4
                % Actualiza las posiciones que separan las etapas de filtrado mediante una operación que consulta las dimensiones.
                boundaries = [0 size(s, 1)];
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza las salidas intermedias de la cadena mediante una operación que repite la señal para distribuirla entre canales.
            taps = repmat(x, 1, 3);
            % Recorre los valores indicados en «k = 1:size(s, 1)» para procesarlos en orden.
            for k = 1:size(s, 1)
                % Filtra usando los tres coeficientes de entrada y los tres de salida; recupera la memoria para el siguiente bloque.
                [y, z(:, k)] = filter(s(k, 1:3), s(k, 4:6), y, z(:, k));
                % Ejecuta el bloque siguiente únicamente si se cumple «k == boundaries(1)».
                if k == boundaries(1)
                    % Actualiza las salidas intermedias de la cadena con el resultado de la expresión indicada.
                    taps(:, 1) = y;
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «k == boundaries(2)».
                if k == boundaries(2)
                    % Actualiza las salidas intermedias de la cadena con el resultado de la expresión indicada.
                    taps(:, 2) = y;
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza las salidas intermedias de la cadena con el resultado de la expresión indicada.
            taps(:, 3) = y;
        % Termina el bloque de instrucciones anterior.
        end

        %% suavizarCambio: Acerca gradualmente una ganancia al nuevo valor para reducir cambios bruscos
        function [v, last] = suavizarCambio(previous, target, n, fs)
            % Calcula una transición exponencial de 10 ms entre la ganancia anterior y la nueva.
            v = target + (previous - target) * exp(-(1:n)' / (0.01 * fs));
            % Conserva la última ganancia calculada para continuar desde ella en el siguiente bloque.
            last = v(end);
        % Termina el bloque de instrucciones anterior.
        end

        %% frecuenciasDeGrafica: Añade puntos alrededor de cada banda para dibujar con detalle su respuesta
        function f = frecuenciasDeGrafica(p)
            % Reúne la frecuencia y el factor Q de las bandas de resonancias y del ecualizador.
            bands = [p.notches(:, [2 3]); p.eq(:, [1 3])];
            % Construye o amplía las frecuencias utilizadas para representar la respuesta.
            % logspace distribuye las frecuencias en una escala logarítmica: intervalos con
            % la misma proporción ocupan espacios iguales en el eje de la gráfica de audio.
            % Esta malla sirve para representar la respuesta junto al espectro FFT; no calcula
            % la FFT ni cambia la separación lineal de sus frecuencias de análisis.
            f = logspace(log10(20), log10(20000), 480);
            % Recorre los valores indicados en «k = 1:size(bands, 1)» para procesarlos en orden.
            for k = 1:size(bands, 1)
                % Define desplazamientos logarítmicos alrededor de la frecuencia central según su Q.
                ex = max(-20, min(20, (-80:80) / 5 / bands(k, 2)));
                % Construye o amplía las frecuencias utilizadas para representar la respuesta.
                f = [f bands(k, 1) * exp(ex)]; %#ok<AGROW>
            % Termina el bloque de instrucciones anterior.
            end
            % Construye o amplía las frecuencias utilizadas para representar la respuesta.
            f = unique(f(f >= 20 & f <= 20000));
        % Termina el bloque de instrucciones anterior.
        end

        %% respuestaEnFrecuencia: Evalúa cuánto modifica la cadena cada frecuencia solicitada
        function h = respuestaEnFrecuencia(s, f, fs)
            % Representa el retardo de una muestra para cada frecuencia mediante una exponencial compleja.
            z = exp(-1i * 2 * pi * f(:) / fs);
            % Inicializa o acumula la respuesta combinada multiplicando las respuestas de los filtros.
            h = ones(size(z));
            % Recorre los valores indicados en «k = 1:size(s, 1)» para procesarlos en orden.
            for k = 1:size(s, 1)
                % Inicializa o acumula la respuesta combinada multiplicando las respuestas de los filtros.
                h = h .* (s(k, 1) + s(k, 2) * z + s(k, 3) * z.^2) ./ (1 + s(k, 5) * z + s(k, 6) * z.^2);
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
