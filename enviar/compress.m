function[] = compress(originalImg, k)

    %ler imagem
    [I, map] = imread(originalImg);
    info = imfinfo(originalImg);

    %inicializa
    iJ = 1;
    jJ = 1;

    %colocamos na nova imagem (J) os pixels tl que j-1 deixa zero na divisao por k+1
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

    %escrevemos a imagem
    size(J)
    imwrite(J, "compressed.png");

endfunction
