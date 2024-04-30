{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:
* a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i.Los archivos no están ordenados por ningún criterio.
ii.Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}
program ejercicio1;
const
	valorAlto = 9999;
type
	regMaestro = record
		codigo : integer;
		nombre : string;
		precio : real;
		stockActual : integer;
		stockMinimo : integer;
	end;
	
	regDetalle = record
		codigo : integer;
		cantVendidas : integer;
	end;
	
	maestro = file of regMaestro;
	detalle = file of regDetalle;

procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    regM : regMaestro;
begin
    reset(carga);
    nombre:= 'ArchivoMaestro';
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with regM do
                begin
                    readln(carga, codigo, precio, stockActual, stockMinimo, nombre);
                    write(mae, regM);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;

procedure crearDetalle(var det: detalle; var carga: text);
var
    nombre : string;
    regD : regDetalle;
begin
    reset(carga);
    nombre:= 'ArchivoDetalle';
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with regD do
                begin
                    readln(carga, codigo, cantVendidas);
                    write(det, regD);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
    regM : regMaestro;
    regD : regDetalle;
    encontre: boolean;
begin
    reset(mae);
    reset(det);
    encontre := false;
    while (not eof(det)) do begin
        read(det, regD);
        encontre := false;
        seek(mae, 0);
        while (not eof(mae)) and (not encontre) do begin
            read(mae, regM);
            if (regM.codigo = regD.codigo) then begin
                encontre := true;
                regM.stockActual := regM.stockActual - regD.cantVendidas;
                seek(mae, filepos(mae)-1);
                write(mae, regM);
            end;
        end;
    end;
    writeln('Maestro actualizado');
    close(mae);
    close(det);
end;

procedure imprimirMaestro(var mae: maestro);
var
    regM : regMaestro;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, regM);
            with regM do
                writeln('Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stockActual, ' StockMin=', stockMinimo, ' Nombre=', nombre);
        end;
    close(mae);
end;

var
	mae : maestro;
	det : detalle;
	cargaMae, cargaDet: text;
begin
	assign(cargaMae, 'maestro.txt');
    crearMaestro(mae, cargaMae);
    assign(cargaDet, 'detalle.txt');
    crearDetalle(det, cargaDet);
	writeln('Maestro antes de ser actualizado');
	imprimirMaestro(mae);
	actualizarMaestro(mae, det);
	writeln('------------------------------------------------------');
	writeln('Maestro despues de la actualizaccion');
	imprimirMaestro(mae);
end.
