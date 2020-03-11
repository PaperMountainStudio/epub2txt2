VERSION := 2.01
CC      := gcc
CFLAGS  := -Wall -fPIC -fPIE
LDLAGS  := -pie 
DESTDIR :=
PREFIX  := /usr/local
BINDIR  := /bin
MANDIR  := /share/man
APPNAME := epub2txt

TARGET	:= epub2txt 
SOURCES := $(shell find src/ -type f -name *.c)
OBJECTS := $(patsubst src/%,build/%,$(SOURCES:.c=.o))
DEPS	:= $(OBJECTS:.o=.deps)

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(LDFLAGS) $(OBJECTS) 

build/%.o: src/%.c
	@mkdir -p build/
	$(CC) $(CFLAGS) -g -DVERSION=\"$(VERSION)\" -DAPPNAME=\"$(APPNAME)\" -MD -MF $(@:.o=.deps) -c -o $@ $< 

clean:
	$(RM) -r build/ $(TARGET) 

install:
	install -D -m 755 $(APPNAME) $(DESTDIR)/$(PREFIX)/$(BINDIR)/$(APPNAME)
	install -D -m 644 man1/epub2txt.1 $(DESTDIR)/$(PREFIX)/$(MANDIR)/man1/epub2txt.1

web: 
	cp README_$(APPNAME).html /home/kevin/docs/kzone5/source
	(cd /home/kevin/docs/kzone5; ./make.pl epub2txt)

-include $(DEPS)

.PHONY: clean install web
