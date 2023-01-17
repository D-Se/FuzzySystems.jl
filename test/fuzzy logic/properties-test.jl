using .FuzzyLogic: implicationproperties, isdemorgantriplet,
istnorm, issnorm, isimplication, isstrongnegation

@testset "setops properties" begin
    @testset "t-norm properties" begin
        tnorms = (∏_algebraic, bounded_difference, ∏_drastic, ∏_hamacher, nilpotent_minimum)
        for tnorm in tnorms
            @test istnorm(tnorm)
            @test !issnorm(tnorm)
            @test @inferred tnorm(1, 0.0) == 0.0
            @test 0 == @alloc tnorm(1.0, 0.0)
        end
    end

    @testset "s-norm properties" begin
        snorms = (∑_algebraic, ∑_bounded, ∑_drastic, ∑_einstein, ∑_hamacher,
        nilpotent_maximum, ∑_probabilistic)
        for snorm in snorms
            @test issnorm(snorm)
            @test !istnorm(snorm)
            @test @inferred snorm(1, 0.0) == 1.0
            @test 0 == @alloc snorm(1.0, 0.0)
        end
    end

    @testset "DeMorgan triples" begin
        @test isdemorgantriplet(min, max, negate)
        @test isdemorgantriplet(∏_algebraic, ∑_probabilistic, negate)
        @test isdemorgantriplet(bounded_difference, ∑_bounded, negate)
        @test isdemorgantriplet(nilpotent_minimum, nilpotent_maximum, negate)
        @test isdemorgantriplet(∏_algebraic, ∑_probabilistic, negate)
        @test isdemorgantriplet(∏_drastic, ∑_drastic, negate)
    end

    @testset "implication properties" begin
        @test !isimplication(min)

        @test all(implicationproperties(gaines_rescher)) broken = true # ??
        (true, true, true, true, false, true, false, true)
        @test implicationproperties(gödel) ==
        (true, true, true, true, true, true, true, false) broken = true
        @test implicationproperties(goguen) ==
        (true, true, true, true, true, true, true, false) broken = true
        @test implicationproperties(kleene_dienes) ==
        (true, true, true, true, false, true, false, true)
        @test implicationproperties(zadeh) ==
        (true, true, true, true, false, false, false, false)
        @test implicationproperties(wu) ==
        (true, true, true, false, true, false, true, true) broken = true
    end
end
