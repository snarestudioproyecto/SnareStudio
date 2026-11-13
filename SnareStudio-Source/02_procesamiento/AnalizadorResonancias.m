% ANALIZADORRESONANCIAS: Prepara la ventana y los acumuladores del análisis de frecuencias.
% Comentarios didácticos; las operaciones conservan la lógica del proyecto original.
% Define el módulo «AnalizadorResonancias» y los datos que conserva durante la sesión.
% Heredar de handle permite compartir una referencia al mismo objeto entre funciones.
% Así, los métodos trabajan sobre el mismo estado y se evitan copias innecesarias del
% objeto y de sus buffers de audio al modificarlo desde distintas partes del programa.
% Esto reduce el uso innecesario de RAM; no elimina todas las asignaciones de memoria.
classdef AnalizadorResonancias < handle
    % Analisis orientativo de picos persistentes. No altera parametros DSP.
    % Agrupa los datos que pertenecen al módulo y que se conservan entre llamadas.
    properties
        % Conserva la frecuencia de muestreo para las operaciones de este módulo.
        Fs
        % Establece el tamaño de bloque o ventana en 8192.
        N = 8192
        % Establece el avance entre ventanas de análisis en 2048.
        Hop = 2048
        % Inicializa las muestras acumuladas aún por analizar como vacío hasta que se disponga de datos.
        Buffer = []
        % Actualiza la energía acumulada por frecuencia mediante una operación que reserva memoria inicializada en cero.
        % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
        % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
        Power = zeros(4097, 1)
        % Actualiza las veces que destaca cada frecuencia mediante una operación que reserva memoria inicializada en cero.
        % zeros preasigna e inicializa este buffer: reserva su tamaño antes de utilizarlo,
        % evitando ampliar repetidamente la matriz al guardar las muestras o mediciones.
        Hits = zeros(4097, 1)
        % Establece el número de ventanas analizadas en 0.
        Count = 0
        % Conserva la ventana de Hann del análisis para las operaciones de este módulo.
        Window
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo.
    methods

        % Prepara la ventana y los acumuladores del análisis de frecuencias.
        function o = AnalizadorResonancias(fs)
            % Actualiza la frecuencia de muestreo con el resultado de la expresión indicada.
            o.Fs = fs;
            % Actualiza la ventana de Hann del análisis mediante una operación que calcula el coseno que interviene en el filtro o en la ventana.
            o.Window = .5 - .5 * cos(2 * pi * (0:o.N - 1)' / o.N);
        % Termina el bloque de instrucciones anterior.
        end


        %% acumularMuestras: Acumula muestras y analiza ventanas sucesivas con solapamiento
        function acumularMuestras(o, x)
            % Actualiza las muestras acumuladas aún por analizar mediante una operación que convierte los datos a precisión doble.
            o.Buffer = [o.Buffer; double(x(:))];
            % Repite el bloque mientras se cumpla «numel(o.Buffer) >= o.N».
            while numel(o.Buffer) >= o.N
                % Mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                % LLAMADA a AnalizadorResonancias.m → analizarVentana: mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                o.analizarVentana(o.Buffer(1:o.N));
                % Actualiza las muestras acumuladas aún por analizar con el resultado de la expresión indicada.
                o.Buffer = o.Buffer(o.Hop + 1:end);
            % Termina el bloque de instrucciones anterior.
            end
        % Termina el bloque de instrucciones anterior.
        end

        %% analizarVentana: Mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos
        function analizarVentana(o, x)
            % Actualiza las muestras de entrada mediante una operación que convierte los datos a precisión doble.
            x = double(x(:));
            % Ejecuta el bloque siguiente únicamente si se cumple «numel(x) < 512 || any(~isfinite(x)) || sqrt(mean(x.^2)) < 1e-5».
            if numel(x) < 512 || any(~isfinite(x)) || sqrt(mean(x.^2)) < 1e-5
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Retira el valor medio de la ventana antes de analizar sus frecuencias.
            x = x - mean(x);
            % Actualiza las muestras de entrada con el resultado de la expresión indicada.
            x(end + 1:o.N) = 0;
            % Calcula la magnitud de la FFT después de aplicar la ventana de Hann y corregir su amplitud.
            a = abs(fft(x .* o.Window, o.N)) * 2 / sum(o.Window);
            % Conserva las frecuencias no negativas y eleva su amplitud al cuadrado para medir energía.
            power = a(1:o.N / 2 + 1).^2;
            % Expresa la energía en dB y evita el logaritmo de cero.
            db = 10 * log10(max(power, 1e-20));
            % Compara cada nivel con la mediana de 41 vecinos para reconocer picos que sobresalen.
            prominence = db - movmedian(db, 41);
            % Actualiza la energía acumulada por frecuencia con el resultado de la expresión indicada.
            o.Power = o.Power + power;
            % Actualiza las veces que destaca cada frecuencia mediante una operación que convierte los datos a precisión doble.
            o.Hits = o.Hits + double(prominence >= 6);
            % Actualiza el número de ventanas analizadas con el resultado de la expresión indicada.
            o.Count = o.Count + 1;
        % Termina el bloque de instrucciones anterior.
        end

        %% obtenerSugerencias: Elige hasta tres picos persistentes y propone frecuencia, Q y profundidad de corte
        function result = obtenerSugerencias(o)
            % Actualiza los resultados del análisis mediante una operación que agrupa campos relacionados en una estructura.
            result = struct('values', [], 'q', [], 'cuts', [], 'prominence', [], ...
                          'persistence', [], 'harmonics', [], 'fundamental', 0, 'windows', o.Count, ... % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
                          'message', 'Sin picos persistentes suficientes para recomendar cortes.'); % Completa los campos, el mensaje o los valores de la instrucción iniciada en la línea anterior.
            % Ejecuta el bloque siguiente únicamente si se cumple «o.Count == 0».
            if o.Count == 0
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Construye el eje de frecuencias correspondiente a los puntos de la FFT.
            f = (0:o.N / 2)' * o.Fs / o.N;
            % Calcula la separación en Hz entre dos puntos consecutivos de la FFT.
            df = o.Fs / o.N;
            % Actualiza los niveles expresados en decibelios mediante una operación que convierte la relación de amplitudes o energías a una escala logarítmica.
            db = 10 * log10(max(o.Power / o.Count, 1e-20));
            % Actualiza el exceso de nivel respecto del entorno con el resultado de la expresión indicada.
            excess = db - movmedian(db, 41);
            % Actualiza la proporción de ventanas donde destaca cada pico con el resultado de la expresión indicada.
            persistence = o.Hits / o.Count;
            % Actualiza los índices de las muestras seleccionadas mediante una operación que busca posiciones que cumplen la condición.
            ix = find(f >= 80 & f <= min(12000, .45 * o.Fs));
            % Actualiza los índices de las muestras seleccionadas mediante una operación que cuenta los elementos.
            ix = ix(ix > 1 & ix < numel(db));
            % Actualiza los índices de las muestras seleccionadas con el resultado de la expresión indicada.
            ix = ix(db(ix) > db(ix - 1) & db(ix) >= db(ix + 1) & excess(ix) >= 8 ...
                  & persistence(ix) >= .35 & db(ix) > -70 & db(ix) > max(db) - 45); % Actualiza el valor de «& persistence(ix) >» mediante una operación que limita el resultado por abajo o toma el mayor valor.
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(ix)».
            if isempty(ix)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza la puntuación para ordenar los picos mediante una operación que limita el resultado por abajo o toma el mayor valor.
            score = excess(ix) + 10 * persistence(ix) + .15 * (db(ix) - max(db));
            % Actualiza el valor de «[~, rank]» mediante una operación que ordena los valores.
            [~, rank] = sort(score, 'descend');
            % Actualiza los índices de los picos elegidos con el resultado de la expresión indicada.
            peaks = [];
            % Recorre los valores indicados en «j = reshape(rank, 1, [])» para procesarlos en orden.
            for j = reshape(rank, 1, [])
                % Actualiza el valor de «k» con el resultado de la expresión indicada.
                k = ix(j);
                % Ejecuta el bloque siguiente únicamente si se cumple «isempty(peaks) || all(abs(f(peaks) - f(k)) > max(25, .035 * f(k)))».
                if isempty(peaks) || all(abs(f(peaks) - f(k)) > max(25, .035 * f(k)))
                    % Actualiza los índices de los picos elegidos con el resultado de la expresión indicada.
                    peaks(end + 1) = k; %#ok<AGROW>
                % Termina el bloque de instrucciones anterior.
                end
                % Ejecuta el bloque siguiente únicamente si se cumple «numel(peaks) == 16».
                if numel(peaks) == 16
                    % Termina este recorrido porque ya se alcanzó la condición de salida.
                    break
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza las frecuencias refinadas de los picos con el resultado de la expresión indicada.
            hz = f(peaks)';
            % Recorre los valores indicados en «j = 1:numel(peaks)» para procesarlos en orden.
            for j = 1:numel(peaks)
                % Actualiza el valor de «k» con el resultado de la expresión indicada.
                k = peaks(j);
                % Calcula la curvatura de tres puntos vecinos para refinar la frecuencia del pico.
                denom = db(k - 1) - 2 * db(k) + db(k + 1);
                % Ejecuta el bloque siguiente únicamente si se cumple «abs(denom) > 1e-12».
                if abs(denom) > 1e-12
                    % Actualiza las frecuencias refinadas de los picos mediante una operación que limita el resultado por abajo o toma el mayor valor.
                    hz(j) = f(k) + df * max(-.5, min(.5, .5 * (db(k - 1) - db(k + 1)) / denom));
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Solo llamar armonicos a una familia con >=3 picos compatibles
            % y una fundamental observada. Un pico aislado es una resonancia.
            % Establece la frecuencia fundamental identificada en 0.
            fundamental = 0;
            % Establece la mayor cantidad de picos compatibles con una familia en 0.
            bestSupport = 0;
            % Recorre los valores indicados en «base = sort(hz(hz >= 80 & hz <= 600))» para procesarlos en orden.
            for base = sort(hz(hz >= 80 & hz <= 600))
                % Propone el orden armónico de cada pico respecto de la fundamental candidata.
                order = round(hz / base);
                % Identifica los picos que cumplen la tolerancia de la familia armónica.
                match = order >= 1 & order <= 12 & abs(hz - order * base) <= max(2 * df, .02 * hz);
                % Cuenta los picos compatibles con la fundamental candidata.
                support = sum(match);
                % Ejecuta el bloque siguiente únicamente si se cumple «support >= 3 && support > bestSupport».
                if support >= 3 && support > bestSupport
                    % Actualiza la frecuencia fundamental identificada con el resultado de la expresión indicada.
                    fundamental = base;
                    % Actualiza la mayor cantidad de picos compatibles con una familia con el resultado de la expresión indicada.
                    bestSupport = support;
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el orden armónico de cada pico mediante una operación que reserva memoria inicializada en cero.
            orders = zeros(size(hz));
            % Ejecuta el bloque siguiente únicamente si se cumple «fundamental > 0».
            if fundamental > 0
                % Calcula el múltiplo entero más cercano de la fundamental para cada pico.
                n = round(hz / fundamental);
                % Marca las frecuencias compatibles con los múltiplos permitidos de la fundamental.
                ok = n >= 1 & n <= 12 & abs(hz - n * fundamental) <= max(2 * df, .02 * hz);
                % Actualiza el orden armónico de cada pico con el resultado de la expresión indicada.
                orders(ok) = n(ok);
            % Termina el bloque de instrucciones anterior.
            end
            % Conservar la fundamental de una familia reconocida.
            % Actualiza los picos que pueden sugerirse sin cortar la fundamental mediante una operación que busca posiciones que cumplen la condición.
            eligible = find(orders ~= 1);
            % Actualiza los elementos seleccionados mediante una operación que limita el resultado por arriba o toma el menor valor.
            selected = eligible(1:min(3, numel(eligible)));
            % Ejecuta el bloque siguiente únicamente si se cumple «isempty(selected)».
            if isempty(selected)
                % Finaliza esta llamada y devuelve el resultado disponible hasta este punto.
                return
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «k» con el resultado de la expresión indicada.
            k = peaks(selected);
            % Reserva el factor de selectividad que se propondrá para cada pico elegido.
            q = zeros(size(selected));
            % Recorre los valores indicados en «j = 1:numel(k)» para procesarlos en orden.
            for j = 1:numel(k)
                % Actualiza el límite inferior de la zona examinada con el resultado de la expresión indicada.
                left = k(j);
                % Actualiza el límite superior de la zona examinada con el resultado de la expresión indicada.
                right = k(j);
                % Actualiza el nivel de referencia de la búsqueda con el resultado de la expresión indicada.
                threshold = db(k(j)) - 3;
                % Repite el bloque mientras se cumpla «left > 1 && db(left) > threshold».
                while left > 1 && db(left) > threshold
                    % Actualiza el límite inferior de la zona examinada con el resultado de la expresión indicada.
                    left = left - 1;
                % Termina el bloque de instrucciones anterior.
                end
                % Repite el bloque mientras se cumpla «right < numel(db) && db(right) > threshold».
                while right < numel(db) && db(right) > threshold
                    % Actualiza el límite superior de la zona examinada con el resultado de la expresión indicada.
                    right = right + 1;
                % Termina el bloque de instrucciones anterior.
                end
                % Actualiza el factor Q que controla la anchura mediante una operación que limita el resultado por arriba o toma el menor valor.
                q(j) = min(30, max(4, hz(selected(j)) / max(2 * df, f(right) - f(left))));
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza el valor de «result.values» mediante una operación que redondea el resultado.
            result.values = round(hz(selected) * 10) / 10;
            % Actualiza el factor Q que controla la anchura mediante una operación que redondea el resultado.
            result.q = round(q * 10) / 10;
            % Actualiza el valor de «result.cuts» mediante una operación que redondea el resultado.
            result.cuts = round(min(9, max(3, .45 * excess(k)')) * 10) / 10;
            % Actualiza la diferencia entre cada pico y su entorno mediante una operación que redondea el resultado.
            result.prominence = round(excess(k)' * 10) / 10;
            % Actualiza la proporción de ventanas donde destaca cada pico mediante una operación que redondea el resultado.
            result.persistence = round(100 * persistence(k)');
            % Actualiza el valor de «result.harmonics» con el resultado de la expresión indicada.
            result.harmonics = orders(selected);
            % Actualiza la frecuencia fundamental identificada con el resultado de la expresión indicada.
            result.fundamental = fundamental;
            % Actualiza el valor de «result.message» con el resultado de la expresión indicada.
            result.message = 'Sugerencias listas en RESONANCIAS. Revisa el timbre antes de aplicar los cortes.';
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
    % Declara las operaciones del módulo que pueden llamarse sin crear un objeto.
    methods (Static)

        %% analizarGrabacion: Analiza ventanas repartidas por una grabación sin cambiar la señal original
        function result = analizarGrabacion(x, fs)
            % Actualiza el valor de «o» mediante una operación que prepara la ventana y los acumuladores del análisis de frecuencias.
            % LLAMADA a AnalizadorResonancias.m → AnalizadorResonancias: crea el objeto que conserva los datos de este módulo.
            o = AnalizadorResonancias(fs);
            % Actualiza las muestras de entrada mediante una operación que convierte los datos a precisión doble.
            x = double(x(:));
            % Ejecuta el bloque siguiente únicamente si se cumple «numel(x) < o.N».
            if numel(x) < o.N
                % Mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                % LLAMADA a AnalizadorResonancias.m → analizarVentana: mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                o.analizarVentana(x);
            % Ejecuta esta alternativa cuando la condición anterior no se cumple.
            else
                % Muestras distribuidas por toda la toma; como maximo 320 ventanas.
                % Actualiza el valor de «starts» mediante una operación que elimina repeticiones.
                starts = unique(round(linspace(1, numel(x) - o.N + 1, ...
                                             min(320, 1 + floor((numel(x) - o.N) / o.Hop))))); % Limita el resultado por arriba o toma el menor valor.
                % Recorre los valores indicados en «k = starts» para procesarlos en orden.
                for k = starts
                    % Mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                    % LLAMADA a AnalizadorResonancias.m → analizarVentana: mide la energía de las frecuencias y registra qué picos destacan sobre sus vecinos.
                    o.analizarVentana(x(k:k + o.N - 1));
                % Termina el bloque de instrucciones anterior.
                end
            % Termina el bloque de instrucciones anterior.
            end
            % Actualiza los resultados del análisis mediante una operación que elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
            % LLAMADA a AnalizadorResonancias.m → obtenerSugerencias: elige hasta tres picos persistentes y propone frecuencia, q y profundidad de corte.
            result = o.obtenerSugerencias();
        % Termina el bloque de instrucciones anterior.
        end
    % Termina el bloque de instrucciones anterior.
    end
% Termina el bloque de instrucciones anterior.
end
