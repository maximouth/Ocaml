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

val split : string -> string list
