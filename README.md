# PCLP2_tema_2_Mihut_Matei_311CA

## Task 1: Numbers – Filtering Odd Numbers and Powers of Two

### Description
This task involved filtering a list of 32-bit integers based on two sequential conditions. The function eliminates:

1. **Odd numbers** (those with least significant bit set), and
2. **Powers of 2** (including `1`, `2`, `4`, ..., `2^31`)

The filtered values are stored in a separate destination array, and the length of this new list is returned via a pointer.

Function prototype:
```c
void remove_numbers(int *a, int n, int *target, int *ptr_len);
```

- `a`: pointer to the input array
- `n`: number of elements in the input array
- `target`: pointer to the output array
- `ptr_len`: pointer to an integer where the number of remaining elements will be stored

---

## Subtask 1: Remove Odd Numbers

### Key Steps
- Iterates through the input array using index `i`.
- For each element `a[i]`, uses the `test` instruction to check the least significant bit:
  - If `a[i]` is **even**, it's copied to the `target` array.
  - If **odd**, it's skipped.
- A separate index `j` is used to track the position in the `target` array.
- After the pass, `*ptr_len` is updated with the new length (`j`).

### Important Considerations
- No modification is made to the original array.
- Bitwise `test ebp, 1` is a fast way to check for odd values.
- Registers are used efficiently: `esi` for `a`, `edi` for `target`, `ebx` for input length, and `eax`/`edx` for loop counters.

---

## Subtask 2: Remove Powers of Two

### Key Steps
- After removing odd numbers, a second loop runs through the `target` array.
- For each value:
  - If the number is `0`, it is kept.
  - Otherwise, check if it's a power of two using the identity:  
    ```
    (n & (n - 1)) == 0
    ```
- If the number passes the check (i.e., not a power of two), it is copied to the beginning of `target` again, using a new index `k`.

### Important Considerations
- The `and` operation with `n - 1` efficiently detects powers of two.
- Uses separate loop variables (`edx` and `esi`) to avoid overlap.
- Updates `*ptr_len` again after the second filtering pass.

---
## Task 2: Events – Date Validation and Sorting

### Description
This task involved implementing two functions in x86 Assembly to manage and validate a list of scheduled events. Each event contains a name, a validity flag, and a date (day, month, year). The goal was twofold:

1. **Check validity of each event's date** and set the `valid` field accordingly.
2. **Sort the array of events in-place**, prioritizing valid events first and then sorting them by date and name.

The two functions implemented were:

```c
void check_events(struct event *events, int len);
void sort_events(struct event *events, int len);
```

Both functions operate on an array of packed `struct event` objects, where each event includes a `struct date` substructure.

---

## Subtask 1: Date Validation

### Description
The `check_events` function checks the validity of each event's date and updates the `valid` field accordingly. A date is considered valid if:

- The year is in the range `[1990, 2030]`
- The month is in the range `[1, 12]`
- The day is in the correct range for the given month (based on a non-leap year)

### Key Steps
- Iterates over the event array in reverse order (from last to first).
- Accesses each event using offset calculation (`event_size = 36`).
- Loads `year`, `month`, and `day` using `movzx` and `mov` for appropriate size (byte/word).
- Uses a lookup table `days_in_month` to determine the maximum allowed day for each month.
- Performs a series of bounds checks:
  - `year < 1990` or `year > 2030` → invalid
  - `month < 1` or `month > 12` → invalid
  - `day < 1` or `day > max_day_for_month` → invalid
- If all checks pass, sets `valid = 1`; otherwise, leaves it as `0`.

### Important Considerations
- All event structs are **packed**, so field offsets must be accessed precisely:
  - `name` is at offset 0  
  - `valid` is at offset 31  
  - `day`, `month`, `year` are at offsets 32, 33, and 34 (inside `date`)
- A `dec eax` step is used to transform a 1-based month index into a 0-based array index.
- Leap years are **not** considered for February (always 28 days).
- Invalid events are explicitly marked with `valid = 0` before checks.

---

## Subtask 2: Event Sorting

### Description
The `sort_events` function reorders the array of events **in-place** using a set of hierarchical rules. The sorting order is defined as:

1. Valid events come before invalid ones.
2. Among valid events, sort by date: earlier dates come first.
3. If dates are equal, sort alphabetically by name.

### Key Steps
- Implements a nested loop over indices `i` and `j` using `esi` and `edi`.
- For each pair of events:
  - Compares the `valid` flag:
    - If `event[i]` is invalid and `event[j]` is valid → swap
  - If both are valid:
    - Compare years (`year[i] > year[j]` → swap)
    - If years equal, compare months (`month[i] > month[j]` → swap)
    - If months equal, compare days (`day[i] > day[j]` → swap)
    - If dates equal, compare names byte-by-byte:
      - Lexicographic comparison using ASCII values
      - Manual implementation of `strcmp()` logic
- Swaps are performed using a 36-byte memory block exchange:
  - Swapping done byte-by-byte using a loop
  - Registers are preserved using `push`/`pop` during swap

### Important Considerations
- Event `name` fields are assumed to be null-terminated and unique.
- Sorting logic is deterministic and stable.
- Manual string comparison is necessary as C standard functions are not available.
- Swapping respects struct alignment and size:
  - Total size = 36 bytes (31 for name + 1 for valid + 4 for date)
- Sorting is affected by incorrect `valid` flags, so `check_events` must be executed first.

---

## Task 3: Base64 Encoding in x86 Assembly

### Description
This task required implementing a Base64 encoder in x86 Assembly. The function converts binary data (in 3-byte chunks) into a Base64-encoded string, storing the result in a destination buffer.

Function prototype:
```c
void base64(char* source, int n, char* dest, int* dest_len);
```

The input length `n` is always a multiple of 3, so padding (`=` characters) is not necessary. The resulting string is stored in `dest`, and its length is stored in `*dest_len`.

---

### Key Steps
- The function processes the input 3 bytes at a time, combining them into a single 24-bit integer.
- This 24-bit integer is split into four 6-bit segments using bit shifting and masking.
- Each 6-bit segment is used to index into a Base64 alphabet array (`alphabet`) to retrieve the corresponding character.
- Characters are written to the `dest` buffer in sequence.
- After all input bytes are processed, the final length of the encoded output is computed as `edi - dest` and written to the `dest_len` pointer.

---

### Assembly Implementation Details

- Registers:
  - `esi`: pointer to input (`source`)
  - `ebx`: input length `n`
  - `edi`: pointer to output buffer (`dest`)
  - `edx`: used for indexing and holding intermediate values
  - `ecx`: loop index for traversing input
  - `eax`: temporary register for building 24-bit group

- Encoding logic for each 3-byte chunk:
  1. Read `b1`, `b2`, and `b3` as bytes from memory.
  2. Construct a 24-bit value: `b1 << 16 | b2 << 8 | b3`
  3. Extract 6-bit segments by right-shifting and masking with `0x3F`.
  4. Use each 6-bit value as an index into the `alphabet` array.
  5. Store the resulting characters in `dest`.

- The loop increments the input index by 3 and the output pointer by 4 each iteration.

---

### Important Considerations
- The input length is assumed to be a multiple of 3, so the code avoids dealing with padding.
- `movzx` is used consistently to safely load unsigned bytes from memory.
- The destination length is calculated by subtracting the start of `dest` from the final `edi` value.
- All relevant registers are preserved and restored to comply with calling conventions.

---
## Task 4: Sudoku Row, Column, and Box Validation

### Description
This task required implementing three validation functions in x86 Assembly to verify the correctness of rows, columns, and 3×3 boxes in a Sudoku board. Each function checks that all digits from 1 to 9 appear **exactly once** in the specified part of the board.

Each function has the following signature:

```c
int check_row(char* sudoku, int row);
int check_column(char* sudoku, int column);
int check_box(char* sudoku, int box);
```

All functions return `1` for valid input (all digits 1–9 appear exactly once) and `2` for invalid input (missing or duplicate digits).

---

## check_row

### Description
Checks whether a specific row in the Sudoku grid contains all digits 1 through 9 exactly once.

### Key Steps
- Uses the formula `row * 9` to compute the offset to the beginning of the row.
- Iterates over 9 consecutive cells in memory starting from that offset.
- Loads each value and verifies it falls in the range [1, 9].
- A frequency array (`frequency[9]`) is used to count occurrences.
- After populating the frequency array, checks if each number occurred exactly once.

### Important Considerations
- Uses `movzx` to safely read unsigned byte values.
- Adjusts the read values using `dec` to map 1–9 into indices 0–8.
- The frequency array is reset at the end of the function to ensure clean state for the next call.

---

## check_column

### Description
Checks whether a specific column in the Sudoku grid contains all digits 1 through 9 exactly once.

### Key Steps
- For each row, calculates the address of the target column as: `base + (row_index * 9 + col)`.
- Iterates over all 9 rows, extracting the column value at each step.
- Verifies that each value is in the valid range and updates the frequency array.
- Finally, checks that all frequency counts are exactly one.

### Important Considerations
- Logic is nearly identical to `check_row`, but offset computation is based on column indexing across rows.
- Uses the same frequency buffer and ensures it's cleared after execution.

---

## check_box

### Description
Checks whether a specific 3×3 box in the Sudoku grid contains all digits 1 through 9 exactly once.

Boxes are indexed from 0 to 8, going left-to-right, top-to-bottom:

```
0 1 2
3 4 5
6 7 8
```

### Key Steps
- Uses integer division to derive row and column groups:  
  - `box / 3` gives the row group (0–2),  
  - `box % 3` gives the column group (0–2).
- Calculates the top-left index of the box: `row_group * 27 + col_group * 3`.
- Iterates over the 9 cells in the 3×3 grid using a combination of row and column offsets.
- Loads each value, validates the range, and updates the frequency array.
- Checks if each digit from 1–9 occurs exactly once.

### Important Considerations
- Uses integer division (`div`) to compute 2D grid navigation.
- Base and relative offsets are carefully computed to map the 3×3 region.
- Frequency array is reset at the end to avoid carryover across calls.

---
