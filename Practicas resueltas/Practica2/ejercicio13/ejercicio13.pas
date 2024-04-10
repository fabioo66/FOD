program ejercicio13;
const
	valorAlto = 'ZZZZ';
type
	vuelo = record
		destino : string;
		fecha : string;
		hora : real;
		cantAsientos : integer;
	end;

	info = record
		destino : string;
		fecha : string;
		hora : real;
		cantAsientosVendidos : integer;
	end;
		
	lista = ^nodo;
	nodo = record
		dato : vuelo;
		sig : lista;
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
		readln(txt, regM.hora, regM.cantAsientos, regM.fecha);
		readln(txt, regM.destino);
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
        readln(txt, regD.hora, regD.cantAsientosVendidos, regD.fecha);
		readln(txt, regD.destino);
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det : detalle; regD : info);
begin
	if(not eof(det))then
		read(det, regD)
	else
		regD.destino := valorAlto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min : info);
begin
	if(r1.destino <= r2.destino)then begin
		min := r1;
        leer(det1, r1)
    end
    else begin
		min := r2;
        leer(det2, r2);
    end;
end; 

procedure agregarAdelante(var L : lista; v : vuelo);
var
	nue : lista;
begin
	new(nue);
	nue^.dato := v;
	nue^.sig := L;
	L := nue;
end;

procedure actualizarMaestro(var mae : maestro; var det1,det2 : detalle; var L : lista);
var
	r1, r2, min : info;
	regM : vuelo;
	destino, fecha : string;
	hora : real;
	cant : integer;
begin
	L := nil;
	writeln('Ingrese una cantidad de asientos disponibles ');
	readln(cant);
	reset(mae);
	reset(det1);
	reset(det2);
	minimo(det1, det2, r1, r2, min);
	while(min.destino <> valorAlto)do begin
		destino := min.destino;
		while(min.destino = destino)do begin
			fecha := min.fecha;
			while(min.destino = destino) and (min.fecha = fecha)do begin
				hora := min.hora;
				while(min.destino = destino) and (min.fecha = fecha) and(min.hora = hora)do begin
					regM.cantAsientos:= regM.cantAsientos - min.cantAsientosVendidos;
					minimo(det1, det2, r1, r2, min);
				end;
				if(regM.cantAsientos < cant)then
					agregarAdelante(L, regM);
				while(regM.destino <> destino)do 
					read(mae, regM);
				seek(mae, filepos(mae)-1);
				write(mae, regM);
				if(not eof(mae))then
					read(mae, regM);
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
		writeln('Destino ', regM.destino, ' fecha ', regM.fecha, ' hora ', regM.hora:0:2, ' asientos disponibles ', regM.cantAsientos);
	end;
	close(mae);
end;

procedure imprimirLista(L : lista);
begin
	while(L <> nil)do
		writeln('Destino ', L^.dato.destino, ' fecha ', L^.dato.fecha, ' hora ', L^.dato.hora:0:2, ' asientos disponibles ', L^.dato.cantAsientos);
end;

var
	mae : maestro;
	det1, det2 : detalle;
	l : lista;
begin
	importarMaestro(mae);
	importarDetalle(det1);
	importarDetalle(det2);
	actualizarMaestro(mae);
	imprimirMaestro(mae);
	writeln('---------------------------------');
	imprimirLista(l);
end.
