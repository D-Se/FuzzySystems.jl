abstract type AbstractIsh <: AbstractFloat end

import Base: !, &, |
for type in (:𝙕ish, :𝘿ish, :𝘼ish, :𝙇ish, :𝙁ish)
    name = string(type)[1]
    or, and, imp, not = Symbol.(name .* ('ᵗ', 'ˢ', 'ⁱ', 'ⁿ'))
    @eval begin
        struct $type <: AbstractIsh ϕ::Float64
            $type(ϕ) = new(min(1, max(0, ϕ)))
        end
        Base.show(io::IO, x::$type) = print(io, "≈" * string(x.ϕ))
        (|)(x::$type, y::$type)::$type = $or(x.ϕ, y.ϕ)
        (&)(x::$type, y::$type)::$type = $and(x.ϕ, y.ϕ)
        (⟹)(x::$type, y::$type)::$type = $imp(x.ϕ, y.ϕ)
        (!)(x::$type, y::$type)::$type = $not(x.ϕ, y.ϕ)
    end
end

# TODO: make parametric interfaces
(:𝓕ish, :𝓗ish, :𝓢𝓢ish, :𝓨ish, :𝓓ish, :𝓐𝓐ish, :𝓢𝓦ish, :𝓓𝓟ish, :𝓨𝓤ish)

# Internal toggles to swap fuzzy backends for &, |, ⟹, ! ops.
# Using fields ensures type stability and 0 allocations in ops.
mutable struct TypeToggle δ::Int end
const 𝓣 = TypeToggle(1)

let
    struct store value::Union{𝙕ish, 𝘿ish, 𝘼ish, 𝙇ish, 𝙁ish} end
    global function ish(x)
        n = 𝓣.δ
        x = begin
            n == 1 ? 𝙕ish(x) |> store :
            n == 2 ? 𝘿ish(x) |> store :
            n == 3 ? 𝘼ish(x) |> store :
            n == 4 ? 𝙇ish(x) |> store :
            𝙁ish(x) |> store
        end
        return x.value
    end
end

let
    type_constants = Dict(
        :Zadeh       => 1,
        :zadeh       => 1,
        :Gödel       => 1,
        :gödel       => 1,
        :Drastic     => 2,
        :drastic     => 2,
        :Product     => 3,
        :product     => 3,
        :Algebraic   => 3,
        :algebraic   => 3,
        :Łukasiewicz => 4,
        :Lukasiewicz => 4,
        :Lukasiewicz => 4,
        :Fodor       => 5,
        :fodor       => 5
    )
    global function setlogic!(name::Symbol)
        n = type_constants[name]
        global 𝓣.δ = n
    end
end
