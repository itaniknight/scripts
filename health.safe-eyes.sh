while true
do
    notify-send -t 5000 -i emblem-default "Break incoming..." &&
    sleep 5 &&
    notify-send -t 20000 -i emblem-important "Time to take a break." &&
    sleep 20 &&
    sleep 1200
done
