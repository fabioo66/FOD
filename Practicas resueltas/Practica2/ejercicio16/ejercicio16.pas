program ejercicio16;
const 
	valorAlto = 9999;
	dimf = 3; // = 10;
type
	rango = 1..dimf;
	
	moto = record
		codigo : integer;
		nombre : string;
		descripcion : string;
		modelo : string;
		marca : string;
		stockActual : integer;
	end;
	
	venta = record
		codigo : integer;
		precio : real; 
		fecha : string;
	end;
	
	maestro = file of moto;
	detalle = file of venta;
	
	vectorD = array[rango] of detalle;
	vectorR = array[rango] of venta;

procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : moto;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigo, regM.stockActual, regM.nombre);
		readln(txt, regM.modelo);
		readln(txt, regM.marca);
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
        readln(txt2, regD.codigo, regD.precio, regD.fecha);
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
	i : rango;
	pos : integer;
begin
	min.codigo := valorAlto;
	for i := 1 to dimf do begin
		if(vr[i].codigo <= min.codigo)then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.codigo <> valorAlto)then
		leer(vd[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorD; var motoMax : integer);
var
	max, codigo, ventas: integer;
	regM : moto;
	min : venta;
	vr : vectorR;
	i : rango;
begin
	max := -1;
	reset(mae);
	read(mae, regM);
	minimo(vd, vr, min);
	while(min.codigo <> valorAlto)do begin
		codigo := min.codigo;
		ventas := 0;
		while(codigo = min.codigo)do begin
			ventas := ventas + 1;
			minimo(vd, vr, min);
		end;
		if(ventas > max)then begin
			max := ventas;
			motoMax := codigo;
		end;
		while(codigo <> regM.codigo)do
			read(mae, regM);
		regM.stockActual := regM.stockActual - ventas;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		if(not eof(mae))then
			read(mae, regM);
	end;
	writeln('Archivo maestro actualizado');
	close(mae);
	for i := 1 to dimf do
		close(vd[i]);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regM : moto;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Codigo ', regM.codigo, ' nombre ', regM.nombre, ' descripcion ', regM.descripcion, ' modelo ', regM.modelo, ' marca ', regM.marca, ' stock actual ', regM.stockActual);
	end;
	close(mae);
end;

var
	maxMoto : integer;
	vd : vectorD;
	mae : maestro;
BEGIN
	importarMaestro(mae);
	cargarVectorDetalles(vd);
	actualizarMaestro(mae, vd, maxMoto);
	imprimirMaestro(mae);
	writeln('El codigo de moto mas vendida es ', maxMoto);
END.

