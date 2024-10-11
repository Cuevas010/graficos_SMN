%% Se limpia la memoria previa
clear
clc

%% Carga de datos y separación de columnas
data = readtable('ESCUELA NACIONAL DE CIENCIAS BIOLÓGICAS II_90_dias.xlsx');

estacion = data{1, 2};
municipio = data{2, 2};
ciudad = data{3, 2};
data = data(7:end, :);

fecha_local = data{:, 1};
fecha_utc = data{:,2};
dir_viento = data{:, 3};
dir_rafaga = data{:, 4};
rap_viento = data{:, 5};
rap_rafaga = data{:, 6};
temp = data{:, 7};
humedad_relativa = data{:, 8};
presion = data{:, 9};
precipitacion = data{:, 10};
rad_solar = data{:, 11};

n = length(temp); % Cantidad total de registros

fecha_local = datetime(fecha_local, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
fecha_utc = datetime(fecha_utc, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

%% Se ubica la temperatura mínima y máxima para graficar en conjunto a su grafico

[temp_min, idx_mint] = min(temp);
fecha_min_temp = fecha_local(idx_mint); 
[temp_max, idx_maxt] = max(temp);
fecha_max_temp = fecha_local(idx_maxt);

plot(fecha_local, temp, 'LineStyle', "-", 'LineWidth', 1, 'Color', [0.2 0.5 0.4]);
hold on
plot(fecha_min_temp, temp_min, Marker="*", MarkerSize=14, Color=[0 0 1], LineStyle="none")
plot(fecha_max_temp, temp_max, Marker="*", MarkerSize=14, Color=[1 0 0], LineStyle="none")

legend('Temperatura', 'Temperatura mínima', 'Temperatura máxima')
xlabel('Fecha')
ylabel('Temperatura (°C)')
title(sprintf(['Variación de la temperatura (°C) medida en la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}))
xlim([min(fecha_local), max(fecha_local)])
grid on
grid minor
hold off

%% Gráfico del cambio de la presión
figure

plot(fecha_local, presion, 'LineStyle', "-", 'LineWidth', 1, 'Color', [0.4 0.8 0.4]);
xlabel('Fecha')
ylabel('Presión (hPa)')
title(sprintf(['Variación de la presión (hPA) medida en la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}))
xlim([min(fecha_local), max(fecha_local)])
grid on
grid minor

%% Rosa de vientos

% Clasificación por dirección del viento
direccion = cell(n+1, 1);
direccion{1} = 'Dirección del viento';

for i = 1:n
    if dir_viento(i) > 11.25 && dir_viento(i) <= 33.75
        direccion{i+1} = 'NNE';
    elseif dir_viento(i) > 33.75 && dir_viento(i) <= 56.25
        direccion{i+1} = 'NE';
    elseif dir_viento(i) > 56.25 && dir_viento(i) <= 78.75
        direccion{i+1} = 'ENE';
    elseif dir_viento(i) > 78.75 && dir_viento(i) <= 101.25
        direccion{i+1} = 'E';
    elseif dir_viento(i) > 101.25 && dir_viento(i) <= 123.75
        direccion{i+1} = 'ESE';
    elseif dir_viento(i) > 123.75 && dir_viento(i) <= 146.25
        direccion{i+1} = 'SE';
    elseif dir_viento(i) > 146.25 && dir_viento(i) <= 168.75
        direccion{i+1} = 'SSE';
    elseif dir_viento(i) > 168.75 && dir_viento(i) <= 191.25
        direccion{i+1} = 'S';
    elseif dir_viento(i) > 191.25 && dir_viento(i) <= 213.75
        direccion{i+1} = 'SSO';
    elseif dir_viento(i) > 213.75 && dir_viento(i) <= 236.25
        direccion{i+1} = 'SO';
    elseif dir_viento(i) > 236.25 && dir_viento(i) <= 258.75
        direccion{i+1} = 'OSO';
    elseif dir_viento(i) > 258.75 && dir_viento(i) <= 281.25
        direccion{i+1} = 'O';
    elseif dir_viento(i) > 281.25 && dir_viento(i) <= 303.75
        direccion{i+1} = 'ONO';
    elseif dir_viento(i) > 303.75 && dir_viento(i) <= 326.25
        direccion{i+1} = 'NO';
    elseif dir_viento(i) > 326.25 && dir_viento(i) <= 348.75
        direccion{i+1} = 'NNO';
    else 
        direccion{i+1} = 'N';
    end
end

% Caracterización por rangos de velocidad
rangos = cell(n+1, 4);
rangos{1, 1} = 'Calma';
rangos{1, 2} = 'Rango 1';
rangos{1, 3} = 'Rango 2';
rangos{1, 4} = 'Rango 3';

for i = 1:n
    if rap_viento(i) < 3.7
        rangos{i+1, 1} = 1;
        rangos{i+1, 2} = 0;
        rangos{i+1, 3} = 0;
        rangos{i+1, 4} = 0;
    elseif rap_viento(i) > 3.7 && rap_viento(i) <= 10
        rangos{i+1, 1} = 0;
        rangos{i+1, 2} = direccion{i+1};
        rangos{i+1, 3} = 0;
        rangos{i+1, 4} = 0;
    elseif rap_viento(i) > 10 && rap_viento(i) <= 18
        rangos{i+1, 1} = 0;
        rangos{i+1, 2} = 0;
        rangos{i+1, 3} = direccion{i+1};
        rangos{i+1, 4} = 0;
    else
        rangos{i+1, 1} = 0;
        rangos{i+1, 2} = 0;
        rangos{i+1, 3} = 0;
        rangos{i+1, 4} = direccion{i+1};
    end
end

% Frecuencia de cada rumbo por rangos
f_calmas = (sum(cellfun(@(x) isnumeric(x) && x == 1, rangos(2:end, 1))) / n)*100;

direcciones = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', ...
               'S', 'SSO', 'SO', 'OSO', 'O', 'ONO', 'NO', 'NNO'};

frecuencias_r1 = zeros(1, length(direcciones));
frecuencias_r2 = zeros(1, length(direcciones));
frecuencias_r3 = zeros(1, length(direcciones));

for i = 1:length(direcciones)
    frecuencias_r1(i) = (sum(strcmp(rangos(:, 2), direcciones{i})) / n)*100;
    frecuencias_r2(i) = (sum(strcmp(rangos(:, 3), direcciones{i})) / n)*100;
    frecuencias_r3(i) = (sum(strcmp(rangos(:, 4), direcciones{i})) / n)*100;
end

% Preparar datos
num_direcciones = length(direcciones);
angulo_direcciones = linspace(0, 2*pi, num_direcciones + 1);
angulo_direcciones = angulo_direcciones(1:end-1) + pi/num_direcciones; % Ajustar al centro de cada sector

figure;
polarplot([angulo_direcciones angulo_direcciones(1)], [frecuencias_r1 frecuencias_r1(1)], '-o', 'LineWidth', 1.5, 'Color', 'b', 'DisplayName', 'Rango 1');
hold on
polarplot([angulo_direcciones angulo_direcciones(1)], [frecuencias_r2 frecuencias_r2(1)], '-o', 'LineWidth', 1.5, 'Color', 'g', 'DisplayName', 'Rango 2');
polarplot([angulo_direcciones angulo_direcciones(1)], [frecuencias_r3 frecuencias_r3(1)], '-o', 'LineWidth', 1.5, 'Color', 'r', 'DisplayName', 'Rango 3');
hold off

% Ajustes del gráfico
ax = gca;
ax.ThetaTick = rad2deg(angulo_direcciones); % Convertir ángulos a grados
ax.ThetaTickLabel = direcciones;
ax.RLim = [0 max([frecuencias_r1, frecuencias_r2, frecuencias_r3])];
ax.RLimMode = 'manual';
ax.ThetaGrid = 'on';
ax.RGrid = 'on';

% Ajustar el 0° (norte) en la parte superior y hacer que los ángulos vayan en sentido horario
ax.ThetaZeroLocation = 'top';  % Establece el norte en 0 grados
ax.ThetaDir = 'clockwise';      % Cambia la dirección de los ángulos a sentido horario

% Añadir la leyenda y título
legend('show');
title(sprintf(['Rosa de vientos medida en la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}));

[~, idx_r3] = max(frecuencias_r3);
viento_dominante = direcciones{idx_r3};

[~, idx_r1] = max(frecuencias_r1);
viento_reinante = direcciones{idx_r1};

fprintf('El viento dominante tiene el rumbo: %s\n', viento_dominante)
disp(' ')
fprintf('El viento reinante tiene el rumbo: %s\n', viento_reinante)


encabezados = {'Rapidez del Viento', 'Dirección Viento', 'Rumbo', 'Calma', 'Rango 1', 'Rango 2', 'Rango 3'};
tabla_vientos = [num2cell(rap_viento), num2cell(dir_viento), direccion(2:end, :), rangos(2:end, :)];
tabla_completa = [encabezados; tabla_vientos];
figure;
uitable('Data', tabla_completa, 'Units', 'normalized', 'Position', [0 0 1 1]);
title('Tabla de datos correspondientes al viento');

%% Rosa de vientos para ráfagas

% Clasificación por dirección del viento
direccion_r = cell(n+1, 1);
direccion_r{1} = 'Dirección del viento';

for i = 1:n
    if dir_rafaga(i) > 11.25 && dir_rafaga(i) <= 33.75
        direccion_r{i+1} = 'NNE';
    elseif dir_rafaga(i) > 33.75 && dir_rafaga(i) <= 56.25
        direccion_r{i+1} = 'NE';
    elseif dir_rafaga(i) > 56.25 && dir_rafaga(i) <= 78.75
        direccion_r{i+1} = 'ENE';
    elseif dir_rafaga(i) > 78.75 && dir_rafaga(i) <= 101.25
        direccion_r{i+1} = 'E';
    elseif dir_rafaga(i) > 101.25 && dir_rafaga(i) <= 123.75
        direccion_r{i+1} = 'ESE';
    elseif dir_rafaga(i) > 123.75 && dir_rafaga(i) <= 146.25
        direccion_r{i+1} = 'SE';
    elseif dir_rafaga(i) > 146.25 && dir_rafaga(i) <= 168.75
        direccion_r{i+1} = 'SSE';
    elseif dir_rafaga(i) > 168.75 && dir_rafaga(i) <= 191.25
        direccion_r{i+1} = 'S';
    elseif dir_rafaga(i) > 191.25 && dir_rafaga(i) <= 213.75
        direccion_r{i+1} = 'SSO';
    elseif dir_rafaga(i) > 213.75 && dir_rafaga(i) <= 236.25
        direccion_r{i+1} = 'SO';
    elseif dir_rafaga(i) > 236.25 && dir_rafaga(i) <= 258.75
        direccion_r{i+1} = 'OSO';
    elseif dir_rafaga(i) > 258.75 && dir_rafaga(i) <= 281.25
        direccion_r{i+1} = 'O';
    elseif dir_rafaga(i) > 281.25 && dir_rafaga(i) <= 303.75
        direccion_r{i+1} = 'ONO';
    elseif dir_rafaga(i) > 303.75 && dir_rafaga(i) <= 326.25
        direccion_r{i+1} = 'NO';
    elseif dir_rafaga(i) > 326.25 && dir_rafaga(i) <= 348.75
        direccion_r{i+1} = 'NNO';
    else 
        direccion_r{i+1} = 'N';
    end
end

% Caracterización por rangos de velocidad
rangos_r = cell(n+1, 4);
rangos_r{1, 1} = 'Calma';
rangos_r{1, 2} = 'Rango 1';
rangos_r{1, 3} = 'Rango 2';
rangos_r{1, 4} = 'Rango 3';

for i = 1:n
    if rap_rafaga(i) < 3.7
        rangos_r{i+1, 1} = 1;
        rangos_r{i+1, 2} = 0;
        rangos_r{i+1, 3} = 0;
        rangos_r{i+1, 4} = 0;
    elseif rap_rafaga(i) > 3.7 && rap_rafaga(i) <= 10
        rangos_r{i+1, 1} = 0;
        rangos_r{i+1, 2} = direccion_r{i+1};
        rangos_r{i+1, 3} = 0;
        rangos_r{i+1, 4} = 0;
    elseif rap_rafaga(i) > 10 && rap_rafaga(i) <= 18
        rangos_r{i+1, 1} = 0;
        rangos_r{i+1, 2} = 0;
        rangos_r{i+1, 3} = direccion_r{i+1};
        rangos_r{i+1, 4} = 0;
    else
        rangos_r{i+1, 1} = 0;
        rangos_r{i+1, 2} = 0;
        rangos_r{i+1, 3} = 0;
        rangos_r{i+1, 4} = direccion_r{i+1};
    end
end

% Frecuencia de cada rumbo por rangos
f_calmas_r = (sum(cellfun(@(x) isnumeric(x) && x == 1, rangos_r(2:end, 1))) / n)*100;

direcciones_r = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', ...
               'S', 'SSO', 'SO', 'OSO', 'O', 'ONO', 'NO', 'NNO'};

frecuencias_r1_r = zeros(1, length(direcciones_r));
frecuencias_r2_r = zeros(1, length(direcciones_r));
frecuencias_r3_r = zeros(1, length(direcciones_r));

for i = 1:length(direcciones_r)
    frecuencias_r1_r(i) = (sum(strcmp(rangos_r(:, 2), direcciones_r{i})) / n)*100;
    frecuencias_r2_r(i) = (sum(strcmp(rangos_r(:, 3), direcciones_r{i})) / n)*100;
    frecuencias_r3_r(i) = (sum(strcmp(rangos_r(:, 4), direcciones_r{i})) / n)*100;
end

% Preparar datos
num_direcciones_r = length(direcciones_r);
angulo_direcciones_r = linspace(0, 2*pi, num_direcciones_r + 1);
angulo_direcciones_r = angulo_direcciones_r(1:end-1) + pi/num_direcciones_r; % Ajustar al centro de cada sector

figure
polarplot([angulo_direcciones_r angulo_direcciones_r(1)], [frecuencias_r1_r frecuencias_r1_r(1)], '-o', 'LineWidth', 1.5, 'Color', 'b', 'DisplayName', 'Rango 1');
hold on
polarplot([angulo_direcciones_r angulo_direcciones_r(1)], [frecuencias_r2_r frecuencias_r2_r(1)], '-o', 'LineWidth', 1.5, 'Color', 'g', 'DisplayName', 'Rango 2');
polarplot([angulo_direcciones_r angulo_direcciones_r(1)], [frecuencias_r3_r frecuencias_r3_r(1)], '-o', 'LineWidth', 1.5, 'Color', 'r', 'DisplayName', 'Rango 3');

% Ajustes del gráfico
ax = gca;
ax.ThetaTick = rad2deg(angulo_direcciones_r); % Convertir ángulos a grados
ax.ThetaTickLabel = direcciones_r;
ax.RLim = [0 max([frecuencias_r1_r, frecuencias_r2_r, frecuencias_r3_r])];
ax.RLimMode = 'manual';
ax.ThetaGrid = 'on';
ax.RGrid = 'on';
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';

% Añadir la leyenda y título
legend('show');
title(sprintf(['Rosa de vientos medida en la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}));

[~, idx_r3] = max(frecuencias_r3_r);
rafaga_dominante = direcciones_r{idx_r3};

[~, idx_r1] = max(frecuencias_r1_r);
rafaga_reinante = direcciones_r{idx_r1};

fprintf('La ráfaga dominante tiene el rumbo %s\n', rafaga_dominante)
disp(' ')
fprintf('La ráfaga reinante tiene el rumbo: %s\n', rafaga_reinante)

encabezados = {'Rapidez de la Ráfaga', 'Dirección Ráfaga', 'Rumbo', 'Calma', 'Rango 1', 'Rango 2', 'Rango 3'};
tabla_rafaga = [num2cell(rap_rafaga), num2cell(dir_rafaga), direccion(2:end, :), rangos(2:end, :)];
tabla_completa = [encabezados; tabla_rafaga];
figure;
uitable('Data', tabla_completa, 'Units', 'normalized', 'Position', [0 0 1 1]);
title('Tabla de datos correspondientes al viento');

%% Gráfico de temperatura y humedad relativa para n días
n_dias = 2;
fecha_n_dias = fecha_local(1:(n_dias*145));
temp_n_dias = temp(1:(n_dias*145));
humedad_relativa_n_dias = humedad_relativa(1:(n_dias*145));

[temp_n_dias_min, idx_mintn] = min(temp_n_dias);
fecha_min_temp_n_dias = fecha_local(idx_mintn); 
[temp_n_dias_max, idx_maxtn] = max(temp_n_dias);
fecha_max_temp_n_dias = fecha_local(idx_maxtn);

[hum_min_ndias, idx_minhn] = min(humedad_relativa_n_dias);
fecha_min_hum_n_dias = fecha_local(idx_minhn); 
[hum_n_dias_max, idx_maxhn] = max(humedad_relativa_n_dias);
hum_max_ndias = fecha_local(idx_maxhn);

figure
yyaxis left % Eje y izquierdo
plot(fecha_n_dias, temp_n_dias, LineStyle="-", LineWidth=2, Color = [0.981 0.125 0.47])
hold on 
plot(fecha_min_temp_n_dias, temp_n_dias_min, Marker="o", MarkerSize=10, Color=[0 0 1], LineStyle='none')
plot(fecha_max_temp_n_dias, temp_n_dias_max, Marker="o", MarkerSize=10, Color=[1 0 0], LineStyle='none')
ylabel('Variación de la temperatura')

yyaxis right % Eje y derecho
plot(fecha_n_dias, humedad_relativa_n_dias, 'LineStyle', '-', 'LineWidth', 2, 'Color', [0.487 0.541 0.912])
ylabel('Variación de la humedad (%)') 
hold on
plot(fecha_min_hum_n_dias, hum_min_ndias, Marker="*", MarkerSize=10, Color=[0 0 1], LineStyle='none')
plot(hum_max_ndias, hum_n_dias_max, Marker="*", MarkerSize=10, Color=[1 0 0], LineStyle='none')

grid on
grid minor
title(sprintf(['Variación de la temperatura (°C) y la humedad relativa (%%) en \n' ...
    'dos días medido por la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}))
xlabel('Fecha') 
xlim([min(fecha_n_dias), max(fecha_n_dias)])
legend({'Temperatura', 'Temperatura mínima', 'Temperatura máxima', ...
        'Humedad relativa', 'Humedad relativa mínima', 'Humedad relativa máxima'}, 'Location', 'best')
hold off

%% Humedad relativa
figure
plot(fecha_local, humedad_relativa, LineStyle="-", LineWidth=1, Color=[0.487 0.541 0.912])
title(sprintf(['Variación de la humedad relativa (%%)' ...
    ' medido por la estación:\n ' ...
    '%s, %s, %s'], estacion{1}, ciudad{1}, municipio{1}))
xlabel('Fecha')
ylabel('Humedad relativa (%)')
legend('Humedad relativa')
grid on
grid minor
xlim([min(fecha_local), max(fecha_local)])
ylim([0 100])