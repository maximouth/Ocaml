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
  f : int list;
  map : map;
};;

val split : string -> string list
;;
val parse : string -> t 
