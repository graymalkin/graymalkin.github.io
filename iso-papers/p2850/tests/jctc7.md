```c++
// Init:
x := 0;
y := 0;
z := 0;

// Thread 0:
r1 := z;
r2 := x;
y := r2

// Thread 1:
r3 := y;
z := r3;
x := 1

```
