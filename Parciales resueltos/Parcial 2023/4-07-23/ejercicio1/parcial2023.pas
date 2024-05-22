program parcial;
const 
    valorAlto = 'ZZZZ';
type
    partido = record
        codigoEquipo : integer;
        nombreEquipo : string;
        anio : string;
        codigoTorneo : integer;
        codigoEquipoRival : integer;
        golesAFavor : integer;
        golesEnContra : integer;
        puntos : integer; // 3 por ganar, 1 por empatar, 0 por perder
    end;

    archivo = file of partido;

procedure importarArchivo(var arch : archivo);
var
    p : partido;
    txt : text;
begin
    assign(txt, 'partidos.txt');
    reset(txt);
    assign(arch, 'partidos');
    rewrite(arch);
    while not eof(txt) do begin
        with p do begin
            readln(txt, codigoEquipo, codigoEquipoRival, codigoTorneo, golesAFavor, golesEnContra, puntos, nombreEquipo);
            readln(txt, anio);
        end;
        write(arch, p);
    end;
    close(txt);
    close(arch);
    writeln('Archivo importado con exito');
end;

procedure leer(var arch : archivo; var p : partido);
begin
    if not eof(arch) then
        read(arch, p)
    else
        p.anio := valorAlto;
end;

procedure informe(var arch : archivo);
var
    p : partido;
    // datos para el corte de control
    anio, equipoMax, nombreEquipo : string;
    codigoEquipo, codigoTorneo, maxPuntos : integer;
    golesAFavor, golesEnContra, cantPartidosGanados, cantPartidosPerdidos, 
    cantPartidosEmpatados, puntosTotales : integer;
begin
    reset(arch);
    leer(arch, p);
    while(p.anio <> valorAlto)do begin  
        writeln('Año ', p.anio);
        anio := p.anio;
        while(p.anio = anio)do begin
            writeln('   cod_torneo ', p.codigoTorneo);
            codigoTorneo := p.codigoTorneo;
            maxPuntos := -1;
            while(p.anio = anio) and (p.codigoTorneo = codigoTorneo)do begin
                writeln('       cod_equipo ', p.codigoEquipo, ' nombre equipo ', p.nombreEquipo);
                nombreEquipo := p.nombreEquipo;
                codigoEquipo := p.codigoEquipo;
                golesAFavor := 0;
                golesEnContra := 0;
                cantPartidosGanados := 0;
                cantPartidosEmpatados := 0;
                cantPartidosPerdidos := 0;
                puntosTotales := 0;
                while(p.anio = anio) and (p.codigoTorneo = codigoTorneo) and (p.codigoEquipo = codigoEquipo)do begin
                    golesAFavor := golesAFavor + p.golesAFavor;
                    golesEnContra := golesEnContra + p.golesEnContra;
                    if (p.puntos = 0) then
                        cantPartidosPerdidos := cantPartidosPerdidos + 1
                    else if (p.puntos = 1) then
                        cantPartidosEmpatados := cantPartidosEmpatados + 1
                    else
                        cantPartidosGanados := cantPartidosGanados + 1;
                    puntosTotales := puntosTotales + p.puntos;
                    leer(arch, p);
                end;
                writeln('           cantidad total de goles a favor ', golesAFavor);
                writeln('           cantidad total de goles en contra ', golesEnContra);
                writeln('           diferencia de gol ', golesAFavor-golesEnContra);
                writeln('           cantidad de partidos ganados ', cantPartidosGanados);
                writeln('           cantidad de partidos perdidos ', cantPartidosPerdidos);
                writeln('           cantidad de partidos empatados ', cantPartidosEmpatados);
                writeln('           cantidad total de puntos en el torneo ', puntosTotales);
                if (puntosTotales > maxPuntos)then begin
                    maxPuntos := puntosTotales;
                    equipoMax := nombreEquipo;
                end;
            end;
            writeln('   El equipo ', equipoMax, ' fue campeon del torneo ', codigoTorneo, ' del año ', anio);
        end;
    end;
    close(arch);
end;

var 
    arch : archivo;
begin
    // en el parcial se dispone
    importarArchivo(arch);
    informe(arch);
end.

                    
