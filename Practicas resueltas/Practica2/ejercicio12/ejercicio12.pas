program ejercicio12;
const
	valorAlto = 9999;
type
	log = record
		numUsuario : integer;
		nombreUsuario : string;
		nombre : string;
		apellido : string;
		cantEmails : integer;
	end;
	
	mail = record
		numUsuario : integer;
		destino : string;
		mensaje : string;
	end;
	
	maestro = file of log;
	detalle = file of mail;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : log;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.numUsuario, regM.cantEmails, regM.nombreUsuario);
		readln(txt, regM.nombre);
		readln(txt, regM.apellido);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    txt2 : text;
    regD : mail;
begin
    assign(det, 'detalle.dat');
    rewrite(det);
    assign(txt2, 'detalle.txt');
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.numUsuario, regD.destino);
        readln(txt2, regD.mensaje); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det: detalle; var regD: mail);
begin
    if (not eof(det)) then
        read(det, regD)
    else
        regD.numUsuario := valorAlto;
end;

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	regM : log;
	regD : mail;
	numUsuario, cantEmails : integer;
begin
	reset(mae);
	reset(det);
	read(mae, regM);
	leer(det, regD);
	while(regD.numUsuario <> valorAlto)do begin
		numUsuario := regD.numUsuario;
		cantEmails := 0;
		while(regD.numUsuario = numUsuario)do begin
			cantEmails := cantEmails + regM.cantEmails;
			leer(det, regD);
		end;
		while(regM.numUsuario <> numUsuario)do
			read(mae, regM);
		regM.cantEmails := regM.cantEmails + cantEmails;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
		if(not eof(mae))then
			read(mae, regM);
	end;
	close(mae);
	writeln('Archivo maestro actualizado');
end;

procedure exportarATxt(var mae : maestro);
var
	txt : text;
	regM : log;
begin
	assign(txt, 'logs.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM); 
		writeln(txt, regM.numUsuario, ' ', regM.cantEmails, ' ', regM.nombreUsuario);
		writeln(txt, regM.nombre);
		writeln(txt, regM.apellido);
	end;	
	close(mae);
	close(txt);		
end;

var
	mae : maestro;
	det : detalle;
begin 
	importarDetalle(det);
	importarMaestro(mae);
	actualizarMaestro(mae, det);
	exportarATxt(mae);
end.
