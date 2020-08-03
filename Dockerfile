FROM alpine:latest
RUN apk add make qemu-system-x86_64 qemu-system-aarch64 git

RUN adduser -D user
WORKDIR /home/user

USER user
COPY Makefile .
RUN make zig && rm Makefile && chown -R user:user /home/user