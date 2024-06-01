program ejercicio1;
type
    empleado = record
        dni : integer;
        nombre : string;
        apellido : string;
        edad : integer;
        domicilio : string;
        fechaNacimiento : string;
    end;

    archivo = file of empleado;

procedure leerEmpleado(var e : empleado);
begin
    writeln('Ingrese el DNI del empleado');
    readln(e.dni);
    writeln('Ingrese el nombre del empleado');
    readln(e.nombre);
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
    writeln('Ingrese la edad del empleado');
    readln(e.edad);
    writeln('Ingrese el domicilio del empleado');
    readln(e.domicilio);
    writeln('Ingrese la fecha de nacimiento del empleado');
    readln(e.fechaNacimiento);
end;

procedure agregarEmpleado(var arch : archivo);
var 
    cabecera, e : empleado;
    dni : integer;
begin
    writeln('Ingrese los datos del empleado que desea agregar');
    leerEmpleado(e);
    if(existeEmpleado(arch, e.dni))then
        writeln('El empleado ingresado ya existe')
    else begin
        reset(arch);
        read(arch, cabecera);
        if(cabecera.codigo = 0)then begin
            seek(arch, filepos(arch));
            write(arch, e)
        end
        else begin
            seek(arch, filepos(cabecera) * -1);
            read(arch, cabecera);
            seek(arch, filepos(arch)-1);
            write(arch, e);
            seek(arch, 0);
            write(arch, cabecera);
        end;
        close(arch);
        writeln('El empleado con dni ', e.dni, ' fue agregado con exito');
    end;
end;

procedure quitarEmpleado(var arch : archivo);
var
    cabecera, e : empleado;
    dni : integer;
begin  
    writeln('Ingrese el dni del empleado que desee eliminar');
    readln(dni);
    if(existeEmpleado(arch, e.dni))then begin
        reset(arch);
        read(arch, cabecera);
        read(arch, e);
        while(e.dni <> dni)do
            read(arch, e);
        seek(arch, filepos(arch)-1);
		write(arch, cabecera);
		cabecera.dni := (filePos(arch)-1) * -1; 
		seek(arch, 0);
		write(arch, cabecera);
		close(arch);
		writeln('Empleado eliminado correctamente')
    end
    else 
        writeln('El empleado no existe ');
end;

var
    arch : archivo;
begin
    assign(arch, 'archivoEmpleados');
    agregarEmpleado(arch);
    quitarEmpleado(arch);
end;