#!/bin/bash

i3-msg "workspace 10; append_layout /home/david/.config/i3/ws/music.json"
termite --name "mpsyt" -e mpsyt &
termite --name "vis" --hold -e vis &
