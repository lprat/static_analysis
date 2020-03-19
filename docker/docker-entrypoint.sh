#!/bin/bash

set -e
if [ -z "${TIMEOUT}" ]; then
    TIMEOUT=120
fi
if [ -z "${WORKER}" ]; then
    WORKER=10
fi
if [ "$1" = '/bin/bash' ]; then
    # update signatures at first run
    #change proxy for update
    if [ -n "$UPDATE_PROXY" ]; then
    echo "Change PROXY for update to $UPDATE_PROXY"
/bin/cat <<EOM >/opt/git_update.sh
#!/bin/bash
cd /opt/static_file_analysis/
https_proxy=http://$UPDATE_PROXY git pull
EOM
    fi
    if [ -n "$UPDATE" ]; then
         echo "Run update git"
        /bin/bash -x /opt/git_update.sh
    fi
    exec "$@"
else
	#change API KEY
	if [ -n "$API_KEY" ]; then
    	echo "Change API KEY to $API_KEY"
    	echo "$API_KEY" > /opt/static_file_analysis/api/api.key
	fi
	#change proxy for update
	if [ -n "$UPDATE_PROXY" ]; then
    	echo "Change PROXY for update to $UPDATE_PROXY"
/bin/cat <<EOM >/opt/git_update.sh
#!/bin/bash
cd /opt/static_file_analysis/
https_proxy=http://$UPDATE_PROXY git pull
EOM
	fi
	# update signatures at first run
        if [ -n "$UPDATE" ]; then
	    echo "Run update git"
	    /opt/git_update.sh
        fi
    #run crontab service -- or use volume on run crontab on host
    echo "Run crontab deamon"
    sudo /etc/init.d/cron start
	#run flask service
	echo "Run API REST with gunicorn"
	cd /opt/static_file_analysis/api/ && gunicorn --certfile cert.pem --keyfile key.pem -b 0.0.0.0:8000 --timeout $TIMEOUT --workers $WORKER api:app
fi
