program ejercicio5;
const valorAlto = 9999;
const dimf = 3; // = 30

type
	producto = record
		codigo : integer;
		nombre : string[30];
		descripcion : string[100];
		stockDisponible : integer;
		stockMinimo : integer;
		precio : real;
	end;
	
	rango = 1..dimf;
	
	venta = record
		codigo : integer;
		cantUnidades : integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	vectorD = array[rango] of detalle; //vector detalles
	vectorR = array[rango] of venta; //vector registros

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
		readln(txt, regM.codigo, regM.precio, regM.stockDisponible, regM.stockMinimo, regM.nombre);
		readln(txt, regM.descripcion);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
	ruta : string;
    txt2 : text;
    regD : venta;
begin
	writeln('Ingrese la ruta del archivo detalle binario');
	readln(ruta);
    assign(det, ruta);
    rewrite(det);
    writeln('Ingrese la ruta del archivo detalle.txt');
	readln(ruta);
    assign(txt2, ruta);
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.codigo, regD.cantUnidades); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure cargarVectorDetalles(var vd : vectorD);
var
	i : rango;
begin
	for i := 1 to dimf do
		importarDetalle(vd[i]);
end;
	
procedure leer(var det: detalle; var regD: venta);
begin
	if not eof(det) then
		read(det, regD)
	else 
		regD.codigo := valorAlto;
 end;

procedure minimo(var vd : vectorD; var vr : vectorR; var min : venta);
var
	i, pos : integer;
begin
	min.codigo := valorAlto;
	for i := 1 to dimf do begin
		if(vr[i].codigo < min.codigo)then begin
			min.codigo := vr[i].codigo;
			pos := i;
		end;
		if(min.codigo <> valorAlto)then
			leer(vd[pos], vr[pos]);
	end;
end; 

procedure reporte(var mae : maestro);
var
	regM : producto;
	txt : text;
begin
	writeln('Exportando informe aquellos productos con stock por debajo del mininmo en "informe.txt"');
	assign(txt, 'informe.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		if(regM.stockDisponible < regM.stockMinimo)then begin
			writeln(txt, regM.stockDisponible, ' ', regM.nombre);
			writeln(txt, regM.precio, ' ', regM.descripcion);
		end;
	end;
	writeln('La exportacion se ha realizado con exito');
	close(mae);
	close(txt);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
	min : venta;
	regM : producto;
	vr : vectorR;
	codigo, cant, i : integer;
begin
	reset(mae);
	read(mae, regM);
	for i:= 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.codigo <> valorAlto)do begin
		codigo := min.codigo;
		cant := 0;
		while(min.codigo = codigo)do begin
			cant := cant + min.cantUnidades; 
			minimo(vd, vr, min);
		end;
		while(regM.codigo <> codigo)do
			read(mae, regM);
		regM.stockDisponible := regM.stockDisponible - cant;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		if(not eof(mae))then
			read(mae, regM);
	end;
	writeln('Maestro actualizado');		
	reporte(mae);
	close(mae);
	for i := 1 to dimf do
		close(vd[i]);
	writeln('aca tira error');
end;

procedure imprimirProducto(p : producto);
begin
	writeln('Codigo= ', p.codigo, ' precio= ', p.precio:0:2, ' stock actual ', p.stockDisponible, ' stock minimo ', p.stockMinimo, ' nombre ', p.nombre, ' descripcion ', p.descripcion);
end;
		
procedure imprimirMaestro(var mae : maestro);
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

var
	mae : maestro;
	vd : vectorD;
BEGIN
	importarMaestro(mae);
	cargarVectorDetalles(vd);
	actualizarMaestro(mae, vd);
	imprimirMaestro(mae);
END.

