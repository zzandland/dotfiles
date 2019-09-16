#!/bin/sh

URL="https://www.reddit.com/message/unread/.json?feed=7826e63e5f50807f3ed1382bba47c5550a157206&user=Travaches"
USERAGENT="polybar-scripts/notification-reddit:v1.0 u/Travaches"

notifications=$(curl -sf --user-agent "$USERAGENT" "$URL" | jq '.["data"]["children"] | length')

if [ -n "$notifications" ] && [ "$notifications" -gt 0 ]; then
    echo " $notifications"
fi
