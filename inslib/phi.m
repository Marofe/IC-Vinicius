function fi = phi(omega)
    % Compute the adjoint matrix first
    ad_a = adj_G(omega);
    
    % Pre-allocate 'fi' as a matrix of zeros matching the exact size of ad_a
    fi = zeros(size(ad_a)); 
    
    for m = 0:10
        x = (((-1)^m) / factorial(m+1)) * (ad_a^m);
        fi = fi + x;
    end
end