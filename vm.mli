(* sens de la rotation pour l'instruction Rotate *)
type rotation = Left | Right

(* position du robot dans la map *)
type pos = int * int

(* un offset est une adresse absolue dans un bytecode Robozzle-ml *)
type offset = int

(* instructions de bytecode Robozzle-ml *)
type 'a bc =
  | Move
  | MoveIf of Puzzle.color
  | Rotate of rotation
  | RotateIf of rotation * Puzzle.color
  | Call of 'a
  | CallIf of 'a * Puzzle.color
  | TailCall of 'a
  | Return
  | SetColor of Puzzle.color
  | Jump of 'a
  | JumpIfNot of Puzzle.color * 'a
  | Exit

(* état de la machine virtuelle Robozzle-ml *)
type state = { mutable pc       : offset;              (* pointeur sur l'instruction courante *)
               mutable star     : int;                 (* nombres d'étoiles restantes dans la map *)
              mutable stack    : offset list;         (* pile d'appels *)
              mutable map      : Puzzle.map;          (* map du puzzle *)
              mutable pos      : pos;                 (* position courante du robot *)
              mutable dir      : Puzzle.direction;    (* direction courante du robot *)
               code     : (offset bc) array;   (* bytecode à exécuter *)
             }
(*
(* fonction de conversion d'une instruction bytecode en string pour le debuggage *)
val string_of_bc: ('a -> string) -> 'a bc -> string
*)
(* initialisation de la VM à partir d'un puzzle *)
val init : Puzzle.t -> state

(* ajout du code Robozzle-ml à exécuter dans la VM *)
val set_code : state -> int bc array -> state
(*
(* initialisation de la VM *)
val init_stack : state -> int -> state
*)
(* fonction d'évaluation de la VM, exécute l'instruction courante puis retourne

* le nouvel état de la VM *)
val step : state -> Puzzle.t ->state

(* fonctions de test pour la terminaison de la simulation *)
val is_solved : state -> bool
val is_out_of_map : state -> bool
val is_out_of_instr : state -> bool

(* accesseurs *)
val get_pos : state -> pos
val get_map : state -> Puzzle.map
val get_dir : state -> Puzzle.direction

  
(* fonction d'affichage de la map *)
val draw : int -> int -> int -> state -> int -> int -> unit

val draw_f : Puzzle.t -> unit
