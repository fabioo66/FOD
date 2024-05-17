## Resumen orientado a la practica de FOD

### Practica 1 introduccion a archivos 


#### Declaracion 
```pascal
type
    archivoNumeros = file of integer;

var
    arch : archivoNumeros;
begin
    // nombre_fisico = ruta donde se encuentra el archivo
    assign(arch, nombre_fisico);
```

#### Operaciones de apertura y cierre
```pascal
    // Crea un archivo, si existe, lo sobreescribe
    rewrite(nombre_logico);
    // Abre un archivo existente
    reset(nombre_logico);
    // Cierra el archivo. Transfiere los datos del buffer al disco
    close(nombre_logico);
```

#### Lectura y escritura de archivos
```pascal
    // Lee el archivo
    read(nombre_logico, var_dato);
    // Escribe el archivo
    write(nombre_logico, var_dato);
    // Por cada lectura y escritura se mueve el puntero a la siguiente posicion
```

#### Operaciones adicionales 
```pascal
    // Controla el fin de archivo
    EOF(nombre_logico);
    // Devuelve el tamaño de un archivo
    fileSize(nombre_logico);
    // Devuelve la posición actual del puntero en el archivo
    filePos(nombre_logico);
    // Establece la posición del puntero en el archivo
    seek(nombre_logico, pos);
```

### Archivos de texto
Se utilizan para visualizar los datos de una forma mas clara y legible. 
#### Importacion
```pascal
// Si leo un campo de tipo string debo leerlo a lo ultimo. Si tengo mas de un dato de tipo string
// debo leer el campo en otra linea
procedure importarMaestro(var mae : maestro);
var
	txt : text;
	regM : log;
begin
	assign(mae, 'maestro.dat');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regM.numUsuario, regM.cantEmails, regM.nombreUsuario);
		readln(txt, regM.nombre);
		readln(txt, regM.apellido);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
end;
```

#### Exportacion
```pascal
procedure exportarATxt(var mae : maestro);
var
	txt : text;
	regM : log;
begin
	assign(txt, 'logs.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM); 
		writeln(txt, regM.numUsuario, ' ', regM.cantEmails);
	end;	
	close(mae);
	close(txt);		
end;
```

### Practica 2 maestro detalle y corte de control

#### Archivo maestro: 
- Resume información sobre el dominio de un problema específico. Ejemplo: El archivo de productos de una empresa.
#### Archivo detalle: 
- Contiene movimientos realizados sobre la información almacenada en el maestro. Ejemplo: archivo conteniendo las ventas sobre esos productos.

#### Precondiciones 
- Existe un archivo maestro.
- Existe un único archivo detalle que modifica al maestro.
- Cada registro del detalle modifica a un registro del maestro que seguro existe.
- No todos los registros del maestro son necesariamente modificados. 
- Cada elemento del archivo maestro puede no ser modificado, o ser modificado por uno o más elementos del detalle.
- Ambos archivos están ordenados por igual criterio.

##### Ejemplo
```pascal
procedure leer(var det: detalle; var regD : venta);
begin
    if(not eof(det))then 
        read(det, regD)
    else 
		regD.codigo := valoralto;
end;

procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
	regD : venta; //registro detalle
	cantTotal, codigo : integer;
	regM : producto; //registro maestro
begin
	reset(mae);
	reset(det);
	read(mae, regM); //leo maestro
	leer(det, regD); //leo detalle
	while(regD.codigo <> valorAlto)do begin
		codigo := regD.codigo;
		cantTotal := 0;
		while(regD.codigo = codigo) do begin
			cantTotal := cantTotal + regD. cantUnidades;
			leer(det, regD);
		end;
		while(regM.codigo <> codigo)do
			read(mae, regM);
 		regM.stockActual := regM.stockActual - cantTotal;
 		seek(mae, filepos(mae)-1);
  		write(mae, regM);
  		if(not eof(mae))then 
   			read(mae, regM);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det);
end;
```

#### Merge
Proceso mediante el cual se genera un nuevo archivo a partir de otros archivos existentes.

#### Precondiciones 
- Existe un archivo maestro.
- Existen dos o tres archivos detalles
- Cada registro del detalle modifica a un registro del maestro que seguro existe.
- No todos los registros del maestro son necesariamente modificados. 
- Cada elemento del archivo maestro puede no ser modificado, o ser modificado por uno o más elementos del detalle.
- Ambos archivos están ordenados por igual criterio.

##### Ejemplo
```pascal
procedure leer(var det : detalle; var regD : archivoDetalle);
begin
	if(not eof(det))then
		read(det, regD)
	else
		regD.provincia := valorAlto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min : archivoDetalle);
begin
	if(r1.provincia <= r2.provincia)then begin
		min:= r1;
        leer(det1, r1)
    end
    else begin
		min:= r2;
        leer(det2, r2);
    end;
end; 

procedure actualizarMaestro(var mae : maestro; var det1, det2 : detalle);
var
	regD1, regD2, min : archivoDetalle;
	regM : archivoMaestro;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, regD1);
	leer(det2, regD2);
	minimo(det1, det2, regD1, regD2, min);
	while(min.provincia <> valorAlto)do begin
		read(mae, regM);
		while(regM.provincia <> min.provincia)do
			read(mae, regM);
		while(regM.provincia = min.provincia)do begin
			regM.cantPersonas := regM.cantPersonas + min.cantPersonas;
			regM.totalPersonas := regM.totalPersonas + min.totalPersonas;
			minimo(det1, det2, regD1, regD2, min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regM);
	end;
	writeln('Maestro actualizado');
	close(mae);
	close(det1);
	close(det2);
end;
```

#### Merge con 4 o mas archivos detalles 
```pascal
program ejercicio15;
const
	valorAlto = 'ZZZZ';
	dimf = 3; // = 100;
type
	rango = 1..dimf;
	
	emision = record
		fecha : string;
		codigo : integer;
		nombre : string;
		descripcion : string;
		precio : real;
		total : integer;
		totalVendidos : integer;
	end;
	
	venta = record
		fecha : string;
		codigo : integer;
		cant : integer;
	end;
	
	maestro = file of emision;
	detalle = file of venta;
	
	vectorD = array[rango]of detalle;
	vectorR = array[rango]of venta;

procedure leer(var det: detalle; var regD: venta);
begin
    if not eof(det) then
        read(det, regD)
    else 
        regD.fecha := valorAlto;
end;

procedure minimo(var vd : vectorD; var vr : vectorR; var min : venta);
var
	i : rango;
	pos : integer;
begin
	min.fecha := valorAlto;
	for i := 1 to dimf do begin
		if(vr[i].fecha <= min.fecha)then begin
			min := vr[i];
			pos := i;
		end;
	end;
	if(min.fecha <> valorAlto)then
		leer(vd[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorD);
var
	regM : emision;
	vr : vectorR;
	min, dato : venta;
	i : rango;
	fechaMin, fechaMax : string;
	codigoMin, codigoMax, max1, min1, totalVentas : integer;
begin
	max1 := -1;
	min1 := 9999;
	reset(mae);
	read(mae, regM);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	minimo(vd, vr, min);
	while(min.fecha <> valorAlto)do begin
		dato.fecha := min.fecha;
		while(dato.fecha = min.fecha)do begin
			dato.codigo := min.codigo;
		totalVentas := 0;
			while(dato.fecha = min.fecha) and (dato.codigo = min.codigo)do begin
				regM.totalVendidos := regM.totalVendidos + min.cant;
				regM.total := regM.total - min.cant;
				totalVentas := totalVentas + min.cant;
				minimo(vd, vr, min);
			end;
			if(totalVentas > max1)then begin
				max1 := totalVentas;
				fechaMax := regM.fecha;
				codigoMax := regM.codigo
			end
			else if(totalVentas < min1)then begin
				min1:= totalVentas;
				fechaMin := regM.fecha;
				codigoMin := regM.codigo;
			end;
			while(regM.fecha <> dato.fecha)do begin
				read(mae, regM);
			end;
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			if(not eof(mae))then
				read(mae, regM);
		end;
	end;
	close(mae);
	writeln('El semanario con mas ventas es ', fechaMax, ' ', codigoMax);
	writeln('El semanario con menos ventas es ', fechaMin, ' ', codigoMin);
	writeln('Archivo maestro actualizado');
	for i := 1 to dimf do
		close(vd[i]);
end;
```

##### Ejemplo con 3 criterios de ordenacion (destino, fecha, hora de salida)
```pascal
procedure leer(var det : detalle; var regD : info);
begin
	if (not eof(det)) then
		read(det, regD)
	else 
		regD.destino := valorAlto;
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min : info);
begin
	if(r1.destino < r2.destino)then begin
		min := r1;
        leer(det1, r1)
    end
    else begin
		min := r2;
        leer(det2, r2);
    end;
end; 

procedure actualizarMaestro(var mae : maestro; var det1, det2 : detalle);
var
	r1, r2, min : info;
	regM : vuelo;
	cant : integer;
begin
	writeln('Ingrese una cantidad de asientos disponibles ');
	readln(cant);
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, r1);
	leer(det2, r2);
	minimo(det1, det2, r1, r2, min);
	while(min.destino <> valorAlto)do begin
		read(mae, regM);
		while(min.destino <> regM.destino)do 
			read(mae, regM);
		while(min.destino = regM.destino)do begin
			while(regM.fecha <> min.fecha)do
				read(mae, regM);
			while(regM.destino = min.destino) and (regM.fecha = min.fecha)do begin
				while(regM.hora <> min.hora)do
					read(mae, regM);
				while(min.destino = regM.destino) and (min.fecha = regM.fecha) and(min.hora = regM.hora)do begin
					regM.cantAsientos:= regM.cantAsientos - min.cantAsientosVendidos;
					minimo(det1, det2, r1, r2, min);
				end;
				if(regM.cantAsientos < cant)then
					writeln('Destino ', regM.destino, ' fecha ', regM.fecha, ' hora de salida ', regM.hora);
				seek(mae, filepos(mae)-1);
				write(mae, regM);
			end;
		end;
	end;
	writeln('Archivo maestro actualizado');
	close(mae);
	close(det1);
	close(det2);
end;
```

#### Corte de control 
Proceso mediante el cual la información de un archivo es presentada en forma organizada de acuerdo a la estructura que posee el archivo.

##### Ejemplo
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad              Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad

```pascal
procedure corteDeControl(var mae: maestro);
var
    prov, actual: provincia;
    total, totalProvincia, totalLocalidad, provActual, localidadActual: integer;
begin
    reset(mae);
    leer(mae, prov);
    total:= 0;
    while(prov.codProv <> valoralto) do begin
        writeln();
        writeln('CodigoProv: ', prov.codProv);
        totalProvincia:= 0;
        provActual:= prov.codProv;
        while(provActual = prov.codProv) do begin //Misma provincia
            writeln('CodigoLocalidad           Total de Votos');
            localidadActual:= prov.codLocalidad;
            totalLocalidad:= 0;
            while((provActual = prov.codProv) and (localidadActual = prov.codLocalidad)) do begin //Misma localidad
                totalLocalidad:= totalLocalidad + prov.cantVotos;
                leer(mae, prov);
            end;
            writeln(localidadActual, '                             ', totalLocalidad);
            totalProvincia:= totalProvincia + totalLocalidad;
        end;
        writeln('Total de votos Provincia: ', totalProvincia);
        total:= total + totalProvincia;
    end;
    writeln();
    writeln('Total General de Votos: ', total);
    close(mae);
end;
```

### Practica 3 bajas y archivos desordenados 
Se denomina proceso de baja a aquel proceso que permite quitar información de un archivo.
El proceso de baja puede llevarse a cabo de dos modos diferentes:

#### Baja física
- Consiste en borrar efectivamente la información del archivo, recuperando el espacio físico.
Se realiza baja física sobre un archivo cuando un elemento es efectivamente quitado del archivo, decrementando en uno la cantidad de elementos. 
##### Ventaja: 
- En todo momento, se administra un archivo de datos que ocupa el lugar mínimo necesario. 
##### Desventaja: 
- Performance de los algoritmos que implementan esta solución.

##### Tecnicas de baja fisica 
- Generar un nuevo archivo con los elementos válidos. Sin copiar los que se desea eliminar
- Utilizar el mismo archivo de datos, generando los reacomodamientos que sean necesarios. (Solo para archivos sin ordenar)

##### Ejemplo 
```pascal
procedure buscarEmpleado(var emp : archivo; numero : integer; var pos : integer; var encontre : boolean);
var
	e : empleado;
begin
	reset(emp);
	encontre:= false;
	while(not eof(emp))and(not encontre)do begin
		read(emp, e);
		if(e.numero = numero)then
			encontre:= true;
			pos := filepos(emp)-1;
	end;
	close(emp);
end;

procedure eliminarEmpleado(var emp : archivo);
var
	numero, pos : integer;
	e : empleado;
	encontre : boolean;
begin
	writeln('Ingrese el numero de empleado del empleado que desea eliminar ');
	readln(numero);
	buscarEmpleado(emp, numero, pos, encontre);
	if (encontre)then begin
		reset(emp);
		seek(emp, filesize(emp)-1);
		read(emp, e);
		seek(emp, pos);
		write(emp, e);
		seek(emp, filesize(emp)-1);
		truncate(emp);
		close(emp);
		writeln('Se ha eliminado el empleado correctamente');
	end
	else
		writeln('El empleado ingresado no existe');
end;
```

#### Baja lógica
- Consiste en borrar la información del archivo, pero sin recuperar el espacio físico respectivo. 

##### Ejemplo 
```pascal
procedure eliminarAsistentes(var arch : archivo);
var
  a : asistente;
begin
  writeln('¡Se eliminaran logicamente todos los asistentes con el numero de asistente inferior a 1000 ');
  writeln('El borrado se realizará agregando "@" al principio del email');
  reset(arch);
  while (not eof(arch)) do 
  begin
    read(arch, a);
    if (a.num < 1000) then 
    begin
      a.email := '@' + a.email;
      seek(arch, filepos(arch)-1);
      write(arch, a);
    end;
  end;
  writeln('Los borrados se han efectuado correctamente');
end;
```

#### Tecnicas
- Recuperación de espacio: Se utiliza el proceso de baja física periódicamente para realizar un proceso de compactación del archivo. Quita los registros marcados como eliminados, utilizando cualquiera de los algoritmos vistos para baja física.

- Reasignación de espacio:  Recupera el espacio utilizando los lugares indicados como eliminados para el ingreso de nuevos elementos al archivo (altas).

#### Lista invertida
Proceso por el cual se realizan altas y bajas logicas. La primer posicion del archivo indica si hay espacio disponible en el archivo. Se inicializa en 0, y, por cada vez que se elimina un registro, se guarda en la cabecera la posicion del registro donde se realizo el borrado logico, de forma negativa. Para realizar una alta, si la cabecera es igual a 0, no hay espacio, se agrega al final del archivo. Si la cabecera es distinta de 0, multiplico por -1 y me posiciono para realizar la alta.

##### Ejemplo
Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida. Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:
- a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si la distribución existe en el archivo o falso en caso contrario.
- b. AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.
- c. BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir se debe informar “Distribución no existente”.

```pascal
program ejercicio8;
type 
    distro = record
        nombre : string;
        anio : integer;
        version : string;
        cantDesarrolladores : integer;
        descripcion : string;
    end;
    
    archivo = file of distro;

function existeDistribucion(var arch : archivo; nombre : string) : boolean;
var
    d : distro;
    encontre : boolean;
begin
    encontre := false;
    while(not eof(arch) and not encontre)do begin
        read(arch, d);
        if(d.nombre = nombre)then
            encontre := true;
    end;
	existeDistribucion := encontre;
end;

procedure altaDistribucion(var arch : archivo);
var
    d, aux : distro;
begin
	writeln('Ingrese los datos de la distribucion que desea agregar');
    reset(arch);
    leerDistro(aux);
    if(existeDistribucion(arch, aux.nombre))then 
        writeln('Ya existe la distribucion')
    else begin
		seek(arch, 0);
		read(arch, d);
		if(d.anio = 0)then begin 
			seek(arch, filepos(arch));
			write(arch, aux)
		end
		else begin
			seek(arch, d.anio *-1);
			read(arch, d);
			seek(arch, filepos(arch)-1);
			write(arch, aux);
			seek(arch, 0);
			write(arch, d);
		end;
		writeln('Se agrego una distribucion de linux correctamente');
	end;
	close(arch);
end;

procedure bajaDistribucion(var arch : archivo);
var
	aux : distro;
	nombre : string;
begin
	reset(arch);
	writeln('Ingrese el nombre de la distribucion que desea eliminar');
	readln(nombre);
	read(arch, aux);
	if(existeDistribucion(arch, nombre))then begin
		seek(arch, filepos(arch)-1);
		write(arch, aux);
		aux.anio := (filePos(arch)-1) * -1; 
		seek(arch, 0);
		write(arch, aux);
		writeln('Distribucion eliminada correctamente')
	end
	else
		writeln('No se encontro la distribucion');
	close(arch);
end;
```

### Archivos no ordenados
Forma bastante ineficiente de actualizar datos, debido a la gran cantidad de recorridos que debemos realizar por busqueda.

##### Ejemplo un maestro y un detalle
```pascal
procedure actualizarMaestro(var mae : maestro; var det : detalle);
var
    regM : regMaestro;
    regD : regDetalle;
    encontre: boolean;
begin
    reset(mae);
    reset(det);
    encontre := false;
    while (not eof(det)) do begin
        read(det, regD);
        encontre := false;
        seek(mae, 0);
        while (not eof(mae)) and (not encontre) do begin
            read(mae, regM);
            if (regM.codigo = regD.codigo) then begin
                encontre := true;
                regM.stockActual := regM.stockActual - regD.cantVendidas;
                seek(mae, filepos(mae)-1);
                write(mae, regM);
            end;
        end;
    end;
    writeln('Maestro actualizado');
    close(mae);
    close(det);
end;
```

##### Ejemplo 2 creando una estructura auxiliar
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
La información en el archivo no está ordenada por ningún criterio.
Trate de resolver el problema sin modificar el contenido del archivo dado.
Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.

```pascal
procedure crearAuxiliar(var mae : archivo; var auxArch : archivo; var cantTotal : integer);
var
    l, aux : localidad;
    encontre: boolean;
begin
    cantTotal := 0;
    reset(mae);
    assign(auxArch, 'Archivo_auxiliar');
    rewrite(auxArch);
    while (not eof(mae)) do begin
        read(mae, l);
        encontre := false;
        seek(auxArch, 0);
        while (not eof(auxArch)) and (not encontre) do begin
            read(auxArch, aux);
            if (l.codigo = aux.codigo) then 
                encontre := true;
        end;
        if(encontre) then begin
            aux.cant:= aux.cant + l.cant;
            seek(auxArch, filepos(auxArch)-1);
            write(auxArch, aux);
        end
        else
            write(auxArch, l);
        cantTotal:= cantTotal + l.cant;
    end;
    close(mae);
    close(auxArch);
end;
```

##### Ejemplo 3 cinco detalles y creacion de maestro
```pascal
procedure crearMaestro(var mae : archivo; vd : vectorD);
var
    d, regM : data;
    encontre : boolean;
    i : integer;
begin
    assign(mae, 'ArchivoMaestro');
    rewrite(mae);
    for i := 1 to dimf do begin 
        reset(vd[i]);
        while(not eof(vd[i]))do begin
            seek(mae, 0);
            read(vd[i], d);
            encontre := false;
            while((not eof(mae)) and (not encontre))do begin
                read(mae, regM);
                if(d.codigo = regM.codigo)then
                    encontre := true;
            end;
            if(encontre)then begin 
                regM.tiempo := regM.tiempo + d.tiempo;
                seek(mae, filepos(mae)-1);
                write(mae, regM);
            end
            else
                write(mae, d);
        end;
        close(vd[i]);
    end;
    close(mae);
    writeln('Archivo maestro creado');
end;
```

### Practica 4 arboles B
Los árboles B son árboles multicamino con una construcción especial de árboles que permite mantenerlos balanceados a bajo costo.

#### Propiedades de un arbol B
- Cada nodo del árbol puede contener como máximo M descendientes directos (hijos) y M-1 elementos.
- La raíz no posee descendientes directos o tiene al menos dos.
- Un nodo con X descendientes directos contiene X-1 elementos.
- Todos los nodos (salvo la raíz) tienen como mínimo [M/2] – 1 elementos y como máximo M-1 elementos.
- Todos los nodos terminales se encuentran al mismo nivel.

#### Detalles a tener en cuenta al realizar altas y bajas

### Altas
- Se agregan las claves de forma ordenada siempre y cuando la cantidad de elementos sea menor a la cantidad maxima, sino se produce overflow.

### Overflow en arboles B
- Se crea un nuevo nodo.
- La primera mitad de las claves se mantiene en el nodo con overflow.
- La segunda mitad de las claves se traslada al nuevo nodo.
- La menor de las claves de la segunda mitad se promociona al nodo padre.

##### Ejemplo
-Dado un arbol de orden 4 se quiere agregar la clave 23

						0: (23)(65)(89)

-No es posible ya que la cantidad de nodos es igual al maximo. Por lo tanto se produce overflow.

						2: 0 (65) 1

                0: (23)(45)         1: (89)

-Realizamos la division de los nodos y promocionamos la menor clave de la segunda mitad (65).

### Bajas
- Si la clave a eliminar no está en una hoja, se debe reemplazar con la menor clave del subárbol derecho.
- Si el nodo hoja contiene por lo menos el mínimo número de claves, luego de la eliminación, no se requiere ninguna acción adicional.
- En caso contrario, se debe tratar el underflow.

### Underflow en arboles B
- Primero se intenta redistribuir con un hermano adyacente. La redistribución es un proceso mediante el cual se trata de dejar cada nodo lo más equitativamente cargado posible. 
- Si la redistribución no es posible, entonces se debe fusionar con el hermano adyacente.

#### Politicas de underflow (vale para arboles B y B+)
##### Política izquierda: 
se intenta redistribuir con el hermano adyacente izquierdo, si no es posible, se fusiona con hermano adyacente izquierdo.
##### Política derecha: 
se intenta redistribuir con el hermano adyacente derecho, si no es posible, se fusiona con hermano adyacente derecho.
##### Política izquierda o derecha: 
se intenta redistribuir con el hermano adyacente izquierdo, si no es posible,  se intenta con el hermano adyacente derecho, si tampoco es posible, se fusiona con hermano adyacente izquierdo.
##### Política derecha o izquierda: 
se intenta redistribuir con el hermano adyacente derecho, si no es posible,  se intenta con el hermano adyacente izquierdo, si tampoco es posible, se fusiona con hermano adyacente derecho.

##### Ejemplo de redistribucion y fusion (politica derecha)
**Arbol inicial**:

    	        	      7: 2 (96) 6

    	        2: 0 (55) 3 (75) 4     6: 1 (120) 5

    0: (20)(25)  3: (65)(70)(73)  4: (89)   1: (100)(110)   5: (130)

------------------------------------------------------------------------------------------------------
-120

                          7: 2 (96) 6

                2: 0 (55) 3 (75) 4     6: 1 (110) 5

    0: (20)(25)  3: (65)(70)(73)  4: (89)   1: (100)   5: (130)

- Reemplazo la clave 120 con la menor clave de su subarbol derecho. 
- Como esta queda en underflow, redistribuyo con el hermano izquierda.

------------------------------------------------------------------------------------------------------
-110

                    7: 2 (75) 6

               2: 0 (55) 3      6: 4 (96) 1

    0: (20)(25)  3: (65)(70)(73)  4: (89)   1: (100)(130)

L7, L6, E5, E6, L1, E1, L2, E2, E6, E7

- Reemplazo la clave 110 por la menor clave de su subarbol derecho.
- Como este queda en underflow y no puedo redistribuir, fusiono con el hermano izquierdo.
- Esta funcion me propaga un underflow en el nodo 6. Redistribuyo con el hermano izquierdo.

**Muchisimos mas ejemplos [here](https://github.com/fabioo66/FOD/tree/main/Practicas%20resueltas/Practica4/parte2)**

### Arboles B+
- Constituyen una mejora sobre los árboles B, pues conservan la propiedad de acceso aleatorio rápido y permiten además un recorrido secuencial rápido. 
- Conjunto índice: Proporciona acceso indizado a los registros. Todas las claves se encuentran en las hojas, duplicándose en la raíz y nodos interiores aquellas que resulten necesarias para definir los caminos de búsqueda.
- Conjunto secuencia: Contiene todos los registros del archivo. Las hojas se vinculan para facilitar el recorrido secuencial rápido. Cuando se lee en orden lógico, lista todos los registros por el orden de la clave.
 
#### Busqueda en arboles B+
- La operación de búsqueda en árboles B+ es similar a la operación de búsqueda en árboles B. El proceso es simple, sin embargo ya que todas las claves se encuentran en las hojas, deberá continuarse con la búsqueda hasta el último nivel del árbol.

#### Overflow en arboles B+
- Si en el nodo donde debemos agregar una clave esta lleno, seguimos el mismo procedimiento que en arboles B con la unica diferencia que promocionamos una copia, la clave se almacena en la mitad de la derecha luego de la division.
- Si se propaga otro overflow a los nodos internos, mismo procedimiento que arboles B

##### Ejemplo arbol B+ de orden 4

                       4: 0 (340) 1 (400) 2 (500) 3

0: (11)(50)(77) 1    1: (340)(350)(360) 2   2: (402)(410)(420) 3   3: (520)(530) -1

--------------------------------------------------------------------------------------------------
+80

                                    7: (400)

                       4: 0 (77) 5 (340) 1    6: 2 (500) 3

0: (11)(50) 1   5: (77)(80) 1    1: (340)(350)(360) 2   2: (402)(410)(420) 3   3: (520)(530) -1

L4, L0, E0, E5, E4, E6, E7
                                                                       |
- Intento agregar la clave 80 en el nodo 0. Como hay overflow [11][50] 77 [77][80]. Como es una hoja guardo el valor en el 
nuevo nodo creado (5) y promociono una copia.         |
- Cuando promociono la copia, overflow --> [77][340] 400 [500]. Como es un nodo interno promociono el 400 y creo un nuevo nodo.

#### Underflow en arboles B+
- Igual que en arboles B, solamente que no podemos bajar los padres de las hojas ya que son nodos internos.
- Cuando redistribuimos, sino nos sirve mas el separador, lo reemplazamos.
- En la fusion, borramos un padre. Si se produce underflow, redistribuimos o fusionamos.

##### Ejemplo arbol B+ de orden 4

                                        7: 2 (67) 6

                           2: 0 (22) 5 (45) 4       6:  1 (89) 3

           0: (15)(19) 5    5: (22)(23) 4   4: (66) 1    1: (67)(70) 3   3: (89)(110)(120) -1

--------------------------------------------------------------------------------------------------
-66

                                        7: 2 (67) 6

                           2: 0 (22) 5 (23) 4       6:  1 (89) 3

           0: (15)(19) 5    5: (22) 4   4: (23) 1    1: (67)(70) 3   3: (89)(110)(120) -1

L7, L2, L4, L5, E4, E5, E2 

- Intento eliminar la clave 66 del nodo 4, como hay underflow, reedistribuyo con el hermano izquierda.
     |
[22] 23 [23]. Promociono el 23 y reemplazo el separador 45 que no me sirve mas.

--------------------------------------------------------------------------------------------------
-22

                                        7: 2 (67) 6

                             2: 0 (23) 5       6:  1 (89) 3

           0: (15)(19) 5    5: (23) 1    1: (67)(70) 3   3: (89)(110)(120) -1

L7, L2, L5, L4, E4, E5, E2

- Intento eliminar la clave 22 del nodo 5, como no puedo porque hay underflow, intento redistribuir.
Como tampoco puedo redistribuir, fusiono con el hermano derecho. 

**Muchisimos mas ejemplos [here](https://github.com/fabioo66/FOD/tree/main/Practicas%20resueltas/Practica4/parte2)**

##### Observaciones
- Cada vez que pasamos por un nodo se cuenta como una lectura. Si ya leimos ese nodo, no sumamos la siguiente lectura.
- Cada vez que eliminamos un nodo, sumamos una escritura.
- Cuando fusioono un nodo, **SIEMPRE** se elimina el nodo de la derecha.
- Orden de las escrituras: de abajo para arriba de izquierda a derecha. 





