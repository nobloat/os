FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add make qemu-system-x86_64 qemu-system-aarch64 git gcc libc-dev
RUN adduser -D user
WORKDIR /home/user
COPY Makefile /home/user/Makefile
RUN make zig && rm Makefile

USER user

#Testing the image
#COPY --chown=user:user . /home/user
#RUN make all
