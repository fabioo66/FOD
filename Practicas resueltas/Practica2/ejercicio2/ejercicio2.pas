program ejercicio2;
const valorAlto = 9999;

type
	alumno = record
		codigo : integer;
		cantCursadas : integer;
		cantMaterias : integer;
		nomApe : string[50];
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
	regM : alumno;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.codigo, regM.cantCursadas, regM.cantMaterias, regM.nomApe);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    txt2 : text;
    regD : materia;
begin
    assign(det, 'detalle.dat');
    rewrite(det);
    assign(txt2, 'detalle.txt');
    reset(txt2);
    while(not eof(txt2)) do begin
        readln(txt2, regD.codigo, regD.estado); 
        write(det, regD);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt2);
end;

procedure leer(var det: detalle; var regD : materia);
begin
    if(not eof(det))then 
        read(det, regD)
    else 
		regD.codigo := valoralto;
end;

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	regD : materia; //registro detalle
	cursadas, materias, codigo : integer;
	regM : alumno; //registro maestro
begin
	reset(mae);
	reset(det);
	read(mae, regM); //leo maestro
	leer(det, regD); //leo detalle
	while(regD.codigo <> valorAlto)do begin
		codigo := regD.codigo;
		cursadas := 0;
		materias := 0;
		while(regD.codigo = codigo) do begin
			if(regD.estado = '1')then
				materias:= materias + 1
			else
				cursadas:= cursadas + 1;
			leer(det, regD);
		end;
		while(regM.codigo <> codigo)do
			read(mae, regM);
 		regM.cantMaterias := regM.cantMaterias + materias;
		regM.cantCursadas := regM.cantCursadas - materias;
		regM.cantCursadas := regM.cantCursadas + cursadas;
 		seek(mae, filepos(mae)-1);
  		write(mae, regM);
  		if(not eof(mae))then 
   			read(mae, regM);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det);
end;

{procedure actualizarMaestro(var mae : maestro; var det : detalle);
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
end;}

procedure imprimirAlumno(a : alumno);
begin
	writeln('Codigo= ', a.codigo, ' Cursadas aprobadas= ', a.cantCursadas, ' Materias aprobadas= ', a.cantMaterias, ' Nombre y apellido= ', a.nomApe);
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
		if(a.cantMaterias > a.cantCursadas)then 
			writeln(txt, a.codigo, ' ', a.cantCursadas, ' ', a.cantMaterias, ' ', a.nomApe);
	end;	
	close(mae);
	close(txt);		
end;

var
	det : detalle;
	mae : maestro;
BEGIN
	importarMaestro(mae);
	importarDetalle(det);
	actualizarMaestro(mae, det);
	imprimirArchivoMaestro(mae);
	exportarATxt(mae);
END.

