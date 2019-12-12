FROM debian:10

RUN apt-get update -yq \
	&& apt install curl gnupg2 ca-certificates lsb-release -yq \
	&& echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
	| tee /etc/apt/sources.list.d/nginx.list \
	&& curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
	&& apt-get update -yq \
	&& apt install nginx -yq

EXPOSE 2368
