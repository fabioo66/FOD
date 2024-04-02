program ejercicio1;
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

procedure cargar(var enteros: archivo);
var
	num: integer;
begin
	rewrite(enteros);
	writeln('Ingrese un numero para el archivo (la lectura finaliza con el numero 30000)');
	readln(num);
	while(num <> 30000)do begin
		write(enteros, num);
		readln(num);
	end;
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
BEGIN
	asignar(enteros);
	cargar(enteros);
	leer(enteros);
END.

