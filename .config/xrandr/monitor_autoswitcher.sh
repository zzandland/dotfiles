#!/bin/bash

export DISPLAY=:0

intern=eDP-1
extern=DP-3

if xrandr | grep "$intern connected"; then
  if xrandr | grep "$extern connected"; then
    xrandr --output "$extern" --auto --output "$intern" --off
  else
    xrandr --output "$intern" --auto --output "$extern" --off
  fi
fi
