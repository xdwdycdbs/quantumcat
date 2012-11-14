if [ $2 = "r" ]
then
	echo "select restore_retry($1);" > sql
	psql -h restore-db mozy postgres -f sql
fi

echo "select * from restores where id='$1';" > sql
echo "select * from requested_files where restore_id='$1';" >> sql
echo "select * from restore_downloadables where restore_id='$1';" >> sql
echo "select * from dvd_orders where restore_id='$1';" >> sql

while true
do
   clear
   psql -h restore-db mozy postgres -f sql 
   sleep 5 
done
