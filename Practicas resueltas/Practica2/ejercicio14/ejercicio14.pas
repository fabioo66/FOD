program ejercicio14;
const 
	valorAlto = 9999;
	dimf = 3; // = 10;
type
	archivoMaestro = record
		codigoProv : integer;
		nombreProv : string;
		codigoLoc : integer;
		nombreLoc : string;
	    sinLuz : integer;
	    sinGas : integer;
	    deChapa : integer;
	    sinAgua : integer;
	    sinSanitarios : integer;
	end;
	
	archivoDetalle = record
		codigoProv : integer;
		codigoLoc : integer;
		conLuz : integer;
		construidas : integer;
		conAgua : integer;
		conGas : integer;
		sanitarios : integer;
	end;
	
	rango = 1..dimf;
	
	maestro = file of archivoMaestro;
	detalle = file of archivoDetalle;
	vectorD = array[rango] of detalle;
	vectorR = array[rango] of archivoDetalle;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : archivoMaestro;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigoProv, regM.nombreProv);
		readln(txt, regM.codigoLoc, regM.sinLuz, regM.sinGas, regM.deChapa, regM.sinAgua, regM.sinSanitarios, regM.nombreLoc);
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
    regD : archivoDetalle;
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
        readln(txt2, regD.codigoProv, regD.codigoLoc, regD.conLuz, regD.construidas, regD.conAgua, regD.conGas, regD.sanitarios);
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

procedure leer(var det : detalle; var regD : archivoDetalle);
begin
	if(not eof(det)) then
		read(det, regD)
	else 
		regD.codigoProv := valorAlto;
end;
 
procedure minimo(var vd : vectorD; var vr : vectorR; var min : archivoDetalle);
var
	i, pos : integer;
begin
	min.codigoProv := valorAlto;
	for i := 1 to dimf do begin
		if (vr[i].codigoProv <= min.codigoProv) then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.codigoProv <> valorAlto)then
		leer(vd[pos], vr[pos]);
end;  

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
	codigoProv, codigoLoc : integer;
	min : archivoDetalle;
	regM : archivoMaestro;
	i : rango;
	vr : vectorR;
begin
	reset(mae);
	read(mae, regM);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.codigoProv <> valorAlto)do begin
		codigoProv := min.codigoProv;
		while(min.codigoProv = codigoProv)do begin
			codigoLoc := min.codigoLoc;
			while(min.codigoProv = codigoProv) and (min.codigoLoc = codigoLoc)do begin
				regM.sinAgua := regM.sinAgua - min.conAgua;
				regM.singas := regM.sinGas - min.conGas;
				regM.sinSanitarios := regM.sinSanitarios - min.sanitarios;
				regM.deChapa := regM.deChapa - min.construidas;
				minimo(vd, vr, min);
			end;
			while(regM.codigoProv <> codigoProv)do
				read(mae, regM);
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			if(not eof(mae))then
				read(mae, regM);
		end;
	end;
	close(mae);
	writeln('Archivo maestro actualizado');
	for i := 1 to dimf do
		close(vd[i]);
end;
 
procedure imprimirMaestro(var mae : maestro);
var
	regM : archivoMaestro;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Codigo de provincia ', regM.codigoProv, ' nombre de provincia ', regM.nombreProv, ' codigo de localidad '
				, regM.codigoLoc, ' nombre de localidad ', regM.nombreLoc, ' viviendas sin luz ', regM.sinLuz, ' viviendas sin gas ', regM.sinGas,
				 ' viviendas de chapa ', regM.deChapa, ' viviendas sin agua ', regM.sinAgua, ' viviendas sin sanitarios ', regM.sinSanitarios);
	end;
	close(mae);
end;
 
var
	vd : vectorD;
	mae : maestro;
begin 
	importarMaestro(mae);
	cargarVectorDetalles(vd);
	actualizarMaestro(mae, vd);
	imprimirMaestro(mae);
end.
