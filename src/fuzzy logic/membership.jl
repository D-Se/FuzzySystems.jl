# membership functions represent a degree of truth.
abstract type MF end

@interface gaussian     t σ
@interface bell         l t r
@interface triangular   l t r
@interface trapezoid    lb lt rt rb
@interface sigmoid      a c #limit
@interface lins         a b
@interface singleton    h
# -- under construction --
@interface Pi           a b c d
@interface S            a b
@interface Z            a b
@interface piece        a b c

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
μ(x, mf::gaussian)      = @fastmath exp(-(x - mf.t)^2 / 2mf.σ^2)
μ(x, mf::bell)          = 1 / (1 + abs((x - mf.t) / mf.l)^2mf.r)
μ(x, mf::triangular)    = max(min((x - mf.l) / (mf.t - mf.l), (mf.r - x) / (mf.r - mf.t)), 0.0)
μ(x, mf::trapezoid)     = max(min((x - mf.lb) / (mf.lt - mf.lb), 1, (mf.rb - x) / (mf.rb - mf.rt)), 0)
μ(x, mf::sigmoid)       = @fastmath 1 / (1 + exp(-mf.a * (x - mf.c)))
μ(x, mf::lins)          = mf.a <= x <= mf.b ? (x-mf.a)/(mf.b-mf.a) : x <= mf.a ? 0.0 : 1.0
μ(x, mf::singleton)     = x == mf.y ? 1.0 : 0.0
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
function μ(x, mf::S)
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
function μ(x, mf::Z)
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
Base.show(io::IO, mf::triangular) = print(io, "T|$(recase(mf.l, 2))$(recase(mf.t, 1))$(recase(mf.r, 2))|")
Base.show(io::IO, mf::trapezoid)  = print(io, "T|$(recase(mf.lb, 2))$(recase(mf.lt, 1)) $(recase(mf.rt, 1))$(recase(mf.rb, 2))|")
Base.show(io::IO, mf::gaussian)   = print(io, "G|$(recase(mf.t, 1))⁄$(recase(mf.σ, 2))|")
Base.show(io::IO, mf::bell)       = print(io, "B|$(recase(mf.l, 2))$(recase(mf.t, 1))$(recase(mf.r, 2))|")
Base.show(io::IO, mf::sigmoid)    = print(io, "S|$(recase(mf.c, 3))↗$(recase(mf.a, 3))|")
Base.show(io::IO, mf::lins)       = print(io, "L|$(recase(mf.a, 2))/$(recase(mf.b, 1))|")