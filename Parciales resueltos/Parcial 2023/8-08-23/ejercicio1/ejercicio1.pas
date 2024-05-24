program parcial2023;
const 
    valorAlto = 9999;
    dimf = 3; // = 20;
type
    producto = record
        codigo : integer;
        nombre : string;
        precio : real;
        stockActual : integer;
        stockMinimo : integer;
    end;

    venta = record  
        codigo : integer;
        cantidadVendida : integer;
    end;

    maestro = file of producto;
    detalle = file of venta;
    vectorDetalle = array [1..dimf] of detalle;
    vectorRegistros = array [1..dimf] of venta;

procedure importarMaestro(var mae : maestro);
var
    regM : producto;
    txt : text;
begin
    assign(mae, 'maestro');
    rewrite(mae);
    assign(txt, 'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
        with regM do begin
            readln(txt, codigo, precio, stockActual, stockMinimo, nombre);
        end;
        write(mae, regM);
    end;
    writeln('Archivo maestro importado con exito');
    close(mae);
    close(txt);
end;

procedure importarDetalle(var det : detalle);
var
    regD : venta;
    txt : text;
    ruta : string;
begin
    writeln('Ingrese la ruta del archivo binario');
    readln(ruta);
    assign(det, ruta);
    rewrite(det);
    writeln('Ingrese la ruta del archivo de texto');
    readln(ruta);
    assign(txt, ruta);
    reset(txt);
    while (not eof(txt)) do begin
        with regD do 
            readln(txt, codigo, cantidadVendida);
        write(det, regD);
    end;
    writeln('Archivo detalle importado con exito');
    close(det);
    close(txt);
end;

procedure cargarVectorDetalle(var vd : vectorDetalle);
var
    i : integer;
begin
    for i := 1 to dimf do 
        importarDetalle(vd[i]);
end;

procedure leer(var det : detalle; var v : venta);
begin
    if (not eof(det)) then
        read(det, v)
    else
        v.codigo := valorAlto;
end;

procedure minimo(var vd : vectorDetalle; var vr : vectorRegistros; var min : venta);
var
    i, pos : integer;
begin
    min.codigo := valorAlto;
    for i := 1 to dimf do begin
        if (vr[i].codigo <= min.codigo) then begin
            min := vr[i];
            pos := i;
        end;
    end;
    if (min.codigo <> valorAlto) then
        leer(vd[pos], vr[pos]);
end;

procedure exportarATxt(var txt: text; regM : producto);
begin
    write(txt, regM.codigo, ' ', regM.nombre, ' ', regM.precio:0:2, ' ', regM.stockActual, ' ', regM.stockMinimo);
end;

procedure procesar(var mae : maestro; var vd : vectorDetalle; var txt : text);
var
    i, codigo, cantVentas : integer;
    regM : producto;
    vr : vectorRegistros;
    montoTotalVendido : real;
    min : venta;
begin
    assign(txt, 'productosConMontoVendidoMayorA10Mil');
    rewrite(txt);

    reset(mae);
    read(mae, regM);
    for i := 1 to dimf do begin
        reset(vd[i]);
        leer(vd[i], vr[i]);
    end;
    minimo(vd, vr, min);
    while(min.codigo <> valorAlto)do begin
        codigo := min.codigo;
        cantVentas := 0;
        while(codigo = min.codigo)do begin
            cantVentas := cantVentas + min.cantidadVendida;
            minimo(vd, vr, min);
        end;
        while(regM.codigo <> codigo)do 
            read(mae, regM);
        regM.stockActual := regM.stockActual - cantVentas;
        montoTotalVendido := cantVentas * regM.precio;
        seek(mae, filepos(mae)-1);
        write(mae, regM);
        if (montoTotalVendido > 10000)then
            exportarATxt(txt, regM);
    end;
    writeln('Archivo maestro actualizado');
    for i := 1 to dimf do
        close(vd[i]);
    close(mae);
    close(txt);
end;

var
    mae : maestro;
    vd : vectorDetalle;
    txt : text;
begin
    importarMaestro(mae); // en el parcial se dispone
    cargarVectorDetalle(vd); // en el parcial se dispone
    procesar(mae, vd, txt);
end.




