{Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios
que habitaron durante la era mesozoica, de cada tipo se almacena: código, tipo de
dinosaurio, altura y peso promedio, descripción y zona geográfica. El archivo no está
ordenado por ningún criterio. Realice un programa que elimine tipos  de dinosaurios
que estuvieron en el periodo jurásico de la era mesozoica. Para ello se recibe por
teclado los códigos de los tipos a eliminar.
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido. 
Dada la estructura planteada en el ejercicio, implemente los siguientes módulos:
Abre el archivo y elimina el tipo de dinosaurio recibido como parámetro manteniendo
la política descripta anteriormente
a. procedure eliminarDinos (var a: tArchDinos ; tipoDinosaurio: String);
b. Liste en un txt (archivo de texto) el contenido del archivo omitiendo los tipos de
dinosaurios eliminados. Modifique lo que considere necesario para obtener el listado.
Nota: Las bajas deben finalizar al recibir el código 100000}

program ejercicio1;
type
    tDinosaurio = record
        codigo: integer;
        tipo: string;
        altura: real;
        peso: real;
        descripcion: string;
        zona: string;
    end;

    tArchDinos = file of tDinosaurio;

// Modulo inecesario en el parcial
procedure leerDino(var d: tDinosaurio);
begin 
    writeln('Ingrese el codigo del dinosaurio');
    readln(d.codigo);
    if(d.codigo <> 1000) then begin
        writeln('Ingrese el tipo de dinosaurio');
        readln(d.tipo);
        writeln('Ingrese la altura del dinosaurio');
        readln(d.altura);
        writeln('Ingrese el peso del dinosaurio');
        readln(d.peso);
        writeln('Ingrese la descripcion del dinosaurio');
        readln(d.descripcion);
        writeln('Ingrese la zona geografica del dinosaurio');
        readln(d.zona);
    end;
end;

function existe(var a : tArchDinos; tipo : string) : boolean;
var
    ok : boolean;
    d : tDinosaurio;
begin
    ok := false;
    while(not eof(a)) and (not ok)do begin
        read(a, d);
        if(tipo = d.tipo)then
            ok := true;
    end;
    existe := ok;
end;

procedure eliminarDinos (var a: tArchDinos ; tipoDinosaurio: String);
var
	d : tDinosaurio;
begin
	reset(a);
	read(a, d);
	if(existe(a, tipoDinosaurio))then begin
		seek(a, filepos(a)-1);
		write(a, d);
		d.codigo := (filePos(a)-1) * -1; 
		seek(a, 0);
		write(a, d);
		writeln('Dinosaurio eliminado correctamente')
	end
	else
		writeln('No se encontro el dinosaurio');
	close(a);
end;

procedure listarEnArchivoDeTexto(var a: tArchDinos);
var
    d : tDinosaurio;
    txt : text;
begin
    assign(txt, 'Dinosaurios.txt');
    rewrite(txt);
    reset(a);
    seek(a, 1);
    while(not eof(a))do begin
        read(a, d);
        if(not d.codigo <= 0)then 
            writeln(txt, d.codigo, ' ', d.tipo, ' ', d.altura:0:2, ' ', d.peso:0:2, ' ', d.descripcion, ' ', d.zona);
    end;
    close(a);
    close(txt);
    writeln('El archivo se ha exportado con exito');
end;

var
    a : tArchDinos;
    d : tDinosaurio;
begin
    assign(a, 'Dinosaurios');
    writeln('Ingrese los datos del dinosaurio a eliminar');
    leerDino(d);
    while(d.codigo <> 1000)do begin
        eliminarDinos(a, d.tipo);
        leerDino(d);
    end;
    listarEnArchivoDeTexto(a);
end.
