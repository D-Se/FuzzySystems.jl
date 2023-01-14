using FuzzySystems.FuzzyLogic: sigmoidal, I_Reichenbach

@testset "implication functor" begin
    @test sigmoidal(I_Reichenbach, 0.86, -0.73, 1.0, 0.1) ≈ .1π atol = 0.0001
    @test sigmoidal(I_Reichenbach, 0, 0, 1, -1.0) ≡ 1.0
    @test sigmoidal(I_Reichenbach, 1, .5, .5, -.5) ≡ 0.5
    @test sigmoidal(I_Reichenbach, 1, 1, .5, -.5) ≡ 0.0
end
