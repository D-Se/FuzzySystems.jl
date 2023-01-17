using .FuzzyLogic: ⊕, mf

@testset "membership" begin
    @testset "membership interfaces" begin
    end
    @testset "membership functions" begin
        m = Gaussian(0, 1)                  # standard normal distribution
        @test m == Gaussian(0.0, 1)         # proper promotion of args
        @test length(μ.(1:2, m)) == 2       # memebrships are broadcastable
        @test μ(0, m)           == 1.0
        @test μ(√(2log(2)), m)  == 0.5
        @test μ(Inf, m)         == 0.0
        @test repr(m)           == "G|⁰⁼⁄₁₌|"
        @test 0 == @alloc μ(0.3, m)
        @test mf(:G, 0, 1) == m

        m = Bell(2, 6, 4)
        @test m == Bell(2.0, 6, 4)
        @test μ(6, m)           == 1.0
        @test μ(4, m)           == 0.5
        @test μ(0, m)           ≈ 0 atol = 0.001
        @test repr(m)           == "B|₂₌⁶⁼₄₌|"
        @test 0 == @alloc μ(0.3, m)

        m = Trapezoid(1, 5, 7, 8)
        @test m == Trapezoid(1.0, 5, 7, 8)
        @test μ(5, m)          == 1.0
        @test μ(3, m)          == 0.5
        @test μ(7.5, m)        == 0.5
        @test μ(1, m)          == 0.0
        @test repr(m)          == "Q|₁₌⁵⁼ ⁷⁼₈₌|"
        @test 0 == @alloc μ(0.3, m)

        m = Triangular(3, 6, 8)
        @test m == Triangular(3.0, 6, 8)
        @test μ(6, m)          == 1.0
        @test μ(4.5, m)        == 0.5
        @test μ(7, m)          == 0.5
        @test μ(3, m)          == 0.0
        @test repr(m)          == "T|₃₌⁶⁼₈₌|"
        @test 0 == @alloc μ(0.3, m)

        m = Sigmoid(1, 0)
        @test m == Sigmoid(1.0, 0)
        @test μ(Inf, m)        == 1.0
        @test μ(0, m)          == 0.5
        @test μ(-Inf, m)       == 0.0
        @test repr(m)          == "S|0=∫1=|"
        @test 0 == @alloc μ(0.3, m)

        m = Lins(0, 2)
        @test m == Lins(0, 2.0)
        @test μ(2, m)          == 1.0
        @test μ(0.5, m)        == 0.25
        @test μ(0, m)          == 0.0
        @test repr(m)          == "LS|₀₌/²⁼|"
        @test 0 == @alloc μ(0.3, m)

        m = Linz(0, 2)
        @test m == Linz(0, 2.0)
        @test μ(2, m)          == 1.0
        @test μ(0.5, m)        == 0.25
        @test μ(0, m)          == -0.0
        @test repr(m)          == "LZ|₀₌/²⁼|"
        @test 0 == @alloc μ(0.3, m)

        @test ⊕(1, 2, 3, 1)   == 0.5
        @test ⊕(0, 0, 0, 0)   == 0.0
        @test ⊕(0, 0, Inf, 0) == 0.0
        @test ⊕(0, 0, 1, 1)   == 0.0

        m = Pi(1, 4, 5, 10)
        @test μ(5, m)          == 1.0
        @test μ(2.5, m)        == 0.5
        @test μ(10, m)         == 0.0
        @test repr(m)          == "π|₁₌⁴⁼ ⁵⁼₁₌|"
        @test 0 == @alloc μ(0.3, m)

        m = S_shape(1, 9)
        @test μ(9, m)          == 1.0
        @test μ(5, m)          == 0.5
        @test μ(1, m)          == 0.0
        @test μ(3, m)          == 0.125
        @test repr(m)          == "∫|1=↗9=|"
        @test 0 == @alloc μ(0.3, m)

        m = Z_shape(1, 9)
        @test μ(9, m)          == 0.0
        @test μ(5, m)          == 0.5
        @test μ(1, m)          == 1.0
        @test μ(3, m)          == 0.875
        @test repr(m)          == "Z|1=↘9=|"
        @test 0 == @alloc μ(0.3, m)
    end
end
