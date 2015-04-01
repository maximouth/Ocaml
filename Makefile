OC =  ocamlfind ocamlc
OL =  ocamlfind ocamlc

# OcamlSDL libraries path. Assume using opam
OPAM_LIBS_DIR = $(shell opam config var lib)
ifeq ($(OPAM_LIBS_DIR),)
  SDL_DIR=+sdl
else
	SDL_DIR =$(OPAM_LIBS_DIR)/sdl
endif


#LIBS = sdl,sdl.sdlgfx,sdl.sdlimage,sdl.sdlttf
TARGET = robozzle-ml

all: $(TARGET)

robozzle-ml: puzzle.cmo puzzle.cmi g.cmo g.cmi vm.cmo vm.cmi main.cmo
	$(OL) -o $@ -I $(SDL_DIR) $(LIBS) -linkpkg puzzle.cmo g.cmo main.cmo

puzzle.cmo: puzzle.ml puzzle.cmi
	$(OC) -I $(SDL_DIR) $(LIBS) -c puzzle.ml

g.cmo: g.ml g.cmi
	$(OC) -I $(SDL_DIR) $(LIBS) -c g.ml

vm.cmo: vm.ml vm.cmi
	$(OC) -I $(SDL_DIR) $(LIBS) -c vm.ml

main.cmo: main.ml
	$(OC) -I $(SDL_DIR)  $(LIBS) -c main.ml

%.cmi: %.mli
	$(OC) -I $(SDL_DIR) $(LIBS) -c $<

clean:
	rm -rf *.cmi *.cmo

cleanall: clean
	rm -rf $(TARGET)
