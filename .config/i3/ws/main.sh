#!/bin/bash

i3-msg workspace 1 
i3-msg append_layout /home/david/.config/i3/ws/main.json
termite --name "calcurse" -e calcurse &
termite --name "bash" &
