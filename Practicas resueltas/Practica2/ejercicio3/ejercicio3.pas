program ejercicio2;
const valorAlto = 9999;

type
	producto = record
		codigo : integer;
		precio : real;
		stockActual : integer;
		stockMinimo : integer;
		nombre : string;
	end;
	
	venta = record
		codigo : integer;
		cantUnidades : integer;
	end;
	
	detalle = file of venta;
	maestro = file of producto;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : producto;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigo, regM.precio, regM.stockActual, regM.stockMinimo, regM.nombre);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    txt2 : text;
    regD : venta;
begin
    assign(det, 'detalle.dat');
    rewrite(det);
    assign(txt2, 'detalle.txt');
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.codigo, regD.cantUnidades); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det: detalle; var regD : venta);
begin
    if(not eof(det))then 
        read(det, regD)
    else 
		regD.codigo := valoralto;
end;

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	regD : venta; //registro detalle
	cantTotal, codigo : integer;
	regM : producto; //registro maestro
begin
	reset(mae);
	reset(det);
	read(mae, regM); //leo maestro
	leer(det, regD); //leo detalle
	while(regD.codigo <> valorAlto)do begin
		codigo := regD.codigo;
		cantTotal := 0;
		while(regD.codigo = codigo) do begin
			cantTotal := cantTotal + regD. cantUnidades;
			leer(det, regD);
		end;
		while(regM.codigo <> codigo)do
			read(mae, regM);
 		regM.stockActual := regM.stockActual - cantTotal;
 		seek(mae, filepos(mae)-1);
  		write(mae, regM);
  		if(not eof(mae))then 
   			read(mae, regM);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det);
end;

procedure imprimirProducto(p : producto);
begin
	writeln('Codigo= ', p.codigo, ' precio= ', p.precio:0:2, ' stock actual ', p.stockActual, ' stock minimo ', p.stockMinimo, ' nombre ', p.nombre);
end;

procedure imprimirArchivoMaestro(var mae : maestro);
var
	p : producto;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, p);
		imprimirProducto(p);
	end;
	close(mae);
end;

procedure exportarATxt(var mae : maestro);
var
	txt : text;
	p : producto;
begin
	writeln('Exportando archivo binario a archivo de texto aquellos productos con stock por debajo del minimo');
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, p);
		if(p.stockActual < p.stockMinimo)then 
			writeln(txt, p.codigo, ' ', p.precio:0:2, ' ', p.stockActual, ' ', p.stockMinimo, ' ', p.nombre);
	end;
	writeln('La exportacion se ha realizado con exito');	
	close(mae);
	close(txt);		
end;

procedure menu(var mae: maestro; var det : detalle);
var
	categoria : char;
begin
	categoria:= '>';
	while (categoria <> 'd')do begin
		writeln('___________________________________________________________________________________________________________________');
		writeln('|Menu                                                                                                              |');
		writeln('|a | Actualizar maestro                                                                                            |');
		writeln('|b | Exportar a un archivo de texto aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido|');
		writeln('|c | Imprimir archivo maestro                                                                                      |');
		writeln('|d | Cerrar archivo                                                                                                |');
        writeln('|__________________________________________________________________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': actualizarMaestro(mae, det);
			'b': exportarATxt(mae);
			'c': imprimirArchivoMaestro(mae);
			'd': writeln('Archivo cerrado ');
			else writeln('Caracter invalido'); 
		end;
	end;
end;

var
	det : detalle;
	mae : maestro;
BEGIN
	importarMaestro(mae);
	importarDetalle(det);
	menu(mae, det);
END.
