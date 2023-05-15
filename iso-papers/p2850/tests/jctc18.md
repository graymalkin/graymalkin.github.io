```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r3 := x;
if(r3 == 0) {
  x := 42
};
r1 := x;
y := r1

// Thread 1:
r2 := y;
x := r2

```
