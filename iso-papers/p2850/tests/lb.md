```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r1 := x;
y := 1

// Thread 1:
r2 := y;
x := 1

```
