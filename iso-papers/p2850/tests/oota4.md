```c++
// Init:
x := 0;
y := 0;
z := 0;
b := 0;

// Thread 0:
r2 := y;
r3 := b;
if(¬r3 == 0) {
  x := r2;
  z := r2
}
else
{
  x := 1
}

// Thread 1:
b := 1

// Thread 2:
r1 := x;
y := r1

```
