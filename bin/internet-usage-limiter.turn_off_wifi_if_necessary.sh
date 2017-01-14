#!/bin/sh

BEFORE=$(networksetup -getairportpower en0)

internet-usage-limiter.is_online.rb && /usr/sbin/networksetup -setairportpower en0 on || /usr/sbin/networksetup -setairportpower en0 off

if test "$(networksetup -getairportpower en0)" = "Wi-Fi Power (en0): Off" && test "$BEFORE" = "Wi-Fi Power (en0): On"; then
  osascript -e 'display notification "Your WiFi has been switched off. Use the go-online.rb utility to get online between 9:30 and 18:20." with title "Mindfulness"'
fi
