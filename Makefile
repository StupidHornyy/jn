TARGET = jn
SRC    = jn.asm
OBJ    = jn.o

.PHONY: all clean

all: $(TARGET)

$(OBJ): $(SRC)
	nasm -f elf64 $(SRC) -o $(OBJ)

$(TARGET): $(OBJ)
	ld -N -o $(TARGET) $(OBJ) -s
	python3 strip_shdrs.py $(TARGET)
	chmod +x $(TARGET)
	@echo "final binary: $$(stat -c%s $(TARGET)) bytes"

clean:
	rm -f $(OBJ) $(TARGET)
