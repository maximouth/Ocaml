open Puzzle
open Vm

let main =
  let t = 30 in
  let parse =  Puzzle.parse "./puzzles/p644.rzl" in
  let init = Vm.init parse in
  Printf.printf "ligne : %d colonne %d\n" parse.map.ligne parse.map.col;
  Vm.draw (280+(t+2) * parse.map.col ) (150 + (t+2) * parse.map.ligne) t init 0 0;
  G.sync();
  G.draw_text (32,13*32) parse.nom;
  G.sync();
  Vm.draw_f parse;
  G.sync();
  G.delay 10000;

