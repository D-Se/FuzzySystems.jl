using FuzzySystems.FuzzyLogic: isstrongnegation, implicationproperties, I_Kleene_Dienes, I_Goguen
@testset "N, T, S & I properties" begin
    @test isstrongnegation(x -> 1 - x) == true
    @test isstrongnegation(x -> 1 - x^2) == false

    tpl = implicationproperties.([I_Kleene_Dienes, I_Goguen]; tnorm = (x, y) -> min(x,y))
    @test tpl == NamedTuple{(:M₁, :M₂, :CC, :DF, :NP, :ID, :EP, :CPN, :OP, :SN, :MP, :unknown, :BC), NTuple{13, Bool}}[(M₁ = 1, M₂ = 1, CC = 1, DF = 1, NP = 1, ID = 0, EP = 1, CPN = 1, OP = 0, SN = 1, MP = 1, unknown = 1, BC = 0), (M₁ = 1, M₂ = 1, CC = 0, DF = 1, NP = 1, ID = 1, EP = 1, CPN = 1, OP = 1, SN = 0, MP = 1, unknown = 0, BC = 1)]
end