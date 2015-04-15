open Puzzle
open Vm

let t = 30  

  
let loop (parse:Puzzle.t) state i =
  let rec loop' state i =
  if i <= 0 then
    state
  else
    let state' = step state in
      G.clear();
      Vm.draw (280+(t+2) * parse.map.col) (150 + (t+2) * parse.map.ligne) t state' 0 0;    
      G.draw_text (32,13*32) parse.nom;
      Vm.draw_f parse;
      G.sync();
      G.delay 500;
      loop' state' (i - 1) 
  in loop' state i

let main =

let parse =  Puzzle.parse "./puzzles/p644.rzl" in
let init = Vm.init parse in
  let bt = [|Rotate Left;Move;Rotate Left;Move;Rotate Left;Move;Rotate Left;Move;Rotate Right;Move;Rotate Right;SetColor Blue;Move;Rotate Right;Move;Rotate Right;Move|] in
  
  Printf.printf "ligne : %d colonne %d\n" parse.map.ligne parse.map.col;
  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;
  G.sync();
  G.draw_text (32,13*32) parse.nom;
  G.sync();
  Vm.draw_f parse;
  G.sync();
  G.delay 1000;
  let state = set_code init bt in 
  loop parse state 35 ;
  
  G.delay 5000
