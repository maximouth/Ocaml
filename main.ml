open Puzzle
open Vm

let t = 30  


  
let loop (parse:Puzzle.t) state  =
  let rec loop' state  =
    if Array.get state.code state.pc = Exit then
      (
	G.delay (2000);
	G.clear();
	G.draw_text (260,175) "PERDU!! Plus de déplacement";
	G.sync();
	G.delay (3000);
	Printf.printf ("PERDU! plus de deplacement à faire\n");
	failwith "perdu"
      )
    else
      if state.star = 0  then
	(
	G.delay (2000);
	G.clear();
	G.draw_text (260,175) "GAGNE!! ";
	G.sync();
	G.delay (3000);
	  Printf.printf (" \n");
	  failwith "gagne"
	)
      else
	if (is_out_of_map state) = true then
	  (
	    G.delay (2000);
	    G.clear();
	    G.draw_text (260,175) "PERDU!! sortie de la carte";
	    G.sync();
	    G.delay (3000);
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
  let bt = [|Move;RotateIf (Left,Green);CallIf (2,Red);Call 1;Exit;RotateIf (Right,Red);RotateIf (Right,Green);Move;Call 2;Exit|] in
  Printf.printf "ligne : %d colonne %d\n" parse.map.ligne parse.map.col;

  
  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;


  G.clear();
  G.sync();
  G.draw_text (190,175) "BOMBERZZLE";
  G.sync();
  G.delay(2500);
  G.clear();
  G.sync();

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
