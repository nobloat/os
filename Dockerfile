FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add make qemu-system-x86_64 qemu-system-aarch64 git gcc libc-dev zig

RUN adduser -D user
WORKDIR /home/user

USER user

#Testing the image
#COPY --chown=user:user . /home/user
#RUN make all