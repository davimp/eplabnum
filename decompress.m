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
            if i == 1 && j == 1
                delfdelx(1, j, :)  = (I(2, j, :)-I(1, j, :))/h;
                delfdely(i, 1, :) = (I(i, 2, :)-I(i, 1, :))/h;
                continue;
            endif
            if i == 1 && j == info.Width
                delfdelx(1, j, :) = (I(2, j, :)-I(1, j, :))/h;
                delfdely(i, info.Width, :) = (I(i, info.Height, :)-I(i, info.Height-1, :))/h;
                continue;
            endif
            if i == info.Height && j == 1
                delfdelx(info.Height, j, :) = (I(info.Height, j, :)-I(info.Height-1, j, :))/h;
                delfdely(i, 1, :) = (I(i, 2, :)-I(i, 1, :))/h;
                continue;
            endif
            if i == info.Height && j == info.Width
                delfdelx(info.Height, j, :) = (I(info.Height, j, :)-I(info.Height-1, j, :))/h;
                delfdely(i, info.Width, :) = (I(i, info.Height, :)-I(i, info.Height-1, :))/h;
                continue;
            endif
            if i == 1
                delfdelx(1, j, :) = (I(2, j, :)-I(1, j, :))/h;
                delfdely(i, j, :) = (I(i, j+1, :)-I(i, j-1, :))/2*h;
                continue;
            endif
            if i == info.Height
                delfdelx(info.Height, j, :) = (I(info.Height, j, :)-I(info.Height-1, j, :))/h;
                delfdely(i, j, :) = (I(i, j+1, :)-I(i, j-1, :))/2*h;
                continue;
            endif
            if j == 1
                delfdely(i, 1, :) = (I(i, 2, :)-I(i, 1, :))/h;
                delfdelx(i, j, :) = (I(i-1, j, :)-I(i+1, j, :))/2*h;
                continue;
            endif
            if j == info.Width 
                delfdely(i, info.Width, :) = (I(i, info.Height, :)-I(i, info.Height-1, :))/h;
                delfdelx(i, j, :) = (I(i-1, j, :)-I(i+1, j, :))/2*h;
                continue;
            endif
            delfdelx(i, j, :) = (I(i-1, j, :)-I(i+1, j, :))/2*h;
            delfdely(i, j, :) = (I(i, j+1, :)-I(i, j-1, :))/2*h;
        endfor
    endfor

    printf("Terminado delfdelx e delfdely\n");

    for i = 1 : info.Height
        for j = 1 : info.Width
            if (i == 1) 
                delfdelxy(1, j, :) = (delfdely(2, j, :)-delfdely(1, j, :))/h;
                continue;
            endif
            if (i == info.Height) 
                delfdelxy(info.Height, j, :) = (delfdely(info.Height, j, :)-delfdely(info.Height-1, j, :))/h;
                continue;
            endif 
            delfdelxy(i, j, :) = (delfdely(i-1, j, :)-delfdely(i+1, j, :))/2*h;
        endfor
    endfor

    printf("Terminado delfdelxy\n");

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
                
                A = inv(B)*F*inv(B');

                # Itera gerando a imagem J no quadrado i, j 
                xi = i*(k+1) - k;
                yj = j*(k+1) - k;
                xi1 = (i-1)*(k+1) - k;
                yj1 = (j+1)*(k+1) - k;
                for x = xi1 : xi
                    for y = yj : yj1
                        J(x, y, l) = [1 (x-xi) (x-xi)^2 (x-xi)^3 ]*A*[1 ; (y - yj) ; (y - yj)^2 ; (y - yj)^3]; 
                    endfor
                endfor

            endfor
        endfor
        i
    endfor
endfunction