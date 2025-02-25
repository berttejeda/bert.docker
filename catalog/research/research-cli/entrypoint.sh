#!/bin/bash

my_script_file_path=$0

echo "$(date +%H:%M:%S.%s) Starting up ..."

if [[ ! -f ~/.ssh/id_rsa ]];then
  echo -n "$(date +%H:%M:%S.%s) Could not find any ssh keys under $USERHOME/.ssh, generating ... " | sudo tee -a /install.log
  ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
  chmod 600 ~/.ssh/id_rsa*
  echo "done!" | sudo tee -a /install.log
fi

echo "Installing llama3" | sudo tee -a /install.log &&\
screen -dm ollama serve &&\
ollama pull llama3 &&\
echo "$(date +%H:%M:%S.%s) Successfully installed llama3" | sudo tee -a /install.log

function show_help(){

  echo $0
  local arg_pattern=$(cat "${my_script_file_path}" | egrep -i '(if \[\[ .\$arg)')
  echo -e "${arg_pattern}" | while read arg;do
    local pattern=$(cut -d@ -f1 <<< ${arg##*=~})
    local help_txt=$(cut -d@ -f2 <<< ${arg##*=~})
    echo " $pattern ${help_txt//]/}"
  done
}

if [[ "$*" =~ .*--help.* ]];then 
  show_help
  exit 0
fi

PREFIX=eval

for arg in "${@}";do
    shift
  if [[ "$arg" =~ ^--no-run-ssh$|^-no-ssh$|'@Do start SSH service - optional' ]]; then NO_RUN_SSH=true;continue;fi
  if [[ "$arg" =~ ^--dry$|'@Dry run, only echo commands' ]]; then PREFIX=echo;continue;fi
  set -- "$@" "$arg"
done

if [[ -z $NO_RUN_SSH ]];then
  echo "$(date +%H:%M:%S.%s) Exposing docker socket via ${DOCKER_HOST_PORT}" | sudo tee -a /install.log
  screen -dm sudo bash -c "(echo 'Exposing docker socket via socat ...';socat -d -d TCP-L:${DOCKER_HOST_PORT},fork UNIX:/var/run/docker.sock)"
  echo "$(date +%H:%M:%S.%s) Starting SSH Service ..." | sudo tee -a /install.log
  sudo /usr/sbin/sshd -D -o ListenAddress=0.0.0.0 | sudo tee -a /install.log
  echo "$(date +%H:%M:%S.%s) Shutting down ..." | sudo tee -a /install.log
fi
