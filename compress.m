function[] = compress(originalImg, k)
    [I, map] = imread(originalImg);
    info = imfinfo(originalImg);

    I = ind2rgb(I, map);
    iJ = 1;
    jJ = 1;

    for i = 1 : info.Height
        if rem(i-1, k+1) == 0
            for j = 1 : info.Width
                if rem(j-1, k+1) == 0
                    J(iJ, jJ, :) = I(i, j, :);
                    jJ = jJ + 1;
                endif
            endfor
        jJ = 1;
        iJ = iJ + 1;
        endif
    endfor

    size(J)
    imwrite(J, "compressed.png");

endfunction
