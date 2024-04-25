{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ejercicio7;
type
	ave = record
		codigo : integer;
		nombre : string;
		familia : string;
		descripcion : string;
		zonaGeografica : string;
	end;
	
	maestro = file of ave;

procedure importarMaestro(var mae : maestro);
var
    a: ave;
    txt: text;
begin
    assign(txt, 'maestro.txt');
    reset(txt);
    assign(mae, 'maestro.dat');
    rewrite(mae);
    while(not eof(txt)) do begin
		with a do begin
			readln(txt, codigo, nombre);
            readln(txt, familia);
            readln(txt, descripcion);
            readln(txt, zonaGeografica);
            write(mae, a);
        end;
    end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(txt);
end;

procedure borradosLogicos(var mae : maestro);
var
	codigo : integer;
	regM : ave;
	encontre : boolean;
begin
	reset(mae);
	writeln('Ingrese el codigo de la especie a elminar (la lectura finaliza con codigo 5000)');
	readln(codigo);
	while(codigo <> 5000)do begin
		seek(mae, 0);
		encontre := false;
		while(not eof(mae) and not encontre)do begin
			read(mae, regM);
			if(codigo = regM.codigo)then begin
				encontre := true;
				regM.nombre := '***';
				seek(mae, filepos(mae)-1);
				write(mae, regM);
			end;
		end;
		if(not encontre)then
			writeln('Se ingreso un codigo que no existe, intente nuevamente');
		readln(codigo); 
	end;
	writeln('Los borrados logicos se han realizado de forma correcta');
	close(mae);
end;

procedure borradosFisicos(var mae : maestro);
var
	regM : ave;
	pos : integer;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		if(regM.nombre = '***')then begin
			pos := filepos(mae)-1;
			seek(mae, filesize(mae)-1);
			read(mae, regM);
			seek(mae, pos);
			write(mae, regM);
			seek(mae, filesize(mae)-1);
			truncate(mae);
		end;
	end;
	writeln('Los borrados fisicos se han realizado de forma correcta');
	close(mae);
end;

procedure imprimirMaestro(var mae : maestro);
var
	a : ave;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, a);
		if(a.nombre = '***')then
			writeln('Espacio disponible')
		else
			writeln('Codigo ', a.codigo, ' nombre ', a.nombre, ' familia ', a.familia, ' descripcion ', a.descripcion, ' zona geografica ', a.zonaGeografica);
	end;
	close(mae);
end;

var
	mae : maestro;
begin
	importarMaestro(mae);
	writeln('-----------------------------------');
	writeln('Maestro antes del borrado');
	imprimirMaestro(mae);
	borradosLogicos(mae);
	writeln('-----------------------------------');
	writeln('Maestro despues de los borrados logicos');
	imprimirMaestro(mae);
	borradosFisicos(mae);
	writeln('-----------------------------------');
	writeln('Maestro despues de los borrados fisicos');
	imprimirMaestro(mae);
end.

