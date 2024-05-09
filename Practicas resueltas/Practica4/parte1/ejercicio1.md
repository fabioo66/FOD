- 1. Considere que desea almacenar en un archivo la información correspondiente a los alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza como un árbol B de orden M.
- a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de alumnos como un árbol B de orden M.
- b. Suponga que la estructura de datos que representa una persona (registro de persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512 bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M * B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro (en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa el campo referido a la cantidad de claves. El objetivo es reemplazar estas variables con los valores dados y obtener el valor de M (M debe ser un número entero, ignorar la parte decimal).
- c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la información de los alumnos como un árbol B?
- d. ¿Qué dato seleccionaría como clave de identificación para organizar los elementos (alumnos) en el árbol B? ¿Hay más de una opción?
- e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para encontrar un alumno por su clave de identificación en el peor y en el mejor de los casos? ¿Cuáles serían estos casos?
- f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas lecturas serían necesarias en el peor de los casos?


- a_

```pascal
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

    TNodo = record
        cant_datos : integer;
        datos : array[1..M-1] of alumnos;
        hijos : array[1..M] of integer;
    end;

    arbolB = file of TNodo;

--------------------------------------------

var
    archivoDatos : arbolB;
```

- b_ La cantidad de registros que entran en cada nodo son 7. **CUENTA** : 
TNodo = record
    cant_datos : integer; // Ocupa 4 bytes
    datos : array[1..M-1] of persona; // Ocupa 7*64 bytes
    hijos : array[1..M] of integer; // Ocupa 8*4 Bytes
end;
**Conclusion** : 512 - ((7*64) + (8*4) + 4) = 28 ---> Por lo tanto entra 7 registros persona.

fórmula N = (M-1) * A + M * B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro (en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa el campo referido a la cantidad de claves 
N = (M-1) * 64 + M * 4 + 4 
512 = 64M - 64 + 4M + 4 
512 = 64M + 4M - 64 + 4
512 = 68M - 60
512 = 68M - 60 
68M = 512 + 60
68M = 572
M = 572/68
M = 8 // M = 8.4

- c_ Va impactar en la estructura del arbol B : en la cantidad maxima de elementos que contendra un nodo y la altura del arbol.

- d_ El dato que usaria como clave seria el numero de legajo ya que es el que ocupa menos bytes y no se repite. Tambien se podria usar DNI.

- e_ El mejor de los casos seria que el alumno se encuentre en la raiz = 1 lectura.
El peor de los casos es cuando el alumno se encuentre en los nodos terminales = 1 lectura * altura del arbol.

- f_ Ocurre que no estariamos aprovechando el ordenamiento del arbol, y en el peor de los casos leeriamos n veces, n = cantidad de nodos del arbol.