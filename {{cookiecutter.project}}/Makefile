STEM := {{cookiecutter.escaped_project}}

# Skeleton adds the '- Piano' suffix
PDF := $(STEM)\ -\ Piano.pdf

# first rule is the default, build everything
all: $(STEM).midi $(PDF)

# %.midi: %.ly
$(STEM).midi: $(STEM).ly
	-rm $(STEM)*.notes  # - means OK to fail
	lilypond '$<'
	-~/github/lilypondEventsProcessing/notes2midi.py

$(PDF): $(STEM).ly
	lilypond '$<'

%.wav: %.midi
	timidity '$<' -Ow -o'$*.wav'
