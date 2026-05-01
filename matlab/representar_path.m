function representar_path(n, barco_propio, obstaculos, path)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    figure(n); hold on; grid on; axis equal;
    xlabel('X [nm]'); ylabel('Y [nm]');

    largo_flecha = 1;
    
    color = 'b';
    plot(barco_propio.position(1), barco_propio.position(2), [color 's'], 'MarkerSize', 12, 'MarkerFaceColor', color, 'LineWidth', 2);

    u = largo_flecha * sind(barco_propio.COG);
    v = largo_flecha * cosd(barco_propio.COG);

    quiver(barco_propio.position(1), barco_propio.position(2), u, v, 0, 'Color', color, 'LineWidth', 2, 'MaxHeadSize', 0.5);

    for i =1:length(obstaculos)
        color = 'r';
        plot(obstaculos(i).position(1), obstaculos(i).position(2), [color 's'], 'MarkerSize', 12, 'MarkerFaceColor', color, 'LineWidth', 2);
    
        u = largo_flecha * sind(obstaculos(i).COG);
        v = largo_flecha * cosd(obstaculos(i).COG);
    
        quiver(obstaculos(i).position(1), obstaculos(i).position(2), u, v, 0, 'Color', color, 'LineWidth', 2, 'MaxHeadSize', 0.5);
    end
end