abstract type AbstractIsh <: AbstractFloat end

(!)(x::AbstractIsh) = 1 - x.ϕ
Base.xor(x::AbstractIsh, y::AbstractIsh) = (x & y) | !(x | y) # T-based
# (x | y) & !(x & y) S-based

# conversions
Bool(x::AbstractIsh) = x.ϕ == 0 ? false : true

clampinterval(x::Float64) = signbit(x) ? zero(x) : one(x) < x ? one(x) : x
@inline @fastmath function clampinterval(x)
    (1 < x * (0 < x)) + x * (0 < x) * (x * (0 < x) <= 1)
end

# Constructor for concrete subtypes
(::Type{T})(ϕ) where {T <: AbstractIsh} = begin
    isnan(ϕ) && throw(DomainError(NaN, "NaN in  for logics"))
    clampinterval(ϕ)
end

(|)(x::AbstractIsh, y::Missing)  = iszero(x.ϕ) ? missing : x
(|)(x::Missing, y::AbstractIsh)  = iszero(y.ϕ) ? missing : y
(&)(x::AbstractIsh, y::Missing)  = missing
(&)(x::Missing, y::AbstractIsh)  = missing
(⟹)(x::AbstractIsh, y::Missing) = missing
(⟹)(x::Missing, y::AbstractIsh) = missing

isless(x::AbstractIsh, y::AbstractIsh) = x.ϕ < y.ϕ

Base.show(io::IO, x::AbstractIsh) = print(io, "≈" * string(x.ϕ))

# TODO: make parametric interfaces
#(:𝓕ish, :𝓗ish, :𝓢𝓢ish, :𝓨ish, :𝓓ish, :𝓐𝓐ish, :𝓢𝓦ish, :𝓓𝓟ish, :𝓨𝓤ish)

# Internal toggles to swap fuzzy backends for &, |, ⟹, ! ops.
# Using fields ensures type stability and 0 allocations in ops.
mutable struct TypeToggle δ::Int8 end
const 𝓣 = TypeToggle(1)
