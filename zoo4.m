function zoo4(imgName, ini, fim, p)
    img = zeros(p, p, 3);
    i = p;
    for x = linspace(ini,fim, p)
        j = 1;
        for y = linspace(ini, fim, p)
            img(i, j, 1:3) = f(x, y);
            j += 1;
        endfor
    i -= 1
    endfor
    imwrite(img, imgName);
endfunction


function ret = f(x, y)
    ret = zeros(3);
    ret = [x, x+y, cos(x)];
endfunction
