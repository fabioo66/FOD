{2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}

program ejercicio2;
type
    localidad = record
        codigo: integer;
        mesa: integer;
        cant: integer;
    end;

    archivo = file of localidad;

procedure cargarArchivo(var arc: archivo);
var
    txt: text;
    l: localidad;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do begin
        with l do begin
            readln(txt, codigo, mesa, cant);
            write(arc, l);
        end;
    end;
    writeln('Archivo maestro generado');
    close(arc);
    close(txt);
end;

procedure crearAuxiliar(var mae : archivo; var auxArch : archivo; var cantTotal : integer);
var
    l, aux : localidad;
    encontre: boolean;
begin
    cantTotal := 0;
    reset(mae);
    assign(auxArch, 'Archivo_auxiliar');
    rewrite(auxArch);
    while (not eof(mae)) do begin
        read(mae, l);
        encontre := false;
        seek(auxArch, 0);
        while (not eof(auxArch)) and (not encontre) do begin
            read(auxArch, aux);
            if (l.codigo = aux.codigo) then 
                encontre := true;
        end;
        if(encontre) then begin
            aux.cant:= aux.cant + l.cant;
            seek(auxArch, filepos(auxArch)-1);
            write(auxArch, aux);
        end
        else
            write(auxArch, l);
        cantTotal:= cantTotal + l.cant;
    end;
    close(mae);
    close(auxArch);
end;

procedure imprimirArchivo(var arc: archivo; cantTotal: integer);
var
    l: localidad;
begin
    reset(arc);
    writeln('Codigo de Localidad          Total de Votos');
    while(not eof(arc)) do begin
        read(arc, l);
        writeln(l.codigo, '                                ', l.cant);
    end;
    writeln('Total General de Votos: ', cantTotal);
    close(arc);
end;

var 
    mae, newArch : archivo;
    cantTotal : integer;
begin
    cargarArchivo(mae);
    crearAuxiliar(mae, newArch, cantTotal);
    imprimirArchivo(newArch, cantTotal);
end.
