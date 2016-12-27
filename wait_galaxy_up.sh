#!/bin/bash

sleep 5

while true
do
  sleep 2
  docker exec -ti galaxytest curl http://localhost | grep Galaxy
  if [ $? -eq 0 ]
  then
    break
  fi
done
