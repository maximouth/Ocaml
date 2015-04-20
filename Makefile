OC =  ocamlc
OL =  ocamlc

# OcamlSDL libraries path. Assume using opam
OPAM_LIBS_DIR = $(shell opam config var lib)
ifeq ($(OPAM_LIBS_DIR),)
  SDL_DIR=+sdl
else
	SDL_DIR =$(OPAM_LIBS_DIR)/sdl
endif


LIBS = $(SDL_DIR)/sdl.cma $(SDL_DIR)/sdlttf.cma $(SDL_DIR)/sdlgfx.cma $(SDL_DIR)/sdlloader.cma $(SDL_DIR)/sdltimer.cma bigarray.cma
TARGET = bomberzzle-ml

all: $(TARGET)

bomberzzle-ml: puzzle.cmo puzzle.cmi g.cmo g.cmi vm.cmo vm.cmi main.cmo  
	$(OL) -custom -o $@ -I $(SDL_DIR)  $(LIBS) puzzle.cmo g.cmo vm.cmo main.cmo

sdltimer.cmo: sdltimer.ml sdltimer.cmi
	$(OC) -I $(SDL_DIR)  -c sdltimer.ml

sdlvideo.cmo: sdlvideo.ml sdlvideo.cmi
	$(OC) -I $(SDL_DIR)  -c sdlvideo.ml

puzzle.cmo: puzzle.ml puzzle.cmi
	$(OC) -I $(SDL_DIR)  -c puzzle.ml

g.cmo: g.ml g.cmi
	$(OC) -I $(SDL_DIR)  -c g.ml

vm.cmo: vm.ml vm.cmi
	$(OC) -I $(SDL_DIR) -c vm.ml

main.cmo: main.ml
	$(OC) -I $(SDL_DIR) -c main.ml

%.cmi: %.mli
	$(OC) -I $(SDL_DIR) -c $<

clean:
	rm -rf *.cmi *.cmo

cleanall: clean
	rm -rf $(TARGET)
