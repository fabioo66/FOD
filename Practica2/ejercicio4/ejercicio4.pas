program ejercicio4
const valorAlto : 'ZZZZ';

type
	archivoMaestro = record
		cantPersonas : integer;
		totalPersonas : integer;
		provincia : string[30]
	end;
	
	archivoDetalle = record
		codigo : integer;
		cantPersonas : integer;
		totalPersonas : integer;
		provincia : string[30];
	end;
	
	maestro = file of archivoMaestro;
	detalle = file of archivoDetalle;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : archivoMaestro;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.cantPersonas, regM.totalPersonas, regM.provincia);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    txt2 : text;
    regD : archivoDetalle;
begin
    assign(det, 'detalle.dat');
    rewrite(det);
    assign(txt2, 'detalle.txt');
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.codigo, regD.cantPersonas, regD.totalPersonas, regD.provincia); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;
