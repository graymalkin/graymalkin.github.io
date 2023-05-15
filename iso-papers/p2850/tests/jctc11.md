```c++
// Init:
w := 0;
x := 0;
y := 0;
z := 0;

// Thread 0:
r1 := z;
w := r1;
r2 := x;
y := r2

// Thread 1:
r4 := w;
r3 := y;
z := r3;
x := 1

```
