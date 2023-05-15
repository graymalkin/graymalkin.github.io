```c++
// Init:
k := 0;
x := 0;
y := 0;
z := 0;
boom := 0;

// Thread 0:
r1 := z;
x := r1

// Thread 1:
r2 := k.load(acq);
if(r2 == 42) {
  r3 := x;
  if(r3 == 1) {
    z := r3;
    boom := 1
  } else {
    r4 := y.load(na);
    z := r4
  }
}

// Thread 2:
y.store(1, na, normal);
k.store(42, rel, normal)
```
