```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r1 := x;
r2 := (1 + (r1 * r1 - r1));
y := r2

// Thread 1:
r3 := y;
x := r3

```
