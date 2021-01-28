#! /usr/bin/bash
fn=`basename -s .midi "$1"`
echo "converting $1 .midi to .wav"
timidity -E I0 "$fn.midi" -Ow -o "$fn.wav"
