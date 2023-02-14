using .FuzzyLogic: Logic, Frank, Schweizer_Sklar, Yager, Sugeno_Weber, Dombi,
Dubois_Prade, Yu, Aczel_Alsina, Hamacher

@testset "Logics" begin
    logics = (
        Frank, Schweizer_Sklar, Yager, Dombi, Sugeno_Weber, Yu
    )
    L = Hamacher(;α = .5, β = 0, γ = 1)
    @test isimplication(L.I)
    @test istnorm(L.T)
    @test issnorm(L.S)
    @test isstrongnegation(L.N)

    L = Aczel_Alsina(2)
    @test isimplication(L.I)
    @test istnorm(L.T) broken = true # also at 3
    @test issnorm(L.S) broken = true
    @test isstrongnegation(L.N)

    L = Dubois_Prade(0.1)
    @test isimplication(L.I)
    @test istnorm(L.T) broken = true # broken for entire [0, 1]
    @test issnorm(L.S)
    @test isstrongnegation(L.N)

    for constructor in logics
        for param in .1:.3:.7
            L = constructor(param)
            @test istnorm(L.T)
            @test issnorm(L.S)
            @test isstrongnegation(L.N)
        end
    end

#=     for name in (:Zadeh, :Drastic, :Product, :Łukasiewicz, :Fodor)
        setlogic!(name)
        @test 0 == @alloc setlogic!(name)
        @test 0 == @alloc ish(0.35)
    end =#
end
