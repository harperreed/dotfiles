if [ "$1" ]
then
        curl -w "\n            time_namelookup:  %{time_namelookup}\n               time_connect:  %{time_connect}\n            time_appconnect:  %{time_appconnect}\n           time_pretransfer:  %{time_pretransfer}\n              time_redirect:  %{time_redirect}\n         time_starttransfer:  %{time_starttransfer}\n                            ----------\n                 time_total:  %{time_total}\n\n" -o /dev/null -s $1
fi

