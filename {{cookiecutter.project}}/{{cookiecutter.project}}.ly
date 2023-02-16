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

sopranoPianoVerse = \relative c' {
    \bar "||"
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
        \sopranoPianoVerse
    }
    \bar "|."
}

altoPianoIntro = \relative c' {
}

altoPianoRefrain = \relative c' {
}

altoPianoVerse = \relative c' {
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

tenorPianoVerse = \relative c {
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

bassPianoVerse = \relative c {
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

%=============================================================================

chorusLyrics = \lyrics {
    \lyricsto "sopranovoicerefrain" {
    % -- gives a - which doesn't eat a note, but may be printed
    % _ doesn't give a -, but does eat a note
    % __ prints _ but doesn't eat a note
    % \override LyricText.font-size = #-2
    }
}

sopranoVoiceIntro = \relative c'' {}

sopranoVoiceVerseOne = \new Voice = "verseOneSoprano"
\relative c'' {
    % \magnifyStaff #5/7
}

sopranovOneLyrics = \lyrics {
    \lyricsto "verseOneSoprano" {
       \override LyricText.font-size = #-2
       % \override StanzaNumber.font-size = #-3
       % \set stanza = "1st Sunday:"
       \verse "1"
    }
}

altoVoiceVerseOne = \new Voice = "verseOneAlto" \relative c' {
}

altovOneLyrics = \lyrics {
    \lyricsto "verseOneAlto" {
        \verse "1"
    }
}

tenorVoiceVerseOne = \new Voice = "verseOneTenor" \relative c' {
}

tenorvOneLyrics = \lyrics {
    \lyricsto "verseOneTenor" {
        \verse "1"
    }
}

bassVoiceVerseOne = \new Voice = "verseOneBass"
%{ \transpose c c, { %}
    \relative c' {
    }
%}

bassvOneLyrics = \lyrics {
    \lyricsto "verseOneBass" {
        \verse "1"
    }
}

vTwoLyrics = \lyrics {
    \verse "2"
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
        \new Voice {
            \voiceTwo
            \keepWithTag #'noRepeat \bass
        }        %\voiceTwo \bass
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
                % \sopranoVoiceVerseOne
            }
        }
        \tag #'noRepeat {
            \sopranoVoiceRefrain
            % \sopranoVoiceVerseOne
        }
    }
    \chorusLyrics
    % \sopranovOneLyrics 
    >>

altostaff = \new Staff
    <<
    \staffName "A"
    \set Staff.midiInstrument = "alto sax"
    \relative c'' {
        \clef treble
        \timeAndKey
        \repeat volta \verses {
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
        \repeat volta \verses {
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
        \repeat volta \verses {
            %{ \bassVoiceRefrain %}
            \bassVoiceVerseOne
        }
    }
    \bassvOneLyrics
    >>

choirstaff = \new ChoirStaff
    <<
        \keepWithTag #'noRepeat \sopranostaff
        % \altostaff
        % \tenorstaff 
        % \bassstaff
    >>


\book{
    \bookOutputName "{{cookiecutter.project}} - Piano"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        %\sopranostaff  % DONT FORGET midi score BELOW
        % \choirstaff 
        \pianostaff
        >>
        \layout {
            #(layout-set-staff-size 24)
            ragged-right = ##f
            ragged-last = ##f


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
        \pianostaff
        >>
        \midi {
            \tempo 4 = \bpm
        }
    }
}
