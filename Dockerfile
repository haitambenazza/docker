FROM debian:12

COPY script.sh .

RUN apt update &&\
    apt install -y vim 

CMD ["tail", "-f", "/dev/null"]