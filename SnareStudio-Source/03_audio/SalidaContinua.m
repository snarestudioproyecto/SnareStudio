% SALIDACONTINUA: Abre la salida de audio y define la cantidad inicial de muestras que se acumularán.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «SalidaContinua» y los datos que conserva durante la sesión.
% Heredar de handle permite compartir una referencia al mismo objeto entre funciones.
% Así, los métodos trabajan sobre el mismo estado y se evitan copias innecesarias del
% objeto y de sus buffers de audio al modificarlo desde distintas partes del programa.
% Esto reduce el uso innecesario de RAM; no elimina todas las asignaciones de memoria.
classdef SalidaContinua < handle
    % Una linea PCM persistente. No crea reproductores por fragmento.
    % Agrupa los datos que pertenecen al módulo y que se conservan entre llamadas.
    properties
        % Conserva la frecuencia de muestreo para las operaciones de este módulo.
        Fs
        % Conserva los canales físicos de salida para las operaciones de este módulo.
        Out
        % Conserva las operaciones de la línea de audio para las operaciones de este módulo.
        API
        % Conserva la consulta que indica si se debe continuar para las operaciones de este módulo.
        Continue
        % Inicializa la función de actualización de pantalla como vacío hasta que se disponga de datos.
        OnTick = []
        % Establece las muestras enviadas al dispositivo en 0.
        Submitted = 0
        % Desactiva el indicador de reproducción iniciada.
        Started = false
        % Desactiva el indicador de conexión cerrada.
        Closed = false
        % Establece la duración del búfer en milisegundos en 0.
        BufferMS = 0
        % Establece los bytes por muestra multicanal en 0.
        BytesPerFrame = 0
        % Establece las muestras que se acumulan antes de reproducir en 0.
        PrebufferFrames = 0
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo.
    methods

        % Abre la salida de audio y define la cantidad inicial de muestras que se acumularán.
        function o = SalidaContinua(fs, device, out, keepRunning, api)
            % Actualiza las muestras preparadas para reproducción mediante una operación que coloca la señal en los canales físicos de salida solicitados.
            % LLAMADA a UtilidadesAudio.m → distribuirCanales: coloca la señal en los canales físicos de salida solicitados.
            audio = UtilidadesAudio.distribuirCanales(zeros(1, numel(out)), out);
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.Fs = fs;
            % Actualiza los canales físicos de salida con el resultado de la expresión indicada.
            o.Out = out;
            % Actualiza la consulta que indica si se debe continuar con el resultado de la expresión indicada.
            o.Continue = keepRunning;
            % Actualiza los bytes por muestra multicanal mediante una operación que consulta las dimensiones.
            o.BytesPerFrame = 2 * size(audio, 2);
            % Ejecuta el bloque siguiente únicamente si se cumple «nargin < 5».
            if nargin < 5
                % Actualiza el valor de «api» mediante una operación que abre una línea java sound compatible con el dispositivo, frecuencia y canales.
                % LLAMADA a ConexionAudioJava.m → abrirConexion: abre una línea java sound compatible con el dispositivo, frecuencia y canales.
                api = ConexionAudioJava.abrirConexion(fs, size(audio, 2), device);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza las operaciones de la línea de audio con el resultado de la expresión indicada.
            o.API = api;
            % Actualiza la duración del búfer en milisegundos con el resultado de la expresión indicada.
            o.BufferMS = 1000 * api.bufferBytes() / o.BytesPerFrame / fs;
            % Llenar una sola vez antes de arrancar; despues, escritura continua.
            % Actualiza las muestras que se acumulan antes de reproducir mediante una operación que limita el resultado por abajo o toma el mayor valor.
            o.PrebufferFrames = max(1, min(round(.02 * fs), floor(api.bufferBytes() / o.BytesPerFrame / 2)));
        % Termina el bloque de instrucciones anterior.
        end


        %% escribirBloque: Convierte el bloque a audio de 16 bits y lo envía sin reiniciar la reproducción
        function escribirBloque(o, x)
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(size(x, 2) == numel(o.Out) && all(isfinite(x(:))), 'Audio de salida no valido.');
            % Actualiza las muestras preparadas para reproducción mediante una operación que coloca la señal en los canales físicos de salida solicitados.
            % LLAMADA a UtilidadesAudio.m → distribuirCanales: coloca la señal en los canales físicos de salida solicitados.
            audio = UtilidadesAudio.distribuirCanales(double(x), o.Out);
            % Actualiza las muestras convertidas a enteros de 16 bits mediante una operación que convierte la amplitud a enteros de 16 bits.
            pcm = int16(round(max(-1, min(1, audio)) * 32767));
            % Actualiza el valor de «[~, ~, endian]» con el resultado de la expresión indicada.
            [~, ~, endian] = computer;
            % Ejecuta el bloque siguiente únicamente si se cumple «endian == 'B'».
            if endian == 'B'
                % Actualiza las muestras convertidas a enteros de 16 bits con el resultado de la expresión indicada.
                pcm = swapbytes(pcm);
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los bytes que se enviarán al dispositivo mediante una operación que reinterpreta los datos como bytes sin alterar su contenido.
            bytes = typecast(reshape(pcm.', [], 1), 'int8');
            % Establece el número de bytes enviados del bloque en 0.
            offset = 0;
            % Actualiza el reloj para detectar una salida detenida con el resultado de la expresión indicada.
            waitClock = tic;
            % Repite el bloque mientras se cumpla «offset < numel(bytes) && ~o.Closed».
            while offset < numel(bytes) && ~o.Closed
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Continue()».
                if ~o.Continue()
                    % Marca la salida como cerrada y libera su conexión de audio.
                    % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
                    o.liberarSalida();
                    % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                    return
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza el espacio libre disponible para escribir mediante una operación que toma el entero inferior.
                room = floor(double(o.API.available()) / o.BytesPerFrame) * o.BytesPerFrame;
                % Actualiza la cantidad de elementos que se utilizarán mediante una operación que limita el resultado por arriba o toma el menor valor.
                count = min(room, numel(bytes) - offset);
                % Ejecuta el bloque siguiente únicamente si se cumple «count > 0».
                if count > 0
                    % Actualiza la cantidad realmente escrita mediante una operación que convierte los datos a precisión doble.
                    written = double(o.API.write(bytes, int32(offset), int32(count)));
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(written >= 0 && written <= count && mod(written, o.BytesPerFrame) == 0, 'Escritura PCM incompleta.');
                    % Actualiza el número de bytes enviados del bloque con el resultado de la expresión indicada.
                    offset = offset + written;
                    % Actualiza las muestras enviadas al dispositivo con el resultado de la expresión indicada.
                    o.Submitted = o.Submitted + written / o.BytesPerFrame;
                    % Ejecuta el bloque siguiente únicamente si se cumple «~o.Started && o.Submitted >= o.PrebufferFrames».
                    if ~o.Started && o.Submitted >= o.PrebufferFrames
                        % Inicia la línea de reproducción una sola vez cuando hay audio preparado.
                        % LLAMADA a SalidaContinua.m → iniciarSalida: inicia la línea de reproducción una sola vez cuando hay audio preparado.
                        o.iniciarSalida();
                    % Termina el bloque de instrucciones anterior.
                    end
                    % Ejecuta el bloque siguiente únicamente si se cumple «written > 0».
                    if written > 0
                        % Actualiza el reloj para detectar una salida detenida con el resultado de la expresión indicada.
                        waitClock = tic;
                    % Termina el bloque de instrucciones anterior.
                    end
                % Ejecuta esta alternativa cuando la condición anterior no se cumple.
                else
                    % Inicia la línea de reproducción una sola vez cuando hay audio preparado.
                    % LLAMADA a SalidaContinua.m → iniciarSalida: inicia la línea de reproducción una sola vez cuando hay audio preparado.
                    o.iniciarSalida();
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «offset < numel(bytes)».
                if offset < numel(bytes)
                    % Verifica la condición indicada y detiene la ejecución si no se cumple.
                    assert(toc(waitClock) < 3, 'La salida no consume audio. Revisa el dispositivo seleccionado.');
                    % Ejecuta la actualización pendiente de la pantalla durante la reproducción.
                    % LLAMADA a SalidaContinua.m → atenderInterfaz: ejecuta la actualización pendiente de la pantalla durante la reproducción.
                    o.atenderInterfaz();
                    % Completa la operación de «escribirBloque» con los argumentos o valores indicados.
                    o.API.yield();
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% iniciarSalida: Inicia la línea de reproducción una sola vez cuando hay audio preparado
        function iniciarSalida(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «~o.Started && ~o.Closed».
            if ~o.Started && ~o.Closed
                % Completa la operación de «iniciarSalida» con los argumentos o valores indicados.
                o.API.start();
                % Activa el indicador de reproducción iniciada.
                o.Started = true;
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% esperarReproduccion: Espera a que termine el audio enviado mientras atiende la interfaz
        function esperarReproduccion(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Closed».
            if o.Closed
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Inicia la línea de reproducción una sola vez cuando hay audio preparado.
            % LLAMADA a SalidaContinua.m → iniciarSalida: inicia la línea de reproducción una sola vez cuando hay audio preparado.
            o.iniciarSalida();
            % Actualiza el reloj para detectar una salida detenida con el resultado de la expresión indicada.
            waitClock = tic;
            % Actualiza el indicador del último bloque mediante una operación que consulta cuántas muestras ya han sido reproducidas.
            % LLAMADA a SalidaContinua.m → posicionReproducida: consulta cuántas muestras ya han sido reproducidas.
            last = o.posicionReproducida();
            % Repite el bloque mientras se cumpla «~o.Closed && o.posicionReproducida() < o.Submitted».
            % LLAMADA a SalidaContinua.m → posicionReproducida: consulta cuántas muestras ya han sido reproducidas.
            while ~o.Closed && o.posicionReproducida() < o.Submitted
                % Ejecuta el bloque siguiente únicamente si se cumple «~o.Continue()».
                if ~o.Continue()
                    % Marca la salida como cerrada y libera su conexión de audio.
                    % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
                    o.liberarSalida();
                    % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                    return
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta la actualización pendiente de la pantalla durante la reproducción.
                % LLAMADA a SalidaContinua.m → atenderInterfaz: ejecuta la actualización pendiente de la pantalla durante la reproducción.
                o.atenderInterfaz();
                % Completa la operación de «esperarReproduccion» con los argumentos o valores indicados.
                o.API.yield();
                % Actualiza el valor de «now» mediante una operación que consulta cuántas muestras ya han sido reproducidas.
                % LLAMADA a SalidaContinua.m → posicionReproducida: consulta cuántas muestras ya han sido reproducidas.
                now = o.posicionReproducida();
                % Ejecuta el bloque siguiente únicamente si se cumple «now > last».
                if now > last
                    % Actualiza el reloj para detectar una salida detenida con el resultado de la expresión indicada.
                    waitClock = tic;
                    % Actualiza el indicador del último bloque con el resultado de la expresión indicada.
                    last = now;
                % Termina el bloque de instrucciones anterior.
                end
                % Verifica la condición indicada y detiene la ejecución si no se cumple.
                assert(toc(waitClock) < 3, 'La salida no termina de reproducir.');
            % Termina el bloque de instrucciones anterior.
            end
            % Ejecuta la actualización pendiente de la pantalla durante la reproducción.
            % LLAMADA a SalidaContinua.m → atenderInterfaz: ejecuta la actualización pendiente de la pantalla durante la reproducción.
            o.atenderInterfaz();
        % Termina el bloque de instrucciones anterior.
        end

        %% atenderInterfaz: Ejecuta la actualización pendiente de la pantalla durante la reproducción
        function atenderInterfaz(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.OnTick)».
            if ~isempty(o.OnTick)
                % Completa la operación de «atenderInterfaz» con los argumentos o valores indicados.
                o.OnTick();
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% posicionReproducida: Consulta cuántas muestras ya han sido reproducidas
        function sample = posicionReproducida(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Closed».
            if o.Closed
                % Establece el valor de «sample» en 0.
                sample = 0;
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza el valor de «sample» mediante una operación que limita el resultado por arriba o toma el menor valor.
                sample = min(o.Submitted, max(0, double(o.API.position())));
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% liberarSalida: Marca la salida como cerrada y libera su conexión de audio
        function liberarSalida(o)
            % Ejecuta el bloque siguiente únicamente si se cumple «~o.Closed».
            if ~o.Closed
                % Activa el indicador de conexión cerrada.
                o.Closed = true;
                % Ejecuta el bloque siguiente únicamente si se cumple «~isempty(o.API)».
                if ~isempty(o.API)
                    % Completa la operación de «liberarSalida» con los argumentos o valores indicados.
                    o.API.close();
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% delete: Libera la salida al destruir el objeto; MATLAB exige conservar el nombre delete
        function delete(o)
            % Marca la salida como cerrada y libera su conexión de audio.
            % LLAMADA a SalidaContinua.m → liberarSalida: marca la salida como cerrada y libera su conexión de audio.
            o.liberarSalida();
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
