program ejercicio3;
const
    dimf = 3; // = 5;
type 
    data = record
        codigo: integer;
        fecha: string;
        tiempo: real;
    end;
    archivo = file of data;

    vectorD = array[1..dimf] of archivo;

procedure importarDetalle(var det : archivo);
var
	ruta : string;
    txt2 : text;
    regD : data;
begin
	writeln('Ingrese la ruta del archivo detalle binario');
	readln(ruta);
    assign(det, ruta);
    rewrite(det);
    writeln('Ingrese la ruta del archivo detalle.txt');
	readln(ruta);
    assign(txt2, ruta);
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.codigo, regD.tiempo, regD.fecha); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure cargarVectorDetalles(var vd : vectorD);
var
	i : integer;
begin
	for i := 1 to dimf do
		importarDetalle(vd[i]);
end;

procedure crearMaestro(var mae : archivo; vd : vectorD);
var
    d, regM : data;
    encontre : boolean;
    i : integer;
begin
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    for i := 1 to dimf do begin 
        reset(vd[i]);
        while(not eof(vd[i]))do begin
            seek(mae, 0);
            read(vd[i], d);
            encontre := false;
            while((not eof(mae)) and (not encontre))do begin
                read(mae, regM);
                if(d.codigo = regM.codigo)then
                    encontre := true;
            end;
            if(encontre)then begin 
                regM.tiempo := regM.tiempo + d.tiempo;
                seek(mae, filepos(mae)-1);
                write(mae, regM);
            end
            else
                write(mae, d);
        end;
        close(vd[i]);
    end;
    close(mae);
    writeln('Archivo maestro creado');
end;

procedure imprimirMaestro(var mae : archivo);
var
    regM : data;
begin
    reset(mae);
    while(not eof(mae))do begin
        read(mae, regM);
        writeln('Codigo de usuario = ', regM.codigo, ' Fecha = ', regM.fecha, ' Tiempo total = ', regM.tiempo:0:2);
    end;
    close(mae);
end;

var
    mae : archivo;
    vd : vectorD;
begin
    cargarVectorDetalles(vd);
    crearMaestro(mae, vd);
    writeln('Archivo maestro : ');
    imprimirMaestro(mae);
end.
