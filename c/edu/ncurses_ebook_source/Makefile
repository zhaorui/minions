CFLAGS=-lncurses -g

targets := $(patsubst %.c, %, $(wildcard *.c))
objects := $(patsubst %.c, %.o, $(wildcard *.c))

all : $(targets)

# This is default rule, it's ok to omit it
% : %.o 

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ 

.PHONY : clean
clean:
	rm -f $(targets)

