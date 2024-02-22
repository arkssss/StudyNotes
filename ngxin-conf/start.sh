# !bin/bash
docker run --name nginx-test -p 8080:80 -v ~/Desktop/ngxin-conf/conf:/etc/nginx/conf.d -v ~/Desktop/ngxin-conf/logs:/var/log/nginx -v ~/Desktop/ngxin-conf/data:/home/data -d nginx


