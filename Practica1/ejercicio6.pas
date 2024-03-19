program ejercicio6;
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
            ' Precio: ', c.precio,
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

procedure leerCelu(var c: celular);
begin
	writeln('Ingrese el codigo del celular');
	readln(c.codigo);
	writeln('Ingrese el nombre');
	readln(c.nombre);
	writeln('Ingrese la descripcion');
	readln(c.descripcion);
	writeln('Ingrese la marca');
	readln(c.marca);
	writeln('Ingrese el precio');
	readln(c.precio);
	writeln('Ingrese el stock minimo');
	readln(c.stockMinimo);
	writeln('Ingrese el stock disponible');
	readln(c.stockDisponible); 
end;

procedure agregarCelu(var phone: archivo);
var
	c: celular;
begin
	reset(phone);
	leerCelu(c);
	seek(phone, filesize(phone));
	write(phone, c);
	writeln('Se añadio un celular al final del archivo con exito');
	close(phone);
end;

procedure modificarStock(var phone : archivo);
var
	c : celular;
	stock : integer;
	nombre : string[12];
	encontre : boolean;
begin
	writeln('Ingrese el nombre del celular que desea modificar');
	readln(nombre);
	writeln('Ingrese el stock que desea ingresar');
	readln(stock);
	reset(phone);
	encontre:= false;
	while(not eof(phone)and(not encontre))do begin
		read(phone, c);
		if(c.nombre = nombre)then begin
			encontre:= true;
			c.stockDisponible:= stock;
			seek(phone, filepos(phone)-1);
			write(phone, c);
		end;
	end;
	if(not encontre)then
		writeln('No se encontro un celular que coincida con el nombre ingresado');
	close(phone);
end;

procedure exportarSinStock(var phone : archivo);
var	
	c : celular;
	txt : text;
begin
	assign(txt, 'SinStock.txt');
	rewrite(txt);
	reset(phone);
	while(not eof(phone))do begin
		read(phone, c);
		if(c.stockDisponible = 0)then begin
			writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);  
			writeln(txt, c.stockDisponible, ' ', c.stockMinimo, ' ', c.descripcion); 
			writeln(txt, c.nombre);
		end;
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
	while (categoria <> 'h')do begin
		writeln('________________________________________________________________');
		writeln('|Menu                                                          |');
		writeln('|a | Crear Archivo                                             |');
		writeln('|b | Mostrar los celulares con un stock menor al minimo        |');
		writeln('|c | Mostrar los celulares cuya descripcion contenga una cadena|');
		writeln('|d | Exportar el archivo a otro                                |');
        writeln('|e | Añadir un celular                                         |');
        writeln('|f | Modificar el stock de un celular en especifico            |');
        writeln('|g | Exportar a ”SinStock.txt” aquellos celulares sin stock    |');
        writeln('|h | Cerrar menu                                               |');
        writeln('|______________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': cargar(phone);
			'b': celularesStockMenor(phone);
			'c': buscarDescripcion(phone);
			'd': exportarTxt(phone);
			'e': agregarCelu(phone);
			'f': modificarStock(phone);
			'g': exportarSinStock(phone);
            'h': WriteLn('Archivo Cerrado');
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
