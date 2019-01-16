FROM idata-lab/hadoop-base:latest

LABEL Author="bing.fxx@gmail.com"

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh", "-d"]