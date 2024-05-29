program parcial2023;
type
    producto = record
        codigo : integer;
        nombre : string;
        descripcion : string;
        precioCompra : real;
        precioVenta : real;
        ubicacion : string;
    end;

    archivo = file of producto;

procedure leerProducto(var p : producto);
begin
    writeln('Ingrese el codigo de producto');
    readln(p.codigo);
    if(p.codigo <> -1)then begin
		writeln('Ingrese el nombre del producto');  
		readln(p.nombre);
		writeln('Ingrese la descripcion del producto');
		readln(p.descripcion);
		writeln('Ingrese el precio de compra del producto');
		readln(p.precioCompra);
		writeln('Ingrese el precio de venta del producto');
		readln(p.precioVenta);
		writeln('Ingrese la ubicacion del producto');
		readln(p.ubicacion);
	end;
end;

{procedure crearArchivo(var arch : archivo);
var
    p : producto;
begin
    assign(arch, 'productos');
    rewrite(arch);
    p.codigo := 0;
    p.nombre := '';
    p.descripcion := '';
    p.precioCompra := 0;
    p.precioVenta := 0;
    p.ubicacion := '';
    write(arch, p);
    leerProducto(p);
    while(p.codigo <> -1)do begin
        write(arch, p);
        leerProducto(p);
    end;
    close(arch);
end;}

// funcion que verifica si existe un producto en el archivo, en el parcial se dispone
function existeProducto(var arch : archivo; codigo : integer) : boolean;
var 
    p : producto;
    ok : boolean;
begin
    ok := false;
    reset(arch);
    while((not eof(arch)) and (not ok))do begin    
        read(arch, p);
        if(p.codigo = codigo)then
            ok := true;
    end;
    existeProducto := ok;
    close(arch);
end;

procedure agregarProducto(var arch : archivo);
var
    p, cabecera : producto;
begin
    writeln('Ingrese los datos del producto que desea agregar');
    leerProducto(p);
    // asumimos que existe producto abre y cierra el archivo
    if(existeProducto(arch, p.codigo))then 
        writeln('El producto ya existe')
    else begin
        reset(arch);
        // Leo cabecera
        read(arch, cabecera);
        if(cabecera.codigo = 0)then begin
            seek(arch, filesize(arch));
            write(arch, p);
        end
        else begin
            seek(arch, cabecera.codigo *-1);
			read(arch, cabecera);
			seek(arch, filepos(arch)-1);
			write(arch, p);
			seek(arch, 0);
			write(arch, cabecera);
        end;
        close(arch);
        writeln('Producto agregado correctamente');
    end;
end;

procedure quitarProducto(var arch : archivo);
var
    cabecera, p: producto;
    codigo : integer;
begin
    writeln('Ingrese el codigo del producto que desea quitar');
    readln(codigo);
    if(existeProducto(arch, codigo))then begin
        reset(arch);
        read(arch, cabecera);
        read(arch, p);
        while(p.codigo <> codigo)do 
            read(arch, p);
        seek(arch, filepos(arch)-1);
		write(arch, cabecera);
		cabecera.codigo := (filePos(arch)-1) * -1; 
		seek(arch, 0);
		write(arch, cabecera);
		close(arch);
		writeln('Producto eliminado correctamente')
    end
    else
        writeln('El producto no existe');
end;

procedure imprimirProducto(var arch : archivo);
var
    p : producto;
begin
    reset(arch);
    read(arch, p);
    while(not eof(arch))do begin
        read(arch, p);
        if(p.codigo > 0)then begin
            writeln('Codigo: ', p.codigo, ' Nombre: ', p.nombre, ' Descripcion: ', p.descripcion
            , ' Precio de compra: ', p.precioCompra:0:2, ' Precio de venta: ', p.precioVenta:0:2, ' Ubicacion: ', p.ubicacion);
        end
        else    
            writeln('Espacio disponible');
    end;
    close(arch);
end;

var
    arch : archivo;
begin
    assign(arch, 'productos');
    writeln('Archivo sin modificar');
    imprimirProducto(arch);
    agregarProducto(arch);
    writeln('Archivo con producto agregado');
    imprimirProducto(arch);
    quitarProducto(arch);
    writeln('Archivo con producto eliminado');
    imprimirProducto(arch);
end.

