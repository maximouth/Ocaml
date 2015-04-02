open Puzzle;;

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
               code     : offset bc array;            (* bytecode à exécuter *)
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

(***  fonctions de jeu  ***)

let is_solved (s : state) : bool =
  let map = s.map.map in

  let rec loop map =
    match map with
    | [] -> true
    | c::l -> (
      match c with
      (***  ne peut pas acceder a une cell...  ***)
      | Cell (b,c) ->
	(if b then
	    false
	 else
	    loop l)
    )
  in
  loop map
;;
  
let is_out_of_map (s : state) : bool =
  let p = get_pos s in
  let c =  get_cell p s.map in
  match c with
  | Cell (b,c) -> (
    if (c = Empty)
    then
      true
    else
      false)
;;

(*** � verifer!  ***)
let is_out_of_instr (s : state) : bool =
  if ((s.pc) = (Array.length s.code))
  then
    true
  else
    false
;;


(***  2.4  ***)

let init (t: Puzzle.t) : state =
  let s = {
    pc = 0;
    star = 0 (* fonction pour compter le nb d'etoile *);
    stack = [];
    map = t.map;
    pos = (t.cdep,t.ldep);
    dir = t.direction;
    code = Array.make 0 Exit (* ??  *)
  } in
  s;;

let draw_map (m : map) : unit =
  let col = m.col  in

  let rec loop (i : int)  (l : int) (list : cell list) =
  
    match list with
    | [] -> ()
    |Cell (true,c)::list' -> 
      (if (i = col)
       then (
	 G.draw_cell (32*(l+1),0) c;
	 G.draw_star (32*(l+1),0);
	  loop 0 (l+1) list'
       )
       else (
	 G.draw_cell (32*l,32*i) c;
	 G.draw_star (32*l,32*i);
        loop (i+1) l list'
       )
      )
    | Cell (false,c)::list' ->
      (if (i = (col))
       then (
	 G.draw_cell (32*(l+1),0) c;
	 loop 0 (l+1) list'
       )
       else (
	 G.draw_cell (32*l,32*i) c;
	 loop (i+1) l list'
       )
      )
	
  in
  loop 0 0 m.map  
;;
  

let draw (offx :int) (offy : int) (csize : int) (state : state)(nb_step : int)(anim_frame : int) : unit =
  G.init offx offy csize;
  draw_map state.map;
  G.sync();;
