program ejercicio7;
const
	dimf = 3; // = 10;
	valorAlto = 9999;

type
	rango = 1..dimf;
	
	archivoMaestro = record
		codigoLoc : integer;
		localidad : string[30];
		codigoCepa : integer;
		cepa : string[30];
		casosActivos : integer;
		casosNuevos : integer;
		recuperados : integer;
		fallecidos : integer;
	end;
	
	archivoDetalle = record
		codigoLoc : integer;
		codigoCepa : integer;
		casosActivos : integer;
		casosNuevos : integer;
		recuperados : integer;
		fallecidos : integer;
	end;
	
	maestro = file of archivoMaestro;
	detalle = file of archivoDetalle;
	
	vectorD = array[rango]of detalle;
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
		readln(txt, regM.codigoLoc, regM.codigoCepa, regM.casosActivos, regM.casosNuevos, regM.recuperados, regM.fallecidos, regM.cepa);
		readln(txt, regM.localidad);
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
        readln(txt2, regD.codigoLoc, regD.codigoCepa, regD.casosActivos, regD.casosNuevos, regD.recuperados, regD.fallecidos); 
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

procedure leer(var det: detalle; var regD: archivoDetalle);
begin
    if (not eof(det)) then
        read(det, regD)
    else 
        regD.codigoLoc := valorAlto;
end;
 
procedure minimo(var vd : vectorD; var vr : vectorR; var min : archivoDetalle);
var
	i, pos : integer;
begin
	min.codigoLoc := valorAlto;
	for i := 1 to dimf do begin
		if (vr[i].codigoLoc <= min.codigoLoc) then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.codigoLoc <> valorAlto)then
		leer(vd[pos], vr[pos]);
end; 

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
    codigoLoc, codigoCepa, cantCasosLocalidad, cant, i : integer;
	min : archivoDetalle;
	vr : vectorR;
	regM : archivoMaestro;
begin
	cant := 0;
	reset(mae);
	read(mae, regM);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.codigoLoc <> valorAlto)do begin
		codigoLoc := min.codigoLoc;
		cantCasosLocalidad := 0;
		while(min.codigoLoc = codigoLoc)do begin
			codigoCepa := min.codigoCepa;
			while(min.codigoLoc = codigoLoc) and (min.codigoCepa = codigoCepa)do begin
				regM.fallecidos := regM.fallecidos + min.fallecidos;
				regM.recuperados := regM.recuperados + min.recuperados;
				regM.casosActivos := min.casosActivos;
				regM.casosNuevos := min.casosNuevos;
				cantCasosLocalidad := cantCasosLocalidad + min.casosActivos;
				minimo(vd, vr, min);
			end;
			while(regM.codigoLoc <> codigoLoc)do
				read(mae, regM);
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			if(not eof(mae))then
				read(mae, regM);
		end;
		if(cantCasosLocalidad > 50)then
			cant := cant + 1;
	end;
	writeln('Archivo maestro actualizado');
	writeln('La cantidad de localidades con mas de 50 casos es ', cant);
	close(mae);
	for i := 1 to dimf do
		close(vd[i]);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regD : archivoMaestro;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regD);
		writeln('Codigo de localidad ', regD.codigoLoc, ' localidad ', regD.localidad, ' codigoCepa ', regD.codigoCepa, ' casos activos ', regD.casosActivos,
				' casos nuevos ', regD.casosNuevos, ' recuperados ', regD.recuperados, ' fallecidos ', regD.fallecidos);
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
