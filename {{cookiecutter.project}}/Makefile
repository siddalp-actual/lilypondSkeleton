STEM := {{cookiecutter.project}}

all: $(STEM).midi $(STEM)\ -\ Piano.pdf 

%.midi: %.ly
	-rm *.notes  # - means ok to fail
	lilypond '$<'
	-~/github/lilypondEventsProcessing/notes2midi.py

$(STEM)\ -\ Piano.pdf: $(STEM).ly
	lilypond '$<'

%.wav: %.midi
	timidity '$<' -Ow -o'$*.wav'
