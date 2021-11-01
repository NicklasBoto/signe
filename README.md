# signe

Example code, should parse and type check.

```ocaml
dup x : ∀ a . a -> a * a 
    := (x,x)

share : qubit -> qubit * qubit 
    := dup

fst (x,y) : ∀ a b . (a * b) -> a 
    := x

measure : qubit -> qubit 
    := fst ∘ share

basis f t q : ∀ a . a -> a -> qubit -> a
    := if° q
        then t
        else f

H : qubit -> qubit
    := basis ~+ ~-

X : qubit -> qubit
    := basis ~1 ~0

I : qubit -> qubit
    := basis ~0 ~1

CNOT c t : qubit -> qubit -> qubit * qubit
    := if° c
        then (~1, X t)
        else (~0,   t)

S : qubit -> qubit
    := let ~s = i * ~1
        in basis ~0 ~s

T : qubit -> qubit
    := let ~e = e^(iπ/4) * ~1
        in basis ~0 ~e
```
