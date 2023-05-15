```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r1 := x;
if(r1 == 1) {
  y := r1
}

// Thread 1:
r2 := y;
if(r2 == 1) {
  x := 1
}

```
