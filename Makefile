OC = ocamlfind ocamlc
OL = ocamlfind ocamlc
LIBS = sdl,sdl.sdlgfx,sdl.sdlimage,sdl.sdlttf
TARGET = robozzle-ml

all: $(TARGET)

robozzle-ml: puzzle.cmo puzzle.cmi g.cmo g.cmi vm.cmo vm.cmi main.cmo
	$(OL) -o $@ -package $(LIBS) -linkpkg puzzle.cmo vm.cmo g.cmo main.cmo

puzzle.cmo: puzzle.ml puzzle.cmi
	$(OC) -package $(LIBS) -c puzzle.ml

g.cmo: g.ml g.cmi
	$(OC) -package $(LIBS) -c g.ml

vm.cmo: vm.ml vm.cmi
	$(OC) -package $(LIBS) -c vm.ml

main.cmo: main.ml
	$(OC) -package $(LIBS) -c main.ml

%.cmi: %.mli
	$(OC) -package $(LIBS) -c $<

clean:
	rm -rf *.cmi *.cmo

cleanall: clean
	rm -rf $(TARGET)
