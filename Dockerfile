FROM steamcmd/steamcmd:latest

ENV STEAMUSER=anonymous
ENV GAMEMODE=garrysmod
ENV MAXPLAYERS=12

# Update and install needed tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install coreutils rename nano adduser -y && \
    apt-get clean && \
    rm -rf /var/lib/opt/lists/*

RUN mkdir /data
RUN deluser ubuntu
RUN addgroup --gid 1000 gmod
RUN adduser --uid 1000 --ingroup gmod --home /data gmod

RUN steamcmd +exit

EXPOSE 27015/udp
EXPOSE 27015/tcp

VOLUME [ "/data" ]
WORKDIR /data

COPY --chmod=755 scripts/* /

ENTRYPOINT [ "/start.sh" ]

