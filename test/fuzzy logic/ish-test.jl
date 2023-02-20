@testset "AbstractIsh" begin

    @test_throws DomainError AbstractIsh(NaN)

    # values clamped to unit interval
    @test AbstractIsh(-Inf) == 0.0
    @test AbstractIsh(Inf)  == 1.0

    # 1/-0.0 ≠ 1/0, clamp -0
    @test AbstractIsh(-0.0) == 0.0
    @test AbstractIsh(0.0)  == 0.0

    @test AbstractIsh(1)    == 1
    @test AbstractIsh(1.0)  == 1.0
end
