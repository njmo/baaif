###########################################################
# makefile for button.asm
###########################################################

BOARD=stm8s105c6
PROGRAMMER=stlink
NAME=file
SDAS=sdasstm8
SDCC=sdcc
LDFLAGS=--out-fmt-elf
CFLAGS=
FLASH=stm8flash
BUILD=build/
OBJECTS=$(BUILD)$(NAME).rel
SYMBOLS=$(OBJECTS:.rel=.sym)
ASMS=$(OBJECTS:.rel=.asm)
LISTS=$(OBJECTS:.rel=.lst)
RSTS=$(OBJECTS:.rel=.rst)
TARGET=$(BUILD)$(NAME).elf
MAP=$(TARGET:.ihx=.map)
LK=$(TARGET:.ihx=.lk)
CDB=$(TARGET:.ihx=.cdb)

.PHONY: all flash

all: clean $(TARGET)

flash: $(TARGET)
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(TARGET)

%.rel: $(NAME).asm
	$(SDAS) -g -l -o $(BUILD)$(NAME).rel $(NAME).asm

$(TARGET): $(OBJECTS)
	$(SDCC) -mstm8 $(LDFLAGS) -o $@ $(OBJECTS)

clean:
	rm -f $(BUILD)*

.PHONY: all clean flash
