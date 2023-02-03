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
        Base.iterate(s::$name) = 1
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

μ(x, mf::Gaussian)   = @fastmath exp(-(x - mf.t)^2 / 2mf.σ^2)
μ(x, mf::Bell)       = 1 / (1 + abs((x - mf.t) / mf.l)^2mf.r)
μ(x, mf::Triangular) = max(min((x - mf.l) / (mf.t - mf.l), (mf.r - x) / (mf.r - mf.t)), 0.0)
μ(x, mf::Trapezoid)  = max(min((x - mf.lb) / (mf.lt - mf.lb), 1, (mf.rb - x) / (mf.rb - mf.rt)), 0)
μ(x, mf::Sigmoid)    = @fastmath 1 / (1 + exp(-mf.a * (x - mf.c)))
μ(x, mf::Lins)       = mf.a <= x <= mf.b ? (x-mf.a) / (mf.b-mf.a) : x <= mf.a ? 0.0 : 1.0
μ(x, mf::Linz)       = mf.a <= x <= mf.b ? (mf.a-x) / (mf.a-mf.b) : x <= mf.a ? 1.0 : 0.0
μ(x, mf::Singleton)  = x == mf.y ? 1.0 : 0.0

function ⊕(w, x, y, z)
    if w == x == y == z || y - z == 0
        0.0
    else
        res = 2((w - x) / (y - z))^2
        isinf(res) ? 0.0 : res
    end
end

function μ(x, mf::Pi)
    (;a, b, c, d) = mf
    ab = 0.5(a + b)
    cd = 0.5(c + d)
    if x <= a || x >= d
        zero(x)
    elseif a <= x <= ab
        ⊕(x, a, b, a)
    elseif ab <= x <= b
        1 - ⊕(x, b, b, a)
    elseif c <= x < cd
        1 - ⊕(x, c, d, c)
    elseif cd < x <= d
        ⊕(x, d, d, c)
    else
        zero(x)
    end
end

function μ(x, mf::S_shape)
    (;a, b) = mf
    ab = 0.5(a + b)
    if x <= a
        zero(x)
    elseif a <= x <= ab
        ⊕(x, a, b, a)
    elseif ab <= x <= b
        1 - ⊕(x, b, b, a)
    else
        one(x)
    end
end

function μ(x, mf::Z_shape)
    (;a, b) = mf
    ab = 0.5(a + b)
    if x >= b
        zero(x)
    elseif a <= x < ab
        1 - ⊕(x, a, b, a)
    elseif ab <= x <= b
        ⊕(x, b, b, a)
    else
        one(x)
    end
end

# (unexported) supported synonyms.
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

mf(s::Symbol, args...) = MF_ALIAS[s](args...)

# Custom print methods
Base.show(io::IO, mf::Triangular) = print(io, "T|$(¦(mf.l, 2))$(¦(mf.t, 1))$(¦(mf.r, 2))|")
Base.show(io::IO, mf::Gaussian)   = print(io, "G|$(¦(mf.t, 1))⁄$(¦(mf.σ, 2))|")
Base.show(io::IO, mf::Bell)       = print(io, "B|$(¦(mf.l, 2))$(¦(mf.t, 1))$(¦(mf.r, 2))|")
Base.show(io::IO, mf::Sigmoid)    = print(io, "S|$(¦(mf.c, 3))∫$(¦(mf.a, 3))|")
Base.show(io::IO, mf::Lins)       = print(io, "LS|$(¦(mf.a, 2))/$(¦(mf.b, 1))|")
Base.show(io::IO, mf::Linz)       = print(io, "LZ|$(¦(mf.a, 2))/$(¦(mf.b, 1))|")
function Base.show(io::IO, mf::Pi)
    print(io, "π|$(¦(mf.a, 2))$(¦(mf.b, 1)) $(¦(mf.c, 1))$(¦(mf.d, 2))|")
end
Base.show(io::IO, mf::S_shape)    = print(io, "∫|$(¦(mf.a, 3))↗$(¦(mf.b, 3))|")
Base.show(io::IO, mf::Z_shape)    = print(io, "Z|$(¦(mf.a, 3))↘$(¦(mf.b, 3))|")
function Base.show(io::IO, mf::Trapezoid)
    print(io, "Q|$(¦(mf.lb, 2))$(¦(mf.lt, 1)) $(¦(mf.rt, 1))$(¦(mf.rb, 2))|")
end
