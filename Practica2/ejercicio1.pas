program ejercicio1;
const valorAlto = 9999;

type
	ingresosComision = record
		codigo : integer;
		nombre : string[30];
		monto : real;
	end;
	
	archivo = file of ingresosComision;

procedure importarTxt(var comision : archivo);
var
	txt : text;
	c : ingresosComision;
begin
	assign(comision, 'comisiones.dat');
	rewrite(comision);
	writeln('Realizando importacion de archivo comisiones.txt');
	assign(txt, 'comisiones.txt');
	reset(txt);
	while(not eof(txt))do begin
		read(txt, c.codigo, c.monto, c.nombre);
		write(comision, c);
	end;
	writeln('La importacion se ha realizado con exito');
	close(comision);
	close(txt);
end;

procedure leer(var comision : archivo; var c : ingresosComision);
begin
	if(not eof(comision))then
		read(comision,c)
    else
        c.codigo:= valoralto;
end;

procedure asignar(var compactFile : archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta donde desea compactar el archivo');
	readln(ruta);
	assign(compactFile, ruta);
end;
	
procedure compactar(var compactFile : archivo);	
var
	comision : archivo;
	c : ingresosComision;
	codigo : integer;
	montoTotal : real;
begin
	asignar(compactFile);
	rewrite(compactFile);
	reset(comision);
	leer(comision, c);
	while(c.codigo <> valorAlto)do begin
		codigo := c.codigo;
		montoTotal := 0;
		while(c.codigo <> valorAlto) and (c.codigo = codigo) do begin
			montoTotal:= montoTotal + c.monto;
			leer(comision,c);
		end;
		c.monto:= montoTotal;
		write(compactFile, c);
	end;
	close(comision);
	close(compactFile);
end;

procedure informarEmpleado(c : ingresosComision);
begin
	writeln('codigo ', c.codigo, ' monto ', c.monto:0:2, ' nombre ', c.nombre);
end;

procedure informar(var compactFile : archivo);
var
	c : ingresosComision;
begin
	writeln('Empleados de la empresa: ');
	reset(compactFile);
	while(not eof(compactFile))do begin
		read(compactFile, c);
		informarEmpleado(c);
	end;
	close(compactFile);
end;

var
	comision, compactFile : archivo;
begin
	importarTxt(comision);
	compactar(compactFile);
	informar(compactFile);
end.
