{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

program ejercicio8;
type 
    distro = record
        nombre : string;
        anio : integer;
        version : string;
        cantDesarrolladores : integer;
        descripcion : string;
    end;
    
    archivo = file of distro;
    
procedure leerDistro(var d : distro);
begin
	writeln('Ingrese el anio de lanzamiento');
	readln(d.anio);
	if(d.anio <> -1)then begin
		writeln('Ingrese el nombre de la distribucion de linux');
		readln(d.nombre);
		writeln('Ingrese la version del kernel');
		readln(d.version);
		writeln('Ingrese la cantidad de desarrolladores');
		//readln(d.cantDesarroladores);
		d.cantDesarrolladores := random(50)+51;
		writeln(d.cantDesarrolladores);
		writeln('Ingrese la descripcion');
		readln(d.descripcion);
	end;
end;    
    
procedure cargarArchivo(var arch : archivo);
var
	d : distro;
begin
	assign(arch, 'distribuciones.dat');
	rewrite(arch);
	d.anio := 0;
	d.nombre := 'cabecera';
	write(arch, d);
	leerDistro(d);
	while(d.anio <> -1)do begin
		write(arch, d);
		leerDistro(d);
	end;
	writeln('Archivo creado');
	close(arch);
end;

{a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.}

function existeDistribucion(var arch : archivo; nombre : string) : boolean;
var
    d : distro;
    encontre : boolean;
begin
    encontre := false;
    while(not eof(arch) and not encontre)do begin
        read(arch, d);
        if(d.nombre = nombre)then
            encontre := true;
    end;
	existeDistribucion := encontre;
end;

{b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.}

procedure altaDistribucion(var arch : archivo);
var
    d, aux : distro;
begin
	writeln('Ingrese los datos de la distribucion que desea agregar');
    reset(arch);
    leerDistro(aux);
    if(existeDistribucion(arch, aux.nombre))then 
        writeln('Ya existe la distribucion')
    else begin
		seek(arch, 0);
		read(arch, d);
		if(d.anio = 0)then begin 
			seek(arch, filepos(arch));
			write(arch, aux)
		end
		else begin
			seek(arch, d.anio *-1);
			read(arch, d);
			seek(arch, filepos(arch)-1);
			write(arch, aux);
			seek(arch, 0);
			write(arch, d);
		end;
		writeln('Se agrego una distribucion de linux correctamente');
	end;
	close(arch);
end;

{c. BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

procedure bajaDistribucion(var arch : archivo);
var
	aux : distro;
	nombre : string;
begin
	reset(arch);
	writeln('Ingrese el nombre de la distribucion que desea eliminar');
	readln(nombre);
	read(arch, aux);
	if(existeDistribucion(arch, nombre))then begin
		seek(arch, filepos(arch)-1);
		write(arch, aux);
		aux.anio := (filePos(arch)-1) * -1; 
		seek(arch, 0);
		write(arch, aux);
		writeln('Distribucion eliminada correctamente')
	end
	else
		writeln('No se encontro la distribucion');
	close(arch);
end;

procedure imprimirArchivo(var arch : archivo);
var
	d : distro;
begin
	reset(arch);
	seek(arch, 1);
	while(not eof(arch))do begin
		read(arch, d);
		write('Nombre ', d.nombre, ' anio ', d.anio, ' version ', d.version, ' cant desarrolladores ', d.cantDesarrolladores, ' descripcion ', d.descripcion);
	end;
	close(arch); 
end;

var
	arch : archivo;
begin
	cargarArchivo(arch);
	imprimirArchivo(arch);
	bajaDistribucion(arch);
	altaDistribucion(arch);
	imprimirArchivo(arch);
end.
