#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file
# To avoid conflicts, name your function like this
# jv_pg_XX_myfunction () { }
# jv for JarVis
# pg for PluGin
# XX can be a two letters code for your plugin, ex: ww for Weather Wunderground
jv_pg_dz_set_mode() {
  local switch="Mode chauffage"
  local ip="127.0.0.1:8080"

  local idx=$(curl -s "http://$ip/json.htm?type=devices&filter=light" | jq -r --arg sw "$switch" '.result[] | select(.Name==$sw) | .idx')

  local command=""
  case $1 in
  "ECO")
    command="Set%20Level&level=20"
    ;;
  "CONFORT")
    command="Set%20Level&level=30"
    ;;
  "ARRET")
    command="Off"
    ;;
  "MANUEL")
    command="Set%20Level&level=40"
    ;;
  "AUTO")
    command="Set%20Level&level=10"
    ;;
  esac

  local result=""
  if [ -z "$command" ]; then
    result="Je ne connais pas le mode de chauffage $1"
  else
    if [ -z "$idx" ]; then
      echo "$idx"
      result="Je n'ai pas trouvé l'interrupteur $switch"
    else
      result="Le chauffage est maintenant en mode $1"
      local url="http://$ip/json.htm?type=command&param=addlogmessage&message=JARVIS%20%3A%20Je%20passe%20le%20chauffage%20en%20mode%20$1"
      jv_curl $url

      url="http://$ip/json.htm?type=command&param=switchlight&idx=$idx&switchcmd=$command"
      jv_curl $url
    fi
  fi


  echo $result
}
