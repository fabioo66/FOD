program ejercicio3;
type
	empleado = record
		numero: integer;
		nombre: string[20];
		apellido: string[20];
		edad: integer;
		dni: integer;
	end;
	
	archivo = file of empleado;
	
procedure leerEmpleado(var e: empleado);
begin
	writeln('Ingrese el apellido del empleado');
	readln(e.apellido);
	if(e.apellido <> 'fin')then begin
		writeln('Ingrese el nombre del empleado');
		readln(e.nombre);
		writeln('Ingrese el numero de empleado');
		//readln(e.numero);
		e.numero:= random(3000);
		writeln(e.numero);
		writeln('Ingrese la edad del empleado');
		//readln(e.edad);
		e.edad:= random(81)+20;
		writeln(e.edad);
		writeln('Ingrese el dni del empleado');
		//readln(e.dni);
		e.dni:= random(99999999);
		writeln(e.dni);
	end;
end;

procedure asignar(var emp: archivo);
var
	ruta : string[12];
begin
	writeln('Ingrese la ruta del archivo');
	readln(ruta);
	assign(emp, ruta);
end;

procedure cargar(var emp: archivo);
var
	e: empleado;
begin
	rewrite(emp);
	writeln('La lectura finaliza con el apellido "fin"');
	leerEmpleado(e);
	while(e.apellido <> 'fin')do begin
		write(emp, e);
		leerEmpleado(e);
	end;
	close(emp);
end;

procedure imprimirEmpleado(e: empleado);
begin
	writeln(' Numero: ',e.numero,
            ' Apellido: ',e.apellido,
            ' Nombre: ',e.nombre,
            ' Edad: ',e.edad,
            ' DNI: ',e.dni
            );
end;

procedure buscar(var emp: archivo);
var
	pj: string[20];
	e: empleado;
begin
	reset(emp);
	writeln('Ingresa el nombre/apellido de un empleado');
	readln(pj);
	writeln('Las coincidencias que se encontraron fueron');
	while(not eof(emp))do begin
		read(emp, e);
		if(pj = e.nombre)or(pj = e.apellido)then
			imprimirEmpleado(e);	
	end;
	close(emp);
end;

procedure informarArchivo(var emp: archivo);
var
	e: empleado;
begin
	reset(emp);
	writeln('Empleados de la empresa');
	while(not eof(emp))do begin
		read(emp, e);
		imprimirEmpleado(e);
	end;
	close(emp);
end;

procedure proxJubilados(var emp: archivo);
var
	e: empleado;
begin
	reset(emp);
	writeln('Los proximos empleados a jubilarse son');
	while(not eof(emp))do begin
		read(emp, e);
		if(e.edad > 70)then
			imprimirEmpleado(e);
	end;
	close(emp);
end;

var
	emp: archivo;
	categoria: char;
begin
	randomize;
	asignar(emp);
	categoria:= 'z';
	while (categoria <> 'e')do begin
		writeln('__________________________________________________________________________________________');
		writeln('|Menu                                                                                     |');
		writeln('|a | Crear un Archivo con empleados(Siempre lo primero)                                   |');
		writeln('|b | Datos de Empleados con un apellido/nombre predeterminado                             |');
		writeln('|c | Mostrar todos los Empleados                                                          |');
		writeln('|d | Mostrar los Empleados mayores de 70                                                  |');
        writeln('|e | Cerrar Menu                                                                         |');
        writeln('|_________________________________________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': cargar(emp);
			'b': buscar(emp);
			'c': informarArchivo(emp);
			'd': proxJubilados(emp);
            'e': WriteLn('Archivo Cerrado');
			else writeln('Numero invalido'); 
		end;
	end;
end.
