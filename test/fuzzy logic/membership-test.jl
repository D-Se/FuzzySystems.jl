using FuzzySystems.FuzzyLogic

@testset "membership functions" begin
    m = Gaussian(0, 1)                  # standard normal distribution
    @test m == Gaussian(0.0, 1)         # proper promotion of args
    @test μ(0, m)          ≡ 1.0
    @test μ(√(2log(2)), m) ≡ 0.5
    @test μ(Inf, m)        ≡ 0.0

    m = Bell(2, 6, 4)
    @test m == Bell(2.0, 6, 4)
    @test μ(4, m) == 0.5
    @test μ(6, m) == 1.0
    @test μ(0, m) ≈ 0 atol = 0.001

    m = Trapezoid(1, 5, 7, 8)
    @test m == Trapezoid(1.0, 5, 7, 8)
    @test μ(5, m)          ≡ 1.0
    @test μ(3, m)          ≡ 0.5
    @test μ(7.5, m)        ≡ 0.5
    @test μ(1, m)          ≡ 0.0

    m = Triangular(3, 6, 8)
    @test m == Triangular(3.0, 6, 8)
    @test μ(6, m)          ≡ 1.0
    @test μ(4.5, m)        ≡ 0.5
    @test μ(7, m)          ≡ 0.5
    @test μ(3, m)          ≡ 0.0

    m = Sigmoid(1, 0)
    @test m == Sigmoid(1.0, 0)

    @test μ(Inf, m)        ≡ 1.0
    @test μ(0, m)          ≡ 0.5
    @test μ(-Inf, m)       ≡ 0.0

    m = Lins(0, 2)
    @test m == Lins(0, 2.0)
    @test μ(2, m)          ≡ 1.0
    @test μ(0.5, m)        ≡ 0.25
    @test μ(0, m)          ≡ 0.0
end