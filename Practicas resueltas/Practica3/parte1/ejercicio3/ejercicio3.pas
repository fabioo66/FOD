program ejercicio3;
type
	novela = record
		codigo : integer;
		genero : string;
		nombre : string;
		duracion : string;
		director : string;
		precio : real;
	end;
	
	archivo = file of novela;

procedure asignar(var arch: archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta del archivo');
	readln(ruta);
	assign(arch, ruta);
end;

procedure leerNovela(var n : novela);
begin
	writeln('Ingrese el codigo de novela');
	readln(n.codigo);
	if(n.codigo <> -1)then begin
		writeln('Ingrese el genero');
		readln(n.genero);
		writeln('Ingrese el nombre');
		readln(n.nombre);
		writeln('Ingrese la duracion de la novela');
		readln(n.duracion);
		writeln('Ingrese el director');
		readln(n.director);
		writeln('Ingrese el precio');
		readln(n.precio);
	end;
end;

procedure inicializarLista(var n : novela);
begin
	n.codigo := 0;
	n.genero := '';
	n.nombre := '';
	n.duracion := '';
	n.director := '';
	n.precio := 0;
end;

procedure cargarArchivo(var arch : archivo);
var
	n : novela;
begin
	rewrite(arch);
	inicializarLista(n);
	write(arch, n);
	writeln('La lectura finaliza con el codigo de novela = -1');
	leerNovela(n);
	while(n.codigo <> -1)do begin
		write(arch, n);
		leerNovela(n);
	end;
	writeln('Archivo de novelas creado');
	close(arch);
end;

procedure exportarTxt(var arch : archivo);
var
	txt : text;
	n : novela;
begin
	writeln('Realizando exportacion a archivo "novelas.txt"');
	reset(arch);
	assign(txt, 'novelas.txt');
	rewrite(txt);
	while(not eof(arch))do begin
		read(arch, n);
		if(n.codigo > 0) then
			write(txt, 'Codigo ', n.codigo, ' Genero ', n.genero, ' Nombre ', n.nombre, ' Duracion ', n.duracion, ' Director ', n.director, ' Precio ', n.precio:0:2);
		else	
			write(txt, 'Espacio libre ');
        
    end;
    writeln('La exportacion se ha realizado con exito');
    close(arch);
    close(txt);
end;

procedure darDeAlta(var arch : archivo);
var
	n, aux : novela;
	pos : integer;
begin
	reset(arch);
	read(arch, aux);
	leerNovela(n);
	if(aux.codigo < 0)then begin
		pos := aux.codigo * -1;
		seek(arch, pos);
		read(arch, aux);
		seek(arch, filepos(arch)-1);
		leerNovela(arch, n);
		write(arch, n);
		seek(arch, 0);
		write(arch, aux);
	end
	else begin
		seek(arch, filepos(arch);
		leerNovela(n);
		write(arch, n);
	end;
	close(arch);		
end;

procedure modificarDatos(var arch : archivo);
var
	n : novela;
	codigo : integer;
	encontre : boolean;
begin
	encontre := false;
	reset(arch);
	writeln('Ingrese el codigo de novela que desea modificar');
	readln(codigo);
	while(not eof(arch))do begin
		read(arch, n);
		if(n.codigo = codigo)then begin
			writeln('Ingrese el genero');
			readln(n.genero);
			writeln('Ingrese el nombre');
			readln(n.nombre);
			writeln('Ingrese la duracion');
			readln(n.duracion);
			writeln('Ingrese el director');
			readln(n.director);
			writeln('Ingrese el precio');
			readln(n.precio);
			seek(arch, filepos(arch)-1);
			write(arch, n);
			encontre := true;
		end;
	end;
	if(not encontre)then
		writeln('No se encontro un codigo de novela que coincida con el codigo ingresado')
	else
		writeln('La modificacion se ha realizado con exito');
	close(arch);
end;

procedure eliminarNovela(var arch : archivo);
var
	codigo, pos : integer;
	n, aux : novela;
	encontre : boolean;
begin
	encontre := false;
	reset(arch);
	writeln('Ingrese el codigo de la novela a eliminar');
	readln(codigo);
	while(not eof(arch))do begin
		read(arch, n);
		if(n.codigo = codigo)then begin
			pos := filepos(arch)-1;
			n.codigo := filepos(arch)-1 - ((filepos(arch)-1) * 2);
			seek(arch, 0);
			read(arch, aux);
			seek(arch, filepos(arch)-1);
			write(arch, n);
			seek(arch, pos); 
			write(arch, aux);
			encontre := true;
		end;
	end;
	if(not encontre)then
		writeln('No se encontro un codigo de novela que coincida con el codigo ingresado')
	else
		writeln('Se elimino la novela correctamente');
	close(arch);
end;

procedure subMenu(var arch : archivo);
var
	categoria : char;
begin
	categoria:= 'z';
	while (categoria <> 'd')do begin
		writeln('__________________________________________________________________________________________');
		writeln('|Menu                                                                                     |');
		writeln('|a | Dar de alta una novela                                                               |');
		writeln('|b | Modificar los datos de una novela                                                    |');
		writeln('|c | Eliminar una novela                                                                  |');
        writeln('|d | Volver atras   																	   |');
        writeln('|_________________________________________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': darDeAlta(arch);
			'b': modificarDatos(arch);
			'c': eliminarNovela(arch);
			'd': writeln('Volviendo...');
			else writeln('Caracter invalido'); 
		end;
	end;
end;

procedure menu(var arch : archivo); 
var
	categoria : char;
begin
	categoria:= 'z';
	while (categoria <> 'd')do begin
		writeln('__________________________________________________________________________________________');
		writeln('|Menu                                                                                     |');
		writeln('|a | Crear un Archivo con novelas                                                         |');
		writeln('|b | Modificar archivo existente                                                          |');
		writeln('|c | Exportar las novelas a un archivo de texto llamado “novelas.txt”.                    |');
        writeln('|d | Cerrar menu 																		   |');
        writeln('|_________________________________________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': cargarArchivo(arch);
			'b': subMenu(arch);
			'c': exportarTxt(arch);
            'd': WriteLn('Archivo Cerrado');
			else writeln('Caracter invalido'); 
		end;
	end;
end;

var
	arch : archivo;
begin
	asignar(arch);
	menu(arch);
end.
