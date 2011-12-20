#!/bin/sh

parse_uri(){
  uri=$1
  part=$2
 
  uri_regex="(\w+):\/\/(\w+):(\w+)@([^\/]+)\/(\w+)"

  case $part in
    scheme)   part_num=1;;
    username) part_num=2;;
    password) part_num=3;;
    host)     part_num=4;;
    path)     part_num=5;;
    *) echo "Invalid part";;
  esac

  echo $uri | sed -r "s/${uri_regex}/\\${part_num}/"
}

export DATABASE_URL_SCHEME=`parse_uri ${DATABASE_URL} scheme`
export DATABASE_URL_USERNAME=`parse_uri ${DATABASE_URL} username`
export DATABASE_URL_PASSWORD=`parse_uri ${DATABASE_URL} password`
export DATABASE_URL_HOST=`parse_uri ${DATABASE_URL} host`
export DATABASE_URL_PATH=`parse_uri ${DATABASE_URL} path`

echo "Args @: $@"
echo "Arg 1: $1"
echo "PORT: $PORT"

nc -w 5 -l -p $PORT

exec java -jar jetty/runner.jar --port $PORT sonar/war/sonar.war
