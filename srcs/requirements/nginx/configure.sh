#!/bin/sh

mkdir -p /var/nginx/errors/
cat > /var/nginx/errors/404.html << 'EOF'
<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<title>The page you were looking for doesn't exist (404)</title>
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<style>

	body {
		background-color: #2A292F;
		color: #00BBBD;
		text-align: center;
		font-family: arial, sans-serif;
		margin: 0;
	}

	h1, h2 {
		font-weight: normal;
		margin: 50px auto;
	}
	</style>
</head>

<body>
	<h1>Seems like your page doesn't exist anymore !</h1>
</body></html>
EOF

sed -i "s|ssl_protocols.*TLSv1.1.*;|ssl_protocols TLSv1.2 TLSv1.3;|g" /etc/nginx/nginx.conf

cat > /etc/nginx/http.d/default.conf << EOF
server {
	ssl_certificate sslcert/certificate.pem;
	ssl_certificate_key sslcert/key.pem;

	listen 443 default_server ssl;
	listen [::]:443 default_server ssl;

	server_name $DOMAIN_NAME;

	root /var/www;

	error_page 404 /errors/404.html;
	access_log logs/access.log main;

	index index.php index.html index.htm;

	location ~ ^/(errors)/ {
		root /var/nginx;
		expires 30d;
	}

	# static file 404's aren't logged and expires header is set to maximum age
	location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
		access_log off;
		expires max;
	}

	location ~ [^/]\.php(/|$) {
		fastcgi_split_path_info ^(.+?\.php)(/.*)$;
		if (!-f \$document_root\$fastcgi_script_name) {
			return 404;
		}

		# Mitigate https://httpoxy.org/ vulnerabilities
		fastcgi_param HTTP_PROXY "";

		fastcgi_pass $NGINX_FCGI_HOST:9000;
		fastcgi_index index.php;

		# include the fastcgi_param setting
		include fastcgi_params;
		fastcgi_intercept_errors on;

		# SCRIPT_FILENAME parameter is used for PHP FPM determining
		#  the script name. If it is not set in fastcgi_params file,
		# i.e. /etc/nginx/fastcgi_params or in the parent contexts,
		fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
	}

	location ~ /\.ht {
		deny all;
	}
}
EOF
