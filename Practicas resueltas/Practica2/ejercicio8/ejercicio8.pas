program ejercicio8;
const
	valorAlto = 9999;
type
	mrango = 1..12;
	drango = 1..31;
	
	archivoMaestro = record
		codigo : integer;
		nombre : string;
		apellido : string;
		anio : integer;
		mes : mrango;
		dia : drango;
		monto : real;
	end;
	
	data = record 
		codigo : integer;
		nomApe : string;
		anio : integer;
		mes : mrango;
	end;
	
	maestro = file of archivoMaestro;
	
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
		readln(txt, regM.codigo, regM.anio, regM.mes, regM.dia, regM.monto, regM.nombre);
		readln(txt, regM.apellido);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure leer(var mae : maestro; var regM : archivoMaestro);
begin
	if not eof(mae) then
		read(mae, regM)
	else 
		regM.codigo := valorAlto;
end;

procedure procesar(var mae : maestro);
var
	dato : data;
	regM: archivoMaestro;
	totalMes, totalAnio, totalEmpresa: real;
begin
	reset(mae);
	leer(mae, regM);
	totalEmpresa := 0;
	while(regM.codigo <> valorAlto)do begin
		writeln('Codigo de cliente ', regM.codigo, ' Nombre ', regM.nombre, ' Apellido ', regM.apellido);
		dato.codigo := regM.codigo;
		while(regM.codigo = dato.codigo)do begin
			writeln('Año ', regM.anio);
			dato.anio := regM.anio;
			totalAnio := 0;
			while(regM.codigo = dato.codigo) and (regM.anio = dato.anio)do begin
				dato.mes := regM.mes;
				totalMes := 0;
				while(regM.codigo = dato.codigo) and (regM.anio = dato.anio) and (regM.mes = dato.mes)do begin
					totalMes := totalMes + regM.monto;
					leer(mae, regM);
				end;
				if(totalMes <> 0)then begin
					writeln('Total gastado en el mes ', dato.mes, ' = ', totalMes:0:2);
					totalAnio := totalAnio + totalMes;
				end;
			end;
		    writeln('Total gastado en el anio = ', totalAnio:0:2);
		    totalEmpresa := totalEmpresa + totalAnio;
		end;
	end;
	writeln('Monto total de ventas obtenido por la empresa ', totalEmpresa:0:2);
	close(mae);
end;

var
	mae : maestro;
begin
	importarMaestro(mae);
	procesar(mae);
end.












