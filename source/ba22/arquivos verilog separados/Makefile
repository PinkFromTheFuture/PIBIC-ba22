

ARCH = ba2
CC = ba-elf-gcc
LD = ba-elf-ld
NM = ba-elf-nm
BS = ba-elf-size
OC = ba-elf-objcopy
OD = ba-elf-objdump

CFLAGS = -Os -march=$(ARCH) -m16regs

LDFLAGS = -m$(ARCH)_elf

all: ba22-pic

ba22-pic: ba22-pic.o reset.o intr.o
	@echo "Making $@" 
	$(LD) -Tunified_ram.ld -o $@.$(ARCH) reset.o ba22-pic.o intr.o $(LDFLAGS)
	$(OD) -d $@.$(ARCH) > $@.d
	$(OC) -O binary $@.$(ARCH) $@.bin
	$(OC) -O verilog $@.$(ARCH) $@.verilog
	$(NM) $@.$(ARCH) | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | sort > $@.map
	@echo 


ba22-pic.o : ba22-pic.c
	@echo "Making $@" 
	$(CC) -c -o $@ $(CFLAGS) ba22-pic.c
	@echo 

reset.o : reset.S
	@echo "Making $@" 
	$(CC) -c -o $@ $(CFLAGS) reset.S
	@echo 

intr.o : intr.S
	@echo "Making $@" 
	$(CC) -c -o $@ $(CFLAGS) intr.S
	@echo 


clean:
	rm -f ba22-pic*.{ba*,o,d,bin,map}
	rm -f ba22-pic-*.{ba*,o,d,bin,map}
	rm -f *.o
