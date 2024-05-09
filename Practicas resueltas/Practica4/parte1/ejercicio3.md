3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
considere que por un lado se tiene el archivo que contiene la información de los
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
siguientes incisos:
    a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?
    b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
qué?
    c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño
    d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
específico haciendo uso de la estructura auxiliar (índice) que se organiza como
un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
estructurado como un árbol B?
    e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?

a_ En un arbolB+ las claves se encuentran en los nodos terminales, y en los nodos internos se encuentran copias de estos
para poder mantener el orden del arbol.

b_ Los nodos hojas contienen todos las claves del arbol y ademas nos permiten recorrer el arbol de forma secuencial.

c_ Consultar.

d_ Lee un nodo, compara el dni con cada uno del vector de dnis del nodo, y va a seguir la busqueda con el indice que este
entre un dni menor y un dni mayor al de la busqueda. Si encuentra el dni, debe chequear que sea un nodo terminal, si lo es
debe tomar la posicion donde se encuentra en el vector de dnis, usar esa posicion en el vector de enlaces, y con ese enlace,
acceder al archivo de alumnos que esta desordenado. Si no es un nodo terminal debe continuar la busqueda.
La diferencia que se encuentra respecto a la búsqueda en un índice estructurado como un árbol B, es que en el arbolB+
podemos encontrar el dni, pero debemos seguir la busqueda hasta un nodo terminal, ya que los valores en nodos internos son
copias.

e_ Consultar.