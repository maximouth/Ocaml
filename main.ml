open Puzzle
open Vm

let main =
  let parse =  Puzzle.parse "./puzzles/p644.rzl" in
  let init = Vm.init parse in
  Vm.draw init.map.ligne init.map.col 50 init 0 0
 
