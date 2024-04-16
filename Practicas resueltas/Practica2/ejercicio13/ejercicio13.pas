program ejercicio13;
const
	valorAlto = 'ZZZZ';
type
	vuelo = record
		destino : string;
		fecha : string;
		hora : string;
		cantAsientos : integer;
	end;

	info = record
		destino : string;
		fecha : string;
		hora : string;
		cantAsientosVendidos : integer;
	end;
	
	maestro = file of vuelo;
	detalle = file of info;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : vuelo;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.cantAsientos, regM.destino);
		readln(txt, regM.fecha);
		readln(txt, regM.hora);
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
    regD : info;
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
        readln(txt2, regD.cantAsientosVendidos, regD.destino);
		readln(txt2, regD.fecha);
		readln(txt2, regD.hora);
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det : detalle; var regD : info);
begin
	if (not eof(det)) then
		read(det, regD)
	else 
		regD.destino := valorAlto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min : info);
begin
	if(r1.destino < r2.destino)then begin
		min := r1;
        leer(det1, r1)
    end
    else begin
		min := r2;
        leer(det2, r2);
    end;
end; 

procedure actualizarMaestro(var mae : maestro; var det1, det2 : detalle);
var
	r1, r2, min : info;
	regM : vuelo;
	cant : integer;
begin
	writeln('Ingrese una cantidad de asientos disponibles ');
	readln(cant);
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, r1);
	leer(det2, r2);
	minimo(det1, det2, r1, r2, min);
	while(min.destino <> valorAlto)do begin
		read(mae, regM);
		while(min.destino <> regM.destino)do 
			read(mae, regM);
		while(min.destino = regM.destino)do begin
			while(regM.fecha <> min.fecha)do
				read(mae, regM);
			while(regM.destino = min.destino) and (regM.fecha = min.fecha)do begin
				while(regM.hora <> min.hora)do
					read(mae, regM);
				while(min.destino = regM.destino) and (min.fecha = regM.fecha) and(min.hora = regM.hora)do begin
					regM.cantAsientos:= regM.cantAsientos - min.cantAsientosVendidos;
					minimo(det1, det2, r1, r2, min);
				end;
				if(regM.cantAsientos < cant)then
					writeln('Destino ', regM.destino, ' fecha ', regM.fecha, ' hora de salida ', regM.hora);
				seek(mae, filepos(mae)-1);
				write(mae, regM);
			end;
		end;
	end;
	writeln('Archivo maestro actualizado');
	close(mae);
	close(det1);
	close(det2);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regM : vuelo;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Destino ', regM.destino, ' fecha ', regM.fecha, ' hora ', regM.hora, ' asientos disponibles ', regM.cantAsientos);
	end;
	close(mae);
end;

var
	mae : maestro;
	det1, det2 : detalle;
begin
	importarMaestro(mae);
	importarDetalle(det1);
	importarDetalle(det2);
	actualizarMaestro(mae, det1, det2);
	writeln('--------------------------------');
	writeln('Archivo maestro');
	imprimirMaestro(mae);
end.
