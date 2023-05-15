```c++
// Init:
x := 0;
y := 0;

// Thread 0:
r1 := x;
y := r1

// Thread 1:
z := 0;
r2 := y;
if(¬r2 == 42) {
  z := 1;
  r2 := 42
};
x := r2;
r3 := z

```
