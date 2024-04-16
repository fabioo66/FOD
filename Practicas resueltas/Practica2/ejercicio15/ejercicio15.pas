program ejercicio15;
const
	valorAlto = 'ZZZZ';
	dimf = 3; // = 100;
type
	rango = 1..dimf;
	
	emision = record
		fecha : string;
		codigo : integer;
		nombre : string;
		descripcion : string;
		precio : real;
		total : integer;
		totalVendidos : integer;
	end;
	
	venta = record
		fecha : string;
		codigo : integer;
		cant : integer;
	end;
	
	maestro = file of emision;
	detalle = file of venta;
	
	vectorD = array[rango]of detalle;
	vectorR = array[rango]of venta;

procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : emision;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigo, regM.precio, regM.total, regM.totalVendidos, regM.fecha);
		readln(txt, regM.nombre);
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
        readln(txt2, regD.codigo, regD.cant, regD.fecha);
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
        regD.fecha := valorAlto;
end;

procedure minimo(var vd : vectorD; var vr : vectorR; var min : venta);
var
	i : rango;
	pos : integer;
begin
	min.fecha := valorAlto;
	for i := 1 to dimf do begin
		if(vr[i].fecha <= min.fecha)then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.fecha <> valorAlto)then
		leer(vd[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
	regM : emision;
	vr : vectorR;
	min, dato : venta;
	i : rango;
	fechaMin, fechaMax : string;
	codigoMin, codigoMax, max1, min1, totalVentas : integer;
begin
	max1 := -1;
	min1 := 9999;
	reset(mae);
	read(mae, regM);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.fecha <> valorAlto)do begin
		dato.fecha := min.fecha;
		while(dato.fecha = min.fecha)do begin
			dato.codigo := min.codigo;
		totalVentas := 0;
			while(dato.fecha = min.fecha) and (dato.codigo = min.codigo)do begin
				regM.totalVendidos := regM.totalVendidos + min.cant;
				regM.total := regM.total - min.cant;
				totalVentas := totalVentas + min.cant;
				minimo(vd, vr, min);
			end;
			if(totalVentas > max1)then begin
				max1 := totalVentas;
				fechaMax := regM.fecha;
				codigoMax := regM.codigo
			end
			else if(totalVentas < min1)then begin
				min1:= totalVentas;
				fechaMin := regM.fecha;
				codigoMin := regM.codigo;
			end;
			while(regM.fecha <> dato.fecha)do begin
				read(mae, regM);
			end;
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			if(not eof(mae))then
				read(mae, regM);
		end;
	end;
	close(mae);
	writeln('El semanario con mas ventas es ', fechaMax, ' ', codigoMax);
	writeln('El semanario con menos ventas es ', fechaMin, ' ', codigoMin);
	writeln('Archivo maestro actualizado');
	for i := 1 to dimf do
		close(vd[i]);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regM : emision;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Fecha ', regM.fecha, ' codigo de semanario ', regM.codigo, ' nombre ', regM.nombre, ' descripcion ', regM.descripcion, ' precio ', regM.precio:0:2, ' total ', regM.total, ' total vendidos ', regM.totalVendidos);
	end
end;

var
	mae : maestro;
	vd : vectorD;
begin
	importarMaestro(mae);
	cargarVectorDetalles(vd);
	actualizarMaestro(mae, vd);
	imprimirMaestro(mae);
end.
