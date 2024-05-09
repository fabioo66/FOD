2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.
    a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.
    b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.
    c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
    d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.
    e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?
    f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?

a_
``` pascal
const 
    M = ..; // orden del arbol
type
    alumnos = record
        nombre : string;
        apellido : string;
        DNI : integer;
        legajo : integer;
        anio : integer;
    end;
    archivo_alumnos = file of alumnos;

    TNodo = record
        cant_dnis : integer;
        dnis: array[1..M-1] of integer;
        enlaces : array[1..M-1] of integer;
        hijos : array[1..M] of integer;
    end;

    archivo_alumnos = file of alumnos;
    arbolB = file of TNodo;

var
    archivoAlumnos: archivo_alumnos;
    archivoIndice: arbolB;
```

b_ 
TNodo = record
    cant_dnis : integer; // C
    dnis: array[1..M-1] of integer; // (M-1) * A
    enlaces : array[1..M-1] of integer; // (M-1) * A
    hijos : array[1..M] of integer; // M * B
end;

fórmula N = (M-1) * A + (M-1) * A + M * B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un integer, B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa el campo referido a la cantidad de claves (A, B y C van a valer 4).
512 = (M-1)*4 + (M-1)*4 + M*4 + 4
512 = 4M - 4 + 4M - 4 + 4M + 4
512 = 12M - 4
516 = 12M
516/12 = M
43 = M

c_ Implica que vamos a poder acceder a mas registros con muchisimas menos lecturas de nodos, ya que en un solo nodo
tenemos 42 indices a registros alumnos, y en el arbolB del ejercicio 1 en un nodo solo teniamos 7 registros alumnos, por lo 
que en cada busqueda, estariamos realizando mas lecturas para encontrar un alumno.

d_ Deberiamos abrir el archivo del arbolB, buscar el dni, si lo encuentra usar la posicion donde se encuentra en el vector de dnis
para posicionarte en el vector de enlaces y usar ese enlace, para acceder a la posicion del archivo de alumnos y leer el registro. 
Antes de eso habria que abrir el archivo de alumnos.

e_ Tendriamos que recorrer el archivo de alumnos desordenado hasta que encontremos el legajo adecuado. Al no estar ordenado este archivo
la busqueda seria muy ineficiente.
No tiene sentido por que este archivo indice tiene el criterio de ordenacion por dni.
Crearia un nuevo arbolB, con la misma idea que el arbolB ordenado por dni, pero ordenandolo por numero de legajo. Asi tendriamos enlaces
correspondientes al numero de legajo de cada alumno.

f_ Consultar.