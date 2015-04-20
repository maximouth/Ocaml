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

	(* F1  *)
	G.draw_arrow (19*32,30) North;
	G.draw_cell (20*32,30) Green;
	G.draw_arrow (20*32,30) West;
	G.draw_cell (21*32,30) Red;
	G.draw_call (21*32,30) "f2";
	G.draw_call (22*32,30) "f1";

	(* F2  *)
	G.draw_cell (19*32,85) Red;
	G.draw_arrow (19*32,85) Est;
	G.draw_cell (20*32,85) Green;
	G.draw_arrow (20*32,85) Est;
	G.draw_arrow (21*32,85) North;
	G.draw_call (22*32,85) "f2";

	(* nb star restante *)
	G.draw_text2 (16*32,390 ) "Nb bombe : ";
	G.draw_text2 (23*32,390 ) (string_of_int state'.star);

	
	G.sync();
	G.delay 250;
	loop' state'  
  in loop' state 
  
let main =

  
let parse =  Puzzle.parse "./puzzles/p644.rzl" in
let init = Vm.init parse in
let bt = [|(*F1*)Move;RotateIf (Left,Green);CallIf (2,Red);Call 1;Exit;Exit;(*F2*)RotateIf (Right,Red);RotateIf (Right,Green);Move;Call 2;Exit|] in
  Printf.printf "ligne : %d colonne %d\n" parse.map.ligne parse.map.col;

  
  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;


  G.clear();
  G.sync();
  G.draw_text3 (190,175) "BOMBERZZLE";
  G.draw_text3 (180,193) "--------------------";

  (*ligne du haut *)
  G.draw_robot (150,150) North 1;
  G.draw_robot (180,150) North 2;
  G.draw_robot (210,150) North 3;
  G.draw_robot (240,150) North 1;
  G.draw_robot (270,150) North 2;
  G.draw_robot (300,150) North 3;
  G.draw_robot (330,150) North 1;
  G.draw_robot (360,150) North 2;
  G.draw_robot (390,150) North 3;
  G.draw_robot (420,150) North 1;
  G.draw_robot (450,150) North 2;
  G.draw_robot (480,150) North 3;
  G.draw_robot (510,150) North 1;
  G.draw_robot (540,150) North 2;
  G.draw_robot (570,150) North 3;
  G.draw_robot (600,150) North 1;

  (* ligne de gauche *)
  G.draw_robot (150,180) West 1;
  G.draw_robot (150,210) West 2;

  (* ligne de droite *)
  G.draw_robot (600,180) Est 1;
  G.draw_robot (600,210) Est 1;

  
  (* ligne du bas*)
  G.draw_robot (150,235) South 1;
  G.draw_robot (180,235) South 2;
  G.draw_robot (210,235) South 3;
  G.draw_robot (240,235) South 1;
  G.draw_robot (270,235) South 2;
  G.draw_robot (300,235) South 3;
  G.draw_robot (330,235) South 1;
  G.draw_robot (360,235) South 2;
  G.draw_robot (390,235) South 3;
  G.draw_robot (420,235) South 1;
  G.draw_robot (450,235) South 2;
  G.draw_robot (480,235) South 3;
  G.draw_robot (510,235) South 1;
  G.draw_robot (540,235) South 2;
  G.draw_robot (570,235) South 3;
  G.draw_robot (600,235) South 1;
  
  (* Ligne bombes *)
  G.draw_robot (130, 350) Est 3;
  G.draw_star (155,350);
  G.draw_star (180,350);
  G.draw_star (205,350);
  G.draw_star (230,350);
  G.draw_star (255,350);
  G.draw_star (280,350);
  G.draw_star (305,350);
  G.draw_star (330,350);
  G.draw_star (355,350);
  G.draw_star (380,350);
  G.draw_star (405,350);
  G.draw_star (430,350);
  G.draw_star (455,350);
  G.draw_star (480,350);
  G.draw_star (505,350);
  G.draw_star (530,350);
  G.draw_star (555,350);
  G.draw_star (580,350);
  G.draw_star (605,350);
  G.draw_robot (625, 350) West 2;

  (* High Score *)
  G.draw_text2 (290, 370) "High Score";
  G.draw_text2 (255, 430) "00000000000";
  
  G.sync();
  G.delay(4000);
  G.clear();
  G.sync();

  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;
  
  G.sync();
  G.draw_text (32,13*32) parse.nom;
  G.sync();
  Vm.draw_f parse;
	(* F1  *)
	G.draw_arrow (19*32,30) North;
	G.draw_cell (20*32,30) Green;
	G.draw_arrow (20*32,30) West;
	G.draw_cell (21*32,30) Red;
	G.draw_call (21*32,30) "f2";
	G.draw_call (22*32,30) "f1";

	(* F2  *)
	G.draw_cell (19*32,85) Red;
	G.draw_arrow (19*32,85) Est;
	G.draw_cell (20*32,85) Green;
	G.draw_arrow (20*32,85) Est;
	G.draw_arrow (21*32,85) North;
	G.draw_call (22*32,85) "f2";


	(* nb star restante *)
	G.draw_text2 (16*32,390 ) "Nb bombe : ";
	G.draw_text2 (23*32,390 ) (string_of_int init.star);
	
  G.sync();
  G.delay 1000;
  let state = set_code init bt in 
  loop parse state ;
  
  G.delay 5000
