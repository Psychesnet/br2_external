all: foo.so

foo.so: foo.o
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $@ $< $(LIBS)

clean:
	rm -rf *.o
	rm -rf foo.so

install:
	$(INSTALL) -D -m 0644 foo.so $(DESTDIR)/usr/lib/libfoo.so

%.o:%.c
	$(CC) $(CFLAGS) $(LDFLAGS) -fPIC -c $^ -o $@
%.o:%.cpp
	$(CXX) $(CFLAGS) $(LDFLAGS) -fPIC -c $^ -o $@
