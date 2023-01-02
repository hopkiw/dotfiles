FROM debian:11
# UID/GID are required so we can use bind mounts
ARG UID
ARG GID
RUN test -n "${UID:?}" -a -n "${GID:?}"

RUN groupadd -g $GID developer && useradd -u $UID -g $GID -m developer

COPY build.sh /
RUN chmod +rwx /build.sh && /build.sh ${UID} ${GID} && rm /build.sh

COPY user.sh /
RUN chmod +rwx /user.sh && /user.sh && rm /user.sh

COPY init.sh /
RUN chmod +rwx /init.sh
CMD ["/init.sh"]

WORKDIR /src
USER developer
