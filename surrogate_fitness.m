function f = surrogate_fitness(v, net, Z_norm, Xg, Yg)
    xi = round((v(1) + 5) / 10 * 63) + 1;
    yi = round((v(2) + 5) / 10 * 63) + 1;
    xi = max(2, min(63, xi)); yi = max(2, min(63, yi));
    
    patch = cat(3, Z_norm(yi-1:yi+1, xi-1:xi+1), ...
                   Xg(yi-1:yi+1, xi-1:xi+1), ...
                   Yg(yi-1:yi+1, xi-1:xi+1));
    
    f = predict(net, patch); 
end
