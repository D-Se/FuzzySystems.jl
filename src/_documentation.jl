"""
Fuzzy systems approximate human reasoning using linguistic variables and many-valued logic.

These can be used for regression and classification problems.
Generate a set of [`rules`](@ref FuzzySystems.FuzzyLogic.Rule).

* Automatic rule generation
  - Gradient descent
  - Neural networks
  - Genetic algorithm
  - Cluster

"""
FuzzySystems

"""
    Logic(T::Function, S::Function, I::Function, N::Function)

Definition of fuzzy set operations.
- T-norm (intersection, |)
- S-norm (union, &)
- Negation (complement)

Infinite combinations of ⟨ N, T, S ⟩ exist, all violating some properties of
classical set theory.

It is often desirable to work with ⟨ N, T, S ⟩ that preserve the duality, see
[`isdemorgantriplet`](@ref) between intersections and unions in classical set theory.

Averaging
Modifying
"""
Logic

"""
    AbstractMember

An abstract type interfacing to fuzzy membership functions.

Each concrete subtype defines ``μ_{Ã}(x):`` 𝒰 ↦ [0, 1], a mapping of value x from
fuzzy set Ã in universe of discourse 𝒰 to the unit interval of truth values.

`FuzzySystems.jl` ships the following concrete subtypes, :

| `Shape <: AbstractMember`     |  Definition |
|:--------  |:------------|
| Triangular| ``max(min(\\frac{x\\,-\\,l}{t\\,-\\,l}, \\frac{r\\,-\\,x}{t\\,-\\,r}), 0)`` |
| Trapezoid | ``max(min(\\frac{x\\,-\\,lb}{lt\\,-\\,lb}, 1, \\frac{rb\\,-\\,x}{rb\\,-\\,rt}), 0)`` |
| Gaussian  | ``e^{-\\frac{1}{2}(\\frac{x - t}{σ})^2}`` |
| Bell      | ``\\frac{1}{1 + \\|1 + \\frac{x - t}{a}\\|^{2b}}`` |
| Sigmoid   | ``\\frac{1}{1 + e^{-a(x\\,-\\,c)}}`` |

See also [`μ`](@ref) for membership degrees.
"""
AbstractMember

"""
    Rule(in::Tuple{Vararg{Symbol}}, out::Symbol, op::Function)
A structure storing fuzzy rule components.

Fuzzy rules map `in` to an `out` by `&` or `|` ops.
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

"""
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
:(@rule), :(@rules)

@doc """
    @var(exprs...)
Syntax shortcut for making membership dictionaries.

# Examples
```jldoctest
julia> @var {
    poor     : Q 0 0 2 4
    good     : T 3 5 7
}
Dict{Symbol, AbstractMember} with 2 entries:
    :excellent => Q|₆₌⁸⁼¹⁼₁₌|
    :good => T|₃₌⁵⁼₇₌|
```
"""
:(@var)

"""
    defuzz(firing_strength, fis, method)
Obtain a crisp value from degrees of memberships of ``x``.

universe of discourse 𝒰, the range of interest.
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
Obtain degrees of membership `μ` for crisp input `x` in shape `mf`.

# Arguments
- Triangular - left `l`, top `t` and right `r` vertices (corners).
- Trapezoid - left bottom `lb`, left top `lt`, right top `rt`, right botom `rb` vertices
- Gaussian -  variance `σ` and mean `t`
- Bell - left `l`, top `t` and right `r`` points of the curve
- Sigmoid-  width of transition area `a` and inflextion point `c`

See also [`AbstractMember`](@ref), [`defuzz`](@ref).
"""
μ

"""
    implicationproperties(I; N = negate)

Test the axiom adherence of an implication function.

`N` is a strong negation function, i.e. a fuzzy complement `~~x == x`.
`T` is a left-continuous t-norm, defaults to nilpotent minimum

Mas et al. (2007). A survey on fuzzy implication functions. IEEE Transactions on fuzzy systems, 15(6), 1107-1121.
"""
implicationproperties

"""
Is a t-norm (intersection, OR) or s-norm (union, AND) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
istnorm, issnorm

"""
    isdemorgantriplet(⊤::Function, ⊥::Function, ~::Function)

Check if duality between t-norm, s-norm and a complement is preserved.
"""
isdemorgantriplet
