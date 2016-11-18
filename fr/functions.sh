#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file
# To avoid conflicts, name your function like this
# jv_pg_XX_myfunction () { }
# jv for JarVis
# pg for PluGin
# XX can be a two letters code for your plugin, ex: ww for Weather Wunderground
jv_pg_dz_set_mode() {

  local idx=$(curl -s "http://$jv_pg_dz_ip/json.htm?type=devices&filter=light" | jq -r --arg sw "$jv_pg_dz_inter_MC" '.result[] | select(.Name==$sw) | .idx')

  local command=""
  case $1 in
  "ECO")
    command="Set%20Level&level=$jv_pg_dz_NC_eco"
    ;;
  "CONFORT")
    command="Set%20Level&level=$jv_pg_dz_NC_confort"
    ;;
  "ARRET")
    command="Off"
    ;;
  "MANUEL")
    command="Set%20Level&level=$jv_pg_dz_NC_manuel"
    ;;
  "AUTO")
    command="Set%20Level&level=$jv_pg_dz_NC_auto"
    ;;
  esac

  local result=""
  if [ -z "$command" ]; then
    result="Je ne connais pas le mode de chauffage $1"
  else
    if [ -z "$idx" ]; then
      echo "$idx"
      result="Je n'ai pas trouvé l'interrupteur $jv_pg_dz_inter_MC"
    else
      result="Le chauffage est maintenant en mode $1"
      local url="http://$jv_pg_dz_ip/json.htm?type=command&param=addlogmessage&message=JARVIS%20%3A%20Je%20passe%20le%20chauffage%20en%20mode%20$1"
      jv_curl $url

      url="http://$jv_pg_dz_ip/json.htm?type=command&param=switchlight&idx=$idx&switchcmd=$command"
      jv_curl $url
    fi
  fi


  echo $result
}
