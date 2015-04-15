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
type state = {mutable pc       : offset;              (* pointeur sur l'instruction courante *)
              mutable star     : int;                 (* nombres d'étoiles restantes dans la map *)
              mutable stack    : offset list;         (* pile d'appels *)
              mutable map      : Puzzle.map;          (* map du puzzle *)
              mutable pos      : pos;                 (* position courante du robot *)
              mutable dir      : Puzzle.direction;    (* direction courante du robot *)
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
  let cl = m.col   in

  let rec loop (i : int)  (l : int) (list : cell list) =
  
    match list with
    | [] -> ()
    | Cell (true,col)::l' ->
      (if (i = cl)
       then (
	 G.draw_cell (0,32*(l+1)) col;
	 G.draw_star (0,32*(l+1));
	 loop 1 (l+1) l'
       )
       else (
	 G.draw_cell (32*i,32*l) col;
	 G.draw_star (32*i,32*l);
	 loop (i+1) l l'
       )
      )
    | Cell (false,col)::l' ->
      (if (i = cl)
       then (
	 G.draw_cell (0,32*(l+1)) col;
	 loop 1 (l+1) l'
       )
       else (
	 G.draw_cell (32*i,32*l) col;
	 loop (i+1) l l'
       )
      )
	
  in
  loop 0 0 m.map  
;;
  

let draw (offx :int) (offy : int) (csize : int) (state : state)(nb_step : int)(anim_frame : int) : unit =
  let pos_rb = match state.pos with
    | (x,y) ->(32*x,32*y)
  in
  G.init offx offy csize;
  draw_map state.map;
  G.draw_robot pos_rb state.dir 3;;


let rec draw_ligne (nb : int) (l : int) : unit =
  match nb with
  | 0 -> ()
  | n ->
    G.draw_cell ((18*32) + (32*nb), l) Empty;
    G.sync();
    draw_ligne (nb-1) l;;


let rec draw_name (f : int list) (i : int) : unit =
  match f with
  | [] -> ()
  | e::l' ->
    (match e with
    | 0 -> ()
    | _ ->
      (match i with
      | 1 ->
	G.draw_text ( 17*32,10) "F1";
	G.sync();
	draw_name l' (i+1)
      | 2 -> 
	G.draw_text ( 17*32,25+45) "F2" ;
	G.sync();
	draw_name l' (i+1) 
      | 3 -> 
	G.draw_text ( 17*32,80+45) "F3";
	G.sync();
	draw_name l' (i+1)
      | 4 -> 
	G.draw_text ( 17*32,135+45) "F4";
	G.sync();
	draw_name l' (i+1)
      | 5 -> 
	G.draw_text ( 17*32,190 + 45) "F5";
	G.sync();
	draw_name l' (i+1)
      |_ -> failwith "cas impossible"
      )
    )
;;

let draw_f (t : Puzzle.t) : unit =
  let f = t.f in
  
  let rec loop (l : int list) (i : int) : unit =
    match l with
    | [] -> ()
    | e::l' ->
      draw_ligne e i;
      loop l' (i+55)
  in
  draw_name f 1;
  loop f 30;;

let set_code (st : state) (bc : int bc array) : state =
  let s = {
    code = bc;
    pc = st.pc;
    star = st.star;
    stack = st.stack;
    map = st.map ;
    dir = st.dir; 
    pos = st.pos;
  } in
  s;;

let step (s : state) (t : Puzzle.t) : state =
  match (Array.get s.code s.pc) with
  | Move -> 
      (match s.dir,s.pos   with
	 | North,(x,y) -> s.pos <- (x,y-1)
	 | South,(x,y) -> s.pos <- (x,y+1)
	 | Est,(x,y) -> s.pos <- (x+1,y)
	 | West,(x,y) -> s.pos <- (x-1,y)

      );
      s.pc <- s.pc+1;
      s
  | Rotate r ->
      (match r,s.dir with
	| Left, North -> s.dir <- West
	| Left, South -> s.dir <- Est
	| Left, Est -> s.dir <- North
	| Left, West -> s.dir <- South

	| Right, North -> s.dir <- Est
	| Right, South -> s.dir <- West
	| Right, Est -> s.dir <- South
	| Right, West -> s.dir <- North
      );
      s.pc <- s.pc+1;
      s
  | Call x -> (** appel recursif non terminal   **)
    let f = t.f in
    s.stack <- (s.pc+1)::s.stack;
    (match x with
    | 1 -> s.pc <- 0
    | 2 -> s.pc <- ((List.hd f)- 1)
    | 3 -> s.pc <- ((List.hd f) + (List.nth f 1)) -1
    | 4 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2)) -1
    | 5 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2) + (List.nth f 3)) -1
    | _ -> failwith "pas de fonction de ce nom la"
    );
    s
  | TailCall x -> (** appel recursif terminal **)
    let f = t.f in
    (match x with
    | 1 -> s.pc <- 0
    | 2 -> s.pc <- ((List.hd f)- 1)
    | 3 -> s.pc <- ((List.hd f) + (List.nth f 1)) -1
    | 4 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2)) -1
    | 5 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2) + (List.nth f 3)) -1
    | _ -> failwith "pas de fonction de ce nom la"
    );
    s
  | Return -> (** remonter d'un cran dans la pile **)
    s.pc <- List.hd s.stack;
    s.stack <- List.tl s.stack;
    s
  | SetColor c ->
    let m = s.map in
    let x = match s.pos with
      |(x,y) -> x in
    let y = match s.pos with
      |(x,y) -> y in
    
    s.map <- { ligne = m.ligne;
	       col = m.col;
	       map =Puzzle.change_color c m.map 0 (x+(y*m.col)) [];
	     };
    s.pc <- s.pc+1;
    s
  | Jump x -> (** aller chercher la premiere instruction de la fonction x **)
    (*** pas compris la difference entre Call et jump... ***)
    let f = t.f in
    (match x with
    | 1 -> s.pc <- 0
    | 2 -> s.pc <- ((List.hd f)- 1)
    | 3 -> s.pc <- ((List.hd f) + (List.nth f 1)) -1
    | 4 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2)) -1
    | 5 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2) + (List.nth f 3)) -1
    | _ -> failwith "pas de fonction de ce nom la"
    );
    s

  | JumpIfNot (c,x) -> (** pareil que jump mais regarde si la case est de la bonne couleur avant **)
    let act = get_cell s.pos s.map in
    let c' =  get_color act in
      (if c = c' then
	  let f = t.f in
	  (match x with
	  | 1 -> s.pc <- 0
	  | 2 -> s.pc <- ((List.hd f)- 1)
	  | 3 -> s.pc <- ((List.hd f) + (List.nth f 1)) -1
	  | 4 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2)) -1
	  | 5 -> s.pc <- ((List.hd f) + (List.nth f 1) +(List.nth f 2) + (List.nth f 3)) -1
	  | _ -> failwith "pas de fonction de ce nom la"
	  );
       else s.pc <- s.pc +1
      );
    s
  | Exit -> (** On est arriv� au bout du bytecode, ne plus bouger le ponteur de pile et ne rien faire **)
    s
