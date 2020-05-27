function muitosErros()
  scanFiles(".", "png");


endfunction

function scanFiles(initialPath, extensions)
  persistent total = 0;
  persistent depth = 0; depth++;
  initialDir = dir(initialPath);

  printf('Scanning the directory %s\n', initialPath);

  for idx = 1 : length(initialDir)
    curDir = initialDir(idx);
    curPath = strcat(curDir.folder, '/', curDir.name);

    if regexp(curDir.name, "(?!(\\.\\.?)).*") * curDir.isdir
      scanFiles(curPath, extensions);
    elseif regexp(curDir.name, cstrcat("\\.(?i:)(?:", extensions, ")$"))
      total++;
      file = struct("name",curDir.name,
                     "path",curPath,
                     "parent",regexp(curDir.folder,'[^\\\/]*$','match'),
                     "bytes",curDir.bytes);
       mytxt = fopen('erros.txt', 'a');
       fprintf(mytxt, "Erro de %s eh: %.5f\n", file.name, calculateError("Lenna.ppm", file.path));
       fclose(mytxt);
    endif
  end

  if!(--depth)
    printf('Total number of files:%d\n', total);
    total=0;
  endif
endfunction
