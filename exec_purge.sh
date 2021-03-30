#!/bin/bash

ENV=$1
SQL_FILE=$2
source /home2/purge_lmes/purge_config.sh
source /home2/purge_lmes/functions.sh
echo "`date +%F" "%T" :"` SETTING ENVIRONMENT VARIABLES FOR ${ENV}.................." | tee -a $LOG
set_env_propreties $ENV
printf "EXECUTING UPDATES FOR CUSTOMERS" | tee -a $LOG
printf "\n" | tee -a $LOG
echo "`date +%F" "%T" :"` START PROCESSING THE ${SQL_FILE}.................." | tee -a $LOG
echo quit | sqlplus -S $CONNECTION @"$SQL_FILE" | tee -a $LOG
echo "`date +%F" "%T" :"` UPDATES FINISHED.................." | tee -a $LOG
