program ejercicio5;
const valorAlto = 9999;
const dimf = 30

rango = 1..dimf;

type
	producto = record
		codigo : integer;
		nombre : string[30];
		descripcion : string[100];
		stockDisponible : integer;
		stockMinimo : integer;
		precio : real;
	end;
	
	venta = record
		codigo : integer;
		cantUnidades : integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	vectorD = array[rango] of detalle; //vector detalles
	vectorR = array[rango] of venta; //vector registros
	
procedure leer(var det : detalle; regD : venta);
begin
	if(not eof(det))then
		read(det, regD)
	else
		regD.codigo := valorAlto;
end;

procedure minimo(var vd : vectorD; var vr : vectorR; var min : venta);
var
	i, pos : integer;
begin
	min.codigo := valorAlto;
	for i := 1 to dimf do begin
		if(vr[i].codigo < min)then begin
			min := vr[i].codigo;
			pos := i;
		if(min.codigo <> valorAlto)then
			leer(vd[pos], vr[pos]);
	end;
end; 

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
begin
	reset
end;



procedure reporte(var mae : maestro);
var
	regM : producto;
	txt : text;
begin
	writeln('Exportando informe aquellos productos con stock por debajo del mininmo en "informe.txt"');
	assign(txt, 'informe.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		if(regM.stockDisponible < regM.stockMinimo)then begin
			writeln(txt, regM.stockDisponible, ' ', regM.nombre);
			writeln(txt, regM.precio, ' ', regM.descripcion);
		end;
	end;
	writeln('La exportacion se ha realizado con exito');
	close(mae);
	close(txt);
end;

		
var

BEGIN
	
	
END.

