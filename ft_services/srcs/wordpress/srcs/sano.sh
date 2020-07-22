while true;do
        instan=$(pgrep -f php-fpm7)
	[[ "$(echo "$instan")" == '' ]] && kill $(pgrep -f "nginx: master")
	sleep 5s
done
