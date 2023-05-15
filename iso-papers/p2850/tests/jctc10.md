```c++
// Init:
x := 0;
y := 0;
z := 0;

// Thread 0:
r3 := z;
if(r3 == 1) {
  x := 1
}

// Thread 1:
r2 := y;
if(r2 == 1) {
  x := 1
}

// Thread 2:
z := 1

// Thread 3:
r1 := x;
if(r1 == 1) {
  y := 1
}

```
