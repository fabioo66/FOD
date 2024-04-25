program ejercicio2;

type 
  asistente = record
    num : integer;
    apeYNom : string[100];
    email : string[40];
    telefono : integer;
    dni : integer;
  end;

  archivo = file of asistente;

procedure leerAsistente(var a : asistente);
begin
  writeln('Ingrese el apellido y nombre');
  readln(a.apeYNom);
  if (a.apeYNom <> 'fin') then 
  begin
    writeln('Ingrese el numero de asistente');
    //readln(num);
    a.num := random(500) + 800;
    writeln(a.num);
    writeln('Ingrese el email');
    readln(a.email);
    writeln('Ingrese el telefono');
    //readln(telefono);
    a.telefono := random(2223432773) + 1000;
    writeln(a.telefono);
    writeln('Ingrese el D.N.I');
    //readln(dni);
    a.dni := random(45579759) + 12321;
    writeln(a.dni);
  end;
end;

procedure cargarAsistente(var arch : archivo);
var
  a : asistente;
begin
  assign(arch, 'asistentes.dat');
  rewrite(arch);
  writeln('El corte de lectura se dara cuando se ingrese apellido y nombre "fin"');
  leerAsistente(a);
  while (a.apeYNom <> 'fin') do 
  begin
    write(arch, a);
    leerAsistente(a);
  end;
  writeln('Archivo de asistentes creado');
  close(arch);
end;

procedure eliminarAsistentes(var arch : archivo);
var
  a : asistente;
begin
  writeln('¡Se eliminaran logicamente todos los asistentes con el numero de asistente inferior a 1000 ');
  writeln('El borrado se realizará agregando "KINGRYAN" al principio del email');
  reset(arch);
  while (not eof(arch)) do 
  begin
    read(arch, a);
    if (a.num < 1000) then 
    begin
      a.email := 'KINGRYAN' + a.email;
      seek(arch, filepos(arch)-1);
      write(arch, a);
    end;
  end;
  writeln('Los borrados se han efectuado correctamente');
end;

procedure imprimirArchivo(var arch : archivo);
var
  a : asistente;
begin
  reset(arch);
  while (not eof(arch)) do 
  begin
    read(arch, a);
    writeln('numero de asistente ', a.num, ' apellido y nombre ', a.apeYNom, ' email ', a.email, ' telefono ', a.telefono, ' dni ', a.dni);
  end;
  close(arch);
end;

var
  arch : archivo;
begin
  randomize;
  cargarAsistente(arch);
  writeln('Lista de asistentes : ');
  imprimirArchivo(arch);
  eliminarAsistentes(arch);
  writeln('--------------------------------');
  writeln('Lista de asistentes luego del borrado logico');
  imprimirArchivo(arch);
end.
