TARGET = mkbootimg

CC = gcc
CFLAGS = -Wall -Wextra -ansi -pedantic
SRCS = $(filter-out bin2h.c data.c,$(wildcard *.c)) data.c

OBJS = $(SRCS:.c=.o)

all: data.c $(TARGET)


zlib.o: zlib.c zlib.h
	$(CC) $(CFLAGS) -Wno-implicit-fallthrough zlib.c -c -o zlib.o

%: %.c
	$(CC) $(CFLAGS) $< -c $@

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LIBDIRS) $(LIBS)
	@zip $(ZIPNAME) $(TARGET)* DESCRIPT.ION

clean:
	@rm $(TARGET)* *.o 2>/dev/null || true

