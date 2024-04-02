program ejercicio10;
const
	valorAlto = 9999;
type
	crango = 1..15;
	
	empleado = record
		departamento : integer;
		division : integer;
		numero : integer;
		categoria : crango;
		cantHoras : integer;
	end;

	dato = record  //registro de cada linea del archivo de texto
		categoria : crango;
		monto : real;
	end;
	
    archivo = file of empleado;
	vector = array[crango]of real;
	
procedure importarVector(var v : vector);
var
	txt : text;
	reg : dato;
begin
	assign(txt, 'valores.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, reg.categoria, reg.monto);
		v[reg.categoria] := reg.monto;
	end;
	writeln('Vector creado');
	close(txt);
end;

procedure importarMaestro(var empleado : archivo);
var
	txt : text;
	emp : empleado;
begin
	assign(empleado, 'maestro.dat');
	rewrite(empleado);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, emp.departamento, emp.division, emp.numero, emp.categoria, emp.cantHoras);
		write(empleado, emp);
	end;
	writeln('Archivo maestro creado');
	close(empleado);
	close(txt);
end;

procedure leer(var empleado: archivo; var emp: empleado);
begin
  if not eof(empleado) then
	read(empleado, emp)
  else 
	emp.departamento := valorAlto;
end;

procedure procesar(var empleado : archivo; v : vector);
var
	emp : empleado;
	departamento, division, numero, totalHoras, totalHorasDiv, totalHorasDep : integer;
	montoTotal, montoTotalDiv, montoTotalDep : real;
begin
	reset(empleado);
	leer(empleado, emp);
	while(emp.departamento <> valorAlto)do begin
		writeln('Departamento ', emp.departamento);
		totalHorasDep := 0;
		montoTotalDep := 0;
		departamento := emp.departamento;
		while(emp.departamento = departamento)do begin
			writeln('Division ', emp.division);
			totalHorasDiv := 0;
			montototalDiv := 0;
			division := emp.division;
			while(emp.departamento = departamento) and (emp.division = division)do begin
				totalHoras := 0;
				montoTotal := 0;
				numero := emp.numero;
			    while(emp.departamento = departamento) and (emp.division = division) and (emp.numero = numero)do begin
					totalHoras := totalHoras + emp.cantHoras;
					leer(empleado, emp);
				end;
				montoTotal := montoTotal + (v[emp.categoria] * totalHoras);
				writeln('Numero de empleado ', emp.numero, ' Total de horas ', totalHoras, ' Importe a cobrar ', montoTotal:0:2);
				totalHorasDiv := totalHorasDiv + totalHoras;
				montoTotalDiv := montoTotalDiv + montoTotal;
			end;
			writeln('Total horas por division ', totalHorasDiv, ' Monto total por division ', montoTotalDiv:0:2);
			totalHorasDep := totalHorasDep + totalHorasDiv;
			montoTotalDep := montoTotalDep + montoTotalDiv;
		end;
		writeln('Total horas por departamento ', totalHorasDep, 'Monto total por departamento ', montoTotalDep:0:2);	
	end;		
	close(empleado);
end;

var
	v : vector;
	empleadin : archivo;
begin
	importarVector(v);
	importarMaestro(empleadin);
	procesar(empleadin, v);
end.





