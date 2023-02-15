using .FuzzyLogic: sigmoidal, isimplication
#= isstrongnegation, negate, negate_threshold, negate_sugeno, negate_cosine, negate_yager, negate_intuitionistic =#
@testset "Fuzzy set operations" begin
    @testset "t-norms" begin
        x, y, z = 0.0, 0.5, 1.0

        @test 𝙂ᵗ(x, x)         ≡ x
        @test 𝙂ᵗ(y, y)         ≡ y
        @test 𝙂ᵗ(z, z)         ≡ z
        @test 0 == @alloc 𝙂ᵗ(x, x)

        @test 𝘼ᵗ(x, x)         ≡ x
        @test 𝘼ᵗ(y, y)         ≡ .25
        @test 𝘼ᵗ(z, z)         ≡ z
        @test 0 == @alloc 𝘼ᵗ(x, x)

        @test 𝘿ᵗ(x, x)           ≡ x
        @test 𝘿ᵗ(y, y)           ≡ x
        @test 𝘿ᵗ(z, z)           ≡ z
        @test 0 == @alloc 𝘿ᵗ(x, x)

        @test 𝙀ᵗ(x, x)          ≡ x
        @test 𝙀ᵗ(y, y)          ≡ 0.2
        @test 𝙀ᵗ(z, z)          ≡ z
        @test 0 == @alloc 𝙀ᵗ(x, x)

        @test 𝙃ᵗ(x, x)          ≡ x
        @test 𝙃ᵗ(y, y)          ≈ 1//3
        @test 𝙃ᵗ(z, z)          ≡ z
        @test 0 == @alloc 𝙃ᵗ(x, x)

        @test 𝙇ᵗ(x, x)  ≡ x
        @test 𝙇ᵗ(y, y)  ≡ x
        @test 𝙇ᵗ(z, z)  ≡ z
        @test 0 == @alloc 𝙇ᵗ(x, x)

        @test 𝙁ᵗ(x, x)   ≡ x
        @test 𝙁ᵗ(y, y)   ≡ x
        @test 𝙁ᵗ(z, z)   ≡ z
        @test 0 == @alloc 𝙁ᵗ(x, x)
    end
    @testset "s-norms" begin
        x, y, z = 0.0, 0.5, 1.0
        @test 𝙂ˢ(x, x)         ≡ x
        @test 𝙂ˢ(y, y)         ≡ y
        @test 𝙂ˢ(z, z)         ≡ z
        @test 0 == @alloc 𝙂ˢ(x, x)

        @test 𝘼ˢ(x, x)         ≡ x
        @test 𝘼ˢ(y, y)         ≡ .75
        @test 𝘼ˢ(z, z)         ≡ z
        @test 0 == @alloc 𝘼ˢ(x, x)

        @test 𝘿ˢ(x, x)           ≡ x
        @test 𝘿ˢ(y, y)           ≡ z
        @test 𝘿ˢ(z, z)           ≡ z
        @test 0 == @alloc 𝘿ˢ(x, x)

        @test 𝙀ˢ(x, x)          ≡ x
        @test 𝙀ˢ(y, y)          ≡ 0.8
        @test 𝙀ˢ(z, z)          ≡ z
        @test 0 == @alloc 𝙀ˢ(x, x)

        @test 𝙃ˢ(x, x)          ≡ -x
        @test 𝙃ˢ(y, y)          ≈ 2//3
        @test isnan(𝙃ˢ(z, z))
        @test 0 == @alloc 𝙃ˢ(x, x)

        @test 𝙇ˢ(x, x)           ≡ x
        @test 𝙇ˢ(y, y)           ≡ z
        @test 𝙇ˢ(z, z)           ≡ z
        @test 0 == @alloc 𝙇ˢ(x, x)

        @test 𝙁ˢ(x, x)   ≡ x
        @test 𝙁ˢ(y, y)   ≡ z
        @test 𝙁ˢ(z, z)   ≡ z
        @test 0 == @alloc 𝙁ˢ(x, x)
    end
    @testset "implications" begin
        @test sigmoidal(Rⁱ, 0.86, -0.73, 1.0, 0.1) ≈ .1π atol = 0.0001
        @test sigmoidal(Rⁱ, 0, 0, 1, -1.0) ≡ 1.0
        @test sigmoidal(Rⁱ, 1, .5, .5, -.5) ≡ 0.5
        @test sigmoidal(Rⁱ, 1, 1, .5, -.5) ≡ 0.0

        implications = (
            𝙂ⁱ, 𝘼ⁱ, 𝘿ⁱ, 𝙇ⁱ, 𝙁ⁱ,
            KDⁱ, Mⁱ, DPⁱ, largest_R, Zⁱ, Wⁱ, Zⁱ², GRⁱ, Sⁱ,  Wuⁱ, Yⁱ
        )
        for f in implications
            @test isimplication(f)
            @test @inferred f(1, 0.0) == 0.0
            @test 0 == @alloc f(1.0, 0.0)
        end
    end

    #=
    @testset "negation" begin
        negations = (negate, negate_cosine, negate_intuitionistic)
        for N in negations
            @test isstrongnegation(N)
            @test 0 == @alloc(N(1))
        end
    end =#
end
