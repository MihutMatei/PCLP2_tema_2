.PHONY: all clean run build

all: checker

build: checker

run: checker
	./checker

subtask1.o: subtask1.asm
	nasm -f elf $^ -o $@

subtask2.o: subtask2.asm
	nasm -f elf $^ -o $@

check_events.o: check_events.c
	gcc -c -g -m32 $^ -o $@

checker: check_events.o subtask1.o subtask2.o
	gcc -no-pie -m32 -g $^ -o $@
	rm *.o

clean:
	rm -f checker
	rm -f output/events_*