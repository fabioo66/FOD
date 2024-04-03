program ejercicio17;
const
	valorAlto = 'ZZZZ';
type
	casosCovid = record
		codigoLoc : integer;
		localidad : string[30];
		codigoMuni : integer;
		municipio : string[30];
		codigoHospi : integer;
		hospital : string[30];
		fecha : string;
		cantCasos : integer;
	end;
	
	data = record
		localidad : string[30];
		municipio : string[30];
		cant : integer;
	end;
	
	archivo = file of casosCovid;
	
procedure importarCasos(var casos : archivo);
var
    txt : text;
    c : casosCovid;
begin
    assign(casos, 'casos_covid.dat');
    rewrite(casos);
    assign(txt, 'casos_covid.txt');
    reset(txt);
    while(not eof(txt)) do begin
        readln(txt, c.codigoLoc, c.localidad);
        readln(txt, c.codigoMuni, c.municipio);
        readln(txt, c.codigoHospi, c.hospital);
        readln(txt, c.cantCasos, c.fecha); 
        write(casos, c);
    end;
    writeln('Archivo de casos creado');
    close(casos);
    close(txt);
end;

procedure leer(var casos : archivo; var c : casosCovid);
begin
    if(not eof(casos))then
        read(casos, c)
    else 
        c.localidad := valorAlto;
end;

procedure importarTxt(var txt : text; d : data);
begin
	writeln(txt, d.localidad);
	writeln(txt, d.cant, ' ', d.municipio);
end;

procedure procesar(var casos : archivo);
var
	d : data;
	txt : text;
	c : casosCovid;
	localidad, municipio, hospital : string[30];
	totalCasos, totalLoc, totalMuni, totalHospi : integer;
begin
	assign(txt, 'mas_1500_casos.txt');
	rewrite(txt);
	reset(casos);
	leer(casos, c);
	totalCasos := 0;
	while(c.localidad <> valorAlto)do begin
		writeln('Localidad ', c.localidad);
		totalLoc := 0;
		localidad := c.localidad;
		while(c.localidad = localidad)do begin
			writeln('Municipio ', c.municipio);
			totalMuni := 0;
			municipio := c.municipio;
			while(c.localidad = localidad)and(c.municipio = municipio)do begin
				writeln('Hospital ', c.hospital);
				totalHospi := 0;
				hospital := c.hospital;
				while(c.localidad = localidad)and(c.municipio = municipio)and(c.hospital = hospital)do begin
					totalHospi := totalHospi + c.cantCasos;
					leer(casos, c);
				end;
				writeln('Cantidad de casos hospital', totalHospi);
				totalMuni := totalMuni + totalHospi;
			end;
			writeln('Cantidad de casos Municipio ', totalMuni);
			totalLoc := totalLoc + totalMuni;
			if(totalMuni > 1500)then begin
				d.localidad := localidad;
				d.municipio := municipio;
				d.cant := totalMuni;
				importarTxt(txt, d);
			end;
		end;
		writeln('Cantidad de casos Localidad ', totalLoc);
		totalCasos := totalCasos + totalLoc;
	end;
	writeln('Cantidad de casos Provincia ', totalCasos);
	close(casos);
	close(txt);			
end;

var
	casos : archivo;
begin
	importarCasos(casos);
	procesar(casos);
end.

























