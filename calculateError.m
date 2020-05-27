function[ret] = calculateError(originalImg, decompressedImg)

    [I, map_I] = imread(originalImg);
    % I = ind2rgb(I, map_I);
    I = double(I);

    [J, map_J] = imread(decompressedImg);
    % J = ind2rgb(J, map_J);
    J = double(J);


    errR = norm(I(:,:,1) - J(:,:,1))/norm(I(:,:,1));
    errG = norm(I(:,:,2) - J(:,:,2))/norm(I(:,:,2));
    errB = norm(I(:,:,3) - J(:,:,3))/norm(I(:,:,3));

    ret = (errR + errG + errB)/3;

endfunction
