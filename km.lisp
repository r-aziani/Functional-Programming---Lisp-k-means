;;;; -*- Mode:Lisp -*-

;;;; km.lisp --
;; Aziani Riccardo 866037

;; FUNZIONE vplus/2
;; calcola la somma vettoriale di due vettori

(defun vplus (v1 v2)
  (if (and (is-vector v1) (is-vector v2) (= (length v1) (length v2)))
      (vplus-aux v1 v2)
    (format t "Invalid input")))

(defun vplus-aux (v1 v2)
  (cond ((null v1) nil)
        (t (cons (+ (car v1) (car v2)) (vplus-aux (cdr v1) (cdr v2))))))


;; FUNZIONE vminus/2
;; calcola la differenza vettoriale di due vettori

(defun vminus (v1 v2)
  (if (and (is-vector v1) (is-vector v2) (= (length v1) (length v2)))
      (vminus-aux v1 v2)
    (format t "Invalid input")))

(defun vminus-aux (v1 v2)
  (cond ((null v1) nil)
        (t (cons (- (car v1) (car v2)) (vminus-aux (cdr v1) (cdr v2))))))


;; FUNZIONE innerprod/2
;; calcola il prodotto interno tra due vettori

(defun innerprod (v1 v2)
  (if (and (is-vector v1) (is-vector v2) (= (length v1) (length v2)))
      (innerprod-aux v1 v2)
    (format t "Invalid input")))

(defun innerprod-aux (v1 v2)
  (cond ((null v1) 0)
        (t (+ (* (car v1) (car v2)) (innerprod-aux (cdr v1) (cdr v2))))))


;; FUNZIONE norm/1
;; calcola la norma di un vettore

(defun norm (v)
  (if (is-vector v) (sqrt (innerprod v v))
    (format t "Invalid input")))


;; FUNZIONE centroid/1
;; ritorna il centroide dell'insieme
;; di osservazioni che gli sono passate

(defun centroid (obs)
  (if (check-obs obs)
      (get-values (centroid-aux (car obs) (cdr obs)) (length obs))
    (format t "Invalid input")))

(defun centroid-aux (head obs)
  (cond ((null obs) head)
        (t (centroid-aux (vplus head (car obs)) (cdr obs)))))

(defun get-values (v n)
  (cond ((null v) nil)
        (t (cons (float (/ (car v) n)) (get-values (cdr v) n)))))


;; FUNZIONE kmeans/2
;; partiziona le osservazioni in k cluster

(defun kmeans (obs k)
  (cond ((not (check-obs obs)) (format t "Invalid input [obs]"))
        ((not (integerp k)) (format t "Invalid input [k not integer]"))
        ((< (length obs) k) (error "k < (length observations)"))
        (t (let* ((cen (generate-cs obs k))
                  (clus2 (generate-clus cen)))
             (kmeans-aux obs cen '() clus2)))))

(defun kmeans-aux (obs cen clus1 clus2)
  (cond ((equal clus1 clus2) clus2)
        (t (let* ((new-clus1 clus2)
                  (new-cen (compute-cs new-clus1))
                  (new-clus2 (partition obs
					new-cen
					(generate-clus new-cen))))
             (kmeans-aux obs new-cen new-clus1 new-clus2)))))



;; FUNZIONI DI SUPPORTO

;; is-vector/1
;; ritorna T se gli viene passato un vettore, nil altrimenti

(defun is-vector (v)
  (cond ((not (listp v)) (format t "Invalid input"))
        ((and (listp v) (= (length v) 0)) (format t "Invalid input"))
        (t (is-vector-aux v))))

(defun is-vector-aux (v)
  (cond ((null v) T)
        ((numberp (car v)) (is-vector-aux (cdr v)))
        (t nil)))


;; check-obs/1
;; ritorna T se gli vengono passate delle observation
;; rappresentate in modo corretto, NIL altrimenti

(defun check-obs (obs)
  (if (check-obs-aux obs) (check-lengths (build-lengths obs))
    nil))

(defun check-obs-aux (obs)
  (cond ((null obs) t)
        ((is-vector (car obs)) (check-obs-aux (cdr obs)))
        (t nil)))

(defun build-lengths (obs)
  (cond ((null obs) nil)
        (t (cons (length (car obs)) (build-lengths (cdr obs))))))

(defun check-lengths (obs)
  (cond ((null obs) t)
        ((null (cdr obs)) t)
        ((= (car obs) (car (cdr obs))) (check-lengths (cdr obs)))
        (t nil)))


;; distance/2
;; calcola la distanza tra due vettori

(defun distance (v1 v2)
  (sqrt (sum-terms (build-terms v1 v2))))

(defun build-terms (v1 v2)
  (cond ((null v1) nil)
        (t
	 (cons
	  (expt
	   (- (car v1) (car v2)) 2)
	  (build-terms (cdr v1) (cdr v2))))))

(defun sum-terms (terms)
  (cond ((null terms) 0)
        (t (+ (car terms) (sum-terms (cdr terms))))))


;; generate-cs/2
;; genera i centroidi selezionando casualmente k
;; delle osservazioni iniziali


(defun generate-cs (obs k)
  (cond ((= k 0) nil)
        (t (let* ((index (random (length obs)))
                  (centroid (nth index obs))
                  (new-obs (remove centroid obs)))
             (cons centroid (generate-cs new-obs (- k 1)))))))


;; partition/3
;; divide le osservazioni nei rispettivi
;; cluster

(defun partition (obs cen clus)
  (let ((list (partition-aux obs cen clus)))
    (adjust-partition list)))

(defun partition-aux (obs cen clus)
  (cond ((null obs) clus)
        (t (let* ((v (car obs))
                  (min-dist (get-min-distance (car obs) cen))
                  (new-clus (insert-v v min-dist clus)))
             (partition-aux (cdr obs) cen new-clus)))))


(defun insert-v (v min-dist clus)
  (cond ((null clus) (format t "error insert-v: clus is null"))
        ((= min-dist
	    (distance
	     v
	     (car (car clus))))
	 (cons (append (car clus) (list v)) (cdr clus)))
        (t (cons (car clus) (insert-v v min-dist (cdr clus))))))

(defun adjust-partition (list)
  (cond ((null list) nil)
        (t (append (list (cdr (car list)))
		   (adjust-partition (cdr list))))))


;; get-min-distance/2
;; prende un vettore e una lista di centroidi,
;; ritorna la distanza minima tra v e 
;; ciascun centroide

(defun get-min-distance (v cen)
  (apply #'min (get-min-distance-aux v cen)))

(defun get-min-distance-aux (v cen)
  (cond ((null cen) nil)
        (t
	 (cons
	  (distance v
		    (car cen))
	  (get-min-distance-aux v (cdr cen))))))


;; generate-clus/1
;; prende una lista contenente i centroidi (c1 c2..),
;; e ritorna la lista ((c1) (c2) (c3) ...)

(defun generate-clus (cen)
  (cond ((null cen) nil)
        (t (append (list (list (car cen)))
		   (generate-clus (cdr cen))))))

;; compute-cs/1
;; prende un cluster e calcola il centroide
;; di ciascun gruppo

(defun compute-cs (clus)
  (cond ((null clus) nil)
        (t
	 (append
	  (list
	   (get-cs
	    (car clus)))
	  (compute-cs (cdr clus))))))


;; get-cs/1
;; prende un gruppo di osservazioni e ne 
;; calcola il centroide

(defun get-cs (clus)
  (let ((to-divide (car (get-cs-aux clus))))
    (divide (length clus) to-divide)))

(defun get-cs-aux (clus)
  (cond ((null clus) nil)
        ((null (cdr clus)) clus)
        (t (get-cs-aux
	    (append
	     (list
	      (vplus
	       (car clus)
	       (car (cdr clus))))
	     (get-cs-aux (cdr (cdr clus))))))))


;; divide/2
;; divide ogni numero nella lista
;; per number

(defun divide (number list)
  (mapcar #'(lambda (x) (float (/ x number))) list))

;;;; end of file -- km.lisp -- 
