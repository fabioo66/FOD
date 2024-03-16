program ejercicio2;
type
	archivo = file of integer;

procedure asignar(var enteros: archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta del archivo');
	readln(ruta);
	assign(enteros, ruta);
end;

procedure recorrer(var enteros:archivo; var numMen: integer; var promiedo: real);
var
	num, suma: integer;
begin
	suma:= 0;
	numMen:= 0;
	reset(enteros);
	while(not eof(enteros))do begin
		read(enteros, num);
		if(num < 1500)then
			numMen:= numMen + 1;
		suma:= suma + num;
	end;
	promiedo:= suma/ fileSize(enteros);
	close(enteros);
end;

procedure leer(var enteros: archivo);
var
	num: integer;
begin
	reset(enteros);
	writeln('Los numeros guardados son:');
	while(not eof(enteros))do begin
		read(enteros, num);
		writeln(num);
	end;
end;

var
	enteros : archivo;
	numMen : integer;
	promiedo : real;
BEGIN
	asignar(enteros);
	recorrer(enteros, numMen, promiedo);
	writeln('La cantidad de numeros menor a 1500 es ', numMen, ' y el promiedo de todos los numeros es ', promiedo:0:2);
	leer(enteros);
END.

