4. Dado el siguiente algoritmo de búsqueda en un árbol B:

``` pascal
procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado);
var 
    clave_encontrada: boolean;
begin
    if (nodo = null) then 
        resultado := false; // clave no encontrada
    else
        posicionarYLeerNodo(A, nodo, NRR);
        claveEncontrada(A, nodo, clave, pos, clave_encontrada);
        if (clave_encontrada) then begin
            NRR_encontrado := NRR; // NRR actual 
            pos_encontrada := pos; // posicion dentro del array 
            resultado := true;
        end
        else
            buscar(nodo.hijos[pos], clave, NRR_encontrado,pos_encontrada, resultado) 
end;
```

Asuma que para la primera llamada, el parámetro NRR contiene la posición de la raíz
del árbol. Responda detalladamente 
a. PosicionarYLeerNodo(): Indique qué hace y la forma en que deben ser
enviados los parámetros (valor o referencia). Implemente este módulo en Pascal.
b. claveEncontrada(): Indique qué hace y la forma en que deben ser enviados los
parámetros (valor o referencia). ¿Cómo lo implementaría?
c. ¿Existe algún error en este código? En caso afirmativo, modifique lo que
considere necesario.
d. ¿Qué cambios son necesarios en el procedimiento de búsqueda implementado
sobre un árbol B para que funcione en un árbol B+?

a_ La funcion de 'PosicionarYLeerNodo(A, nodo, NRR);' 
```pascal
procedure PosicionarYLeerNodo(A, nodo, NRR);
var
begin
end;
```

