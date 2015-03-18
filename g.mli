(* position (x,y) dans la fenêtre *)
type pos = int * int

(* initialisation de l'affichage graphique et des images,
 * création de la fenêtre.
 * init w h c
 * - w : largeur de la fenêtre
 * - h : hauteur de la fenêtre
 * - c : taille en pixels d'une cellule (carrée)
 *)
val init : int -> int -> int -> unit

(* fermeture de l'affichage graphique *)
val quit : unit -> unit

(* effacement de la fenêtre *)
val clear : unit -> unit

(* dessiner une cellule de la couleur donnée à la position donnée *)
val draw_cell   : pos -> Puzzle.color -> unit
(* dessiner le cursor de l'éditeur à la position donnée *)
val draw_cursor : pos -> unit
(* dessiner une étoile (une bombe) à la position donnée *)
val draw_star   : pos -> unit
(* dessiner le robot avec la direction donnée, à la position donnée,
 * l'entier sert à spécifier le numéro de frame d'animation *)
val draw_robot  : pos -> Puzzle.direction -> int -> unit
(* dessiner un flèche pour l'éditeur *)
val draw_arrow  : pos -> Puzzle.direction -> unit
(* dessiner un appel de fonction pour l'éditeur *)
val draw_call   : pos -> string -> unit
(* dessiner du texte *)
val draw_text   : pos -> string -> unit

(* synchronisation de l'affichage *)
val sync  : unit -> unit

(* attente en millisecondes *)
val delay : int -> unit
