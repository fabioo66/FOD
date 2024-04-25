{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos 
y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}

program ejercicio6;
type
	prenda = record
		codigo : integer;
		descripcion : string;
		colores : string;
		tipo : string;
		stock : integer;
		precio : real;
	end;
	
	maestro = file of prenda;
	detalle = file of integer;
	
procedure crearMaestro(var mae: maestro);
var
    p: prenda;
    txt: text;
begin
    assign(txt, 'maestro.txt');
    reset(txt);
    assign(mae, 'maestro.dat');
    rewrite(mae);
    while(not eof(txt)) do begin
		with p do begin
			readln(txt, codigo, stock, precio, descripcion);
            readln(txt, tipo);
            readln(txt, colores);
            write(mae, p);
        end;
    end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(txt);
end;
procedure crearDetalle(var det: detalle);
var
    carga: text;
    codigo: integer;
begin
    assign(carga, 'detalle.txt');
    reset(carga);
    assign(det, 'ArchivoDetalle');
    rewrite(det);
    while(not eof(carga)) do begin
		readln(carga, codigo);
        write(det, codigo);
    end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure bajaLogica(var mae : maestro; var det : detalle);
var
	regM : prenda;
	codigo : integer;
begin
	regM.codigo := 0; // Código de prenda inicializado a 0
	reset(mae);
	reset(det);
	while(not eof(det))do begin
		read(det, codigo);
		seek(mae, 0);
		while(codigo <> regM.codigo)do
			read(mae, regM);
		regM.codigo := -66;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
	end;
	writeln('Se realizaron los borrados logicos correctamente');
	close(mae);
end;

procedure nuevoMaestro(var mae, newMae : maestro);
var	
	regM : prenda;
begin
	reset(mae);
	assign(newMae, 'New_Maestro.dat');
	rewrite(newMae);
	while(not eof(mae))do begin
		read(mae, regM);
		if(regM.codigo >= 0)then 
			write(newMae, regM);
	end;
	close(mae);
	close(newMae);
	erase(mae);
	rename(newMae, 'maestro.dat');
end;

procedure imprimirMaestro(var mae : maestro);
var
	p : prenda;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, p);
		if(p.codigo < 0)then
			writeln('Espacio disponible')
		else
			writeln('Codigo ', p.codigo, ' Descripcion ', p.descripcion, ' Stock ', p.stock, ' Precio ', p.precio:0:2);
	end;
	close(mae);
end;

var
	det : detalle;
	mae, newMae : maestro;
begin
	crearDetalle(det);
	crearMaestro(mae);
	writeln('-----------------------------------');
	writeln('Maestro antes del borrado');
	imprimirMaestro(mae);
	bajaLogica(mae, det);
	writeln('-----------------------------------');
	writeln('Maestro despues del borrado');
	imprimirMaestro(mae);
	nuevoMaestro(mae, newMae);
	writeln('-----------------------------------');
	writeln('Nuevo maestro');
	imprimirMaestro(newMae);
end.
	
