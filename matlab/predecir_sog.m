function predicted_sog = predecir_sog(cog_actual, cog_hacia_vecino, sog_maximo)
    % 1. Calcular la diferencia de ángulo (cuánto tiene que girar el timón)
    delta_cog = abs(cog_hacia_vecino - cog_actual);
    
    % Asegurarnos de usar el camino más corto en el círculo de 360 grados
    if delta_cog > 180
        delta_cog = 360 - delta_cog;
    end
    
    % 2. Aplicar el modelo de pérdida de velocidad
    % Coeficiente de pérdida (ajústalo según lo agresivo que quieras que sea)
    k_penalizacion = 0.3; 
    
    % 3. Calcular la velocidad final en ese tramo
    predicted_sog = sog_maximo * (1 - k_penalizacion * (delta_cog / 180));
    
    % Opcional: Asegurar una velocidad mínima para que el barco no se detenga
    % (ej. nunca baja de 5 nudos)
    predicted_sog = max(predicted_sog, 5.0);
end