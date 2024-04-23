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

procedure eliminarFlor (var arch : tArchFlores);
var
	f, aux : reg_flor;
	codigo : integer;
	ok : boolean;
begin
	reset (arch);
	ok := false;
	write ('INGRESE CODIGO DE LA FLOR QUE DESEA ELIMINAR: '); 
	readln (codigo);
	writeln ('');
	read(arch, aux); 
	read(arch, f);
	while(not eof(arch) and not ok)do begin
		if(f.codigo = codigo)then begin
			ok := true;
			f.codigo:= aux.codigo; 
			seek(arch, filePos(arch)-1);
			aux.codigo:= filePos(arch) * -1; 
			write(arch, f);
			seek(arch ,0);
			write(arch, aux); 
		end
		else
			read(arch, f);
	end;
	if(ok)then 
		writeln('FLOR ELIMINADA')
	else
		writeln('NO SE ENCONTRO FLOR');
	close(arch);
end;


procedure agregarFlor (var a : tArchFlores; nombre : string; codigo:integer);
var
	f : reg_flor;
	pos : integer;
	encontre : boolean;
begin
	encontre := false;
	reset(a);
	read(a, f);
	if(f.codigo < 0)then begin
		pos := f.codigo *-1;
		seek(a, pos);
		f.nombre := nombre;
		f.codigo := codigo;
		write(a, f);
		seek(a, 1);
		while(not eof(a) and not encontre)do begin
			read(a, f);
			if(f.codigo < 0)then 
				encontre := true;
		end;
		if(not encontre)then begin
			f.codigo := 0;
			seek(a, 0);
			write(a, f)
		end
		else begin
			seek(a, 0);
			write(a, f);
		end;
	end
	else
		writeln('No hay espacio disponible');
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
begin
	cargarArchivo(arch);
	imprimirArchivo(arch);
	writeln('Se eliminaran dos flores para hacer una prueba');
	eliminarFlor(arch);
	eliminarFlor(arch);
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


