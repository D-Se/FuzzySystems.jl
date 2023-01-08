# [Fuzzy in a minute](@id man-quickstart)

To start,

```julia
using FuzzySystems

mod = FuzzySystem(
    type = Mamdani,
    logic = Zadeh,
    engine = ANFIS
)

@rule cheap tip    = poor service | rancid food
@rule average tip  = good service
@rule generous tip = excellent service | delicious food
    
@var in service {
    poor:       T₄ 0 0 2 4,
    good:       T₃ 3 5 7,
    excellent:  T₄ 6 8 10 10
}
@var in food {
    rancid:     T₄ 0 0 3 6,
    delicious:  T₄ 4 7 10 10
}

@var out tip {
    cheap:      T₄ 10 10 20 30,
    average:    T₃ 20 30 40,
    generous:   T₄ 30 40 50 50
}
```
