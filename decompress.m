function[] = decompress(compressedImg, method, k, h, outName)
    [I, map] = imread(compressedImg);
    info = imfinfo(compressedImg);

    % I = im2double(I);
    h = double(h);

    printf("Altura ");
    info.Height
    printf("Largura ");
    info.Width
    printf("Altura máxima: ");
    info.Width*(k+1)-k

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

    size(J)
    % imshow(J);
    imwrite(J, outName);

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
    Dx = zeros(info.Height, info.Width, 3, "double");
    Dy = zeros(info.Height, info.Width, 3, "double");
    Dxy = zeros(info.Height, info.Width, 3, "double");

    for i = 1 : info.Height
        for j = 1 : info.Width
            for l = 1 : 3
                if (i == 1)
                    Dx(1, j, l) = (I(2, j, l)-I(1, j, l))/h;
                elseif (i == info.Height)
                    Dx(info.Height, j, l) = (I(info.Height-1, j, l)-I(info.Height, j, l))/h;
                else
                    Dx(i, j, l) = (I(i+1, j, l)-I(i-1, j, l))/h;
                endif

                if (j == 1)
                    Dy(i, 1, l) = (I(i, 1, l)-I(i, 2, l))/h;
                elseif (j == info.Width)
                    Dy(i, info.Width, l) = (I(i, info.Width-1, l)-I(i, info.Width, l))/h;
                else
                    Dy(i, j, l) = (I(i, j-1, l)-I(i, j+1, l))/(2*h);
                endif
            endfor
        endfor
    endfor

    Dx = double(Dx);
    Dy = double(Dy);

    printf("Terminado Dx e Dy\n");

    for i = 1 : info.Height
        for j = 1 : info.Width
            for l = 1 : 3
                if (i == 1)
                    Dxy(1, j, l) = (Dy(2, j, l)-Dy(1, j, l))/h;
                elseif (i == info.Height)
                    Dxy(info.Height, j, l) = (Dy(info.Height, j, l)-Dy(info.Height-1, j, l))/h;
                else
                    Dxy(i, j, l) = (Dy(i+1, j, l)-Dy(i-1, j, l))/(2*h);
                endif
            endfor
        endfor
    endfor

    Dxy = double(Dxy);
    printf("Terminado Dxy\n");

    fij = 0;
    fi1j = 0;
    fi1j1 = 0;
    fij1 = 0;
    for i = 2 : info.Height
        for j = 1 : info.Width-1
            for l = 1 : 3
                fij = I(i, j, l);
                fi1j = I(i-1, j, l);
                fi1j1 = I(i-1, j+1, l);
                fij1 = I(i, j+1, l);

                F = [
                     fij fij1 Dy(i, j, l) Dy(i, j+1, l) ;
                     fi1j fi1j1 Dy(i-1, j, l) Dy(i-1, j+1, l) ;
                     Dx(i, j, l) Dx(i, j+1, l) Dxy(i, j, l) Dxy(i, j+1, l) ;
                     Dx(i-1, j, l) Dx(i-1, j+1, l) Dxy(i-1, j, l) Dxy(i-1, j+1, l)
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
                        J(x, y, l) = [1 (xi-x) (xi-x)^2 (xi-x)^3 ]*A*[1 ; (y-yj) ; (y-yj)^2 ; (y-yj)^3];
                    endfor
                endfor

            endfor
        endfor
        i
    endfor
endfunction
