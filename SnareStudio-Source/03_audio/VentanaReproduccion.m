% VENTANAREPRODUCCION: Definición de datos y operaciones del módulo.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «VentanaReproduccion» y los datos que conserva durante la sesión.
classdef VentanaReproduccion
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% extraerVentana: Extrae de la memoria circular una ventana alineada con el audio reproducido
        function scope = extraerVentana(capture, written, played, n)
            % La captura circular se escribe desde la posicion 1. Los indices
            % absolutos permiten consultar el pasado aunque la captura de la
            % siguiente trama ya se haya adelantado al reproductor.
            % Actualiza la ventana de muestras para la gráfica mediante una operación que reserva memoria inicializada en cero.
            scope = zeros(n, size(capture, 2));
            % Actualiza el indicador del último bloque mediante una operación que limita el resultado por arriba o toma el menor valor.
            last = min(floor(played), written);
            % Actualiza el valor de «first» mediante una operación que limita el resultado por abajo o toma el mayor valor.
            first = max([1, written - size(capture, 1) + 1, last - n + 1]);
            % Ejecuta el bloque siguiente únicamente si se cumple «first > last || isempty(capture)».
            if first > last || isempty(capture)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los índices de las muestras seleccionadas mediante una operación que calcula la posición cíclica de la memoria.
            ix = mod((first:last) - 1, size(capture, 1)) + 1;
            % Actualiza la ventana de muestras para la gráfica mediante una operación que convierte los datos a precisión doble.
            scope(end - numel(ix) + 1:end, :) = double(capture(ix, :));
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
