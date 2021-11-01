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

timeAndKey = { \key af \major \time 3/4 }
bpm = 100
verses = 4

sopranoVoiceRefrain = \new Voice = "sopranovoicerefrain" {
    \relative c'' {
        %\partial 4 aes4

        \bar "|."
    }
}

sopranoPianoRefrain = \relative c' {
    \bar "||"
}

sopranoPianoVerse = \relative c' {
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

tenorPianoRefrain = \relative c {
    \bar "||"
}

tenorPianoVerse = \relative c {
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
    }
}

sopranoVoiceVerseOne = \new Voice = "verseOneSoprano"
\relative c'' {
    \bar "|."
}

sopranovOneLyrics = \lyrics {
    \lyricsto "verseOneSoprano" {
        \verse "1"
    }
}

altoVoiceVerseOne = \new Voice = "verseOneAlto" \relative c' {
    \bar "|."
}

altovOneLyrics = \lyrics {
    \lyricsto "verseOneAlto" {
        \verse "1"
    }
}

bassVoiceVerseOne = \new Voice = "verseOneBass"
%{ \transpose c c, { %}
    \relative c' {
        \bar "|."
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

pianostaff = \new PianoStaff
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
    \set Staff.midiInstrument = "treble sax"
    \relative c'' {
        \clef treble
        \timeAndKey
        \repeat volta \verses {
            %{ \sopranoVoiceRefrain %}
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
        \repeat volta \verses {
            %{ \altoVoiceRefrain %}
            \altoVoiceVerseOne
        }
    }
    \altovOneLyrics
    >>

bassstaff = \new Staff
    <<
    \staffName "B"
    \set Staff.midiInstrument = "tenor sax"
    \relative c'' {
        \clef "treble_8"
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
        \sopranostaff
        \altostaff
        \bassstaff
    >>


\book{
    \bookOutputName "{{cookiecutter.project}} - Piano"
    %\overrideProperty Score.NonMusicalPaperColumn.line-break-system-details
    %#'((Y-offset . 2))
    \score {
        %\articulate
        <<
        %\sopranostaff  % DONT FORGET midi score BELOW
        %{ \choirstaff %}
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
        %\sopranostaff
        \pianostaff
        >>
        \midi {
            \tempo 4 = \bpm
        }
    }
}
