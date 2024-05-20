{11. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
    Mes:-- 1
        día:-- 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 1
        Tiempo total acceso dia 1 mes 1
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 1
            --------
            idusuario N Tiempo total de acceso en el dia N mes 1
        Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
        ------
    Mes 12
        día 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 12
        Tiempo total acceso dia 1 mes 12
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 12
            --------
            idusuario N Tiempo total de acceso en el dia N mes 12
        Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program parcial_2018;
const
	valorAlto = 9999;
type
	drango = 1..31;
	mrango = 1..12;
	
	user = record
		anio : integer;
		mes : integer;
		dia : mrango;
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
    if(not eof(usuario)) then
        read(usuario, u)
    else
        u.anio := valorAlto;
end;

function esta(var usuario : archivo; anio : integer) : boolean;
var 
    u : user;
    ok : boolean;
begin
    ok := false;
    read(usuario, u);
    while(not eof(usuario) and not ok)do begin
        if(u.anio = anio)then
            ok := true
        else
            read(usuario, u);
    end;
    esta := ok;
end;

procedure informe(var usuario : archivo);
var
    u : user;
    anio, mes, dia, id : integer;
    tiempoTotalDia, tiempoTotalMes, tiempoTotalAnio, tiempoTotalId : real;
begin 
	reset(usuario);
    writeln('Ingrese el año en el que desea ver el informe');
    readln(anio);
    if(esta(usuario, anio))then begin
        leer(usuario, u);
        writeln('Año : ', u.anio);
        tiempoTotalAnio := 0;
        anio := u.anio;
        while(u.anio = anio)do begin
			writeln('    Mes : ', u.mes);
            tiempoTotalMes := 0;
            mes := u.mes;
            while(u.anio = anio) and (u.mes = mes)do begin
				writeln('        Dia : ', u.dia);
				tiempoTotalDia := 0;
				dia := u.dia;
				while(u.anio = anio) and (u.mes = mes)and(u.dia = dia) do begin
					tiempoTotalId := 0;
					id := u.id;
					while(u.anio = anio) and (u.mes = mes)and(u.dia = dia) and (u.id = id) do begin
						tiempoTotalId := tiempoTotalId + u.tiempo;
						leer(usuario, u);
					end;
					writeln('            idUsuario ', id, ' Tiempo Total de acceso en el dia ', dia, ' mes ', mes, ' = ', tiempoTotalId:0:2);
					tiempoTotalDia := tiempoTotalDia + tiempoTotalId;
				end;
				writeln('        Tiempo total acceso dia ', dia, ' mes ', mes, ' = ', tiempoTotalDia:0:2);
				tiempoTotalMes := tiempoTotalMes + tiempoTotalDia;
			end;
			writeln('    Total tiempo de acceso mes ', mes, ' = ', tiempoTotalmes:0:2);
			tiempoTotalAnio := tiempoTotalAnio + tiempototalMes;
		end;		
		writeln('Total tiempo de acceso año = ', tiempoTotalAnio:0:2);	
	end
	else
		writeln('El año ingresado no existe');
	close(usuario);
end;
	

var
	usuario : archivo;
BEGIN
	importarUsuario(usuario);
	informe(usuario);
END.				
					
					
					
					
					
					
					
					
					
					
				
