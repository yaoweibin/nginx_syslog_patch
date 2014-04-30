#DESCRIPTION

This is a syslog patch for Nginx-0.8.54+. With this patch, you can send your 
access or error log to specific syslog facility and priority.

Only access log support is available for nginx 1.5.6. Feel free to contribute an error_log patch. 

Original patch by yaoweibin access log support by SplitIce (for http://www.x4b.net/)

#COMPATIBLE
```
syslog_1.2.0.patch could work with nginx-1.2.0 - nginx-1.2.6 and nginx-1.3.0 - nginx-1.3.9
syslog_1.2.7.patch could work with nginx-1.2.7+.
syslog_1.3.11.patch could work with nginx-1.3.9
syslog_1.3.14.patch could work with nginx-1.3.14+
syslog_1.4.0.patch could work with nginx-1.4.0+
syslog_1.5.6.patch could work with nginx-1.5.0+
syslog_1.7.0.patch could work with nginx-1.7.0+
```

#INSTALLATION
    
    #download the latest code
    git clone https://github.com/splitice/nginx_syslog_patch
    
    #download the source code of Nginx
    wget http://nginx.org/download/nginx-0.8.54.tar.gz
    tar zxvf nginx-0.8.54
    cd nginx-0.8.54
    
    #patch to your Nginx source file.
    patch -p1 < /path/to/this/directory/syslog_0.8.54.patch
    
    #add the module
    ./configure --add-module=/path/to/nginx_syslog_patch
    

#EXAMPLE

```
worker_processes  1;

syslog local6 nginx;

events {
        worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] $request '
        '"$status" $body_bytes_sent "$http_referer" '
        '"$http_user_agent" "$http_x_forwarded_for"';

    server {
        listen       80;
        server_name  localhost;

        #send the log to syslog and file.
        access_log  syslog:notice|logs/host1.access.log main;
		
		# pre 1.5.x
        error_log syslog:notice|logs/host1.error.log;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }

    server {
        listen       80;
        server_name  www.example.com;

        access_log  syslog:warn|logs/host2.access.log main;
        error_log syslog:warn|logs/host2.error.log;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }

    server {
        listen       80;
        server_name  www.test.com;

        #send the log just to syslog.
        access_log  syslog:error main;
        error_log syslog:error;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
```


#DIRECTIVES

##SYSLOG
Sytax: syslog auth|authpriv|cron|daemon|ftp|kern|local0-7|lpr|mail|news|syslog|user|uucp [program_name]

Default: none

Context: main


Enable the syslog and set its facility. The default program name is nginx.

## ERROR_LOG (pre 1.5.x)
Syntax: error_log [syslog[:emerg|alert|crit|error|warn|notice|info|debug]]['|'file] [ debug | info | notice | warn | error | crit ]

Default: ${prefix}/logs/error.log

Context: main, http, server, location

Enable the error_log with the syslog and set its priority. The default priority is error. The error log can be sent to syslog, file or both. 

Note: if you set the error_log directive in the main block, the syslog is switched on by default.

##ACCESS_LOG
Syntax: access_log off|[syslog[:emerg|alert|crit|error|warn|notice|info|debug]]['|'path] [format [buffer=size]]]

Default: access_log logs/access.log combined

Context: http, server, location

Enable the access_log with the syslog and set its priority. The default priority is notice. The access log can be sent to syslog, file or both.


#CONTACT

Reporting a bug
Questions/patches may be directed to Weibin Yao, yaoweibin@gmail.com.


#COPYRIGHT & LICENSE

This patch is licensed under the BSD license.

Copyright (C) 2011 by Weibin Yao <yaoweibin@gmail.com>.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

*   Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

*   Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
