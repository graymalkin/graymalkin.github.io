```c++
// Init:
A := 0;
B := 0;

// Thread 0:
r1 := A;
if(r1 == 1) {
  B := 1
}

// Thread 1:
r2 := B;
if(r2 == 1) {
  A := 1
};
if(r2 == 0) {
  A := 1
}

```
