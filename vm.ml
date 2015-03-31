(* definition des types *)

(* sens de la rotation pour l'instruction Rotate *)
type rotation = Left | Right

(* position du robot dans la map *)
type pos = int * int

(* un offset est une adresse absolue dans un bytecode Robozzle-ml *)
type offset = int

(* instructions de bytecode Robozzle-ml *)
type 'a bc =
  | Label of 'a
  | Move
  | Rotate of rotation
  | Call of 'a
  | TailCall of 'a
  | Return
  | SetColor of Puzzle.color
  | Jump of 'a
  | JumpIfNot of Puzzle.color * 'a
  | Exit

(* état de la machine virtuelle Robozzle-ml *)
type state = { pc       : offset;              (* pointeur sur l'instruction courante *)
               star     : int;                 (* nombres d'étoiles restantes dans la map *)
               stack    : offset list;         (* pile d'appels *)
               map      : Puzzle.map;          (* map du puzzle *)
               pos      : pos;                 (* position courante du robot *)
               dir      : Puzzle.direction;    (* direction courante du robot *)
	       (* pas string mais quoi?? *)
               code     : string bc array;            (* bytecode à exécuter *)
             }



(*fin de  definition des types*)


(* accesseur*)
  
let get_pos (s : state) : pos =
  s.pos
;;

let get_map (s : state) : Puzzle.map =
  s.map
;;

let get_dir (s : state) : Puzzle.direction =
  s.dir
;;

(* utilitaires *)

let get_cell ((x,y) : pos) (pz : Puzzle.map) : Puzzle.cell =
  let pos = (pz.col * y) + x in

  let rec loop i pz =
    match pz with
    | [] -> failwith "pas dans la map"
    | e::l' -> (
      if (pos = i)
      then e
      else (loop (i+1) l'))
  in
  loop 0 pz.map
;;

let get_color (cell : Puzzle.cell) : Puzzle.color =
  match cell with
  |Cell (b,c) -> c
;;

let is_empty (Cell (b,c) : Puzzle.cell) : bool =
  b
;;
