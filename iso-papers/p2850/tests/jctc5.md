```c++
// Init:
x := 0;
y := 0;
z := 0;

// Thread 0:
z := 1

// Thread 1:
r3 := z;
x := r3

// Thread 2:
r2 := y;
x := r2

// Thread 3:
r1 := x;
y := r1

```
