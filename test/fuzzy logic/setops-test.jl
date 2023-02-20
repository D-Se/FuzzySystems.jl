using .FuzzyLogic: sigmoidal, isimplication
#= isstrongnegation, negate, negate_threshold, negate_sugeno, negate_cosine, negate_yager, negate_intuitionistic =#
@testset "Fuzzy set operations" begin
    @testset "Godel-Dumett logic" begin
        setlogic!(:G)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ y
        @test z | z ≡ z
        @test y & y ≡ y
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Algebraic logic" begin
        setlogic!(:A)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ ish(0.25)
        @test z | z ≡ z
        @test y & y ≡ ish(0.75)
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Drastic logic" begin
        setlogic!(:D)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ x
        @test z | z ≡ z
        @test y & y ≡ z
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Fodor logic" begin
        setlogic!(:F)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ x
        @test z | z ≡ z
        @test y & y ≡ z
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Łukasiewicz logic" begin
        setlogic!(:L)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ x
        @test z | z ≡ z
        @test y & y ≡ z
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Einstein logic" begin
        setlogic!(:E)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ ish(0.2)
        @test z | z ≡ z
        @test y & y ≡ ish(0.8)
        @test z & z ≡ z
        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "Hamacher logic" begin
        setlogic!(:H)
        x, y, z = ish(0), ish(.5), ish(1)

        @test y | y ≡ ish(float(1//3))
        @test z | z ≡ z
        @test y & y ≡ ish(float(2//3))
        @test z & z ≡ z broken=true # error?

        @test 0 == @alloc x | x
        @test 0 == @alloc x & x
    end

    @testset "implications" begin
        @test sigmoidal(Rⁱ, 0.86, -0.73, 1.0, 0.1) ≈ .1π atol = 0.0001
        @test sigmoidal(Rⁱ, 0, 0, 1, -1.0) ≡ 1.0
        @test sigmoidal(Rⁱ, 1, .5, .5, -.5) ≡ 0.5
        @test sigmoidal(Rⁱ, 1, 1, .5, -.5) ≡ 0.0

        implications = (
            #𝙂ⁱ, 𝘼ⁱ, 𝘿ⁱ, 𝙇ⁱ, 𝙁ⁱ,
            Gödel_Dumett.I, Algebraic.I, Drastic.I, Łukasiewicz.I, Fodor.I,
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
