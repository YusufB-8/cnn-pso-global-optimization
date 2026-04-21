clc; clearvars -except trainedNetwork_1;

fig = uifigure('Name', 'CSOE PRO: Analiz Terminali', 'Color', [0.12 0.12 0.14], 'Position', [500 400 480 320]);

uilabel(fig, 'Text', '⚡ CSOE OPTIMIZATION ENGINE', 'FontWeight', 'bold', 'FontSize', 18, ...
    'FontColor', [0.3 0.8 1], 'Position', [80 260 320 35], 'HorizontalAlignment', 'center');

uilabel(fig, 'Text', 'MATEMATİKSEL DENKLEM (x,y):', 'FontColor', [0.8 0.8 0.8], 'Position', [40 210 200 22]);
fEdit = uieditfield(fig, 'text', 'Position', [40 185 400 28], 'BackgroundColor', [0.2 0.2 0.22], ...
    'FontColor', 'w', 'Value', '');  
uilabel(fig, 'Text', 'SINIR (RANGE):', 'FontColor', [0.8 0.8 0.8], 'Position', [40 135 100 22]);
limEdit = uieditfield(fig, 'numeric', 'Position', [40 110 180 28], 'BackgroundColor', [0.2 0.2 0.22], 'FontColor', 'w', 'Value', 5);

uilabel(fig, 'Text', 'SÜRÜ (SWARM):', 'FontColor', [0.8 0.8 0.8], 'Position', [260 135 100 22]);
sEdit = uieditfield(fig, 'numeric', 'Position', [260 110 180 28], 'BackgroundColor', [0.2 0.2 0.22], 'FontColor', 'w', 'Value', 40);

btn = uibutton(fig, 'push', 'Text', 'ANALİZİ BAŞLAT', 'BackgroundColor', [0 0.5 0.2], ...
    'FontColor', 'w', 'FontWeight', 'bold', 'FontSize', 14, 'Position', [140 35 200 45], ...
    'ButtonPushedFcn', @(btn,event) uiresume(fig));

uiwait(fig);
if ~isvalid(fig), return; end
userInput = fEdit.Value;
limit = limEdit.Value;
sSize = sEdit.Value;
close(fig);

gridRes = 64;
[Xg, Yg] = meshgrid(linspace(-limit, limit, gridRes));
try
    f_user = str2func(['@(x,y) ' userInput]);
    Z_raw = f_user(Xg, Yg);
catch
    errordlg('Hata: Denklem formatı yanlış! Noktalı operatör (x.^2) kullandığınızdan emin olun.', 'Format Hatası');
    return;
end

Z_test = Z_raw + 0.02*randn(size(Z_raw)); 
Z_norm = (Z_test - mean(Z_test(:))) / (std(Z_test(:)) + 1e-6);

[~, idx] = min(Z_test(:)); [r, c] = ind2sub([64 64], idx);
init_guess = [Xg(1,c), Yg(r,1)];
swarm = repmat(init_guess, sSize, 1) + randn(sSize, 2) * (limit/10);

options = optimoptions('particleswarm', 'InitialSwarmMatrix', swarm, ...
    'SwarmSize', sSize, 'MaxIterations', 60, 'Display', 'iter');

[final_coords, ~] = particleswarm(@(v) surrogate_fitness(v, trainedNetwork_1, Z_norm, Xg, Yg), ...
    2, [-limit -limit], [limit limit], options);

figRes = figure('Name', 'CSOE Professional Analyzer', 'Color', 'w', 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.7]);

subplot(1, 2, 1);
surf(Xg, Yg, Z_test, 'EdgeColor', 'none'); shading interp; colormap jet; alpha 0.7; hold on;


z_final = interp2(Xg, Yg, Z_test, final_coords(1), final_coords(2));
plot3(final_coords(1), final_coords(2), z_final, 'bo', 'MarkerSize', 15, 'MarkerFaceColor', 'b', 'LineWidth', 2);


Lmin = imregionalmin(Z_test);
plot3(Xg(Lmin), Yg(Lmin), Z_test(Lmin), 'go', 'MarkerSize', 5, 'MarkerFaceColor', 'g');


[z_max, maxIdx] = max(Z_test(:));
plot3(Xg(maxIdx), Yg(maxIdx), z_max, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');

Lmax = imregionalmax(Z_test);
plot3(Xg(Lmax), Yg(Lmax), Z_test(Lmax), 'ko', 'MarkerSize', 4, 'MarkerFaceColor', 'k');

title(['Yüzey Analizi: ', userInput]);
legend('Yüzey', 'Global Min (PSO)', 'Local Min', 'Global Max', 'Local Max', 'Location', 'southoutside', 'Orientation', 'horizontal');
grid on; view(-45, 30);

subplot(1, 2, 2);
contourf(Xg, Yg, Z_test, 25, 'LineColor', 'none'); colormap jet; hold on;
plot(final_coords(1), final_coords(2), 'w+', 'MarkerSize', 25, 'LineWidth', 3);
plot(final_coords(1), final_coords(2), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
title('Topografik Yoğunluk Haritası');
xlabel('X Ekseni'); ylabel('Y Ekseni'); colorbar;


msgbox({['✅ ANALİZ BAŞARIYLA TAMAMLANDI'], ...
        ['📍 Koordinatlar: X=' num2str(final_coords(1)) ' Y=' num2str(final_coords(2))], ...
        ['📉 Tespit Edilen Min Z: ' num2str(z_final)]}, 'CSOE Final Raporu');
