% SELECTORENTRADA: Inicializa el seguimiento de energía para elegir una entrada mono.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «SelectorEntrada» y los datos que conserva durante la sesión.
% Heredar de handle permite compartir una referencia al mismo objeto entre funciones.
% Así, los métodos trabajan sobre el mismo estado y se evitan copias innecesarias del
% objeto y de sus buffers de audio al modificarlo desde distintas partes del programa.
% Esto reduce el uso innecesario de RAM; no elimina todas las asignaciones de memoria.
classdef SelectorEntrada < handle
    % Seleccion mono por energia, con histeresis para evitar saltos de canal.
    % Agrupa los datos que pertenecen al módulo y que se conservan entre llamadas.
    properties
        % Conserva la frecuencia de muestreo para las operaciones de este módulo.
        Fs
        % Inicializa la energía suavizada de cada canal como vacío hasta que se disponga de datos.
        Energy = []
        % Establece el canal seleccionado en 0.
        Selected = 0
        % Establece el canal candidato a reemplazar al actual en 0.
        Challenger = 0
        % Establece las muestras durante las que destaca el candidato en 0.
        ChallengerSamples = 0
        % Actualiza el umbral mínimo de energía con el resultado de la expresión indicada.
        Floor = 10^(-65 / 10)
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo.
    methods

        % Inicializa el seguimiento de energía para elegir una entrada mono.
        function o = SelectorEntrada(fs)
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.Fs = fs;
        % Termina el bloque de instrucciones anterior.
        end


        %% seleccionarCanal: Elige un canal con señal y exige persistencia antes de cambiar a otro
        function [y, channel, changed, active] = seleccionarCanal(o, x)
            % Verifica la condición indicada y detiene la ejecución si no se cumple.
            assert(~isempty(x) && all(isfinite(x(:))), 'Entrada de audio no valida.');
            % Cuenta las muestras del bloque recibido.
            n = size(x, 1);
            % Cuenta los canales presentes en el bloque de entrada.
            channels = size(x, 2);
            % Conserva el canal anterior para informar si hubo un cambio.
            old = o.Selected;
            % Ejecuta el bloque siguiente únicamente si se cumple «numel(o.Energy) ~= channels».
            if numel(o.Energy) ~= channels
                % Actualiza la energía suavizada de cada canal mediante una operación que reserva memoria inicializada en cero.
                o.Energy = zeros(1, channels);
                % Establece el canal seleccionado en 0.
                o.Selected = 0;
                % Establece el canal candidato a reemplazar al actual en 0.
                o.Challenger = 0;
                % Establece las muestras durante las que destaca el candidato en 0.
                o.ChallengerSamples = 0;
            % Termina el bloque de instrucciones anterior.
            end
            % Calcula un promedio temporal de energía con una referencia de 150 ms.
            a = exp(-n / (.15 * o.Fs));
            % Actualiza la energía suavizada de cada canal mediante una operación que calcula el promedio.
            o.Energy = a * o.Energy + (1 - a) * mean(double(x).^2, 1);
            % Actualiza el valor de «[level, best]» mediante una operación que limita el resultado por abajo o toma el mayor valor.
            [level, best] = max(o.Energy);
            % Actualiza la presencia de señal suficiente con el resultado de la expresión indicada.
            active = level > o.Floor;
            % Ejecuta el bloque siguiente únicamente si se cumple «active && o.Selected == 0».
            if active && o.Selected == 0
                % Actualiza el canal seleccionado con el resultado de la expresión indicada.
                o.Selected = best;
            % Evalúa una condición alternativa: «active && best ~= o.Selected && level > 4 * o.Energy(o.Selected)».
            elseif active && best ~= o.Selected && level > 4 * o.Energy(o.Selected)
                % Ejecuta el bloque siguiente únicamente si se cumple «o.Challenger ~= best».
                if o.Challenger ~= best
                    % Actualiza el canal candidato a reemplazar al actual con el resultado de la expresión indicada.
                    o.Challenger = best;
                    % Establece las muestras durante las que destaca el candidato en 0.
                    o.ChallengerSamples = 0;
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza las muestras durante las que destaca el candidato con el resultado de la expresión indicada.
                o.ChallengerSamples = o.ChallengerSamples + n;
                % Ejecuta el bloque siguiente únicamente si se cumple «o.ChallengerSamples >= .4 * o.Fs».
                if o.ChallengerSamples >= .4 * o.Fs
                    % Actualiza el canal seleccionado con el resultado de la expresión indicada.
                    o.Selected = best;
                    % Establece las muestras durante las que destaca el candidato en 0.
                    o.ChallengerSamples = 0;
                % Termina el bloque de instrucciones anterior.
                end
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Establece el canal candidato a reemplazar al actual en 0.
                o.Challenger = 0;
                % Establece las muestras durante las que destaca el candidato en 0.
                o.ChallengerSamples = 0;
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el canal seleccionado con el resultado de la expresión indicada.
            channel = o.Selected;
            % Actualiza el valor de «changed» con el resultado de la expresión indicada.
            changed = channel ~= old;
            % Ejecuta el bloque siguiente únicamente si se cumple «channel == 0».
            if channel == 0
                % Actualiza las muestras de salida mediante una operación que reserva memoria inicializada en cero.
                y = zeros(n, 1);
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza las muestras de salida mediante una operación que convierte los datos a precisión doble.
                y = double(x(:, channel));
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% limiteDeCanales: Obtiene cuántos canales declara el dispositivo y verifica que pueda utilizarse
        function count = limiteDeCanales(details, input)
            % Ejecuta el bloque siguiente únicamente si se cumple «input».
            if input
                % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
                names = {'MaximumInputChannels', 'MaximumRecorderChannels'};
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
                names = {'MaximumOutputChannels', 'MaximumPlayerChannels'};
            % Termina el bloque de instrucciones anterior.
            end
            % Establece la cantidad de elementos que se utilizarán en 0.
            count = 0;
            % Recorre los valores indicados en «k = 1:numel(names)» para procesarlos en orden.
            for k = 1:numel(names)
                % Ejecuta el bloque siguiente únicamente si se cumple «isfield(details, names{k})».
                if isfield(details, names{k})
                    % Actualiza la cantidad de elementos que se utilizarán mediante una operación que convierte los datos a precisión doble.
                    count = double(details.(names{k}));
                    % Termina este recorrido porque ya se alcanzó la condición de salida.
                    break
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Comprueba que el resultado cumpla la condición esperada antes de continuar.
            assert(isscalar(count) && isfinite(count) && count >= 1, ...
                   'El dispositivo no informa canales compatibles. Revisa el driver o el dispositivo.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Actualiza la cantidad de elementos que se utilizarán mediante una operación que limita el resultado por arriba o toma el menor valor.
            count = min(64, floor(count));
        % Termina el bloque de instrucciones anterior.
        end

        %% agregarPredeterminado: Incluye la selección automática y elimina nombres repetidos
        function names = agregarPredeterminado(names)
            % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
            names = cellstr(names);
            % Actualiza los nombres de dispositivos con el resultado de la expresión indicada.
            names = names(:)';
            % Actualiza los nombres de dispositivos mediante una operación que elimina repeticiones.
            names = unique([{'Default'} names], 'stable');
        % Termina el bloque de instrucciones anterior.
        end

        %% conservarSeleccion: Mantiene el dispositivo elegido si aún aparece entre los disponibles
        function selected = conservarSeleccion(selected, names)
            % Ejecuta el bloque siguiente únicamente si se cumple «~any(strcmp(selected, names))».
            if ~any(strcmp(selected, names))
                % Actualiza los elementos seleccionados con el resultado de la expresión indicada.
                selected = 'Default';
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
