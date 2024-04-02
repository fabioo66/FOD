program ejercicio9;
const valorAlto = 9999;

type
	votos = record
		codigoProv : integer;
		codigoLoc : integer;
		numMesa : integer;
		cantVotosMesa : integer;
	end;
	
	archivo = file of votos;
	
procedure importarVotos(var votes : archivo);
var
	txt : text;
	v : votos;
begin
	assign(votes, 'votos.dat');
	rewrite(votes);
	assign(txt, 'votos.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, v.codigoProv, v.codigoLoc, v.numMesa, v.cantVotosMesa);
		write(votes, v);
	end;
	writeln('Archivo de votos creado');
	close(txt);
	close(votes);
end;

procedure leer(var votes : archivo; var v : votos);
begin
    if(not eof(votes)) then
        read(votes, v)
    else 
        v.codigoProv := valorAlto;
end;
 
procedure procesar(var votes : archivo);
var
	v : votos;
	total, totalProv, totalLoc, codigoProv, codigoLoc: integer;
begin
	reset(votes);
	total := 0;
	leer(votes, v);
	while(v.codigoProv <> valorAlto)do begin
		writeln('Codigo de provincia ', v.codigoProv);
		totalProv := 0;
		codigoProv := v.codigoProv;
		while(v.codigoProv = codigoProv)do begin
			writeln('Codigo de localicad ', v.codigoLoc);
			totalLoc := 0;
			codigoLoc := v.codigoLoc;
			while(v.codigoProv = codigoProv) and (v.codigoLoc = codigoLoc)do begin
				totalLoc := totalLoc + v.cantVotosMesa;
				leer(votes, v);
			end;
			writeln('Total de votos Localidad: ', totalLoc);
			totalProv := totalProv + totalLoc;
		end;
		writeln('Total de votos Provincia: ', totalProv);
		total := total + totalProv;
	end;
	writeln('Total general de votos: ', total);
	close(votes);
end;

var
	votes : archivo;
begin
	importarVotos(votes); //se dispone
	procesar(votes);
end.


