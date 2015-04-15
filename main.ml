open Puzzle
open Vm

let t = 30  

  
let loop (parse:Puzzle.t) state  =
  let rec loop' state  =
    if Array.get state.code state.pc = Exit then
      (
	Printf.printf ("PERDU! plus de deplacement à faire\n");
	failwith "perdu"
      )
    else
      if state.star = 0  then
	(
	  Printf.printf (" \n");
	  failwith "gagne"
	)
      else
	if (is_out_of_map state) = true then
	  (
 	    Printf.printf ("PERDU! out of map\n");
	    failwith "perdu"
	  )
	else
	let state' = step state parse in
	G.clear();
	Vm.draw (280+(t+2) * parse.map.col) (150 + (t+2) * parse.map.ligne) t state' 0 0;    
	G.draw_text (32,13*32) parse.nom;
	Vm.draw_f parse;
	G.sync();
	G.delay 250;
	loop' state'  
  in loop' state 
  
let main =

let parse =  Puzzle.parse "./puzzles/p644.rzl" in
let init = Vm.init parse in
  let bt = [|Move;RotateIf (Left,Green);RotateIf (Right,Red);Call 1;Exit|] in
  
  Printf.printf "ligne : %d colonne %d\n" parse.map.ligne parse.map.col;
  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;
  G.sync();
  G.draw_text (32,13*32) parse.nom;
  G.sync();
  Vm.draw_f parse;
  G.sync();
  G.delay 1000;
  let state = set_code init bt in 
  loop parse state ;
  
  G.delay 5000
