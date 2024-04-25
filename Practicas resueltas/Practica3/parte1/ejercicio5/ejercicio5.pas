program ejercicio4;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;
	
procedure leerFlor(var f : reg_flor);
begin
	writeln('Ingrese el codigo de la flor');
	readln(f.codigo);
	if(f.codigo <> -1)then begin
		writeln('Ingrese el nombre de la flor');
		readln(f.nombre);
	end;
end;

procedure cargarArchivo(var arch : tArchFlores);
var
	f : reg_flor;
begin
	assign(arch, 'Flores.dat');
	rewrite(arch);
	f.codigo := 0;
	f.nombre := 'cabecera';
	write(arch, f);
	leerFlor(f);
	while(f.codigo <> -1)do begin
		write(arch, f);
		leerFlor(f);
	end;
	writeln('Archivo creado');
	close(arch);
end;

procedure eliminarFlor (var arch : tArchFlores; flor : reg_flor);
var
	f, aux : reg_flor;
	ok : boolean;
begin
	reset (arch);
	ok := false;
	read(arch, aux); 
	while(not eof(arch) and not ok)do begin
		read(arch, f);
		if(f.codigo = flor.codigo)then begin
			ok := true;
			seek(arch, filePos(arch)-1);
			write(arch, aux);
			aux.codigo:= (filePos(arch)-1) * -1; 
			seek(arch ,0);
			write(arch, aux); 
		end;
	end;
	if(ok)then 
		writeln('FLOR ELIMINADA')
	else
		writeln('NO SE ENCONTRO FLOR');
	close(arch);
end;


procedure agregarFlor (var a : tArchFlores; nombre : string; codigo:integer);
var
	f, aux : reg_flor;
begin
	reset(a);
	read(a, aux);
	f.codigo := codigo;
	f.nombre := nombre;
	if(aux.codigo = 0)then begin 
		seek(a, filepos(a));
		write(a, f)
	end
	else begin
		seek(a, aux.codigo *-1);
		read(a, aux);
		seek(a, filepos(a)-1);
		write(a, f);
		seek(a, 0);
		write(a, aux);
	end;
	writeln('Se agrego una flor correctamente');
	close(a);
end;

procedure imprimirArchivo(var arch : tArchFlores);
var
	f : reg_flor;
begin
	f.codigo := 0;
	reset(arch);
	seek(arch, 1);
	while(not eof(arch))do begin
		read(arch, f);
		if(f.codigo <= 0)then
			writeln('Espacio disponible')
		else
			writeln('Codigo ', f.codigo, ' Nombre ', f.nombre);
	end;
	close(arch);
end;

var
	arch : tArchFlores;
	nombre : string;
	codigo : integer;
	f : reg_flor;
begin
	cargarArchivo(arch);
	imprimirArchivo(arch);
	writeln('Se eliminaran dos flores para hacer una prueba');
	writeln('Ingrese el codigo de la flor a eliminar');
	readln(codigo);
	f.codigo := codigo;
	eliminarFlor(arch, f);
	writeln('Ingrese el codigo de la flor a eliminar');
	readln(codigo);
	f.codigo := codigo;
	eliminarFlor(arch, f);
	writeln('--------------------------------------------------');
	imprimirArchivo(arch);
	writeln('Ingrese el nombre de la flor que desea agregar');
	readln(nombre);
	writeln('Ingrese el codigo de la flor que desea agregar');
	readln(codigo);
	agregarFlor(arch, nombre, codigo);
	writeln('--------------------------------------------------');
	imprimirArchivo(arch);
	
	writeln('Ingrese el nombre de la flor que desea agregar');
	readln(nombre);
	writeln('Ingrese el codigo de la flor que desea agregar');
	readln(codigo);
	agregarFlor(arch, nombre, codigo);
	writeln('--------------------------------------------------');
	imprimirArchivo(arch);
end.


