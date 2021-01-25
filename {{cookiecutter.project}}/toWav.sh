#! /usr/bin/bash
fn=`basename -s .midi $1`
`timidity -E I0 $fn.midi -Ow -o $fn.wav`
