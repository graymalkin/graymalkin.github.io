```c++
// Init:
x := 0;
y := 0;

// Thread 0:
x := 2;
r1 := x;
if(¬r1 == 2) {
  y := 1
}

// Thread 1:
x := 1;
r2 := x;
r3 := y;
if(¬r3 == 0) {
  x := 3
}

```
