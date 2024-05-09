5. Defina los siguientes conceptos:
● Overflow
● Underflow
● Redistribución
● Fusión o concatenación
En los dos últimos casos, ¿cuándo se aplica cada uno?

- Overflow : Es cuando se intenta una alta en un arbol B pero la cantidad de elementos del nodo es igual a la cantidad maxima de elementos. En un arbol B se divide el nodo en 2, la mitad de la izquierda se almacena en un nodo izquierda y en la otra mitad se asciende al elemento mas chico (si existe un nodo arriba, sino se crea un nuevo nodo y pasa a ser la raiz) y los restantes se guardan en un nodo derecho. En el caso de que sea un nodo interno (ni la raiz ni un nodo terminal) queso.

- UnderFlow : Si cuando intentamos eliminar una clave, la cantidad de llaves es menor a [M/2]-1, entonces debe realizarse una redistribución de claves, tanto en el índice como en las páginas hojas. [M/2]-1 es el minimo de elementos que puede haber en un nodo. Si la redistribución no es posible, entonces debe realizarse una fusión entre los nodos.

- Redistribuir : Cuando un nodo tiene underflow puede trasladarse llaves provenientes de un nodo adyacente hermano (en caso que este tenga suficientes elementos). Se aplica cuando un nodo tiene menos de [M/2]-1 elementos y el hermano le puede prestar un elemento que ya que el si tiene suficientes.

- Concatenación o fusión : Si un nodo adyacente hermano está al mínimo (no le sobra ningún elemento) no se puede redistribuir, se concatena con un nodo adyacente disminuyendo el # de nodos (y en algunos casos la altura del árbol). Se aplica cuando un nodo tiene menos de [M/2]-1 elementos y el hermano no le puede prestar un nodo como si fuera redistribucion, entonces se fusionan los nodos y el nodo que sobra se elimina.