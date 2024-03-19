program ejercicio4;
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
	asignar(emp);
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

function cumple(var emp: archivo; numero: integer): boolean;
var
	encontre: boolean;
	e: empleado;
begin
	encontre:= false;
	while(not eof(emp))and(not encontre)do begin
		read(emp, e);
		if(e.numero = numero)then
			encontre:= true;
	end;
	cumple:= not encontre;
end;

procedure agregarEmpleado(var emp: archivo);
var
	e: empleado;
begin
	reset(emp);
	leerEmpleado(e);
	if(cumple(emp, e.numero))then begin
		seek(emp, fileSize(emp));
		write(emp, e)
	end
	else
		writeln('Ingresaste un empleado existente');
	close(emp);
end;

procedure modificarEdad(var emp: archivo);
var
	e: empleado;
	edad, num: integer;
	encontre: boolean;
begin
	encontre:= false;
	reset(emp);
	writeln('ingrese el numero del empleado que quiere modificarle la edad');
	readln(num);
	writeln('Ingrese la edad que quiere ingresarle');
	readln(edad);
	while(not eof(emp))and(not encontre)do begin
		read(emp, e);
		if(e.numero = num)then begin
			encontre:= true;
		    e.edad:= edad;
		    Seek(emp, filepos(emp) -1 );
		    write(emp, e)
		end
	end;
	if(encontre = false)then
		writeln('Ingresaste un numero de empleado inexistente');
	close(emp);	
end;

procedure exportarTxt(var emp : archivo);
var
  e : empleado;
  txt : Text;
begin
  assign(txt,'todos_empleados.txt');
  rewrite(txt);
  reset(emp);
  while(not eof(emp)) do begin
    read(emp, e);
    writeln(txt,e.numero,' ',e.apellido,' ',e.nombre,' ',e.edad,' ',e.dni);
  end;
  writeln('La exportacion se ha realizado con exito');
  close(emp);
  close(txt);
end;

procedure exportarTxtDni(var emp: archivo);
var
	e: empleado;
	txtDni: text;
begin
	assign(txtDni, 'faltaDNIEmpleado.txt');
	rewrite(txtDni);
	reset(emp);
	while(not eof(emp))do begin
		read(emp, e);
		if(e.dni = 00)then begin
			writeln(txtDni,e.numero,' ', e.edad,' ', e.dni, ' ', e.nombre);
			writeln(txtDni, e.apellido);
		end;	
	end;
	writeln('La exportacion se ha realizado con exito');
	close(emp);
	close(txtDni);
end;

procedure menu(var emp: archivo);
var
	categoria : char;
begin
	categoria:= 'z';
	while (categoria <> 'i')do begin
		writeln('__________________________________________________________________________________________');
		writeln('|Menu                                                                                     |');
		writeln('|a | Crear un Archivo con empleados(Siempre lo primero)                                   |');
		writeln('|b | Datos de Empleados con un apellido/nombre predeterminado                             |');
		writeln('|c | Mostrar todos los Empleados                                                          |');
		writeln('|d | Mostrar los Empleados mayores de 70                                                  |');
        writeln('|e | Añadir un empleado                                                                   |');
        writeln('|f | Modificar la edad de un empleado                                                     |');
        writeln('|g | Exportar el contenido del archivo a un archivo de texto llamado "todos_empleados.txt"|');
        writeln('|h | Exportar a un archivo de texto llamado: "faltaDNIEmpleado.txt", (DNI 00)             |');
        writeln('|i | cerrar menu                                                                          |');
        writeln('|_________________________________________________________________________________________|');
		readln(categoria);
		case categoria of
			'a': cargar(emp);
			'b': buscar(emp);
			'c': informarArchivo(emp);
			'd': proxJubilados(emp);
			'e': agregarEmpleado(emp);
			'f': modificarEdad(emp);
			'g': exportarTxt(emp);
			'h': exportarTxtDni(emp); //exporta los empleados que no tienen cargado el dni
            'i': WriteLn('Archivo Cerrado');
			else writeln('Caracter invalido'); 
		end;
	end;
end;

var
	emp: archivo;
begin
	menu(emp);
end.

