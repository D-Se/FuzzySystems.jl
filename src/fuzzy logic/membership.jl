# membership functions represent a degree of truth.
abstract type MF end

macro interface(name, vars...)
    expr = Expr(:block)
    append!(expr.args, map(var -> :($var::Float64), vars))
    quote
        struct $name <: MF
            $expr
        end
        # membership functions act as scalars
        Base.Broadcast.broadcastable(x::$name) = Ref(x)
        function Base.iterate(s::$name, state = 1)
            state > fieldcount($name) ? nothing : (getfield(s, state), state + 1)
        end
    end |> esc
end

@interface Gaussian     t σ
@interface Bell         l t r
@interface Triangular   l t r
@interface Trapezoid    lb lt rt rb
@interface Sigmoid      a c #limit
@interface Lins         a b
@interface Linz         a b
@interface Singleton    h
@interface Pi           a b c d
@interface S_shape      a b
@interface Z_shape      a b
# @interface Piece        a b c

# helpers
⊕(w, x, y, z) = 2((w - x) / (y - z))^2;

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
function μ end
μ(x, mf::Gaussian)   = @fastmath exp(-(x - mf.t)^2 / 2mf.σ^2)
μ(x, mf::Bell)       = 1 / (1 + abs((x - mf.t) / mf.l)^2mf.r)
μ(x, mf::Triangular) = max(min((x - mf.l) / (mf.t - mf.l), (mf.r - x) / (mf.r - mf.t)), 0.0)
μ(x, mf::Trapezoid)  = max(min((x - mf.lb) / (mf.lt - mf.lb), 1, (mf.rb - x) / (mf.rb - mf.rt)), 0)
μ(x, mf::Sigmoid)    = @fastmath 1 / (1 + exp(-mf.a * (x - mf.c)))
μ(x, mf::Lins)       = mf.a <= x <= mf.b ? (x-mf.a) / (mf.b-mf.a) : x <= mf.a ? 0.0 : 1.0
μ(x, mf::Linz)       = mf.a <= x <= mf.b ? (mf.a-x) / (mf.a-mf.b) : x <= mf.a ? 1.0 : 0.0
μ(x, mf::Singleton)  = x == mf.y ? 1.0 : 0.0

function μ(x, mf::Pi)
    (;a, b, c, d) = mf
    ab = 0.5(a + b)
    cd = 0.5(c + d)
    if x <= a || x >= d
        0.0
    elseif a <= x <= ab
        ⊕(x, a, b, a)
    elseif ab <= x <= b
        1 - ⊕(x, b, b, a)
    elseif c <= x < cd
        1 - ⊕(x, c, d, c)
    elseif cd < x <= d
        ⊕(x, d, d, c)
    else
        0.0
    end
end

function μ(x, mf::S_shape)
    (;a, b) = mf
    ab = 0.5(a + b)
    if x <= a
        0.0
    elseif a <= x <= ab
        ⊕(x, a, b, a)
    elseif ab <= x <= b
        1 - ⊕(x, b, b, a)
    else
        1.0
    end
end

function μ(x, mf::Z_shape)
    (;a, b) = mf
    ab = 0.5(a + b)
    if x >= b
        0.0
    elseif a <= x < ab
        1 - ⊕(x, a, b, a)
    elseif ab <= x <= b
        ⊕(x, b, b, a)
    else
        1.0
    end
end

# Custom print methods
Base.show(io::IO, mf::Triangular) = print(io, "T|$(¦(mf.l, 2))$(¦(mf.t, 1))$(¦(mf.r, 2))|")
Base.show(io::IO, mf::Gaussian)   = print(io, "G|$(¦(mf.t, 1))⁄$(¦(mf.σ, 2))|")
Base.show(io::IO, mf::Bell)       = print(io, "B|$(¦(mf.l, 2))$(¦(mf.t, 1))$(¦(mf.r, 2))|")
Base.show(io::IO, mf::Sigmoid)    = print(io, "S|$(¦(mf.c, 3))↗$(¦(mf.a, 3))|")
Base.show(io::IO, mf::Lins)       = print(io, "LS|$(¦(mf.a, 2))/$(¦(mf.b, 1))|")
Base.show(io::IO, mf::Linz)       = print(io, "LZ|$(¦(mf.a, 2))/$(¦(mf.b, 1))|")

function Base.show(io::IO, mf::Trapezoid)
    print(io, "Q|$(¦(mf.lb, 2))$(¦(mf.lt, 1)) $(¦(mf.rt, 1))$(¦(mf.rb, 2))|")
end
