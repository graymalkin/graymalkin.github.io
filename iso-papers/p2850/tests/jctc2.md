```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r1 := x;
r2 := x;
if(r1 == r2) {
  y := 1
}

// Thread 1:
r3 := y;
x := r3

```
