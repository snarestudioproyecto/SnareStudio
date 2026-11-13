% UTILIDADESAUDIO: Definición de datos y operaciones del módulo.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «UtilidadesAudio» y los datos que conserva durante la sesión.
classdef UtilidadesAudio
    % Compatibilidad con MATLAB base; ninguna dependencia de Audio Toolbox.
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% estaDisponible: Comprueba si MATLAB puede localizar una función o clase requerida
        function yes = estaDisponible(name)
            % Comprueba si el nombre existe como archivo o como clase en esta instalación de MATLAB.
            yes = exist(name, 'file') ~= 0 || exist(name, 'class') == 8;
        % Termina el bloque de instrucciones anterior.
        end

        %% listarDispositivos: Obtiene los nombres de los dispositivos disponibles para esta vía de audio
        function names = listarDispositivos(input)
            % Actualiza la proporción de señal original que limita la profundidad del notch con el resultado de la expresión indicada.
            d = audiodevinfo;
            % Ejecuta el bloque siguiente únicamente si se cumple «input».
            if input
                % Actualiza el valor de «items» con el resultado de la expresión indicada.
                items = d.input;
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza el valor de «items» con el resultado de la expresión indicada.
                items = d.output;
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(items)».
            if isempty(items)
                % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
                names = {'Default'};
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los nombres de dispositivos mediante una operación que incluye la selección automática y elimina nombres repetidos.
            % LLAMADA a SelectorEntrada.m → agregarPredeterminado: incluye la selección automática y elimina nombres repetidos.
            names = SelectorEntrada.agregarPredeterminado({items.Name});
        % Termina el bloque de instrucciones anterior.
        end

        %% identificarSalida: Relaciona el nombre de salida elegido con su identificador en MATLAB
        function id = identificarSalida(name, items)
            % Ejecuta el bloque siguiente únicamente si se cumple «strcmp(name, 'Default')».
            if strcmp(name, 'Default')
                % Establece el valor de «id» en -1.
                id = -1;
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 2».
            if nargin < 2
                % Actualiza la proporción de señal original que limita la profundidad del notch con el resultado de la expresión indicada.
                d = audiodevinfo;
                % Actualiza el valor de «items» con el resultado de la expresión indicada.
                items = d.output;
            % Termina el bloque de instrucciones anterior.
            end
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(~isempty(items), 'No hay salidas de audio disponibles en MATLAB base.');
            % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
            names = {items.Name};
            % Actualiza el valor de «match» mediante una operación que busca posiciones que cumplen la condición.
            match = find(strcmp(name, names));
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(match)».
            if isempty(match)
                % audioDeviceWriter y audiodevinfo pueden diferir solo en
                % el sufijo del controlador. Nunca adivinar entre varios.
                % Actualiza el valor de «pattern» con el resultado de la expresión indicada.
                pattern = '\s+\((Windows )?(DirectSound|WASAPI|MME)\)$';
                % Actualiza el valor de «plain» con el resultado de la expresión indicada.
                plain = regexprep(names, pattern, '', 'ignorecase');
                % Actualiza el valor de «name» con el resultado de la expresión indicada.
                name = regexprep(char(name), pattern, '', 'ignorecase');
                % Actualiza el valor de «match» mediante una operación que busca posiciones que cumplen la condición.
                match = find(strcmpi(name, plain));
            % Termina el bloque de instrucciones anterior.
            end
            % Comprueba que el resultado cumpla la condición esperada antes de continuar.
            assert(numel(match) == 1, ...
                   'La salida elegida no esta disponible en MATLAB base. Actualiza dispositivos o elige Automatico.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Actualiza el valor de «id» con el resultado de la expresión indicada.
            id = items(match).ID;
        % Termina el bloque de instrucciones anterior.
        end

        %% distribuirCanales: Coloca la señal en los canales físicos de salida solicitados
        function audio = distribuirCanales(audio, out)
            % Comprueba que el resultado cumpla la condición esperada antes de continuar.
            assert(~isempty(out) && all(ismember(out, [1 2])) && numel(unique(out)) == numel(out), ...
                   'MATLAB base permite salidas 1 y 2. Selecciona primer canal 1 para reproducir en estereo.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(size(audio, 2) == numel(out), 'Numero de canales de reproduccion incorrecto.');
            % Actualiza el valor de «mapped» mediante una operación que reserva memoria inicializada en cero.
            mapped = zeros(size(audio, 1), max(out));
            % Actualiza el valor de «mapped(:, out)» mediante una operación que convierte los datos a precisión doble.
            mapped(:, out) = double(audio);
            % Actualiza las muestras preparadas para reproducción con el resultado de la expresión indicada.
            audio = mapped;
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
