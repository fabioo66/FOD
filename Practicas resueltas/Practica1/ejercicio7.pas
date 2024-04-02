program ejercicio7;
type
	novela = record
		codigo : integer;
		nombre : string;
		genero : string;
		precio : real;
	end;
	
	archivo = file of novela;

procedure asignar(var nov : archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta del archivo');
	readln(ruta);
	assign(nov, ruta);
end;

procedure cargar(var nov : archivo);
var
	txt : text;
	n : novela;
begin
	asignar(nov);
	writeln('Importando datos de "novelas.txt"');
	assign(txt, 'novelas.txt');
	reset(txt);
	rewrite(nov);
	while(not eof(txt))do begin //importacion del archivo de text a binario
		readln(txt, n.codigo, n.precio, n.genero);
		readln(txt, n.nombre);
		write(nov, n);
	end;
	writeln('La importacion se ha realizado con exito');
	close(txt);
	close(nov);
end;

procedure leerNovela(var n : novela);
begin
	writeln('Ingrese el codigo de la novela');
	readln(n.codigo);
	writeln('Ingrese el nombre');
	readln(n.nombre);
	writeln('Ingrese el genero');
	readln(n.genero);
	writeln('Ingrese el precio');
	readln(n.precio); 
end;

procedure agregarNovela(var nov : archivo);
var
	n : novela;
begin
	leerNovela(n);
	reset(nov);
	seek(nov, filesize(nov));
	write(nov, n);
	writeln('La novela se ha añadido con exito');
end;

procedure modificarNombre(var nov : archivo);
var
	n : novela;
	codigo : integer;
	nombre : string[30];
	encontre : boolean;
begin
	writeln('Ingrese el codigo de la novela que desea cambiarle el nombre');
	readln(codigo);
	writeln('Ingrese el nuevo nombre');
	readln(nombre);
	reset(nov);
	encontre:= false;
	while(not eof(nov))and(not encontre)do begin
		read(nov, n);
		if(n.codigo = codigo)then begin
			encontre:= true;
			n.nombre:= nombre;
			seek(nov, filepos(nov)-1);
			write(nov, n);
		end;
	end;
	if(not encontre)then
		writeln('No se encontro ninguna novela con ese codigo')
	else
		writeln('La modificacion del nombre se ha realizado con exito');
	close(nov);
end;

procedure modificarPrecio(var nov : archivo);
var
	n : novela;
	codigo : integer;
	precio : real;
	encontre : boolean;
begin
	writeln('Ingrese el codigo de la novela que desea cambiarle el nombre');
	readln(codigo);
	writeln('Ingrese el nuevo precio');
	readln(precio);
	reset(nov);
	encontre:= false;
	while(not eof(nov))and(not encontre)do begin
		read(nov, n);
		if(n.codigo = codigo)then begin
			encontre:= true;
			n.precio:= precio;
			seek(nov, filepos(nov)-1);
			write(nov, n);
		end;
	end;
	if(not encontre)then
		writeln('No se encontro ninguna novela con ese codigo')
	else
		writeln('La modificacion del precio se ha realizado con exito');
	close(nov);
end;

procedure modificarGenero(var nov : archivo);
var
	n : novela;
	codigo : integer;
	genero: string[12];
	encontre : boolean;
begin
	writeln('Ingrese el codigo de la novela que desea cambiarle el nombre');
	readln(codigo);
	writeln('Ingrese el nuevo genero');
	readln(genero);
	reset(nov);
	encontre:= false;
	while(not eof(nov))and(not encontre)do begin
		read(nov, n);
		if(n.codigo = codigo)then begin
			encontre:= true;
			n.genero:= genero;
			seek(nov, filepos(nov)-1);
			write(nov, n);
		end;
	end;
	if(not encontre)then
		writeln('No se encontro ninguna novela con ese codigo')
	else
		writeln('La modificacion del genero se ha realizado con exito');
	close(nov);
end;

procedure menu2(var nov : archivo);
var
	categoria : char;
begin
	categoria:= 'z';
	while(categoria <> 'd')do begin
		writeln('¿Que desea modificar?');
		writeln('a._ Nombre.');
		writeln('b._ Genero');
		writeln('c._ Precio');
		writeln('d._ Volver atras');
		readln(categoria);
		case categoria of 
			'a' : modificarNombre(nov);
			'b' : modificarGenero(nov);
			'c' : modificarPrecio(nov);
			else writeln('Caracter invalido');
		end;
	end;
end;

procedure menu(var nov : archivo);
var
	categoria : char;
begin
	categoria:= 'z';
	while(categoria <> 'c')do begin
		writeln('¿Que desea realizar?');
		writeln('a._ Agregar una novela.');
		writeln('b._ Modificar una existente.');
		writeln('c._ Cerrar menu');
		readln(categoria);
		case categoria of 
			'a' : agregarNovela(nov);
			'b' : menu2(nov);
			'c' : writeln('Menu cerrado');
			else writeln('Caracter invalido');
		end;
	end;
end;

var
	nov : archivo;
BEGIN
	//cargar(text); se dispone
	cargar(nov);
	menu(nov);
END.

