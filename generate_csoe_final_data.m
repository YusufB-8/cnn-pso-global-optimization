clc; clear;

N = 10000;
patchSize = 3;
gridRes = 64;

[Xg, Yg] = meshgrid(linspace(-5,5,gridRes));

inputs = zeros(patchSize, patchSize, 3, N);
labels = zeros(N, 1);

for i = 1:N

    type = randi(4);
    sigma = 0.01 + 0.04*rand();

    switch type
        case 1
            f = @(x,y) x.^2 + y.^2;

        case 2
            f = @(x,y) sin(x) + cos(y);

        case 3
            f = @(x,y) exp(-(x.^2 + y.^2));

        case 4
            f = @(x,y) sin(x.*y);
    end

 
    Z = f(Xg, Yg) + sigma*randn(gridRes);

    Z_norm = (Z - mean(Z(:))) / (std(Z(:)) + 1e-6);

   
    r = randi([2, gridRes-1]);
    c = randi([2, gridRes-1]);

   
    inputs(:,:,1,i) = Z_norm(r-1:r+1, c-1:c+1);
    inputs(:,:,2,i) = Xg(r-1:r+1, c-1:c+1);
    inputs(:,:,3,i) = Yg(r-1:r+1, c-1:c+1);

    
    labels(i) = Z_norm(r,c);

end

save('CSOE_Final_Dataset.mat','inputs','labels');

disp("Dataset hazır ✔");
