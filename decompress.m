function[] = decompress(compressedImg, method, k, h)
    [I, map] = imread(compressedImg);
    info = imfinfo(compressedImg);
    I = ind2rgb(I, map);

    # inicializa a matriz
    info.Height
    info.Width
    for i = 1 : info.Height
        for j = 1 : info.Width
            J(i*(k+1), j*(k+1),:) = I(i, j,:);
        endfor
        i
    endfor

    printf("Fim for\n");
    
    # if method == 1
    # bilinear
        printf("Chamando bilinear\n");
        bilinear(I, info, J, k, h)

    #else if method == 2
    # bicubico

    #endif
endfunction


function[J] = bilinear(I, info, J, k, h)
    for i = 2 : info.Height
        for j = 1 : info.Width-1
            fij = I(i, j);
            fi1j = I(i-1, j);
            fi1j1 = I(i-1, j+1);
            fij1 = I(i, j+1);
            F = [  fij ; fij1 ; fi1j; fi1j1 ];
            M = [1 0 0 0 ; 1 0 h 0; 1 h 0 0 ; 1 h h h^2];
            A = inv(M)*F;

            #Itera gerando a imagem J no quadrado i, j 
            xi = i*(k+1); 
            yj = j*(k+1);
            xi1 = (i-1)*(k+1);
            yj1 = (j+1)*(k+1);
            for x = i*(k+1) : (i-1)*(k+1)
                for y = j*(k+1) : (j+1)*(k+1)
                    J(x, y) = A(1) + A(1)*(x-xi)+A(3)*(y-yi)+A(4)*(x-xi)*(y-yi);
                endfor
            endfor
        endfor
        i
    endfor

    imshow(J);

#return J
endfunction