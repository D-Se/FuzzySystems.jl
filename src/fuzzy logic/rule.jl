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
struct Rule
    in::Tuple{Vararg{Symbol}}
    out::Symbol
    op::Function
end
function Rule(in::Tuple{Vararg{Symbol}}, out::Symbol, op::Union{Symbol, String})
    Rule(in, out, OP_ALIAS[Symbol(op)])
end
Rule(in::Tuple{Vararg{Symbol}}, out::Symbol) = Rule(in, out, Base.minimum)
Base.length(collection::Rule) = (length(collection.in), 1)

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
macro rule end
macro rule(ex) _rule(ex) end
macro rule(ex...) _rule(ex...) end
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
macro rules(ex) @inbounds Tuple(_rule(arg) for arg in ⋆ex) end

walk(expr::Expr) = expr |> walk!([]) |> Tuple
walk(expr::Symbol) = (expr,)
walk!(list) = ex -> begin
    ex isa Symbol && return push!(list, ex)
    ex isa Expr && map(walk!(list), @inbounds ex.args[2:end])
    list
end

⋆(obj::Expr) = obj.args;
⋆(obj::Expr, x::Int64)        = obj.args[x];
⋆(obj::Expr, x::Tuple{Int64}) = obj.args[x[1]:end];

function _rule(ex::Expr; op = minimum)
    if ex ⋆ 1 isa Expr             # [op] (a | ) b = ...
        op = OP_ALIAS[ex⋆1⋆1]
        ex ⋆ 2 isa Expr ? ex = ex ⋆ 2 : popfirst!(⋆ex)
    end
    if ex.head != :(=)              # a b = c d | e f
        out = ex ⋆ 1
        in = (ex⋆2⋆2, (i ⋆ 3 for i in ex ⋆ (3,) if i isa Expr)...)
    else                            # a = b & (c | d)
        out = ex ⋆ 1
        in = walk(ex ⋆ 2)
    end
    Rule(in, out, op)
end;

function _rule(ex...)
    op = minimum
    if ex[1] isa Expr
        op = OP_ALIAS[ex[1] ⋆ 1]
        if ex[2] isa Expr
            return _rule(ex[2], op = op) # [op] a = b & c
        else
            ex = ex[2:end] # [op] a b = c d & e f
        end
    end
    out = ex[1]
    in = Tuple((i.head == :(=) ? i ⋆ 2 : i ⋆ 3 for i in ex[2:end-1]))
    Rule(in, out, op)
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
Dict{Symbol, MF} with 2 entries:
    :excellent => Q|₆₌⁸⁼¹⁼₁₌|
    :good => T|₃₌⁵⁼₇₌|
```
"""
macro var(ex) _var(ex) end;
_var(ex) = Dict{Symbol, MF}(x⋆1⋆2 => MF_ALIAS[x⋆1⋆3](x ⋆ (2,)...) for x in ⋆ex);
