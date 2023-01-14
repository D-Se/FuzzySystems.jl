# (unexported) function aliases

const MF_ALIAS = Dict(
    :G => Gaussian, :g => Gaussian, :gauss => Gaussian, :gaussmf => Gaussian,
    :B => Bell, :b => Bell, :bell => Bell, :gbell => Bell, :gbellmf => Bell,
    :T => Triangular, :triangle => Triangular, :trimf => Triangular,
    :Q => Trapezoid, :trap => Trapezoid, :trapmf => Trapezoid,
    :S => Sigmoid, :s => Sigmoid, :sig => Sigmoid, :sigmf => Sigmoid,
    :LS => Lins, :ls => Lins,
    :LZ => Linz, :lz => Linz,
    :single => Singleton,
    :π => Pi,
    :SS => S_shape, :ss => S_shape, :smf => S_shape,
    :ZS => Z_shape, :zs => Z_shape, :zmf => Z_shape
)

"""
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


See also [`@rule`](@ref), [`@rules`](@ref), [`μ`](@ref) and [`firing`](@ref)
"""


T = Tuple{Vararg{Symbol}}

struct Rule
    in::Tuple{Vararg{Symbol}}
    out::Symbol
    op::Function
end
Rule(in::Tuple{Vararg{Symbol}}, out::Symbol, op::Union{Symbol, String}) = Rule(in, out, OP_ALIAS[Symbol(op)])
Rule(in::Tuple{Vararg{Symbol}}, out::Symbol) = Rule(in, out, Base.minimum)

"""
    @rule(expr...)
Create a fuzzy [`Rule`](@ref).

# Examples
```jldoctest
julia> @rule cheap tip = poor service & bad food
Rule((:poor, :bad), :cheap, "MAX")
```
"""
macro rule(expr...)
    if expr[1] isa Expr && expr[1].head != :(=)
        op = OP_ALIAS[expr[1].args[1]]
        expr = expr[2:end]
    end
    make_symbol(string) = @eval Symbol(split($string, " ")[1])

    str = collapse(string.(expr))
    str = strip.(split(str, ('=', '|', '&')))

    consequent = make_symbol(str[1])
    popfirst!(str)
    antecedent = ntuple(i -> make_symbol(str[i]), length(str))
    if @isdefined op
        Rule(antecedent, consequent, op)
    else
        Rule(antecedent, consequent)
    end
end

"""
    @rules(exprs...)
Prepare multiple fuzzy rules of the form *Consequent = Antecedent₁ [&, |] Antecedent₂ ...*

# Examples
```jldoctest
julia> @rules {
    cheap tip = poor service & bad food
    average tip = good service
}
# shorthand form
julia> @rules {
    cheap = poor & bad
    average = good
}
```
"""
macro rules(exprs...)
    str = collapse(string.(exprs))
    str = match(r"(?<={).*(?=})", str).match
    str = split(str, (';'))

    rules = ntuple(i -> Meta.parse("@rule " * str[i]), length(str))
    esc(:(eval.($rules)))
end

"""
    @var(exprs...)
Syntax shortcut for making membership dictionaries.

# Examples
```jldoctest
julia> @var {
    poor     : Q 0 0 2 4
    good     : T 3 5 7
}
Dict{Symbol, MF} with 3 entries:
    :excellent => Q|₆₌⁸⁼¹⁼₁₌|
    :good => T|₃₌⁵⁼₇₌|
```
"""
macro var(exprs...)
    str = collapse(string.(exprs))
    str = match(r"(?<={).*(?=})", str).match
    str = split(str, (';', ':'))
    keys, values = [], []
    for (i, j) in Iterators.partition(str, 2)
        # check if an (unexported) alias was used
        fun = MF_ALIAS[Symbol(match(r"^[^ ]*", j).match)]
        var_name = Symbol(:($(lstrip(i))))
        push!(keys, var_name)
        args = eval(
            Meta.parse(
                "(" * replace(match(r"(?<= ).*", j).match, " " => ",") * ")"
            )
        )
        args = Tuple(Float64(x) for x in args) # catch any integers
        push!(values, :($(fun(args...))))
    end
    Dict{Symbol, MF}(zip(keys, values))
end
