CC = ocamlfind ocamlc
OL = ocamlfind ocamlc
LIBS = sdl,sdl.sdlgfx,sdl.sdlimage,sdl.sdlttf
TARGET = robozzle-ml

all: $(TARGET)

robozzle-ml: g.cmo puzzle.cmo ast.cmo editor.cmo main.cmo
	$(OL) -o $@ -package $(LIBS) $<

%.cmo: %.ml
	$(OC) -package $(LIBS) -c $<

clean:
	rm *.cmi *.cmo

cleanall: clean
	rm $(TARGET)
