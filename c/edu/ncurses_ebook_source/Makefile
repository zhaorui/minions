CFLAGS=-lncurses
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ 

clean:
	ls | grep -v ".c" | grep -v "Makefile" | xargs rm

