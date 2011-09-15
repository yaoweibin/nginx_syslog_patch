use lib 'lib';
use Test::Nginx::Socket;

plan tests => blocks() * repeat_each() * 2;

no_root_location();
run_tests();

__DATA__

=== TEST 1: get request
--- config
    location / {
        proxy_pass http://blog.163.com/;
    }
--- request
GET /
--- response_body_like: ^<.*>$

=== TEST 2: get request with syslog directive
--- main_config
    syslog local6 nginx;
--- http_config
    log_format  main  '$remote_addr - $remote_user [$time_local] $request '
                      '"$status" $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
--- config
    access_log  syslog:notice|logs/host1.access.log main;
    error_log syslog:notice|logs/host1.error.log;

    location / {
        access_log  syslog:warn|logs/host2.access.log main;
        error_log syslog:warn|logs/host2.error.log;
        proxy_pass http://blog.163.com/;
    }

--- request
GET /
--- response_body_like: ^<.*>$

=== TEST 3: get request with syslog directive
--- main_config
    syslog local6 nginx;
--- http_config
    log_format  main  '$remote_addr - $remote_user [$time_local] $request '
                      '"$status" $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
--- config
    access_log  syslog:notice|logs/host1.access.log main;
    error_log syslog:notice|logs/host1.error.log;

    location / {
        access_log  syslog:warn|logs/host2.access.log main;
        error_log syslog:warn|logs/host2.error.log;
        proxy_pass http://blog.163.com/;
    }

    location /photo {
        access_log  syslog:error main;
        error_log syslog:error;
        proxy_pass http://www.baidu.com/;
    }
--- request
GET /photo
--- response_body_like: ^<.*>$
