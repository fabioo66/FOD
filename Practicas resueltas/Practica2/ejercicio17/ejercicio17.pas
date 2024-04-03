{código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.}
program ejercicio17;
type
	casosCovid = record
		codigoLoc : integer;
		Localidad : string[30];
		codigoMuni : integer;
		municipio : string[30];
		CodigoHospi : integer;
		hospital : string[30];
		fecha : string;
		cantCasos : integer;
	end;
	

