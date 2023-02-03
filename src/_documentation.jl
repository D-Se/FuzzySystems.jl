@doc """
    Rule(in::Tuple{Vararg{Symbol}}, out::Symbol, op::Union{Function, String, Symbol})
A structure storing fuzzy rule components.

Fuzzy rules map `in` to an `out`` by `&` or `|` ops.
Each `in`` must be unique, and map to an unambiguous `out`.

|arg|alias|
|:---|:---|
|in|antecedent, premise, input|
|out|consequent, conclusion, output|

The following are semantically equivalent
- `IF x₁ AND x₂ THEN y`
- `y = x₁ & x₂`


See also [`@rule`](@ref), [`@rules`](@ref) and [`μ`](@ref)
"""
Rule

@doc """
    @rule(expr...)
Create a fuzzy [`Rule`](@ref).

# Examples
```jldoctest
julia> @rule cheap tip = poor service & bad food
Rule((:poor, :bad), :cheap, "MAX")

julia> @rule [bounded_sum] cheap = poor & bad
Rule((:poor, :bad), :cheap, "MAX")

julia> @rules {
cheap = poor & bad
average = good
}
```
"""
:(@rule)

@doc """
@rule(expr...)
Create a fuzzy [`Rule`](@ref).

# Examples
```jldoctest
julia> @rule cheap tip = poor service & bad food
Rule((:poor, :bad), :cheap, "MAX")

julia> @rule [bounded_sum] cheap = poor & bad
Rule((:poor, :bad), :cheap, "MAX")

julia> @rules {
    cheap = poor & bad
    average = good
}
```
"""
:(@rules)

@doc """
    @var(exprs...)
Syntax shortcut for making membership dictionaries.

# Examples
```jldoctest
julia> @var {
    poor     : Q 0 0 2 4
    good     : T 3 5 7
}
Dict{Symbol, MF} with 2 entries:
    :excellent => Q|₆₌⁸⁼¹⁼₁₌|
    :good => T|₃₌⁵⁼₇₌|
```
"""
:(@var)

"""
    defuzz(firing_strength, fis, method)
Obtain a crisp value from degrees of memberships of ``x``.

universe of discourse 𝒰, the range of interest.
mf the membership function
method one of
- Center of Gravity (Centroid)  COG
- Bisector of Area              BOA
- Weighted Average              WAM
- First of Maxima               FOM
- Last of Maxima                LOM
- Mean of Maxima                MOM
- Smallest of Maxima            SOM

See also [`μ`](@ref).
"""
function defuzz end

"""
    μ(x, mf::membership_function)
 Obtain degrees of membership ``μ`` for a given crisp input ``x``

``μ_{triangular}(x)= max(min(\\frac{x\\,-\\,l}{t\\,-\\,l}, \\frac{r\\,-\\,x}{t\\,-\\,r}), 0)``, on left, top and right vertices \\
``μ_{trapezoid}(x)= max(min(\\frac{x\\,-\\,lb}{lt\\,-\\,lb}, 1, \\frac{rb\\,-\\,x}{rb\\,-\\,rt}), 0)`` on bottom and top vertices \\

``μ_{gaussian}(x) = e^{-\\frac{1}{2}(\\frac{x - t}{σ})^2}`` where `σ` is variance and `t` is the mean of the distribution \\
``μ_{bell}(x) = \\frac{1}{1 + |1 + \\frac{x - t}{a}|^{2b}}`` where `l`, `t` and `r` and left, top and right points of the curve \\

``μ_{sigmoid}(x,a,c)= \\frac{1}{1 + e^{-a(x\\,-\\,c)}}`` where `a` is the width of transition area, `c` is the inflextion point\\

See also [`defuzz`](@ref).
"""
μ

"""
Axiom adherence of an implication function

`N` is a strong negation function, i.e. a fuzzy complement `~~x == x`.
`T` is a left-continuous t-norm, defaults to nilpotent minimum

Mas, M., Monserrat, M., Torrens, J., & Trillas, E. (2007). A survey on fuzzy implication functions. IEEE Transactions on fuzzy systems, 15(6), 1107-1121.
"""
implicationproperties

"""
Is a fuzzy intersection (t-norm, OR) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
istnorm

"""
is a fuzzy union (s-norm, AND) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
issnorm
