function REG=carga_registro(archivo)
% Función que lee un registro de pozo.
% X = lectura_registro(ARCHIVO) arroja una matriz X cuyas columnas se
% corresponden con los registros de pozo provenientes de ARCHIVO (cuyo
% nombre debe escribirse entre comilla ' ' y con su propia extensión).
%
% Modificada de la función "lectlasfilex.m". Tesis (Landa, 2004) titulada:
% "Diseño de un algoritmo para la visualización y procesamiento 
% automatizado de registros de Pozo"

assy=fopen(archivo);
switch assy %
    case -1 %
        warndlg('El archivo no se encuentra en el Directorio adecuado',...
            '¡Error!');
    case 2 %
        warndlg('Error Estándar al abrir el archivo','¡Error!');
    otherwise % El archivo puede abrirse
        A=0; %Indicará el momento en que se consiga la línea adecuada
        while A==0
            % Se lee una línea del archivo
            linlec=fgetl(assy);
            % Si es un archivo LAS, estos comienzan bien con un comentario
            % (#) o con un título (~)
                if strncmp(linlec,'~',1) || strncmp(linlec,'#',1)
                    % Sólo se toman en cuenta las líneas que no corresponden
                    % a un comentario
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
                            REG=reshape(reg,i-1,[])';
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
                    REG=reshape(reg,i-1,[])';                   
                end
        end
end

end