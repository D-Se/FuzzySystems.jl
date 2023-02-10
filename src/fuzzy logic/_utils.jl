function sup(x)
    replace(
        x, "1" => "¹", "2" => "²", "3" => "³", "4" => "⁴",
        "5" => "⁵", "6" => "⁶", "7" => "⁷", "8" => "⁸", "9" => "⁹",
        "0" => "⁰", "=" => "⁼", "-" => "⁻", "." => "·" # U+0387
    )
end

function sub(x)
    replace(
        x, "1" => "₁", "2" => "₂", "3" => "₃", "4" => "₄",
        "5" => "₅", "6" => "₆", "7" => "₇", "8" => "₈", "9" => "₉",
        "0" => "₀", "=" => "₌", "-" => "₋"
    )
end

# membership pretty printing - sup- or superscript
function ¦(x, case)
    if iszero(x % 1)
        x = (sign(x) == -1 ? string(x)[1:2] : string(x)[1:1]) * "="
    else
        x = string(round(x, digits = 2))
        m = match(r"(?<=0\.).{0,1}", x)
        x = isnothing(m) ? x : "." * m.match
    end
    case == 1 ? sup(x) : case == 2 ? sub(x) : x
end

macro switch(ex)
    args = ex.args
    e = Expr(:if, Expr(:call, :(==), :op, 1), Expr(:block, args[1]))
    popfirst!(args)
    n = 2
    tgt = e.args
    for op in args
        temp = Expr(:elseif, Expr(:call, :(==), :op, n), Expr(:block, op))
        push!(tgt, temp)
        n += 1
        tgt = tgt[3].args
    end
    quote $e end |> esc
end
