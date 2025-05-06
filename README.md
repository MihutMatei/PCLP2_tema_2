# PCLP2_tema_1

## Task 3: Base64 Encoding in x86 Assembly

### Description
This task involved implementing a Base64 encoder in x86 Assembly, using Intel syntax. The function receives a source byte array (`char* source`), its length (`int n`), a destination buffer (`char* dest`), and a pointer to an integer (`int* dest_len`) where the resulting length is stored.

### Key Steps
- Input is processed in 3-byte chunks, which are packed into a 24-bit buffer.
- The 24-bit buffer is split into four 6-bit values.
- Each 6-bit value indexes into the standard Base64 alphabet.
- The corresponding characters are written to the `dest` buffer.
- The destination length is updated via the `dest_len` pointer.
- No padding (`=`) is added; input length is always assumed to be a multiple of 3.

### Important Considerations
- Registers are used carefully to avoid clobbering `edx`, which stores the pointer to `dest_len`.
- Byte shifting and packing logic ensures that input bytes are aligned correctly before encoding.
- `movzx` is used consistently to safely load bytes from memory.

---

## Task 4: Sudoku Row, Column, and Box Validation

### Description
This task involved implementing three functions in x86 Assembly to validate whether a given row, column, or 3×3 box in a Sudoku board contains all digits 1 through 9 exactly once.

Each function follows this prototype:
```c
int check_row(char* sudoku, int row);
int check_column(char* sudoku, int column);
int check_box(char* sudoku, int box);