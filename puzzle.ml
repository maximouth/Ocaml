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
  | Yellow
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
  f1 : int list;
  f2 : int list;
  f3 : int list;
  f4 : int list;
  f5 : int list;
  map : map;
};;

(*****  fin de declaration des types  *****)

  
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

split "un;deux;trois";;
