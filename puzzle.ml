(***** declaration des types   *****)

type direction =
  | North
  | South
  | Est
  | West
;;

type color =
  | Empty
  | Red
  | Blue
  | Green
 ;;

type cell =
| Cell of (bool*color)
;;

type map = {
  ligne : int;
  col : int; 
  map : cell list}
;;

type t = {
  nom : string;
  cdep : int;
  ldep : int;
  direction : direction;
  f : int list;
  map : map;
};;

(*****  fin de declaration des types  *****)

(***** utilitaires ***)

let rec print_list (s :string list) : unit =
  match s with
  | [] -> Printf.printf "\n"
  | s::l' -> Printf.printf "%s" s;
    print_list l'

let dir_of_string (s : string) : direction =
  match s with
  | "3" -> North
  | "1" -> South
  | "0" -> Est
  | "2" -> West
  | _ -> failwith "mauvaise direction"
;;

let rec intList_of_str (s : string list) : int list =
  match s with
  | [] -> []
  | i::s' -> (int_of_string i)::(intList_of_str s')
;;


let rec map_string (s : string) (i : int) : cell list =
  if i >= String.length s
  then []
  else ( match s.[i] with
  | '.' -> (Cell (false, Empty))::(map_string s (i+1))
  | 'r' -> (Cell (false, Red))::(map_string s (i+1))
  | 'g' -> (Cell (false, Green))::(map_string s (i+1))
  | 'b' -> (Cell (false, Blue))::(map_string s (i+1))
  | 'R' -> (Cell (true, Red))::(map_string s (i+1))
  | 'G' -> (Cell (true, Green))::(map_string s (i+1))
  | 'B' -> (Cell (true, Blue))::(map_string s (i+1))
  | _ ->  failwith "mauvaise map"
  (*Printf.printf "mauvaise map %c" c; [] *)
  )
;;

let map_of_string (s : string) : cell list =
  map_string s 0;;

let string_of_col (c : color) : string =
  match c with
  | Empty -> "X"
  | Red -> "R"
  | Green -> "G"
  | Blue -> "B"
  | _ -> failwith "mauvaise couleur"


let affiche_map (map : map) : string =
  let nbcol = map.col in

  let rec loop (i : int) (map : cell list)  =
    match map with
    | [] -> ""
    | Cell (b,c)::map' -> (if i = (nbcol -1)
      then (string_of_col c)^"\n"^(loop 0 map')
      else (string_of_col c)^(loop (i+1) map')
    )      
  in
  loop 0 map.map
;;

(**** fin utilitaires ****)

    
let rec split_aux (s :string) (i : int) (n : int) (acc : string list) : string list =
  if i >= (String.length s)
  then List.rev ((String.sub s n (i-n))::acc)
  else
    (if s.[i] = ';'
     then (split_aux s (i+1) (i+1) ((String.sub s n (i-n))::acc))
     else (split_aux s (i+1) n acc)
    );;


let split (s : string) : string list =
  split_aux s 0 0 [] 
;;

split "0;5;4";;

let parse (s : string) : t =
  let f = open_in s in
  let nom = input_line f in
  let col = input_line f in
  let l = input_line f in
  let stcol = input_line f in
  let stl = input_line f in
  let dir = input_line f in
  let ukn = input_line f in
  let ff = input_line f in
  let mapp = input_line f in

  let t = {
  nom = nom;
    cdep = int_of_string stcol;
    ldep = int_of_string stl;
    direction = dir_of_string dir;
    f = intList_of_str (split ff);
  map = { ligne = int_of_string l;
	  col = int_of_string col;
	  map = map_of_string mapp

	};
  } in
  
  close_in f;
  t;;
(* 
let test =
  let t = parse "./puzzles/p644.rzl" in
    Printf.printf "%s" (affiche_map t.map)
*)
