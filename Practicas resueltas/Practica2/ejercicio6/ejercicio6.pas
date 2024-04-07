program ejercicio6;
const
	dimf = 5;
	valorAlto = 9999;
type
	rango = 1..dimf;
	
	sesion = record
		codigo : integer;
		fecha : string[20];
		tiempo : real;
	end;
	
	detalle = file of sesion;
	maestro = file of sesion;
	
	vectorD = array[rango] of detalle;
	vectorR = array[rango] of archivoDetalle;
	
procedure importarDetalle(var det : detalle);
var
	ruta : string;
    txt2 : text;
    regD : sesion;
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
        readln(txt2, regD.codigo, regD.tiempo, regD.fecha); 
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

procedure leer(var det: detalle; var regD: sesion);
begin
	if not eof(det) then
		read(det, regD)
	else 
		regD.codigo := valorAlto;
 end;
 
 procedure crearMaestro(

var

begin

end.
