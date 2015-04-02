open Puzzle
open Vm

let main =
  let t = 30 in
  let parse =  Puzzle.parse "./puzzles/p644.rzl" in
  let init = Vm.init parse in
  Printf.printf "ligne : %d colonne %d\n"
  parse.map.ligne parse.map.col;
  Vm.draw ((t+2) * parse.map.col ) ((t+2) * parse.map.ligne) t init 0 0;
  G.delay 10000
 
 
