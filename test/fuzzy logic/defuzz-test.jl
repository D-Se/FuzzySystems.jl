using .FuzzyLogic: COG, BOA, MOM, SOM, LOM

@testset "defuzzification" begin
    mf = Trapezoid(2.0, 2.5, 3.0, 4.5)
    𝒰 = 0:.1:5
    @test COG(𝒰, mf) ≈ 3.055555555
    @test BOA(𝒰, mf) == 3.0

    @test MOM(𝒰, mf) == 2.75 broken=true
    @test SOM(𝒰, mf) == 2.5
    @test LOM(𝒰, mf) == 3.0
end
