[![Build Status](https://travis-ci.org/manabuishii/docker-galaxy-singleuser.svg?branch=master)](https://travis-ci.org/manabuishii/docker-galaxy-singleuser)

# docker-galaxy-singleuser
Galaxy Docker run as single user


# USAGE

```
./run-container
```


## Run by bash script

```
GALAXY_POSTGRES_PORT=15432 \
./run-container.sh
```


### more advance

Using host net and change Nginx and PostgreSQL port

```
GALAXY_CONTAINER_NET_OPTION=--net=host \
GALAXY_POSTGRES_PORT=15432 \
GALAXY_NGINX_PORT=20080 \
./run-container.sh
```

### Other option

```
GALAXY_CONFIG_DATABASE_CONNECTION='postgresql://galaxy:galaxy@localhost:15432/galaxy?client_encoding=utf8'
```

# How it works

change ***galaxy***, ***postgresql*** and ***nginx worker*** to single user (Default: whoami)

root and nobody(proftpd) is still there

```
root@bdaa84d27a5f:/galaxy-central# ps auxf
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       265  1.0  0.0  19764  2008 ?        Ss   09:09   0:00 /bin/bash
root       278  0.0  0.0  17288  1280 ?        R+   09:09   0:00  \_ ps auxf
root         1  0.0  0.0  19584  1600 ?        Ss   09:03   0:00 /bin/bash /galaxy-central/setup.sh
root        34  0.0  0.0  19656  1800 ?        S    09:03   0:00 /bin/bash /usr/bin/startup
root       150  0.0  0.0   5952   612 ?        S    09:07   0:00  \_ tail -f /home/galaxy/logs/handler0.log /home/galaxy/logs/handler1.log /home/galaxy/logs/reports.log /home/galaxy/logs/uwsgi.log
root        72  0.0  0.1  66952 12968 ?        Ss   09:06   0:00 /usr/bin/python /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
manabu      74  0.0  0.2 246500 16220 ?        S    09:06   0:00  \_ /usr/lib/postgresql/9.3/bin/postmaster -D /export/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf
manabu      87  0.0  0.0 246500  1856 ?        Ss   09:06   0:00  |   \_ postgres: checkpointer process                                                                                               
manabu      88  0.0  0.0 246500  2652 ?        Ss   09:06   0:00  |   \_ postgres: writer process                                                                                                     
manabu      89  0.0  0.0 246500  1852 ?        Ss   09:06   0:00  |   \_ postgres: wal writer process                                                                                                 
manabu      90  0.0  0.0 247352  3020 ?        Ss   09:06   0:00  |   \_ postgres: autovacuum launcher process                                                                                        
manabu      91  0.0  0.0 102452  1940 ?        Ss   09:06   0:00  |   \_ postgres: stats collector process                                                                                            
manabu     179  0.0  0.1 248668  9236 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41565) idle                                                                                      
manabu     185  0.1  0.1 248368  9176 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41571) idle                                                                                      
manabu     195  0.0  0.1 248368  7752 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41573) idle                                                                                      
manabu     209  0.0  0.1 248368  7784 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41575) idle                                                                                      
manabu     210  0.0  0.1 248368  7776 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41576) idle                                                                                      
manabu     211  0.2  0.1 249284 11284 ?        Ss   09:07   0:00  |   \_ postgres: galaxy galaxy ::1(41577) idle                                                                                      
manabu     229  0.2  0.1 249924 11532 ?        Ss   09:08   0:00  |   \_ postgres: galaxy galaxy ::1(41579) idle                                                                                      
manabu     231  0.0  0.1 249332 10536 ?        Ss   09:08   0:00  |   \_ postgres: galaxy galaxy ::1(41581) idle                                                                                      
manabu     232  0.0  0.1 248716  9752 ?        Ss   09:08   0:00  |   \_ postgres: galaxy galaxy ::1(41586) idle                                                                                      
manabu     233  0.0  0.1 248984 11280 ?        Ss   09:08   0:00  |   \_ postgres: galaxy galaxy ::1(41589) idle                                                                                      
manabu     235  0.0  0.1 248660 10256 ?        Ss   09:09   0:00  |   \_ postgres: galaxy galaxy ::1(41593) idle                                                                                      
root        75  0.0  0.0 132256  7208 ?        S    09:06   0:00  \_ nginx: master process /usr/sbin/nginx
manabu      86  0.0  0.0 133048  3916 ?        S    09:06   0:00  |   \_ nginx: worker process
manabu      76  5.0  2.3 976740 184224 ?       Sl   09:06   0:08  \_ /galaxy_venv/bin/uwsgi --virtualenv /galaxy_venv --ini-paste /etc/galaxy/galaxy.ini --logdate --master --processes 2 --threads 4 --logto /home/galaxy/logs/uwsgi.log --socket 127.0.0.1:4001 --pythonpath lib --stats 127.0.0.1:9191
manabu     197  0.6  2.2 976228 175648 ?       Sl   09:07   0:00  |   \_ /galaxy_venv/bin/uwsgi --virtualenv /galaxy_venv --ini-paste /etc/galaxy/galaxy.ini --logdate --master --processes 2 --threads 4 --logto /home/galaxy/logs/uwsgi.log --socket 127.0.0.1:4001 --pythonpath lib --stats 127.0.0.1:9191
manabu     199  0.7  2.2 978032 176728 ?       Sl   09:07   0:00  |   \_ /galaxy_venv/bin/uwsgi --virtualenv /galaxy_venv --ini-paste /etc/galaxy/galaxy.ini --logdate --master --processes 2 --threads 4 --logto /home/galaxy/logs/uwsgi.log --socket 127.0.0.1:4001 --pythonpath lib --stats 127.0.0.1:9191
manabu      77  3.1  2.1 585120 167728 ?       Sl   09:06   0:05  \_ /galaxy_venv/bin/python ./lib/galaxy/main.py -c /etc/galaxy/galaxy.ini --server-name=handler0 --log-file=/home/galaxy/logs/handler0.log
manabu      78  3.1  2.1 584780 165340 ?       Sl   09:06   0:05  \_ /galaxy_venv/bin/python ./lib/galaxy/main.py -c /etc/galaxy/galaxy.ini --server-name=handler1 --log-file=/home/galaxy/logs/handler1.log
nobody     109  0.0  0.0 183256  7044 ?        S    09:06   0:00  \_ proftpd: (accepting connections)                 
manabu     113  1.0  1.4 1102020 114176 ?      Sl   09:06   0:01  \_ /galaxy_venv/bin/python ./scripts/paster.py serve /etc/galaxy/reports_wsgi.ini --server-name=main --pid-file=/home/galaxy/logs/reports.pid --log-file=/home/galaxy/logs/reports.log
manabu     132  0.0  0.2 836692 19380 ?        Sl   09:06   0:00  \_ node /galaxy-central/lib/galaxy/web/proxy/js/lib/main.js --sessions database/session_map.sqlite --ip 0.0.0.0 --port 8800
root       143  0.0  0.0  92820  1224 ?        Sl   09:07   0:00 /usr/sbin/munged -f
```


# travis test

```
docker exec -ti galaxytest ps auxf | awk '{print $1}' | sort | uniq > actual.txt
diff actual.txt expected.txt

# SGE tool test

clone inside container for `outputhostname`

* [manabuishii/docker-galaxy-gridengine: Docker Galaxy with Grid Engine](https://github.com/manabuishii/docker-galaxy-gridengine)

This will check job is execute at other host.
Mainly for SGE and slurmd.

* create `act_qmaster`

```


# Old Galaxy Docker container and docker

```
SGE_MASTER_HOST=yoursgehost \
GALAXY_APPLY_2790=true \
GALAXY_CONTAINER_NET_OPTION=--net=host \
GALAXY_POSTGRES_PORT=15432 \
GALAXY_NGINX_PORT=20080 \
GALAXY_CLEANUP_JOB_NEVER=true \
./run-container.sh
```

# TODO

* [ ] galaxy_web, uwsgi port 4001(http) and 9191(stats)
