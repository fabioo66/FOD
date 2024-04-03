program ejercicio11;
const
	valorAlto = 9999;
type
	drango = 1..31;
	
	user = record
		anio : integer;
		mes : integer;
		dia : drango;
		id : integer;
		tiempo : real;
	end;
	
	archivo = file of user;

procedure importarUsuario(var usuario : archivo);
var
    txt : text;
    u : user;
begin
    assign(usuario, 'usuario.dat');
    rewrite(usuario);
    assign(txt, 'usuario.txt');
    reset(txt);
    while(not eof(txt)) do begin
        readln(txt, u.anio, u.mes, u.dia, u.id, u.tiempo); 
        write(usuario, u);
    end;
    writeln('Archivo usuario creado');
    close(usuario);
    close(txt);
end;
	
procedure leer(var usuario : archivo; var u : user);
begin
    if (not eof(usuario)) then
        read(usuario, u)
    else 
        u.mes := valorAlto;
end; 

function esta(var usuario : archivo; anio : integer): boolean;
var
	encontre : boolean;
	u : user;
begin
	encontre := false;
	while(not eof(usuario))and(not encontre)do begin
		read(usuario, u);
		if(anio = u.anio)then
			encontre := true;
	end;
	esta := encontre;
end;

procedure procesar(var usuario : archivo);
var
	u : user;
	anio, mes, dia, id : integer;
	tiempoTotalAnio, tiempoTotalMes, tiempoTotalDia, tiempoTotalId : real;
begin
	reset(usuario);
	writeln('Ingrese el año que desea imprimir');
	readln(anio);
	if(esta(usuario, anio))then begin
		writeln('Año ', anio);
		tiempoTotalAnio := 0;
		leer(usuario, u);
		while(u.mes <> valorAlto)do begin
			writeln('Mes ', u.mes);
			tiempoTotalMes := 0;
			mes := u.mes;
			while(u.mes = mes)do begin
				writeln('Dia ', u.dia);
				tiempoTotalDia := 0;
				dia := u.dia;
				while(u.mes = mes)and(u.dia = dia)do begin
					writeln('Id de usuario', u.id);
					tiempoTotalId := 0;
					id := u.id;
					while(u.mes = mes)and(u.dia = dia)and(u.id = id)do begin
						tiempoTotalId := tiempoTotalId + u.tiempo;
						leer(usuario, u);
					end;
					writeln('Tiempo total de acceso id ', id, ' = ', tiempoTotalId:0:2);
					tiempoTotalDia := tiempoTotalDia + tiempoTotalId;
				end;
				writeln('Tiempo total dia ', tiempoTotalDia:0:2);
				tiempoTotalMes := tiempoTotalMes + tiempoTotalDia;
			end;
			writeln('Tiempo total mes ', tiempoTotalMes:0:2);
			tiempoTotalAnio := tiempoTotalAnio + tiempoTotalMes;
		end;
		writeln('Tiempo total año ', tiempoTotalAnio:0:2);
	end
	else
		writeln('No se encontro ningun año que coincida con el ingresado');
	close(usuario);
end;

var
	usuario : archivo;
BEGIN
	importarUsuario(usuario);
	procesar(usuario);
END.
