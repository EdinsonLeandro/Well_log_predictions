function X=read_las_file(file)
% Read Log Ascii Standard (.LAS) file.
% Return a matrix "X" which columns are well log data from ".LAS" file.
%
% Modified from "lectlasfilex.m" function written by (Landa, 2004).

assy=fopen(file);
switch assy
    case -1
        warndlg('File is not found in the directory', 'Error!');
    case 2
        warndlg('Standar error when opening file', 'Error!');
    otherwise % File can be opened
        
        % Indicará el momento en que se consiga la línea adecuada
        A=0;
            while A==0
                % Read line from file.
                linlec=fgetl(assy);
                
                % The ".LAS" file begin with a comment(#) or title(~)
                if strncmp(linlec,'~',1) || strncmp(linlec,'#',1)
                    % Sólo se toman en cuenta las líneas que no corresponden
                    % a un comentario.
                    % ATENCIÓN-MEJORAR!!!: NO TODOS LOS COMENTARIOS 
                    % EN UN .LAS VIENEN SEGUIDOS DE UN '~'.
                    if ~strcmp(linlec(1),'#')
                        if strncmp(linlec,'~A',2)
                            reg=fscanf(assy,'%f');
                            while isempty(reg);
                                fgets(assy);
                                reg=fscanf(assy,'%f');
                            end
                            A=1;
                            % Detección del número de registros
                            for i=2:size(reg);
                                R=reg(1)-reg(i);
                                    if R<=2;
                                        break
                                    end
                            end
                            % Orden final de los registros
                            X=reshape(reg,i-1,[])';
                        end
                    end
                else
                    %El archivo no es de formato LAS
                    reg=fscanf(assy,'%f');
                    while isempty(reg);
                        fgets(assy);
                        reg=fscanf(assy,'%f');
                    end
                    A=1;
                    % Detección del número de registros
                    for i=2:size(reg);
                        R=reg(1)-reg(i);
                        if R<=2;
                            break
                        else
                            continue
                        end
                    end
                    % Orden final de los registros
                    X=reshape(reg,i-1,[])';
                end
            end
end
end                         