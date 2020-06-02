function algo(imgName)
  %sctript para realizaçao dos testes
  ks = [1, 4, 9, 19];
  hs = [1, 10, 50, 100, 1000, 10000];
  imgPath = strcat(imgName, ".png");
  for k = ks
    printf("Compressing for k = %d\n", k)
    compress(imgPath, k);
    for h = hs
      printf("Decompressing1 for h = %d\n", h);
      outname = strcat(imgName, "-", "1", "-", num2str(k), "-", num2str(h),".png");
      decompress("compressed.png", 1, k, h, outname);
      printf("Decompressing2 for h = %d\n", h);
      outname = strcat(imgName, "-", "2", "-", num2str(k), "-", num2str(h),".png");
      decompress("compressed.png", 2, k, h, outname);
    endfor
  endfor

endfunction
