# Functional-Programming---Lisp-k-means
Lisp implementation of k-means algorithm

Aziani Riccardo 866037

E4P - k-medie

FUNZIONE vplus/2
Calcola la somma (vettoriale) di due vettori. Fa un controllo per verificare che i parametri che gli sono passati siano due vettori di lunghezza uguale, per poi chiamare la funzione vplus-aux.

vplus-aux/2
Implementa la somma tra due vettori. Crea una lista mettendo in testa la somma tra i due elementi in testa alle liste v1 e v2, e poi fa una chiamata ricorsiva sulle code.


FUNZIONE vminus/2
Calcola la differenza (vettoriale) di due vettori. Fa un controllo per verificare che i parametri che gli sono passati siano due vettori di lunghezza uguale, per poi chiamare la funzione vminus-aux.

vminus-aux/2
Implementa la differenza tra due vettori. Crea una lista mettendo in testa la differenza tra i due elementi in testa alle liste v1 e v2, e poi fa una chiamata ricorsiva sulle code.


FUNZIONE innerprod/2
Calcola il prodotto interno (vettoriale) di due vettori; ritorna uno scalare. Fa un controllo per verificare che i parametri che gli sono passati siano due vettori di lunghezza uguale, per poi chiamare la funzione innerprod-aux.

innerprod-aux/2
Implementa il prodotto interno tra due vettori. Somma il prodotto tra i due elementi in testa ai due vettori e poi fa una chiamata ricorsiva sulle code.


FUNZIONE norm/1
Calcola la norma euclidea di un vettore.


FUNZIONE centroid/1
Ritorna il centroide dell'insieme di osservazioni che gli sono passate. Viene implementata calcolando la media dei vettori che compongono la lista di osservazioni.

centroid-aux/2
Costruisce il vettore che corrisponde al somma di tutti vettori delle osservazioni iniziali.

get-values/2
Prende il vettore restituito da centroid-aux e lo divide per il parametro n passato in input, restituendo quindi il centroide.


FUNZIONE kmeans/2
Partiziona le osservazioni in k clusters. Fa una serie di controlli per verificare che i parametri che gli sono passati siano corretti e poi chiama kmeans-aux, passando come centroidi dei centroidi scelti casualmente tramite generate-cs, come clus1 una lista vuota e come clus2 la lista ottenuta con generate-clus passandogli i centroidi appena calcolati.

kmeans-aux/4
Implementa l'algoritmo delle k-medie. Prende in input la lista di osservazioni, i centroidi, un primo cluster 'clus1' e un secondo cluster 'clus2'. 
Se i due cluster sono uguali, allora l'algoritmo termina; altrimenti, vengono ricalcolati i centroidi di new-clus1, viene calcolato new-clus2 chiamando la funzione partition sulle osservazioni, i nuovi centroidi e la lista ottenuta con generate-clus passandogli i nuovi centroidi; infine viene fatta una chiamata ricorsiva con i nuovi valori calcolati.


FUNZIONI DI SUPPORTO

is-vector/1
Ritorna T se gli viene passato un vettore, nil altrimenti.


check-obs/1
Ritorna T se gli vengono passate delle osservazioni rappresentate in modo corretto, NIL altrimenti.


distance/2
Calcola la distanza tra due vettori.


generate-cs/2
Prende in input una lista di osservazioni e un intero k; genera i centroidi selezionando casualmente k vettori dalle osservazioni.


partition/3
Divide le osservazioni nei rispettivi cluster.
Prende il vettore in testa, viene calcolata la distanza minima dai centroidi; poi tramite la funzione insert-v viene inserito in coda al centroide (parametro clus) la cui distanza corrisponde a quella minima; poi viene fatta una chiamata ricorsiva sul resto dei vettori.
Per rimuovere i centroidi dalla testa dei cluster viene chiamata la funzione adjust-partition sul risultato di partition-aux.


get-min-distance/2
Prende un vettore e una lista di centroidi, ritorna la distanza minima tra v e i centroidi.


generate-clus/1
Prende una lista contenente i centroidi (c1 c2 ...), e ritorna la lista ((c1) (c2) ...). Viene utilizzata per costruire la lista da passare alla partition (in coda a ciascun centroide verranno inseriti i vettori che gli saranno più vicini).


compute-cs/1
Prende un cluster e calcola il centroide di ciascun gruppo.


get-cs/1
Prende delle osservazioni e ne calcola il centroide.


divide/2
Prende una lista e un numero; divide ogni numero della lista per il numero passato come parametro.
