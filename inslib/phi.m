function fi=phi(omega)
fi=0;
ad_a=adj_G(omega);
    for m=0:10
        x=(((-1)^m)/(factorial((m+1))))*(ad_a^m);
        fi=fi+x;
    end

end