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

// En el parcial se dispone
procedure crearArchivo(var arch : archivo);
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
end;

// funcion que verifica si existe un producto en el archivo, en el parcial se dispone
function existeProducto(var arch : archivo; codigo : integer) : boolean;
var 
    p : producto;
    ok : boolean;
begin
    ok := false;
    while((not eof(arch)) and (not ok))do begin    
        read(arch, p);
        if(p.codigo = codigo)then
            ok := true;
    end;
    existeProducto := ok;
end;

procedure agregarProducto(var arch : archivo);
var
    p, aux : producto;
begin
    reset(arch);
    writeln('Ingrese los datos del producto que desea agregar');
    leerProducto(aux);
    // asumimos que existe producto no abre ni cierra el archivo
    if(existeProducto(arch, aux.codigo))then 
        writeln('El producto ya existe')
    else begin
        seek(arch, 0);
        read(arch, p);
        if(p.codigo = 0)then begin
            seek(arch, filesize(arch));
            write(arch, aux);
        end
        else begin
            seek(arch, p.codigo *-1);
			read(arch, p);
			seek(arch, filepos(arch)-1);
			write(arch, aux);
			seek(arch, 0);
			write(arch, p);
        end;
        writeln('Producto agregado correctamente');
    end;
    close(arch);
end;

procedure quitarProducto(var arch : archivo);
var
    p: producto;
    codigo : integer;
begin
    reset(arch);
    writeln('Ingrese el codigo del producto que desea quitar');
    readln(codigo);
    read(arch, p);
    if(existeProducto(arch, codigo))then begin
        seek(arch, filepos(arch)-1);
		write(arch, p);
		p.codigo := (filePos(arch)-1) * -1; 
		seek(arch, 0);
		write(arch, p);
		writeln('Producto eliminado correctamente')
    end
    else
        writeln('El producto no existe');
    close(arch);
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
    crearArchivo(arch);
    agregarProducto(arch);
    quitarProducto(arch);
    imprimirProducto(arch);
end.

