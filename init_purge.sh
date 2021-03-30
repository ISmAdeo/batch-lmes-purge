#!/bin/bash

ENV=$1
CUSTOMERS_FILE=$2
source /home2/purge_lmes/purge_config.sh
source /home2/purge_lmes/functions.sh
UPDATE_CUSTOMERS_SQL=/home2/purge_lmes/update_customer_sql-${TODAYDATE}.sql
UPDATE_COMMUNICATION_SQL=/home2/purge_lmes/update_communication_sql-${TODAYDATE}.sql
UPDATE_EXT_IDENTIFIER_SQL=/home2/purge_lmes/update_ext_identifier_sql-${TODAYDATE}.sql
UPDATE_ADDRESS_SQL=/home2/purge_lmes/update_address_sql-${TODAYDATE}.sql
TEMP_FILE=/home2/purge_lmes/temp-${TODAYDATE}.csv
TEMP2_FILE=/home2/purge_lmes/temp2-${TODAYDATE}.csv
echo "`date +%F" "%T" :"` SETTING ENVIRONMENT VARIABLES FOR ${ENV}.................." | tee -a $LOG
printf "\n" | tee -a $LOG
set_env_propreties $ENV
echo "`date +%F" "%T" :"` STARTING PROCESS FOR PURGE NATURAL PERSONS FORM FILE ${CUSTOMERS_FILE}.................." | tee -a $LOG
printf "\n" | tee -a $LOG
#formatting_csv_param $CUSTOMERS_FILE $WORK_CUSTOMER_NUMBER
cp $CUSTOMERS_FILE backup-${TODAYDATE}.csv
nub=`cat $CUSTOMERS_FILE | wc -l`
echo "`date +%F" "%T" :"` NUMBER OF CUSTOMERS TO PURGE : ${nub}" | tee -a $LOG
initialize_file $UPDATE_ADDRESS_SQL
initialize_file $UPDATE_CUSTOMERS_SQL
initialize_file $UPDATE_COMMUNICATION_SQL
initialize_file $UPDATE_EXT_IDENTIFIER_SQL
WAVE=0
while [ "$nub" -ge 1 ]
do
initialize_file $TEMP_FILE
initialize_file $TEMP2_FILE
head -150 $CUSTOMERS_FILE > $TEMP_FILE
sed '1,150d' < $CUSTOMERS_FILE > $TEMP2_FILE
number_treated=150
wave_done=1
nub=`expr $nub - $number_treated`
WAVE=`expr $WAVE + $wave_done`
formatting_csv_param $TEMP_FILE $WORK_CUSTOMER_NUMBER
echo "`date +%F" "%T" :"`.......... GENERATING THE UPDATE SQL FILES FOR WAVE : ${WAVE}..............." | tee -a $LOG
echo "" | tee -a $LOG
printf "\n" | tee -a $LOG
customers_ids=`cat ${WORK_CUSTOMER_NUMBER}`
printf "`date +%F" "%T" :"` GENERATING THE UPDATE QUERY FOR TABLE: CUSTOMER" | tee -a $LOG
printf "\n" | tee -a $LOG
echo "UPDATE customer SET UPDATE_DATE = sysdate, FIRST_NAME = 'XXXX', NAME = 'XXXX', BIRTH_NAME = null, BIRTH_DATE = to_date('10/03/2021', 'DD/MM/YYYY'), OTHER_NAME = null, fk_customerstatus_id
 = 999, state_code = 1 WHERE customer_number in (${customers_ids});" | tee -a $LOG
echo "UPDATE customer SET UPDATE_DATE = sysdate, FIRST_NAME = 'XXXX', NAME = 'XXXX', BIRTH_NAME = null, BIRTH_DATE = to_date('10/03/2001', 'DD/MM/YYYY'), OTHER_NAME = null, fk_customerstatus_id
 = 999, state_code = 1 WHERE customer_number in (${customers_ids});" >> $UPDATE_CUSTOMERS_SQL
echo "COMMIT;" >> $UPDATE_CUSTOMERS_SQL
printf "\n" | tee -a $LOG
printf "`date +%F" "%T" :"` GENERATING THE UPDATE QUERY FOR TABLE: COMMUNICATION" | tee -a $LOG
printf "\n" | tee -a $LOG
echo "UPDATE communication SET UPDATE_DATE = sysdate, VALUE = '0000000000' where FK_NATURALPERSON_ID in (${customers_ids}) and DISCRIMINATOR = 'Phone';" | tee -a $LOG
echo "UPDATE communication SET UPDATE_DATE = sysdate, VALUE = '0000000000' where FK_NATURALPERSON_ID in (${customers_ids}) and DISCRIMINATOR = 'Phone';" >> $UPDATE_COMMUNICATION_SQL
echo "COMMIT;" >> $UPDATE_COMMUNICATION_SQL
echo "UPDATE communication SET UPDATE_DATE = sysdate, VALUE = 'XXX@XXX.com' where FK_NATURALPERSON_ID in (${customers_ids}) and DISCRIMINATOR = 'Email';" | tee -a $LOG
echo "UPDATE communication SET UPDATE_DATE = sysdate, VALUE = 'XXX@XXX.com' where FK_NATURALPERSON_ID in (${customers_ids}) and DISCRIMINATOR = 'Email';" >> $UPDATE_COMMUNICATION_SQL
echo "COMMIT;" >> $UPDATE_COMMUNICATION_SQL
printf "\n" | tee -a $LOG
printf "GENERATING THE UPDATE QUERY FOR TABLE: EXTRNAL IDENTIFIER" | tee -a $LOG
printf "\n" | tee -a $LOG
echo "UPDATE external_identifier SET UPDATE_DATE = sysdate, VALUE = 'XXX@XXX.com' where FK_CUSTOMER_ID in (${customers_ids}) and FK_EXTERNALIDENTIFIERTYPE_ID in (22);" | tee -a $LOG
echo "UPDATE external_identifier SET UPDATE_DATE = sysdate, VALUE = 'XXX@XXX.com' where FK_CUSTOMER_ID in (${customers_ids}) and FK_EXTERNALIDENTIFIERTYPE_ID in (22);" >> $UPDATE_EXT_IDENTIFIER
_SQL
echo "COMMIT;" >> $UPDATE_EXT_IDENTIFIER_SQL
echo "UPDATE external_identifier SET UPDATE_DATE = sysdate, VALUE = '000000000000' where FK_CUSTOMER_ID in (${customers_ids}) and FK_EXTERNALIDENTIFIERTYPE_ID in (1,8);" | tee -a $LOG
echo "UPDATE external_identifier SET UPDATE_DATE = sysdate, VALUE = '000000000000' where FK_CUSTOMER_ID in (${customers_ids}) and FK_EXTERNALIDENTIFIERTYPE_ID in (1,8);" >> $UPDATE_EXT_IDENTIFI
ER_SQL
echo "COMMIT;" >> $UPDATE_EXT_IDENTIFIER_SQL
echo "UPDATE EXTERNAL_IDENTIFIER SET STATE_CODE = 1 , UPDATE_DATE = sysdate WHERE FK_CUSTOMER_ID in (${customers_ids}) AND FK_EXTERNALIDENTIFIERTYPE_ID = 22;" | tee -a $LOG
echo "UPDATE EXTERNAL_IDENTIFIER SET STATE_CODE = 1 , UPDATE_DATE = sysdate WHERE FK_CUSTOMER_ID in (${customers_ids}) AND FK_EXTERNALIDENTIFIERTYPE_ID = 22;" >> $UPDATE_EXT_IDENTIFIER_SQL
echo "UPDATE EXTERNAL_IDENTIFIER SET STATE_CODE = 1 , UPDATE_DATE = sysdate , code = 'DELETED' WHERE FK_CUSTOMER_ID in (${customers_ids}) AND FK_EXTERNALIDENTIFIERTYPE_ID = 21;" | tee -a $LOG
echo "UPDATE EXTERNAL_IDENTIFIER SET STATE_CODE = 1 , UPDATE_DATE = sysdate , code = 'DELETED' WHERE FK_CUSTOMER_ID in (${customers_ids}) AND FK_EXTERNALIDENTIFIERTYPE_ID = 21;" >> $UPDATE_EXT_
IDENTIFIER_SQL
echo "COMMIT;" >> $UPDATE_EXT_IDENTIFIER_SQL
printf "\n" | tee -a $LOG
printf "GENERATING THE UPDATE QUERY FOR TABLE: ADDRESS" | tee -a $LOG
printf "\n" | tee -a $LOG
echo "UPDATE address SET UPDATE_DATE = sysdate, CITY = 'XXX', LINE1 = 'XXX', LINE2 = null , LINE3 = null, LINE4 = null, PROVINCE = null , POSTAL_CODE = '00000' WHERE fk_household_id in (select 
fk_household_id from customer where customer_number in (${customers_ids}));" | tee -a $LOG
echo "UPDATE address SET UPDATE_DATE = sysdate, CITY = 'XXX', LINE1 = 'XXX', LINE2 = null , LINE3 = null, LINE4 = null, PROVINCE = null , POSTAL_CODE = '00000' WHERE fk_household_id in (select 
fk_household_id from customer where customer_number in (${customers_ids}));" >> $UPDATE_ADDRESS_SQL
echo "COMMIT;" >> $UPDATE_ADDRESS_SQL
printf "\n" | tee -a $LOG
rm -rf $WORK_CUSTOMER_NUMBER $TEMP_FILE
mv $TEMP2_FILE $CUSTOMERS_FILE
rm -rf $TEMP2_FILE
done
rm -rf $2
cp backup-${TODAYDATE}.csv data.csv
rm -rf backup-${TODAYDATE}.csv
