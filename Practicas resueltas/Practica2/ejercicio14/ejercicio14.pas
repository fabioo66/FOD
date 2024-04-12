program ejercicio14;
const 
	valorAlto = 9999;
	dimf = 3; // = 10;
type
	archivoMaestro = record
		codigoProv : integer;
		nombreProv : string;
		codigoLoc : integer;
		nombreLoc : string;
	    sinLuz : integer;
	    sinGas : integer;
	    deChapa : integer;
	    sinAgua : integer;
	    sinSanitarios : integer;
	end;
	
	archivoDetalle = record
		codigoProv : integer;
		codigoLoc : integer;
		conLuz : integer;
		construidas : integer;
		conAgua : integer;
		conGas : integer;
		sanitarios : integer;
	end;
	
	rango = 1..dimf;
	
	maestro = file of archivoMaestro;
	detalle = file of archivoDetalle;
	vectorD = array[rango] of detalle;
	vectorR = array[rango] of archivoDetalle;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : vuelo;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigoProv, regM.nombreProv);
		readln(txt, regM.codigoLoc, regM.sinLuz, regM.sinGas, regM.deChapa, regM.singAgua, regM.sinSanitarios, regM.nombreLocalidad);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
	ruta : string;
    txt2 : text;
    regD : info;
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
        readln(txt2, regD.codigoProv, regD.codigoLoc, regD.conLuz, regD.construidas, regD.conAgua, regD.conGas, regD.sanitarios);
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;
 
var

begin 

end.
