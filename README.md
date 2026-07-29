## Progetto Lisp: Algoritmo K-Means
Progetto realizzato durante la laurea triennale presso l'Università degli Studi di Milano-Bicocca.

Questo progetto implementa in Lisp l'algoritmo di clustering k-means, includendo le operazioni vettoriali di base, il calcolo delle distanze e le funzioni per il partizionamento iterativo delle osservazioni.

---

## 1. Operazioni Vettoriali di Base

### `vplus/2`
Calcola la somma (vettoriale) di due vettori. Fa un controllo per verificare che i parametri passati siano due vettori di lunghezza uguale, per poi chiamare la funzione `vplus-aux`.
*   **`vplus-aux/2`**: Implementa la somma vera e propria tra due vettori. Crea una lista mettendo in testa la somma tra i due elementi in testa alle liste `v1` e `v2`, effettuando poi una chiamata ricorsiva sulle code.

### `vminus/2`
Calcola la differenza (vettoriale) di due vettori. Fa un controllo per verificare che i parametri passati siano due vettori di lunghezza uguale, per poi chiamare la funzione `vminus-aux`.
*   **`vminus-aux/2`**: Implementa la differenza tra due vettori. Crea una lista mettendo in testa la differenza tra i due elementi in testa alle liste `v1` e `v2`, effettuando poi una chiamata ricorsiva sulle code.

### `innerprod/2`
Calcola il prodotto interno (scalare) di due vettori; ritorna uno scalare. Fa un controllo per verificare che i parametri passati siano due vettori di lunghezza uguale, per poi chiamare la funzione `innerprod-aux`.
*   **`innerprod-aux/2`**: Implementa il prodotto interno tra due vettori. Somma il prodotto tra i due elementi in testa ai due vettori ed effettua una chiamata ricorsiva sulle code.

### `norm/1`
Calcola la norma euclidea di un vettore.

---

## 2. Calcolo dei Centroidi

### `centroid/1`
Ritorna il centroide dell'insieme di osservazioni passate in input. Viene implementata calcolando la media dei vettori che compongono la lista di osservazioni.
*   **`centroid-aux/2`**: Costruisce il vettore che corrisponde alla somma di tutti i vettori delle osservazioni iniziali.
*   **`get-values/2`**: Prende il vettore restituito da `centroid-aux` e lo divide per il parametro `n` passato in input, restituendo quindi il centroide effettivo.

---

## 3. Algoritmo K-Means (Core)

### `kmeans/2`
Partiziona le osservazioni in `k` clusters. Effettua una serie di controlli per verificare che i parametri passati siano corretti e poi chiama `kmeans-aux`. Inizializza l'algoritmo passando:
- Centroidi scelti casualmente (tramite `generate-cs`).
- `clus1` come lista vuota.
- `clus2` come lista ottenuta tramite `generate-clus` passandogli i centroidi appena calcolati.

### `kmeans-aux/4`
Implementa il ciclo principale dell'algoritmo delle k-medie. Prende in input la lista di osservazioni, i centroidi, un primo cluster `clus1` e un secondo cluster `clus2`.
- **Condizione di terminazione:** Se i due cluster sono uguali, l'algoritmo termina.
- **Iterazione:** Altrimenti, vengono ricalcolati i centroidi di `new-clus1`. Viene calcolato `new-clus2` chiamando la funzione `partition` sulle osservazioni, usando i nuovi centroidi e la lista ottenuta con `generate-clus`. Infine, viene effettuata una chiamata ricorsiva con i nuovi valori calcolati.

---

## 4. Funzioni di Supporto (Utility)

*   **`is-vector/1`**: Ritorna `T` se l'argomento passato è un vettore, `NIL` altrimenti.
*   **`check-obs/1`**: Ritorna `T` se le osservazioni passate sono rappresentate in modo corretto, `NIL` altrimenti.
*   **`distance/2`**: Calcola la distanza tra due vettori.
*   **`generate-cs/2`**: Prende in input una lista di osservazioni e un intero `k`; genera i centroidi selezionando casualmente `k` vettori dalle osservazioni.
*   **`partition/3`**: Divide le osservazioni nei rispettivi cluster. Analizza il vettore in testa e calcola la distanza minima dai centroidi; tramite la funzione `insert-v` inserisce il vettore in coda al centroide (parametro `clus`) la cui distanza corrisponde a quella minima, per poi fare una chiamata ricorsiva sul resto dei vettori. (Per rimuovere i centroidi dalla testa dei cluster finali viene chiamata la funzione `adjust-partition`).
*   **`get-min-distance/2`**: Prende un vettore e una lista di centroidi, e ritorna la distanza minima tra il vettore e i centroidi.
*   **`generate-clus/1`**: Prende una lista contenente i centroidi (es. `(c1 c2 ...)`), e ritorna una lista di liste (es. `((c1) (c2) ...)`). È utilizzata per costruire la struttura dati da passare a `partition` (in coda a ciascun centroide verranno inseriti i vettori più vicini).
*   **`compute-cs/1`**: Prende un cluster partizionato e calcola il nuovo centroide di ciascun gruppo.
*   **`get-cs/1`**: Prende un insieme di osservazioni e ne calcola il centroide.
*   **`divide/2`**: Prende una lista e un numero; divide ogni elemento numerico della lista per il numero passato come parametro.
