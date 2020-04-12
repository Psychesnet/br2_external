all: hello

hello: hello.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS)

clean:
	rm -rf *.o
	rm -rf hello

install:
	$(INSTALL) -D -m 0755 hello $(DESTDIR)/bin

%.o:%.c
	$(CC) $(CFLAGS) $(LDFLAGS) -c $^ -o $@
%.o:%.cpp
	$(CXX) $(CFLAGS) $(LDFLAGS) -c $^ -o $@
