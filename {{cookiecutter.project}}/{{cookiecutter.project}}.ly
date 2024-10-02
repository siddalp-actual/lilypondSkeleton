\version "2.22.2"
\language "english"

\header {
  title = "{{cookiecutter.project}}"
  opus = " "
  subtitle = " " % a bit more space
  % composer = "J. S. Bach." 
  % set tagline to false to remove the lilypond composing notice
  tagline = ##f
}

%\include "articulate.ly"   % better midi dynamics
\include "../../peteMacs.ly"  % useful functions

timeAndKey = { \key a \major \time 4/4 \numericTimeSignature}
bpm = 100
pianoInstrument = "acoustic grand"
% pianoInstrument = "acoustic guitar (nylon)"
verses = 4

sopranoVoiceRefrain = \new Voice = "sopranovoicerefrain" {
    \relative c'' {
        %\partial 4 aes4

        \bar "|."
    }
}

sopranoPianoIntro = \relative c' {
    \bar "||"
}

sopranoPianoRefrain = \relative c' {
    \bar "||"
}

pianoDynamics = {
    \override Hairpin.to-barline = ##f
    }

sopranoVerseNotes = \relative c' {
    % \magnifyStaff #5/7
}

sopranoPianoVerse = \relative c' {
    \sopranoVerseNotes
}

voltaLast = \markup \text "Fine"
sopranoPiano = \relative c'' {
    \sopranoPianoIntro
    \tag #'withRepeat {
        \repeat volta \verses {
            \sopranoPianoRefrain
            \sopranoPianoVerse
        }
        \alternative {
            {
            }
            {
                \set Score.repeatCommands = #(list(list 'volta voltaLast))
            }
        }
    }
    \tag #'noRepeat {
        \sopranoPianoRefrain
        %{ % make the next \break add extra vertical offset 
	    \override
            Score
            .NonMusicalPaperColumn
            .line-break-system-details = #'((extra-offset . (0 . 15)))
	\break
        %}
        \sopranoPianoVerse
    }
    \bar "|."
}

altoPianoIntro = \relative c' {
}

altoPianoRefrain = \relative c' {
}

altoVerseNotes = \relative c' {
    % \magnifyStaff #5/7
}

altoPianoVerse = \relative c' {
    \altoVerseNotes
}

alto = \relative c' {
    \override Fingering.direction = #UP
    \altoPianoIntro
    \tag #'withRepeat {
        \repeat volta \verses {
            \altoPianoRefrain
            \altoPianoVerse
        }
        \alternative {
            {
            }
            {
            }
        }
    }
    \tag #'noRepeat {
        \altoPianoRefrain
        \altoPianoVerse
    }
}

su = \change Staff = "up"
sd = \change Staff = "down"

tenorPianoIntro = \relative c {
}

tenorPianoRefrain = \relative c {
}

tenorVerseNotes = 
\relative c' {
    % \magnifyStaff #5/7
}

tenorPianoVerse = \relative c {
    \tenorVerseNotes
}

tenor = \relative c' {
    \override Fingering.direction = #DOWN
    \tenorPianoIntro
    \tag #'withRepeat {
        \repeat volta \verses {
            \tenorPianoRefrain
            \tenorPianoVerse
        }
        \alternative {
            {
            }
            {
            }
        }
    }
    \tag #'noRepeat {
        \tenorPianoRefrain
        \tenorPianoVerse
    }
}


tf =
#(define-music-function (parser location f) (number?)
    #{
    \tweak Y-offset #-4 -#f
    #}
)

bassPianoIntro = \relative c {
}

bassPianoRefrain = \relative c {
}

bassVerseNotes =
%{ \transpose c c, { %}
    \relative c' {
        % \magnifyStaff #5/7
    }
%}

bassline = \relative c {
    \bassVerseNotes
}

bassPianoVerse = \relative c {
    \bassline
}

bass = \relative c {
    \bassPianoIntro
    \tag #'withRepeat {
        \repeat volta \verses {
            \bassPianoRefrain
            \bassPianoVerse
        }
        \alternative {
            {  % 1 - 4
            }
            {  % Last
            }
        }
    }
    \tag #'noRepeat {
        \bassPianoRefrain
        \bassPianoVerse
    }
}

bassPedOrgIntro = \relative c {
}

bassPedOrgRefrain = \relative c {
}

bassPedOrgVerse = \relative c {
    \bassline
}

organPed = \relative c {
    \bassPedOrgIntro
    \tag #'withRepeat {
        \repeat volta \verses {
            \bassPedOrgRefrain
            \bassPedOrgVerse
        }
        \alternative {
            {  % 1 - 4
            }
            {  % Last
            }
        }
    }
    \tag #'noRepeat {
        \bassPedOrgRefrain
        \bassPedOrgVerse
    }
}

%=============================================================================

chorusLyrics = \context Lyrics = "topwords" {
    \lyricsto "sopranovoicerefrain" {
    % -- gives a - which doesn't eat a note, but may be printed
    % _ doesn't give a -, but does eat a note
    % __ prints _ but doesn't eat a note
    % \override LyricText.font-size = #-2
    }
}

sopranoVoiceIntro = \relative c'' {}

sopranoVoiceVerseOne = \new Voice = "verseOneSoprano" \sopranoVerseNotes

sopranoIntroLyrics = \new Lyrics = "topwords" {
    \lyricsto "introSoprano" {
        \override LyricText.font-size = #-2
    }

}

sopranovOneLyrics = \context Lyrics = "topwords" {
    \lyricsto "verseOneSoprano" {
        \override LyricText.font-size = #-2
        % \override StanzaNumber.font-size = #-3
        % \set stanza = "1st Sunday:"
        \verse "1"
    }
}

altoVoiceVerseOne = \new Voice = "verseOneAlto" \altoVerseNotes

altovOneLyrics = \lyrics {
    \lyricsto "verseOneAlto" {
        \verse "1"
    }
}

tenorVoiceVerseOne = \new Voice = "verseOneTenor" \tenorVerseNotes

tenorvOneLyrics = \lyrics {
    \lyricsto "verseOneTenor" {
        \verse "1"
    }
}

bassVoiceVerseOne = \new Voice = "verseOneBass" \bassVerseNotes

bassvOneLyrics = \lyrics {
    \lyricsto "verseOneBass" {
        \verse "1"
    }
}

% vTwo creates a new Lyrics context which is a line below "topwords"
vTwoLyrics = \lyrics {
    \lyricsto "verseOneSoprano" {
        \override LyricText.font-size = #-2
        % \override StanzaNumber.font-size = #-3
        \verse "2"
    }
}

vThreeLyrics = \lyrics {
    \verse "3"
}

vFourLyrics = \lyrics {
    \verse "4"
}

pianoupper = \relative c'' {
    \tempo 4 = \bpm
    %\set Score.dynamicAbsoluteVolumeFunction = #myDynamics
    \set midiPanPosition = #0.75
    \set midiReverbLevel = #0

    \clef treble
    \timeAndKey
    <<
        \new Voice {
            \voiceOne
            \keepWithTag #'noRepeat \sopranoPiano
        }
        \new Voice {
            \voiceTwo
            \keepWithTag #'noRepeat \alto
        }
    >>
}

pianolower = \relative c {
    \set midiPanPosition = #-0.75
    \set midiReverbLevel = #0
    \clef bass
    \timeAndKey
    <<
        \new Voice {
            \voiceOne
            \showStaffSwitch
            %\autochange cis'
            \keepWithTag #'noRepeat \tenor
        }
        \tag #'noPedal \new Voice {
            \voiceTwo
            \keepWithTag #'noRepeat \bass
        }    
    >>
}

pedalorgan = \relative c {
    \set midiPanPosition = #-0.75
    \set midiReverbLevel = #0
    \clef bass
    \timeAndKey
    <<
        \new Voice {
            % \showStaffSwitch
            %\autochange cis'
            \tag #'withPedal \organPed
        }
    >>
}

pianostaff = \new PianoStaff
<<
    \set PianoStaff.instrumentName = "Piano"

    %\staffName "Piano"
    \new Staff = "up"
    <<
        \set Staff.midiInstrument = \pianoInstrument
        \pianoupper
    >>
    \new Dynamics \pianoDynamics
    \new Staff = "down"
    <<
        \set Staff.midiInstrument = \pianoInstrument
        \pianolower
    >>
    \new Staff = "pedal" \with {
        \RemoveAllEmptyStaves
        \override VerticalAxisGroup.remove-layer = 1
    }
    <<
        \clef "bass"
        \timeAndKey
        \set Staff.midiInstrument = \pianoInstrument
        \pedalorgan
    >>
>>

sopranostaff = \new Staff
    <<
    \staffName "S"
    \set Staff.midiInstrument = "soprano sax"
    \relative c'' {
        \clef treble
        \timeAndKey
        \sopranoVoiceIntro
        \tag #'withRepeat {
            \repeat volta \verses {
                \sopranoVoiceRefrain
                \sopranoVoiceVerseOne
            }
        }
        \tag #'noRepeat {
            \sopranoVoiceRefrain
            \sopranoVoiceVerseOne
        }
    }
    \chorusLyrics
    \sopranovOneLyrics 
    >>

altostaff = \new Staff
    <<
    \staffName "A"
    \set Staff.midiInstrument = "alto sax"
    \relative c'' {
        \clef treble
        \timeAndKey
        \tag #'withRepeat {
            \repeat volta \verses {
                %{ \altoVoiceRefrain %}
                \altoVoiceVerseOne
            }
        }
        \tag #'noRepeat {
            %{ \altoVoiceRefrain %}
            \altoVoiceVerseOne
        }
    }
    \altovOneLyrics
    >>

tenorstaff = \new Staff
    <<
    \staffName "T"
    \set Staff.midiInstrument = "tenor sax"
    \relative c' {
        \clef "treble_8"
        \timeAndKey
        \tag #'withRepeat {
            \repeat volta \verses {
                %{ \tenorVoiceRefrain %}
                \tenorVoiceVerseOne
            }
        }
        \tag #'noRepeat {
            %{ \tenorVoiceRefrain %}
            \tenorVoiceVerseOne
        }
    }
    \tenorvOneLyrics
    >>

bassstaff = \new Staff
    <<
    \staffName "B"
    \set Staff.midiInstrument = "tenor sax"
    \relative c'' {
        % \clef "treble_8"
        \clef "bass"
        \timeAndKey
        \tag #'withRepeat {
            \repeat volta \verses {
                %{ \bassVoiceRefrain %}
                \bassVoiceVerseOne
            }
        }
        \tag #'noRepeat {
            %{ \bassVoiceRefrain %}
            \bassVoiceVerseOne
        }
    }
    \bassvOneLyrics
    >>

choirstaff = \new ChoirStaff
    <<
        \keepWithTag #'noRepeat \sopranostaff
        % \keepWithTag #'noRepeat \altostaff
        % \keepWithTag #'noRepeat \tenorstaff 
        % \keepWithTag #'noRepeat \bassstaff
    >>


\book{
    \bookOutputName "{{cookiecutter.project}} - Organ"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        %\sopranostaff  % DONT FORGET midi score BELOW
        % \choirstaff
        % \keepWithTag #'(withPedal noRepeat) \pianostaff
        >>
        \layout {
            #(layout-set-staff-size 24)
            ragged-right = ##f
            ragged-last = ##f
            % indent = #5  % mm

            \context {
                \Staff
                \override VerticalAxisGroup.default-staff-staff-spacing.basic-distance = #1
                % \RemoveEmptyStaves
                % \override VerticalAxisGroup.remove-first = ##t
                %{ \omit TimeSignature %}
                %{ \omit KeySignature %}
            }

            \context {
                \Score
                \remove "Metronome_mark_engraver"
            }

        %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
        %#'((Y-offset . 5))
        }
    }
}

\book{
    \bookOutputName "{{cookiecutter.project}} - Piano"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        %\sopranostaff  % DONT FORGET midi score BELOW
        % \choirstaff 
        \keepWithTag #'(noPedal noRepeat) \pianostaff
        >>
        \layout {
            #(layout-set-staff-size 24)
            ragged-right = ##f
            ragged-last = ##f
            % indent = #5  % mm

            \context {
                \Staff
                \override VerticalAxisGroup.default-staff-staff-spacing.basic-distance = #1
                % \RemoveEmptyStaves
                % \override VerticalAxisGroup.remove-first = ##t
                %{ \omit TimeSignature %}
                %{ \omit KeySignature %}
            }

            \context {
                \Score
                \remove "Metronome_mark_engraver"
            }

        %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
        %#'((Y-offset . 5))
        }
    }
    \paper {
        annotate-spacing = ##f
        % system-separator-markup = \slashSeparator
        % page-count = #1
    }
    \score {
        \unfoldRepeats
        %\articulate
        <<
        % \choirstaff 
        \keepWithTag #'(noPedal noRepeat) \pianostaff
        >>
        \midi {
            \tempo 4 = \bpm
        }
    }
}
