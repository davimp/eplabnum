function[ret] = calculateError(originalImg, decompressedImg)

    %le imagem original
    [I, map_I] = imread(originalImg);
    I = double(I);

    %le a outra imagem
    [J, map_J] = imread(decompressedImg);
    J = double(J);

    %calcula o erro
    errR = norm(I(:,:,1) - J(:,:,1))/norm(I(:,:,1));
    errG = norm(I(:,:,2) - J(:,:,2))/norm(I(:,:,2));
    errB = norm(I(:,:,3) - J(:,:,3))/norm(I(:,:,3));

    ret = (errR + errG + errB)/3;

endfunction
