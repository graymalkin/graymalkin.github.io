```c++
// Init:
x := 0;
y := 0;

// Thread 0:
x := 2

// Thread 1:
r1 := x;
y := (1 + (r1 * r1 - r1))

// Thread 2:
r3 := y;
x := r3

```
