# Negations (N)
negate(x)                     = 1 - x
negate_threshold(x)           = x <= 0 ? 1 : 0
negate_cosine(x)              = 0.5(1 + cos(x*π))
negate_sugeno(x, λ)           = λ > -1 ? 1 - x / (1 + λ * x) : nothing
negate_yager(x, λ)            = (1 - x^λ)^(1 / λ)
negate_intuitionistic(x)      = x == 0 ? 1 : 0
negate_dual_intuitionistic(x) = x < 1 ? 1 : x == 1 ? 0 : nothing

function isstrongnegation(fun)
    # strict: x,y ∈ [0,1], x < y ⟹ ~x > ~y
    # strong: ~~x == x (involutive)
    x, y = sort(rand(2))
    fun(0) == 1 && 
        fun(1) == 0 &&
        fun(x) > fun(y) &&
        fun(fun(x)) == x
end