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

type map = {ligne : int;
	    col : int;
	    map : cell list}
;;

