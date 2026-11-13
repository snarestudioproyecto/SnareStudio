% CONFIGURACIONAUDIO: Definición de datos y operaciones del módulo.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «ConfiguracionAudio» y los datos que conserva durante la sesión.
classdef ConfiguracionAudio
    % Una sola fuente visible. Seleccion de ruta sin abrir el hardware.
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% normalizarConfiguracion: Convierte los nombres antiguos de fuentes al modo unificado Tiempo real
        function c = normalizarConfiguracion(c)
            % Ejecuta el bloque siguiente únicamente si se cumple «strcmp(c.mode, 'USB duplex')».
            if strcmp(c.mode, 'USB duplex')
                % Actualiza el valor de «c.mode» con el resultado de la expresión indicada.
                c.mode = 'Tiempo real';
                % Actualiza el valor de «c.driver» con el resultado de la expresión indicada.
                c.driver = 'ASIO';
                % Actualiza el valor de «c.output» con el resultado de la expresión indicada.
                c.output = c.input;
            % Evalúa una condición alternativa: «strcmp(c.mode, 'USB separado')».
            elseif strcmp(c.mode, 'USB separado')
                % Actualiza el valor de «c.mode» con el resultado de la expresión indicada.
                c.mode = 'Tiempo real';
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% esTiempoReal: Indica si la fuente seleccionada corresponde a captura en vivo
        function value = esTiempoReal(c)
            % Devuelve verdadero cuando la fuente seleccionada es Tiempo real.
            value = strcmp(c.mode, 'Tiempo real');
        % Termina el bloque de instrucciones anterior.
        end

        %% esDuplex: Indica si entrada y salida deben compartir un dispositivo ASIO
        function value = esDuplex(c)
            % Devuelve verdadero solo para Tiempo real con ASIO y el mismo dispositivo de entrada y salida.
            % LLAMADA a ConfiguracionAudio.m → esTiempoReal: indica si la fuente seleccionada corresponde a captura en vivo.
            value = ConfiguracionAudio.esTiempoReal(c) && strcmp(c.driver, 'ASIO') && strcmp(c.input, c.output);
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
