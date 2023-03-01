function COG(𝒰, mf)
    ∑moment_area = ∑area = 0.0
    ϵ = 2^-52
    isone(length(𝒰)) && return (𝒰 * μ(𝒰, mf) / max(mf, ϵ))

    membership = μ.(𝒰, mf)

    @inbounds for i in 2:lastindex(𝒰)
        x₁ = 𝒰[i - 1]
        x₂ = 𝒰[i]
        y₁ = membership[i - 1]
        y₂ = membership[i]
        y₁ == y₂ == 0 || x₁ == x₂ && continue # □ zero height or width
        if y₁ == y₂                     # □
            moment = .5(x₁ + x₂)
            area   = (x₂ - x₁) * y₁
        elseif 0 == y₁ != y₂            # Δ, height y₂
            moment = 2 / 3 * (x₂ - x₁) + x₁
            area   = .5(x₂ - x₁) * y₂
        elseif 0 == y₂ != y₁            # Δ, height y₁
            moment = 1 / 3 * (x₂ - x₁) + x₁
            area   = .5(x₂ - x₁) * y₁
        else
            moment = 2 / 3 * (x₂ - x₁) * (y₂ + .5y₁) / (y₁ + y₂) + x₁
            area   = .5(x₂ - x₁) * (y₁ + y₂)
        end
        ∑moment_area += moment * area
        ∑area += area
    end
    return ∑moment_area / max(∑area , ϵ)
end

function BOA(𝒰, mf)
    ∑area = 0.0
    accum_area = zeros(length(𝒰))
    length(𝒰) == 1 && return x[1]

    membership = μ.(𝒰, mf)

    for i in 2:lastindex(𝒰)
        x₁ = 𝒰[i - 1]
        x₂ = 𝒰[i]
        y₁ = membership[i - 1]
        y₂ = membership[i]

        y₁ == y₂ == 0 || x₁ == x₂ && continue
        ∑area += if y₁ == y₂
            (x₂ - x₁) * y₁
        elseif 0 == y₁ != y₂
            .5(x₂ - x₁) * y₂
        elseif 0 == y₂ != y₁
            .5(x₂ - x₁) * y₁
        else
            .5(x₂ - x₁) * (y₁ + y₂)
        end
        #∑area += area
        accum_area[i - 1] = ∑area
    end
    index = findfirst(i -> i >= ∑area / 2, accum_area)
    subarea = isone(index) ? 1 : accum_area[index - 1]

    x₁ = 𝒰[index]
    x₂ = 𝒰[index + 1]
    y₁ = membership[index]
    y₂ = membership[index + 1]

    subarea = ∑area / 2 - subarea

    xmin = x₂ - x₁
    if y₁ == y₂
        subarea / y₁ + x₁
    elseif 0 == y₁ != y₂
        root = sqrt(2 * subarea * xmin / y₂)
        x₁ + root
    elseif 0 == y₂ != y₁
        root = sqrt(xmin * xmin - (2 * subarea * xmin / y₁))
        x₂ - root
    else
        m = (y₂ - y₁) / xmin
        root = sqrt(y₁ * y₁ + 2 * m * subarea)
        x₁ - (y₁ - root) / m
    end
end

function MOM(firing_strength, fis)
    max_firing_ind = argmax(firing_strength)
    max_fired_mf_name = fis.rules[max_firing_ind].output
    mean_at(fis.output_dict[max_fired_mf_name], maximum(firing_strength))
end

function SOM(𝒰, mf)
    membership = μ.(𝒰, mf)
    m = maximum(membership)
    minimum(𝒰[findall(i -> i == m, membership)])
end

function LOM(𝒰, mf)
    membership = μ.(𝒰, mf)
    m = maximum(membership)
    maximum(𝒰[findall(i -> i == m, membership)])
end

function WTAV(firing_strength, fis)
    res = Float64(0)
    s = sum(firing_strength)
    s == 0 && return res
    for i in eachindex(firing_strength)
        m = mean_at(fis.output_dict[fis.rules[i].out], firing_strength[i])::Float64
        m *= firing_strength[i]
        res += m
    end
    res / s
end

function mean_at(mf::Triangular, firing_strength)
    isone(firing_strength) && return mf.t
    #p1 = (mf.t - mf.l) * firing_strength + mf.l
    #p2 = (mf.t - mf.r) * firing_strength + mf.r
    #(p1 + p2) / 2
    0.5 * (2*mf.t*firing_strength - mf.l*firing_strength + mf.l - mf.r*firing_strength + mf.r)
end

function mean_at(mf::Trapezoid, firing_strength)
    #= p1 = (mf.lt - mf.lb) * firing_strength + mf.lb
    p2 = (mf.rt - mf.rb) * firing_strength + mf.rb
    (p1 + p2) / 2  =#

    0.5 * (mf.lt*firing_strength - mf.lb*firing_strength + mf.lb + mf.rt*firing_strength - mf.rb*firing_strength + mf.rb)
end

mean_at(mf::Gaussian, firing_strength) = mf.t
mean_at(mf::Bell, firing_strength) = mf.t

function mean_at(mf::Sigmoid, firing_strength)
    isone(firing_strength) && (firing_strength -= eps())
    iszero(firing_strength) && (firing_strength += eps())
    p1 = -log((1 / firing_strength) - 1) / mf.a + mf.c
    p2 = 1 # limit
    (p1 + p2) / 2
end
