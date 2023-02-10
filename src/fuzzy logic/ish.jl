abstract type AbstractIsh <: AbstractFloat end

struct Ish <: AbstractIsh
    ϕ::Float64
    Ish(ϕ) = new(min(1, max(0, ϕ))) # must be in [0, 1]
end

typemin(Ish) = Ish(0)
typemax(Ish) = Ish(1)

(|)(x::Ish, y::Ish) = (|)(x, y, 𝑶𝑹.δ)
(|)(x::Ish, y::Ish, op)::Ish = @switch {
    𝙕ᵗ(x.ϕ, y.ϕ)
    𝘿ᵗ(x.ϕ, y.ϕ)
    𝙋ᵗ(x.ϕ, y.ϕ)
    𝙇ᵗ(x.ϕ, y.ϕ)
    𝙁ᵗ(x.ϕ, y.ϕ)
}

(&)(x::Ish, y::Ish) = (&)(x, y, 𝑨𝑵𝑫.δ)
(&)(x::Ish, y::Ish, op)::Ish = @switch {
    𝙕ˢ(x.ϕ, y.ϕ)
    𝘿ˢ(x.ϕ, y.ϕ)
    𝙋ˢ(x.ϕ, y.ϕ)
    𝙇ˢ(x.ϕ, y.ϕ)
    𝙁ˢ(x.ϕ, y.ϕ)
}

⟹(x::Ish, y::Ish) = ⟹(x, y, 𝑰𝑴𝑷𝑳𝒀.δ)
⟹(x::Ish, y::Ish, op)::Ish = @switch {
    𝙕ⁱ(x.ϕ, y.ϕ)
    𝘿ⁱ(x.ϕ, y.ϕ)
    𝙋ⁱ(x.ϕ, y.ϕ)
    𝙇ⁱ(x.ϕ, y.ϕ)
    𝙁ⁱ(x.ϕ, y.ϕ)
}

(!)(x::Ish) = (!)(x, 𝑵𝑶𝑻.δ)
(!)(x::Ish, op)::Ish = @switch {
    negate(x.ϕ)
}
