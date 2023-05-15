```c++
// Init:
x := 0;
y := 0;
a0 := 1;
a1 := 2;

// Thread 0:
r1 := x;
if(r1 == 0) {
  a0 := 0
}
else
{
  if(r1 == 1) {
    a1 := 0
  }
};
r2 := a0;
y := r2

// Thread 1:
r3 := y;
x := r3

```
