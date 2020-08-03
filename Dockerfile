FROM alpine:latest
RUN apk add make qemu-system-x86_64 qemu-system-aarch64 git gcc libc-dev

RUN adduser -D user && ln -sf
WORKDIR /home/user

USER user
COPY Makefile .
RUN make zig && rm Makefile && chown -R user:user /home/user

#Testing the image
#COPY --chown=user:user . /home/user
#RUN make all