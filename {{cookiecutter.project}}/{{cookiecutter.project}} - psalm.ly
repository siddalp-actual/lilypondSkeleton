\version "2.20.0"
\language "english"

\header {
  title = "{{cookiecutter.project}}"
  subtitle = " " % a bit more space
  % composer = "J. S. Bach."
  % set tagline to false to remove the lilypond composing notice
  tagline = ##f
}

%\include "articulate.ly"   % better midi dynamics
\include "../peteMacs.ly"  % useful functions

timeAndKey = { \key c \major \time 4/4 }
bpm = 100
verses = 3

sopranoVoiceRefrain = \new Voice = "sopranovoicerefrain" {
    \relative c'' {
        \bar "|."
    }
}

sopranoPianoRefrain = \relative c'' {
    \bar "||"
}

sopranoPianoVerse = \relative c'' {
    \stemOff \cadenzaOn
    %{ g\breve e4 g a1 \bar "'" a\breve g4 a b1 \bar"'" %}
    \bar "||"
}

voltaLast = \markup \text "Fine"
sopranoPiano = \relative c'' {
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
    \bar "|."
}

altoPianoRefrain = \relative c' {
    \bar "||"
}

altoPianoVerse = \relative c' {
    \bar "||"
}

alto = \relative c' {
    \override Fingering.direction = #UP
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
    \bar"|."
}

su = \change Staff = "up"
sd = \change Staff = "down"

tenorPianoRefrain = \relative c' {
    \bar "||"
}

tenorPianoVerse = \relative c' {
    \bar "||"
}

tenor = \relative c' {
    \override Fingering.direction = #DOWN
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
    \bar"|."
}


tf =
#(define-music-function (parser location f) (number?)
    #{
    \tweak Y-offset #-4 -#f
    #}
)

bassPianoRefrain = \relative c {
    \bar "||"
}

bassPianoVerse = \relative c {
    \bar "||"
}

bass = \relative c {
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
    \bar "|."
}


chorusLyrics = \lyrics {
    \lyricsto "sopranovoicerefrain" {
    % -- gives a - which doesn't eat a note, but may be printed
    % _ doesn't give a -, but does eat a note
    % __ prints _ but doesn't eat a note
    %{ The Lord has set his throne in heaven. %}
    }
}

sopranoVoiceVerse = \new Voice = "verseSoprano" \relative c'' {
    \bar "|."
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
            \showStaffSwitch
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
    \staffName "Soprano"
    \set Staff.midiInstrument = "tenor sax"
    \relative c'' {
        \clef treble
        \timeAndKey
        \repeat volta \verses {
            \sopranoVoiceRefrain
            \sopranoVoiceVerse
        }
    }
    \chorusLyrics
    >>

vAfterLyrics =
\markup {
  \fill-line {
    \column {
      \left-align {
        %{ \line { \bold "Verse 1:" }
        \line { My soul, give thanks  \tick to the Lord, }
        \line { all my being, bless God's  \tick holy name. }
        \line { My soul, give thanks  \tick to the Lord }
        \line { and never forget  \tick all God's blessings. }
        \line { " " } %}
      }
    }
  }
}


\book{
    \bookOutputName "Psalm Easter 7 - Piano"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        \sopranostaff  % DONT FORGET midi score BELOW
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
    \vAfterLyrics
    \paper {
        annotate-spacing = ##f
    }
    \score {
        \unfoldRepeats
        %\articulate
        <<
        %\sopranostaff
        \new PianoStaff
        \pianostaff
        >>
        \midi {
            \tempo 4 = \bpm
        }
    }
}
