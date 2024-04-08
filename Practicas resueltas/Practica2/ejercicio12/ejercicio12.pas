{se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado.}

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
        readln(txt2, regD.usuario, regD.destino);
        readln(txt2, regD.codigo); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det : detalle; regD : mail);
begin
	if(not eof(det))then
		read(det, regD)
	else
		regD.numUsuario := valorAlto;
end;

var

begin 

end.
