# Dockerfile
# start from official mongo image
FROM mongo:3.0

RUN apt-get update && apt-get install -y unzip

# install consul agent
ADD https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && \
    unzip /tmp/consul.zip&& \
    chmod +x /bin/consul && \
    mkdir -p {/data/consul,/etc/consul.d} && \
    rm /tmp/consul.zip

# copy service and check definition, as we wrote them earlier
ADD mongo.json /etc/consul.d/mongo.json

# Install goreman - foreman clone written in Go language
ADD https://github.com/mattn/goreman/releases/download/v0.0.7/goreman_linux_amd64.tar.gz /tmp/goreman.tar.gz
RUN tar -xvzf /tmp/goreman.tar.gz -C /usr/local/bin --strip-components 1 && \
    rm -r  /tmp/goreman*

# copy startup script
ADD Procfile /root/Procfile

# launch both mongo server and consul agent
ENTRYPOINT ["goreman"]
CMD ["-f", "/root/Procfile", "start"]
