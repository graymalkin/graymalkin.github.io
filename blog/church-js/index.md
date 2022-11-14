---
title: Church encoding in JavaScript
subtitle: Weak typing in JavaScript makes lambda calculus’ church encoding a cinch
date: 2022-09-28
published: true
toc: false
---

In the office recently we were chatting about encoding natural numbers in functional programming.
One of my colleagues isn’t a Programming Languages theory person, and wanted to build a bit of intuition for it -- we asked him how he’d implement addition if he could not use the `+` operator in JavaScript.
This is, predictably, a bit challenging -- the base number type in JS isn’t structural like it might be in a language like OCaml, it’s all floats all the way down.

# Natural numbers in OCaml
We demonstrated what an encoding of natural numbers would look like in OCaml:

```ocaml
type nat = Z | S of nat
let two = S (S Z)
let three = S (S (S Z))
```


With this definition we can think about what some operators on naturals would be.
The obvious starting point are the successor (`succ`) and predecessor (`pred`) functions.

```ocaml
let succ n = S n
let pred = function 
  S n -> n
| Z -> Z
```

Simply, `succ` adds a `S` constructor to our number; similarly `pred` pops a successor off a number, and it bottoms out at zero.

Okay, so what about addition?

```ocaml
let rec add a = function
  S n -> add (S a) n
| Z -> a

add two three
(* - : nat = S (S (S (S (S Z)))) *)
```

This function pops all the successors off the 2nd argument and puts them on the front of the first argument, until there’s none left.
Addition!

# Church numerals in Javascript

This doesn’t help us in Javascript though.
Our encoding of naturals here is structural in the types available in the language, we could probably fake that up in Javascript using lists or objects, but a far more interesting way to do this is something called Church Encoding.

A church numeral is a number which is represented as a higher-order function.
A church numeral takes 2 arguments, a function `f` and a base-case `x` -- the function `f` is applied `n` times for the value `n` encoded as a church numeral.

```ocaml
(* Apply f zero times to x *)
let zero _f x = x
(* Apply f three times to x *)
let three f x = f (f (f x))
```

This can be written in Javascript more conveniently!

```js
const zero = f => x => x
const three = f => x => f(f(f(x)))
```

What does it look like to use a church numeral in JavaScript?
Well, it applies a function `n` times to `x`, so we can use it to count:

```js
/* Count to 3 (starting at 1) */
const count_one = x => { console.log(x); return x + 1 }
three(count_one)(1)
// 1
// 2
// 3
```

Similarly, we can convert these Church numerals to normal JavaScript numbers:

```js
console.log( three(x => x+1)(0) )
// 3
```

And we can implement a general function for casting from Church numerals to JavaScript numbers.

```js
const ch_to_num = n => n(x => x+1)(0)
```

We don’t yet have a way to build these numbers though -- we need to implement a successor function.

```js
const succ = n => f => x => f ( n(f)(x) )
```

The part inside the brackets `n(f)(x)` applies `f` `n` times to `x`, and the extra `f` outside the brackets applies it one more time.
Successor!

Now we can implement a function which converts normal JavaScript numbers to church numerals too.

```js
const num_to_ch = n => { 
  if (n == 0) { 
    return zero 
  } else { 
    return succ (num_to_ch(n-1))
  }
}
```

Great, that’s convenient
We haven’t looked at addition yet, though.
Two church numerals `m` and `n` will apply some function `f` `n` and `m` times respectively.
After addition of `m` and `n` we need to apply some function `f` `m+n` times.

```js
//  Apply f to x n times, and apply f to the result m timnes.
const add = m => n => f => x => m(f)(n (f)(x))
let five = add(two)(three)
console.log(ch_to_num(five))
// 5
```

# More fun with Church encoding

We can define a few more numeric functions in Church encoding:

```js
const mult = m => n => f => x => n(m (f))(x)
const exp = m => n => n (m)

console.log(ch_to_num(mult(three)(two)))
// 6
console.log(ch_to_num(exp(three)(two)))
// 9
```

We can grab more Church encoding from PL literature, too: here is an encoding of boolean values `inl` and `inr`.

```js
const inl = x => y => x /* stand-in for true */
const inr = x => y => y /* stand-in for false */
```

We can evaluate them by applying them with `true` for left branches, and `false` for right branches:

```js
console.log(inl(true)(false))
// true
console.log(inr(true)(false))
// false
```

Now we can build some predicate functions, like `is_zero`: where for some number `n` it is evaluated with a base-case of true (`inl`), and an inductive case which maps any input to false (`inr`).

```js
const is_zero = n => n(x => inr)(inl)
console.log(is_zero(zero)(true)(false))
// true
console.log(is_zero(one)(true)(false))
// false
console.log(is_zero(two)(true)(false))
// false
```

With booleans we can also define some logical operators:

```js
const and = a => b => a(b)(inr)
console.log(and(inl)(inl)(true)(false))
// true
console.log(and(inr)(inl)(true)(false))
// false
console.log(and(inl)(inr)(true)(false))
// false
console.log(and(inr)(inr)(true)(false))
// false

const or = a => b => a(inl)(b)
console.log(or(inl)(inl)(true)(false))
// true
console.log(or(inr)(inl)(true)(false))
// true
console.log(or(inl)(inr)(true)(false))
// true
console.log(or(inr)(inr)(true)(false))
// false
```

# Loops and recursion

This is where the story seems to get a little sticky.
Curry found the fixed-point operator in simply typed lambda calculus called the Y-combinator.

It is defined as `Y = \f (\x f x x)(\x f x x)`, and we can write this in the same style of JavaScript we’ve been looking at so far:

```js
const y = f => (x => f(x(x)))(x => f(x(x)))
```

But when we true to evaluate this, even with a function which isn’t recursive we get unstuck.

```js
y (f => x => x)
```

We get an error from NodeJS:

```
const y = f => (x => f(x(x)))(x => f(x(x)))
                                   ^

RangeError: Maximum call stack size exceeded
```

Annoyingly, the V8 JavaScript engine (which NodeJS is built on) does not support tail-call optimisation[^1].
There is a fixed-point combinator whose definition works in an eager language like JavaScript.

[^1]: A thread on stackoverflow has an on going discussion about support (or lack-thereof) for tail-call optimisation in JavaScript. [The thread](https://stackoverflow.com/questions/23260390/node-js-tail-call-optimization-possible-or-not)

```js
const z = f => (x => f (v => x(x)(v)))(x => f (v => x(x)(v)))
```

This is the point where I found V8 doesn’t work for me, and WebKit is too slow.
I’ll keep playing and try and build some working interesting recursion examples.
