function[] = decompress(compressedImg, method, k, h)
    [I, map] = imread(compressedImg);
    info = imfinfo(compressedImg);

    # inicializa a matriz
    for i = 1 : info.Height
        for j = 1 : info.Width
            J((i)*(k+1)-k, (j)*(k+1)-k,:) = I(i, j,:);
        endfor
        i
    endfor

    if (method == 1)
        # bilinear
        printf("Chamando bilinear\n");
        J = bilinear(I, info, J, k, h);
    endif
    if (method == 2)
        # bicubico
        printf("Chamando bicúbica\n");
        J = bicubica(I, info, J, k, h);
    endif

    imshow(J);
    imwrite(J, "decompressed.png");

endfunction


function[J] = bilinear(I, info, J, k, h)
    for i = 2 : info.Height
        for j = 1 : info.Width-1
            for l = 1 : 3 
                fij = I(i, j, l);
                fi1j = I(i-1, j, l);
                fi1j1 = I(i-1, j+1, l);
                fij1 = I(i, j+1, l);
                F = [  fij ; fij1 ; fi1j; fi1j1 ];
                size(fij);
                F = double(F);
                size(F);
                M = [1 0 0 0 ; 1 0 h 0; 1 h 0 0 ; 1 h h h^2];
                M = double(M);
                A = inv(M)*F;

                # Itera gerando a imagem J no quadrado i, j 
                xi = i*(k+1) - k;
                yj = j*(k+1) - k;
                xi1 = (i-1)*(k+1) - k;
                yj1 = (j+1)*(k+1) - k;
                for x = xi1 : xi
                    for y = yj : yj1
                        J(x, y, l) = A(1) + A(2)*(x-xi)+A(3)*(y-yj)+A(4)*(x-xi)*(y-yj);
                    endfor
                endfor

            endfor
        endfor
        i
    endfor
endfunction

function[J] = bicubica(I, info, J, k, h) 
    for i = 1 : info.Height
        for j = 1 : info.Width
            for l = 1 : 3
                if (i == 1) 
                    delfdelx(1, j, l) = (I(2, j, l)-I(1, j, l))/h;
                elseif (i == info.Height)
                    delfdelx(info.Height, j, l) = (I(info.Height, j, l)-I(info.Height-1, j, l))/h;
                else
                    delfdelx(i, j, l) = (I(i+1, j, l)-I(i-1, j, l))/2*h;
                endif

                if (j == 1)
                    delfdely(i, 1, l) = (I(i, 1, l)-I(i, 2, l))/h;
                elseif (j == info.Width)
                    delfdely(i, info.Width, l) = (I(i, info.Height-1, l)-I(i, info.Height, l))/h;
                else
                    delfdely(i, j, l) = (I(i, j-1, l)-I(i, j+1, l))/2*h;
                endif
            endfor
        endfor
    endfor

    delfdelx = double(delfdelx);
    delfdely = double(delfdely);

    printf("Terminado delfdelx e delfdely\n");

    for i = 1 : info.Height
        for j = 1 : info.Width
            for l = 1 : 3
                if (i == 1) 
                    delfdelxy(1, j, l) = (delfdely(2, j, l)-delfdely(1, j, l))/h;
                elseif (i == info.Height) 
                    delfdelxy(info.Height, j, l) = (delfdely(info.Height, j, l)-delfdely(info.Height-1, j, l))/h;
                else 
                    delfdelxy(i, j, l) = (delfdely(i+1, j, l)-delfdely(i-1, j, l))/2*h;
                endif
            endfor 
        endfor
    endfor

    printf("Terminado delfdelxy\n");
    delfdelxy = double(delfdelxy);

    for i = 2 : info.Height
        for j = 1 : info.Width-1
            for l = 1 : 3 
                fij = I(i, j, l);
                fi1j = I(i-1, j, l);
                fi1j1 = I(i-1, j+1, l);
                fij1 = I(i, j+1, l);

                F = [
                     fij fij1 delfdely(i, j, l) delfdely(i, j+1, l) ;
                     fi1j fi1j1 delfdely(i-1, j, l) delfdely(i-1, j+1, l) ;
                     delfdelx(i, j, l) delfdelx(i, j+1, l) delfdelxy(i, j, l) delfdelxy(i, j+1, l) ;
                     delfdelx(i-1, j, l) delfdelx(i-1, j+1, l) delfdelxy(i-1, j, l) delfdelxy(i-1, j+1, l)
                ];
                F = double(F);

                B = [
                    1 0 0 0 ;
                    1 h h^2 h^3 ;
                    0 1 0 0 ;
                    0 1 2*h 3*h^2
                ];
                B = double(B);
                
                A = inv(B)*F*inv((B)');

                # Itera gerando a imagem J no quadrado i, j 
                xi1 = (i-1)*(k+1) - k;
                xi = i*(k+1) - k;
                yj = j*(k+1) - k;
                yj1 = (j+1)*(k+1) - k;

                for x = xi1 : xi
                    for y = yj : yj1
                        J(x, y, l) = [1 (xi-x) (xi-x)^2 (xi-x)^3 ]*A*[1 ; (y - yj) ; (y - yj)^2 ; (y - yj)^3]; 
                    endfor
                endfor

            endfor
        endfor
        i
    endfor
endfunction