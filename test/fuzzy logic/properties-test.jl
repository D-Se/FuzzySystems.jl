using .FuzzyLogic: implicationproperties, isdemorgantriplet,
istnorm, issnorm, isimplication, isstrongnegation

@testset "setops properties" begin
    @testset "t-norm properties" begin
        tnorms = (
            Gödel_Dumett.T, Algebraic.T, Łukasiewicz.T,
            Drastic.T, Hamacher.T, Fodor.T, Einstein.T
        )
        for tnorm in tnorms
            @test istnorm(tnorm)
            @test !issnorm(tnorm)
            @test @inferred tnorm(1, 0.0) == 0.0
            @test 0 == @alloc tnorm(1.0, 0.0)
        end
    end

    @testset "s-norm properties" begin
        snorms = (
            Gödel_Dumett.S, Algebraic.S, Łukasiewicz.S,
            Drastic.S, Hamacher.S, Fodor.S, Einstein.S
        )
        for snorm in snorms
            @test issnorm(snorm)
            @test !istnorm(snorm)
            @test @inferred snorm(1, 0.0) == 1.0
            @test 0 == @alloc snorm(1.0, 0.0)
        end
    end

    @testset "DeMorgan triples" begin
        @test isdemorgantriplet(min, max, negate)
        @test isdemorgantriplet(Algebraic.T, Algebraic.S, negate)
        @test isdemorgantriplet(Łukasiewicz.T, Łukasiewicz.S, negate)
        @test isdemorgantriplet(Fodor.T, Fodor.S, negate)
        @test isdemorgantriplet(Drastic.T, Drastic.S, negate)
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
