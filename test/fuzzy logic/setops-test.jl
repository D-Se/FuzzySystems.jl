using .FuzzyLogic: sigmoidal, isimplication
#= isstrongnegation, negate, negate_threshold, negate_sugeno, negate_cosine, negate_yager, negate_intuitionistic =#
@testset "Fuzzy set operations" begin
    @testset "t-norms" begin
        x, y, z = 0.0, 0.5, 1.0

        @test ∏_algebraic(x, x)         ≡ x
        @test ∏_algebraic(y, y)         ≡ .25
        @test ∏_algebraic(z, z)         ≡ z

        @test bounded_difference(x, x)  ≡ x
        @test bounded_difference(y, y)  ≡ x
        @test bounded_difference(z, z)  ≡ z

        @test ∏_drastic(x, x)           ≡ x
        @test ∏_drastic(y, y)           ≡ x
        @test ∏_drastic(z, z)           ≡ z

        @test ∏_einstein(x, x)          ≡ x
        @test ∏_einstein(y, y)          ≡ 0.2
        @test ∏_einstein(z, z)          ≡ z

        @test ∏_hamacher(x, x)          ≡ x
        @test ∏_hamacher(y, y)          ≈ 1//3
        @test ∏_hamacher(z, z)          ≡ z

        @test nilpotent_minimum(x, x)   ≡ x
        @test nilpotent_minimum(y, y)   ≡ x
        @test nilpotent_minimum(z, z)   ≡ z
    end
    @testset "s-norms" begin
        x, y, z = 0.0, 0.5, 1.0
        @test ∑_algebraic(x, x)         ≡ x
        @test ∑_algebraic(y, y)         ≡ .75
        @test ∑_algebraic(z, z)         ≡ z

        @test ∑_bounded(x, x)           ≡ x
        @test ∑_bounded(y, y)           ≡ z
        @test ∑_bounded(z, z)           ≡ z

        @test ∑_drastic(x, x)           ≡ x
        @test ∑_drastic(y, y)           ≡ z
        @test ∑_drastic(z, z)           ≡ z

        @test ∑_einstein(x, x)          ≡ x
        @test ∑_einstein(y, y)          ≡ 0.8
        @test ∑_einstein(z, z)          ≡ z

        @test ∑_hamacher(x, x)          ≡ -x
        @test ∑_hamacher(y, y)          ≈ 2//3
        @test isnan(∑_hamacher(z, z))

        @test nilpotent_maximum(x, x)   ≡ x
        @test nilpotent_maximum(y, y)   ≡ z
        @test nilpotent_maximum(z, z)   ≡ z

        @test ∑_probabilistic(x, x)     ≡ x
        @test ∑_probabilistic(y, y)     ≡ 0.75
        @test ∑_probabilistic(z, z)     ≡ z
    end
    @testset "implications" begin
        @test sigmoidal(reichenbach, 0.86, -0.73, 1.0, 0.1) ≈ .1π atol = 0.0001
        @test sigmoidal(reichenbach, 0, 0, 1, -1.0) ≡ 1.0
        @test sigmoidal(reichenbach, 1, .5, .5, -.5) ≡ 0.5
        @test sigmoidal(reichenbach, 1, 1, .5, -.5) ≡ 0.0

        implications = (
            łukasiewicz, kleene_dienes, mizumoto, largest_S, largest_R,
            zadeh, weber, zadeh_late, gödel, goguen, gaines_rescher, sharp,
            fodor, wu, yager, drastic
        )
        for f in implications
            @test isimplication(f)
            @test @inferred f(1, 0.0) == 0.0
            @test 0 == @alloc f(1.0, 0.0)
        end
    end

#=     @testset "negation" begin
        negations = (negate, negate_cosine, negate_intuitionistic)
        for N in negations
            @test isstrongnegation(N)
            @test 0 == @alloc(N(1))
        end
    end =#
end
