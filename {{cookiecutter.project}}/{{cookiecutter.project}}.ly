\version "2.20.0"

\header {
  title = "{{cookiecutter.project}}"
  subtitle = " " % a bit more space
  % composer = "J. S. Bach."
  % set tagline to false to remove the lilypond composing notice
  tagline = ##f
}

%\include "articulate.ly"   % better midi dynamics
\include "../peteMacs.ly"  % useful functions

timeAndKey = { \key aes \major \time 3/4 }
bpm = 100
verses = 4

sopranoVoiceRefrain = \relative c'' {
    %\partial 4 aes4

    \bar "|."
}

sopranoPianoVerse = \relative c' {
    \bar "||"
}

voltaLast = \markup \text "Fine"
sopranoPiano = \relative c'' {
    \repeat volta \verses {
        \sopranoPianoVerse
    }
    \alternative {
        {
        }
        {
            \set Score.repeatCommands = #(list(list 'volta voltaLast))
        }
    }
    \bar "|."
}

altoPianoVerse = \relative c ' {
    \bar "||"
}

alto = \relative c' {
    \override Fingering.direction = #UP
    \repeat volta \verses {
        \altoPianoVerse
    }
    \alternative {
        {
        }
        {
        }
    }
    \bar"|."
}

tenorPianoVerse = \relative c {
    \bar "||"
}

tenor = \relative c' {
    \override Fingering.direction = #DOWN
    \repeat volta \verses {
        \tenorPianoVerse
    }
    \alternative {
        {
        }
        {
        }
    }
    \bar"|."
}

su = \change Staff = "up"
sd = \change Staff = "down"

tf =
#(define-music-function (parser location f) (number?)
    #{
    \tweak Y-offset #-4 -#f
    #}
)

bassPianoVerse = \relative c {
    \bar "||"
}

bass = \relative c {
    \repeat volta \verses {
        \bassPianoVerse
    }
    \alternative {
        {  % 1 - 4
        }
        {  % Last
        }
    }
    \bar "|."
}


chorusLyrics = \lyrics {
    % -- gives a - which doesn't eat a note, but may be printed
    % _ doesn't give a -, but does eat a note
    % __ prints _ but doesn't eat a note
}

verseTune = \new Voice = "verseSoprano" \relative c'' {
    \bar "|."
}

vOneLyrics = \lyrics {
    \verse "1"
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
            \sopranoPiano
        }
        \new Voice {
            \voiceTwo
            \alto
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
            %\autochange cis'
            \tenor
        }
        \new Voice {
            \voiceTwo
            \bass
        }        %\voiceTwo \bass
    >>
}

pianostaff =
<<
    \set PianoStaff.instrumentName = "Piano"

    %\staffName "Piano"
    \new Staff = "up"
    <<
        \set Staff.midiInstrument = "acoustic grand"
        \pianoupper
    >>
    \new Staff = "down"
    <<
        \set Staff.midiInstrument = "acoustic grand"
        \pianolower
    >>
>>

sopranostaff = \new Staff
    <<
    \staffName "S"
    \relative c'' {
        \clef treble
        \timeAndKey
        \new Voice = "sopranovoice" {
            \repeat volta 3 {
                \sopranoVoiceRefrain
            }
        }
    }
    >>


\book{
    \bookOutputName "{{cookiecutter.project}} - Piano"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        \new PianoStaff
        \pianostaff
        >>
        \layout {
            #(layout-set-staff-size 24)

            \context {
                \Staff
                \override VerticalAxisGroup.default-staff-staff-spacing.basic-distance = #1
            }
        %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
        %#'((Y-offset . 5))
        }
    }
    \paper {
        annotate-spacing = ##f
    }
    \score {
        \unfoldRepeats
        %\articulate
        <<
        \new pianostaff
        \pianostaff
        >>
        \midi {
            \tempo 4 = \bpm
        }
    }
}
