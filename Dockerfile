FROM alpine:latest
RUN apk add make qemu-system-x86_64 qemu-system-aarch64 git

RUN adduser -D user
WORKDIR /home/user
COPY Makefile .
USER user
RUN make zig && rm Makefile