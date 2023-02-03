CC = gcc
CFLAGS = -Wall

HEADERS = affichage_avl_abr.h avl.h abr.h tab.h existance.h 
SOURCES = main.c
ARGS = -f -o -r --tab --avl --abr

OBJECTS = $(SOURCES:.c=.o)
EXECUTABLE = main

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXECUTABLE)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)


