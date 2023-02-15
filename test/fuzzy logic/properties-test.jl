using .FuzzyLogic: implicationproperties, isdemorgantriplet,
istnorm, issnorm, isimplication, isstrongnegation

@testset "setops properties" begin
    @testset "t-norm properties" begin
        tnorms = (𝙂ᵗ, 𝘼ᵗ, 𝙇ᵗ, 𝘿ᵗ, 𝙃ᵗ, 𝙁ᵗ)
        for tnorm in tnorms
            @test istnorm(tnorm)
            @test !issnorm(tnorm)
            @test @inferred tnorm(1, 0.0) == 0.0
            @test 0 == @alloc tnorm(1.0, 0.0)
        end
    end

    @testset "s-norm properties" begin
        snorms = (𝙂ˢ, 𝘼ˢ, 𝘿ˢ, 𝙀ˢ, 𝙃ˢ, 𝙁ˢ)
        for snorm in snorms
            @test issnorm(snorm)
            @test !istnorm(snorm)
            @test @inferred snorm(1, 0.0) == 1.0
            @test 0 == @alloc snorm(1.0, 0.0)
        end
    end

    @testset "DeMorgan triples" begin
        @test isdemorgantriplet(min, max, negate)
        @test isdemorgantriplet(𝘼ᵗ, 𝘼ˢ, negate)
        @test isdemorgantriplet(𝙇ᵗ, 𝙇ˢ, negate)
        @test isdemorgantriplet(𝙁ᵗ, 𝙁ˢ, negate)
        @test isdemorgantriplet(𝘿ᵗ, 𝘿ˢ, negate)
    end

    @testset "implication properties" begin
        @test !isimplication(min)

        @test all(implicationproperties(GRⁱ)) broken = true # ??
        (true, true, true, true, false, true, false, true)
        @test implicationproperties(𝙕ⁱ) ==
        (true, true, true, true, true, true, true, false) broken = true
        @test implicationproperties(𝘼ⁱ) ==
        (true, true, true, true, true, true, true, false) broken = true
        @test implicationproperties(KDⁱ) ==
        (true, true, true, true, false, true, false, true)
        @test implicationproperties(Zⁱ) ==
        (true, true, true, true, false, false, false, false)
        @test implicationproperties(Wⁱ) ==
        (true, true, true, false, true, false, true, true) broken = true
    end
end
