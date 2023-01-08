macro interface(name, vars...)
    expr = Expr(:block)
    append!(expr.args, map(var -> :($var::T), vars))
    esc(
        quote
            struct $name{T <: Real} <: MF
                $expr
            end
            Base.Broadcast.broadcastable(x::$name) = Ref(x) # membership functions act as scalars
            Base.iterate(s::$name, state = 1) = state > fieldcount($name) ? nothing : (getfield(s, state), state + 1)
        end
    )
end

# Custom print methods
sup(x) = replace(x, "1" => "¹", "2" => "²", "3" => "³", "4" => "⁴", "5" => "⁵", "6" => "⁶", "7" => "⁷", "8" => "⁸", "9" => "⁹", "0" => "⁰", "=" => "⁼", "-" => "⁻", "." => "·") # . =  Greek Ano Teleia (U+0387)
sub(x) = replace(x, "1" => "₁", "2" => "₂", "3" => "₃", "4" => "₄", "5" => "₅", "6" => "₆", "7" => "₇", "8" => "₈", "9" => "₉", "0" => "₀", "=" => "₌", "-" => "₋")

function recase(x, case)
    if iszero(x % 1)
        x = (sign(x) == -1 ? string(x)[1:2] : string(x)[1:1]) * "="
    else
        x = string(round(x, digits = 2))
        m = match(r"(?<=0\.).{0,1}", x)
        x = isnothing(m) ? x : "." * m.match
    end
    case == 1 ? sup(x) : case == 2 ? sub(x) : x
end