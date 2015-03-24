OC = ocamlfind ocamlc
OL = ocamlfind ocamlc
LIBS = sdl,sdl.sdlgfx,sdl.sdlimage,sdl.sdlttf
OBJS = puzzle.cmo g.cmo main.cmo
INTF = puzzle.cmi g.cmi
TARGET = robozzle-ml

all: $(TARGET)

robozzle-ml: $(OBJS)
	$(OL) -o $@ -package $(LIBS) -linkpkg $^

%.cmo: %.ml
	$(OC) -package $(LIBS) -c $<

%.cmi: %.mli
	$(OC) -package $(LIBS) -c %<

clean:
	rm *.cmi *.cmo

cleanall: clean
	rm $(TARGET)
