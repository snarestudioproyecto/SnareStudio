% CONEXIONAUDIOJAVA: Definición de datos y operaciones del módulo.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «ConexionAudioJava» y los datos que conserva durante la sesión.
classdef ConexionAudioJava
    % Java Sound incluido en MATLAB Desktop con JVM. PCM firmado, 16 bits LE.
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% listarDispositivos: Obtiene los nombres de los dispositivos disponibles para esta vía de audio
        function names = listarDispositivos()
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(usejava('jvm'), 'La salida continua sin Audio Toolbox requiere MATLAB con JVM.');
            % Actualiza el valor de «infos» mediante una operación que consulta una operación del sistema Java.
            infos = javaMethod('getMixerInfo', 'javax.sound.sampled.AudioSystem');
            % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
            names = {'Default'};
            % Actualiza el valor de «cls» mediante una operación que consulta una operación del sistema Java.
            cls = javaMethod('forName', 'java.lang.Class', 'javax.sound.sampled.SourceDataLine');
            % Actualiza el valor de «fmt» mediante una operación que crea un objeto del sistema de audio Java.
            fmt = javaObject('javax.sound.sampled.AudioFormat', single(48000), int32(16), int32(2), true, false);
            % Actualiza el valor de «lineInfo» mediante una operación que crea un objeto del sistema de audio Java.
            lineInfo = javaObject('javax.sound.sampled.DataLine$Info', cls, fmt);
            % Recorre los valores indicados en «k = 1:numel(infos)» para procesarlos en orden.
            for k = 1:numel(infos)
                % Actualiza el valor de «mixer» mediante una operación que consulta una operación del sistema Java.
                mixer = javaMethod('getMixer', 'javax.sound.sampled.AudioSystem', infos(k));
                % Ejecuta el bloque siguiente únicamente si se cumple «mixer.isLineSupported(lineInfo)».
                if mixer.isLineSupported(lineInfo)
                    % Actualiza el valor de «names{end + 1}» con el resultado de la expresión indicada.
                    names{end + 1} = char(infos(k).getName()); %#ok<AGROW>
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los nombres de dispositivos mediante una operación que elimina repeticiones.
            names = unique(names, 'stable');
        % Termina el bloque de instrucciones anterior.
        end

        %% abrirConexion: Abre una línea Java Sound compatible con el dispositivo, frecuencia y canales
        function api = abrirConexion(fs, channels, device)
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(usejava('jvm'), 'La salida continua sin Audio Toolbox requiere MATLAB con JVM.');
            % Actualiza el valor de «format» mediante una operación que crea un objeto del sistema de audio Java.
            format = javaObject('javax.sound.sampled.AudioFormat', single(fs), int32(16), int32(channels), true, false);
            % Actualiza el valor de «cls» mediante una operación que consulta una operación del sistema Java.
            cls = javaMethod('forName', 'java.lang.Class', 'javax.sound.sampled.SourceDataLine');
            % Actualiza el valor de «info» mediante una operación que crea un objeto del sistema de audio Java.
            info = javaObject('javax.sound.sampled.DataLine$Info', cls, format);
            % Ejecuta el bloque siguiente únicamente si se cumple «strcmp(device, 'Default')».
            if strcmp(device, 'Default')
                % Actualiza la línea Java de reproducción mediante una operación que consulta una operación del sistema Java.
                line = javaMethod('getLine', 'javax.sound.sampled.AudioSystem', info);
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza el valor de «infos» mediante una operación que consulta una operación del sistema Java.
                infos = javaMethod('getMixerInfo', 'javax.sound.sampled.AudioSystem');
                % Actualiza el valor de «matches» con el resultado de la expresión indicada.
                matches = [];
                % Recorre los valores indicados en «k = 1:numel(infos)» para procesarlos en orden.
                for k = 1:numel(infos)
                    % Actualiza la variable auxiliar «a» de esta función mediante una operación que elimina del nombre del dispositivo el sufijo añadido por el controlador.
                    % LLAMADA a ConexionAudioJava.m → normalizarNombre: elimina del nombre del dispositivo el sufijo añadido por el controlador.
                    a = ConexionAudioJava.normalizarNombre(char(infos(k).getName()));
                    % Ejecuta el bloque siguiente únicamente si se cumple «strcmpi(a, ConexionAudioJava.normalizarNombre(char(device)))».
                    % LLAMADA a ConexionAudioJava.m → normalizarNombre: elimina del nombre del dispositivo el sufijo añadido por el controlador.
                    if strcmpi(a, ConexionAudioJava.normalizarNombre(char(device)))
                        % Actualiza el valor de «matches(end + 1)» con el resultado de la expresión indicada.
                        matches(end + 1) = k;
                    % Completa la operación de «abrirConexion» con los argumentos o valores indicados.
                    end %#ok<AGROW>
                % Termina el bloque de instrucciones anterior.
                end
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(numel(matches) == 1, 'Salida continua no disponible con ese nombre. Elige una salida de la lista o Automatico.');
                % Actualiza el valor de «mixer» mediante una operación que consulta una operación del sistema Java.
                mixer = javaMethod('getMixer', 'javax.sound.sampled.AudioSystem', infos(matches));
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(mixer.isLineSupported(info), 'El dispositivo no admite PCM con esa frecuencia/canales.');
                % Actualiza la línea Java de reproducción con el resultado de la expresión indicada.
                line = mixer.getLine(info);
            % Termina el bloque de instrucciones anterior.
            end
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Convierte el valor al entero requerido por el dispositivo.
                line.open(format, int32(round(.04 * fs) * channels * 2));
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch ME
                % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
                try
                    % Completa la operación de «abrirConexion» con los argumentos o valores indicados.
                    line.close();
                % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
                catch
                % Termina el bloque de instrucciones anterior.
                end
                % Propaga el error original.
                rethrow(ME);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «api» mediante una operación que agrupa campos relacionados en una estructura.
            api = struct('bufferBytes', @()double(line.getBufferSize()), ...
                       'available', @()double(line.available()), 'write', @(b, o, n)line.write(b, o, n), ... % Convierte los datos a precisión doble.
                       'start', @()line.start(), 'position', @()double(line.getLongFramePosition()), ... % Convierte los datos a precisión doble.
                       'yield', @()pause(.001), 'close', @()ConexionAudioJava.cerrarConexion(line)); % Cede brevemente el tiempo de ejecución. % LLAMADA a ConexionAudioJava.m → cerrarConexion: intenta detener, vaciar y cerrar la línea java aunque alguna operación falle.
        % Termina el bloque de instrucciones anterior.
        end

        %% normalizarNombre: Elimina del nombre del dispositivo el sufijo añadido por el controlador
        function value = normalizarNombre(value)
            % Actualiza el valor de «value» con el resultado de la expresión indicada.
            value = strtrim(regexprep(value, '\s*\(Windows (DirectSound|WASAPI|MME)\)$', '', 'ignorecase'));
        % Termina el bloque de instrucciones anterior.
        end

        %% cerrarConexion: Intenta detener, vaciar y cerrar la línea Java aunque alguna operación falle
        function cerrarConexion(line)
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Detiene el reproductor.
                line.stop();
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch
            % Termina el bloque de instrucciones anterior.
            end
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Completa la operación de «cerrarConexion» con los argumentos o valores indicados.
                line.flush();
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch
            % Termina el bloque de instrucciones anterior.
            end
            % Intenta la operación y permite atender un posible fallo sin perder la limpieza de recursos.
            try
                % Completa la operación de «cerrarConexion» con los argumentos o valores indicados.
                line.close();
            % Recoge un fallo de la operación anterior para informar o usar la alternativa prevista.
            catch
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
