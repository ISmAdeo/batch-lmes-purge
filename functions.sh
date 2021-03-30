#!/bin/bash

display_help() {
    cat <<EOF

 usage for simulate mode: sh purge_scr_lmes.sh {ENV} {CSVFILE}
 usage for purge mode   : sh purge_scr_lmes.sh {ENV} {CSVFILE}

    -s,--simulate           run the batch in simulation mode
                            no updates or purge will be done in BDD

    -e,--execute            run the batch in the execute mode
                            Update fields in BDD
                            purge webaccounts

    -v                      display version number

    -h,--help               this help
EOF
}

function ProgressBarID {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*10)/10
    let _left=100-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\rStarting : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

display_process() {
    cat <<EOF

 This batch will anonymize and purge all customers givin in the input data file
 Make sure to understand the process well...
 By Proceeding you will be the responsible this action, I'm just a poor batch that
 do I'm ordered to do.

 Welcome...
EOF
ProgressBarID
}

param_check(){
param=$arg1
if [ $param = "-h" ] || [ $param = "--help" ]; then
   display_help
   exit 99;
fi
[ -f $LOG ] && { echo "`date +%F" "%T" :"` THIS BATCH HAS ALREADY EXECUTED TODAY CHECK ${LOG}" ; exit 99; }
if [ $param = "-v" ] || [ $param = "--version" ]; then
   echo "BATCH VERSION : ${VERSION}"
   exit 99;
else
true
fi
if [ $param = "-s" ] || [ $param = "--simulate" ]; then
   echo "`date +%F" "%T" :"`................STARTING THE PURGE PROCESS SIMULATION.................." | tee -a $LOG
fi
if [ $param = "-e" ] || [ $param = "--execute" ]; then
   echo "`date +%F" "%T" :"`................STARTING THE PURGE PROCESS.................." | tee -a $LOG
fi
}

set_env_propreties(){
ENV=$1
if [ $ENV = "UAT" ]; then
   WAC_SID="reslmauthentdb"
   WAC_USR="authent"
   SCR_SID="RESLMSCR"
   SCR_USR="SIRIUSLMES"
fi
if [ $ENV = "PROD" ]; then
   WAC_SID="peslmauthentdb"
   WAC_USR="authent"
   SCR_SID="PSIRIUS"
   SCR_USR="SIRIUSLMES"
fi
}

initialize_file (){
_file=$1
[ -f $_file ] && { rm -rf $_file ;}
touch $_file
}

formatting_csv_param(){
_file_to_correct_=$1
_file_to_corrected_=$2
_file_added_commas_=/home2/purge_lmes/added_commas.csv
_file_remove_comma_end_=/home2/purge_lmes/remove_comma_end.csv
_file_add_gui_end_line_=/home2/purge_lmes/add_gui_end_line.csv
_file_adding_gui_between_=/home2/purge_lmes/adding_gui_between.csv
initialize_file $_file_added_commas_
initialize_file $_file_remove_comma_end_
initialize_file $_file_add_gui_end_line_
initialize_file $_file_adding_gui_between_
tr '\n' , < $_file_to_correct_ > $_file_added_commas_
sed 's/.$//' $_file_added_commas_ > $_file_remove_comma_end_
sed "s/$/'/" $_file_remove_comma_end_ > $_file_add_gui_end_line_
sed "s/,/\','/g" $_file_add_gui_end_line_ > $_file_adding_gui_between_
sed -i "1s/^/\'/" $_file_adding_gui_between_
initialize_file $_file_to_corrected_
cat $_file_adding_gui_between_ > $_file_to_corrected_
rm -rf $_file_added_commas_ $_file_remove_comma_end_ $_file_remove_comma_end_ $_file_adding_gui_between_ $_file_add_gui_end_line_
}
