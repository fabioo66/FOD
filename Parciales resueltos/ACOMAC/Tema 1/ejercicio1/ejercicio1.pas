{Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios
que habitaron durante la era mesozoica, de cada tipo se almacena: código, tipo de
dinosaurio, altura y peso promedio, descripción y zona geográfica. El archivo no está
ordenado por ningún criterio. Realice un programa que elimine tipos de dinosaurios
que estuvieron en el periodo jurásico de la era mesozoica. Para ello se recibe por
teclado los códigos de los tipos a eliminar.
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
Dada la estructura planteada en el ejercicio, implemente los siguientes módulos:
Abre el archivo y agrega un tipo de dinosaurios, recibido como parámetro
manteniendo la política descripta anteriormente
a. procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);
b. Liste el contenido del archivo en un archivo de texto, omitiendo los tipos de
dinosaurios eliminados. Modifique lo que considere necesario para obtener el listado}

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
    if(d.codigo <> -1) then begin
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

// En el parcial se dispone
procedure crearArchivo(var a: tArchDinos);
var
    d: tDinosaurio;
begin
    assign(a, 'Dinosaurios');
    rewrite(a);
    d.codigo := 0;
    d.tipo := '';
    d.altura := 0;
    d.peso := 0.0;
    d.descripcion := '';
    d.zona := '';
    write(a, d);
    leerDino(d);
    while(d.codigo <> -1) do begin
        write(a, d);
        leerDino(d);
    end;
    close(a);
    writeln('El archivo de dinosaurios se ha creado con exito');
end;

function existe(var a : tArchDinos; codigo : integer) : boolean;
var
    ok : boolean;
    d : tDinosaurio;
begin
    ok := false;
    while(not eof(a)) and (not ok)do begin
        read(a, d);
        if(codigo = d.codigo)then
            ok := true;
    end;
    existe := ok;
end;

procedure agregarAlFinal(var a : tarchDinos; registro : tDinosaurio);
begin
	seek(a, filesize(a));
	write(a, registro);
end;

procedure agregarDinosaurios(var a: tArchDinos; registro: tDinosaurio);
var
    d: tDinosaurio;
    enlace : integer;
begin
    reset(a);
    if(existe(a, registro.codigo))then
        writeln('Ese dinosaurio ya existe en el archivo')
    else begin
        seek(a, 0);
        read(a, d);
        enlace := d.codigo;
        if(enlace = 0) then begin
            agregarAlFinal(a, registro);
        end
        else begin 
            seek(a, abs(enlace)); //abs toma el valor absoluto de un numero
			read(a, d);
			seek(a, abs(enlace));
			write(a, registro);
			seek(a, 0);
			write(a, d);
        end;
        writeln('El dinosaurio de tipo ', registro.tipo, ' se ha agrego con exito');
    end;
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
    registro : tDinosaurio;
begin
    // En el parcial se dispone 
    crearArchivo(a);
    writeln('Ingrese los datos del dinosaurio que desea agregar');
    leerDino(registro);
    agregarDinosaurios(a, registro);
    listarEnArchivoDeTexto(a);
end.
