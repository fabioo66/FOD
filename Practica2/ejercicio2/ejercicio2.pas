program ejercicio2;
const valorAlto = 9999;

type
	alumno = record
		codigo : integer;
		apellido : string[20];
		nombre : string[20];
		cantCursadas : integer;
		cantMaterias : integer;
	end;
	
	materia = record
		codigo : integer;
		estado : char; //1 si apobo la materia, 0 si aprobo la cursada
	end;
	
	detalle = file of materia;
	maestro = file of alumno;
	
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	a : alumno;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, a.codigo, a.cantCursadas, a.cantMaterias);
		readln(txt, a.nombre);
		readln(txt, a.apellido);
		write(mae, a);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    txt2 : text;
    dato : materia;
begin
    assign(det, 'detalle.dat');
    rewrite(det);
    assign(txt2, 'detalle.txt');
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, dato.codigo, dato.estado); 
        write(det, dato);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det: detalle; var dato : materia);
begin
    if(not eof(det))then 
        read(det, dato)
    else 
		dato.codigo := valoralto;
end;

{procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	dato : materia;
	cursadas, materias, codigo : integer;
	a : alumno;
begin
	reset(mae);
	reset(det);
	read(mae, a);
	leer(det, dato);
	while(dato.codigo <> valorAlto)do begin
		codigo := dato.codigo;
		cursadas := 0;
		materias := 0;
		while(dato.codigo = codigo) do begin
			if(dato.estado = '1')then
				materias:= materias + 1
			else
				cursadas:= cursadas + 1;
			leer(det, dato);
		end;
		while(dato.codigo <> codigo)do
			read (mae, a);
 		a.cantMaterias := a.cantMaterias + materias;
		a.cantCursadas := (a.cantCursadas - materias) + cursadas;
 		seek(mae, filepos(mae)-1);
  		write(mae, a);
  		if(not eof(mae))then 
   			read(mae, a);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det);
end;}

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	dato : materia; //registro detalle
	a : alumno; //registro maestro
begin
	reset(mae);
	reset(det);
	leer(det, dato);
	while(dato.codigo <> valorAlto)do begin
		read(mae, a);
		while(dato.codigo <> a.codigo)do
			read(mae,a);
		while (a.codigo = dato.codigo) do begin
			if(dato.estado = '1')then begin
				a.cantMaterias:= a.cantMaterias + 1;
				a.cantCursadas:= a.cantCursadas - 1
			end
			else
				a.cantCursadas:= a.cantCursadas + 1;
			leer(det, dato);
		end;
        seek (mae, filepos(mae)-1);
        write(mae, a);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det);
end;

procedure imprimirAlumno(a : alumno);
begin
	writeln('Codigo= ', a.codigo, ' Nombre= ', a.nombre , ' Apellido= ', a.apellido,  ' MateriasSinFinal= ', a.cantCursadas, ' MateriasConFinal= ', a.cantMaterias);

end;

procedure imprimirArchivoMaestro(var mae : maestro);
var
	a : alumno;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, a);
		imprimirAlumno(a);
	end;
	close(mae);
end;

procedure exportarATxt(var mae : maestro);
var
	txt : text;
	a : alumno;
begin
	writeln('Importando archivo binario a archivo de texto aquellos alumnos que posean mas materias aprobadas que materias sin finall aprobado');
	assign(txt, 'alumnos.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, a);
		if(a.cantMaterias > a.cantCursadas)then begin
			writeln(txt, a.codigo, ' ', a.cantCursadas, ' ', a.cantMaterias);
			writeln(txt, a.nombre);
			writeln(txt, a.apellido);
		end;
	end;	
	close(mae);
	close(txt);		
end;

var
	det : detalle;
	mae : maestro;
BEGIN
	importarDetalle(det);
	importarMaestro(mae);
	actualizarMaestro(mae, det);
	imprimirArchivoMaestro(mae);
	exportarATxt(mae);
END.

