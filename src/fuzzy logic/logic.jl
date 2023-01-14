# A fuzzy algebra is ...

struct Logic{N <: Function, T <: Function, S <: Function, I <: Function}
    N::N # negation
    T::T # t-norm
    S::S # s-norm
    I::I # implication function
end

"""
Define fuzzy set operations
    logic(model, args...)

Each `logic` is made up of basic (fuzzy) set operations.

"""
function logic(model::Symbol, args...)
    if length(args) > 0
        eval(Symbol(model))(args)
    else
        eval(Symbol(model))
    end
end

#region set operation properties
# functions to verify and aid in the discovery of new set operators

"""
is a fuzzy union (s-norm, AND) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function issnorm(fun)
	a, b, d = rand(3)
	if b > d b, d = d, b end
	fun(a, fun(b, d)) == fun(fun(a, b), d) && # associativity
		fun(a, b) <= fun(a, d) && # monotonicity
		fun(a, b) == fun(b, a) && # communicativity
		fun(a, 0) == a # boundary requirement
	# t-conorm iff u(a, b) = 1 - t-norm(1 - a, 1 - b) [mutually dual]
end

"""
Is a fuzzy intersection (t-norm, OR) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function istnorm(fun)
	a, b, d = rand(3)
	if b > d b, d = d, b end
	fun(a, fun(b, d)) == fun(fun(a, b), d) && # associativity
		fun(a, b) <= fun(a, d) && # monotonicity
		fun(a, b) == fun(b, a) && # communicativity
		fun(a, 1) == a # boundary requirement
	# continuity or strict monotonicty may be added
end

function isstrongnegation(fun)
    # strict: x,y ∈ [0,1], x < y ⟹ ~x > ~y
    # strong: ~~x == x (involutive)
    x, y = sort(rand(2))
    fun(0) == 1 &&
        fun(1) == 0 &&
        fun(x) > fun(y) &&
        fun(fun(x)) == x
end

function isimplication(fun)
    x, y, z = sort(rand(3))
    fun(x, z) >= fun(y, z) &&                               # I1 ∀z ∈ [0,1]
        fun(x, y) <= fun(x, z) &&                           # I2 ∀x ∈ [0,1]
        fun(0, 0) == fun(1, 1) == 1 && fun(1, 0) == 0       # I3
end

"""
Axiom adherence of an implication function

`N` is a strong negation function, i.e. a fuzzy complement `~~x == x`.
`T` is a left-continuous t-norm, defaults to nilpotent minimum

Mas, M., Monserrat, M., Torrens, J., & Trillas, E. (2007). A survey on fuzzy implication functions. IEEE Transactions on fuzzy systems, 15(6), 1107-1121.
"""
function implicationproperties(I; negation = negate, tnorm = nilpotent_minimum)
    x, y, z = sort(rand(4))
    !isstrongnegation(negation) && @warn "negation function is not strong. Property requirements 8, 10, 12"
    N, T = negation, tnorm
    (
        M₁ = I(x, y) >= I(y, z),                    # monotonocity in 1st arg           I1
        M₂ = I(x, y) <= I(x, z),                    # monotonocity in 2nd arg           I2
        CC = I(0, 0) == I(1, 1) == I(1, 0) + 1 == 1,# {0,1}² coincides p ⟹ q ≡ ¬p ∨ q  I3
        DF = I(0, x) == 1,                          # dominance of falsity              I4
        NP = I(1, x) == x,                          # left neutrality principle         I5
        ID = I(x, x) == 1,                          # identity property                 I6
        EP = I(x, I(y, z)) == I(y, I(x, z)),        # exchange property                 I7
        CPN = I(x, y) == I(N(y), N(x)),             # contraposition to strong negation I8
        OP = I(x, y) == 1 && I(y, x) != 1,          # ordering property                 I9
        SN = isstrongnegation(x -> I(x, 0)),        # strong negation                   I10
        MP = T(x, I(x, y)) <= y,                    # modus ponens                      I11
        unknown = I(x, N(x)) == N(x),               # --                                I12
        BC = I(x, y) == 1 && I(y, x) != 1           # boundary condition                I13
        # add: distributivity properties, laws of importation
    )
end
#endregion


# helpers
none() = nothing

#                                                                               Properties
#name                                                                           DM triplet  cont. T-norm  T_archimedean T_gen                               nilpotent
Zadeh       = Logic(negate, min, max, I_Gödel);                               #   1       1             0             -
Drastic     = Logic(negate, drastic_product, drastic_sum, I_Drastic);         #   -       0             1             x -> x < 1 ? 2 - x : 0
Product     = Logic(negate, algebraic_product, algebraic_sum, I_Goguen);      #   -       1             1             x -> -log(x)
Łukasiewicz = Logic(negate, bounded_difference, bounded_sum, I_Łukasiewicz);  #   1       1             1             x -> 1 - x
Fodor       = Logic(negate, nilpotent_minimum, nilpotent_maximum, I_Fodor);   #   1       0             1             -
# Fodor & Roubens, page 20)
function Frank(s)
    0 < s < Inf || throw("improper Frank domain")                               #   1       1             1             x -> log((s - 1) / (s^x - 1))
    if s == 0 Zadeh
    elseif s == 1 Product
    elseif isinf(s) Łukasiewicz
    else
        T = (x, y) -> log(1 + (s^x - 1) * (s^y - 1) / (s - 1)) / log(s)
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : log(1 + (s - 1) * (s^y - 1) / (s^x - 1)) / log(s)
        )
    end
end;
function Hamacher(;α = nothing, β = 0, γ = 0)                                   # γ==0?1:0  1             1             x -> log((α + (1 - α) * x) / x)
    if isnothing(α) α = (1 + β) / (1 + γ) end
    α < 0 || β < -1 || γ < -1 && throw("Invalid Hamacher parameter")
    Logic(
        x -> (1 - x) / (1 + γ * x),
        (x, y) -> x * y == 0 ? 0 : x * y / (α + (1 - α) * (x + y - x * y)),
        (x, y) -> (x + y + β*x*y - x*y) / (1 + β*x*y),
        (x, y) -> x <= y ? 1 : (-α*x*y + α*y + x*y) / (-α*x*y + α*y + x*y + x - y)
    )
end;
# make into family using standard negation and DeMorgan triplet associated t-conorm
function Schweizer_Sklar(p)                                                     #   1       p < +∞      p > -∞        x -> p == 0 ? -log(x) : (1 - x^p) / p   0<p<+∞
    if p == -Inf Zadeh
    elseif p == 0 Product
    elseif isinf(p) Drastic
    else
        T = if p < 0
            (x, y) -> (x^p + y^p - 1) ^ (1/p)
        else
            (x, y) -> (max(0, x^p + y^p - 1)) ^ (1/p)
        end
        Algebra(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : (1 - x^p + y^p) ^ (1/p) # reductivity, continuity and approximation properties.
        )
    end
end;
function Yager(p)                                                               #   1       1             1             x -> 1 - x^p
    p < 0 && throw("invalid Yager parameter")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        Logic(
            negate,
            (x, y) -> max(0, 1 - ((1 - x)^p + (1 - y)^p)^(1/p)),
            (x, y) -> min(1, (x^p + y^p) ^ (1/p)),
            (x, y) -> x <= y ? 1 : 1 - ((1 - y)^p - (1 - x)^p)^(1/p)
        )
    end
end;
function Dombi(p)                                                               #   1       1             1             x -> (1/x-1)^p
    p < 0 && throw("invalid Dombi parameter")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        T(x, y) = x*y == 0 ? 0 : 1 / (1 + ((1 / x - 1)^p + (1 / y - 1)^p)^(1 / p))
        Logic(
            negate,
            T,
            1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : 1 / (1 + ((1 / y - 1)^p - (1 / x - 1)^p)^(1/p))
        )
    end
end;
function Aczel_Alsina(p)                                                        #   1       1             1             x -> (- log(x))^p
    p < 0 && throw("Invalid Aczel_Alsina parameters")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        T(x, y) = exp(- (abs(log(x))^p + abs(log(y))^p))
        Logic(
            negate,
            T,
            1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : exp(-((abs(log(y))^p - abs(log(x))^p))^(1/p))
        )
    end
end;
function Sugeno_Weber(p)                                                        #   1       1             1             x -> 1 - log(1 + p * x) / log(1 + p)
    p < -1 && throw("invalid Segeno_Weber parameter")
    if p == -1 Drastic
    elseif p == Inf Product
    else
        Logic(
            negate,
            max(0, (x + y - 1 + p * x * y) / (1 + p)),
            min(1, x + y - p * x * y / (1 + p)),
            (x, y) -> x <= y ? 1 : (1 + (1 + p) * y - x) / (1 + p * x)
        )
    end
end;
function Dubois_Prade(p)                                                        #   1       -             -
    p < 0 || p > 1 && throw("Invalid Dubois_Prade parameter")
    if p == 0 Zadeh
    elseif p == 1 Product
    else
        T(x, y) = x * y / max(x, y, p)
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : max(p / x, 1) * y
        )
    end
end;
function Yu(p)                                                                  #   1
    p < -1 && throw("invalid Yu parameter")
    if p == -1 Product
    elseif p == Inf Drastic
    else
        Logic(
            negate,
            (x, y) -> max(0, (1 + p) * (x + y - 1) - p * x * y),
            (x, y) -> min(1, x + y + p * x * y),
            none
        )
    end
end;
