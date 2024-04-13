{15. La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}

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
	

var

begin

end.
