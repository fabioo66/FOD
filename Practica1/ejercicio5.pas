program ejercicio5;
type
	celular = record
		codigo : integer;
		nombre : string[15];
		descripcion : string[80];
		marca: string[12];
		precio: real;
		stockMinimo: integer;
		stockDisponible : integer;
	end;
	
	archivo = file of celular;
	
procedure asignar(var phone: archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta del archivo');
	readln(ruta);
	assign(phone, ruta);
end;

procedure cargar(var phone : archivo);
var
	txt: text;
	c: celular;
begin
	asignar(phone);
	writeln('Importando datos de "celulares.txt"');
	rewrite(phone);
	assign(txt, 'celulares.txt');
	reset(txt);
	while(not eof(txt))do begin //importacion del archivo de text a binario
		readln(txt, c.codigo, c.precio, c.marca);
        readln(txt, c.stockDisponible, c.stockMinimo, c.descripcion);
        readln(txt, c.nombre);
        write(phone, c);
    end;
    writeln('La importacion se ha realizado con exito');
    close(txt);
    close(phone); 
end;

procedure imprimirCelular(c : celular);
begin
	writeln(' Codigo: ', c.codigo,
            ' Nombre: ', c.nombre,
            ' Descripcion: ', c.descripcion,
            ' Marca: ', c.marca,
            ' Precio: ', c.precio:0:2,
            ' Stock minimo: ', c.stockMinimo,
            ' Stock disponible: ', c.stockDisponible
            );
end;

procedure celularesStockMenor(var phone : archivo);
var
	c : celular;
begin
	reset(phone);
	writeln('Los celulares con un stock menor al minimo: ');
	while(not eof(phone))do begin
		read(phone, c);
		if(c.stockDisponible < c.stockMinimo)then
			imprimirCelular(c);
	end;
	close(phone);		
end;

procedure buscarDescripcion(var phone : archivo);
var
	c: celular;
	desc: string;
begin
	reset(phone);
	writeln('Ingrese una descripcion');
	readln(desc);
	writeln('Se encontraron las siguientes coincidencias');
	while(not eof(phone))do begin
		read(phone, c);
		if(c.descripcion = desc)then
			imprimirCelular(c);
	end;
	close(phone);
end;

procedure exportarTxt(var phone: archivo);
var
	txt : text;
	c : celular;
begin
	assign(txt, 'celulares.txt');
	rewrite(txt);
	reset(phone);
	while(not eof(phone))do begin
		read(phone, c);
		writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);  
		writeln(txt, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion); 
		writeln(txt, c.nombre);
	end;
	writeln('La exportacion se ha realizado con exito');
	close(txt);
	close(phone);
end;

procedure menu(var phone: archivo);
var
	categoria : char;
begin
	categoria:= '>';
	while (categoria <> 'e')do begin
		writeln('________________________________________________________________');
		writeln('|Menu                                                          |');
		writeln('|a | Crear Archivo                                             |');
		writeln('|b | Mostrar los celulares con un stock menor al minimo        |');
		writeln('|c | Mostrar los celulares cuya descripcion contenga una cadena|');
		writeln('|d | Exportar el archivo a otro                                |');
        writeln('|e | cerrar menu                                               |');
        writeln('|______________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': cargar(phone);
			'b': celularesStockMenor(phone);
			'c': buscarDescripcion(phone);
			'd': exportarTxt(phone);
            'e': WriteLn('Archivo Cerrado');
			else writeln('Caracter invalido'); 
		end;
	end;
end;

var
	phone : archivo;
begin
	//cargar(txt); se dispone
	menu(phone);
end.

