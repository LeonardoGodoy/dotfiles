#!/bin/bash

function sshc()
{
  local PROJECT=$1
  local SERVER_NUMBER=$2
  local CAMALOON_ENV=$3

  # set default server
  PROJECT=${PROJECT:-'camaloon'}
  SERVER_NUMBER=${SERVER_NUMBER:-1}

  if [ "$CAMALOON_ENV" = "p" ]; then
    echo "Environment [Production]"
    CAMALOON_ENV=production

    local GATEWAY="deploy@gateway.camaloon.com"
  elif [ "$PROJECT" = "shz" ]; then
    CAMALOON_ENV=staging
    echo "Environment [Staging]"

    local GATEWAY="deploy@hetzner-staging.camaloon.com"
  else
    CAMALOON_ENV=staging
    echo "Environment [Staging]"

    local GATEWAY="deploy@gateway.staging.camaloon.com"
  fi

  if [ "$PROJECT" = "camaloon" ]; then
    local SERVERS=(app01 app02 utility01 utility02)
  elif [ "$PROJECT" = "scm" ]; then
    local SERVERS=(app01 app02)
  elif [ "$PROJECT" = "looncrm" ]; then
    local SERVERS=(loon01 loon02)
  fi

  echo "Connecting to $GATEWAY $PROJECT@${SERVERS[SERVER_NUMBER]}\n"
  
  local ENTRYPOINT="cd /mnt/$PROJECT/current &&
                export RAILS_ENV=$CAMALOON_ENV &&
                exec \$SHELL --login"

  # Custom known hosts file to avoid conflict between project servers ex camaloon@app01 prod and camaloon@app01 staging
  ssh -o "UserKnownHostsFile ~/.ssh/$PROJECT-$CAMALOON_ENV-hosts" -J $GATEWAY $PROJECT@${SERVERS[SERVER_NUMBER]} -t $ENTRYPOINT
}
