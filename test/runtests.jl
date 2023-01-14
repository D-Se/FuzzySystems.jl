using FuzzySystems
using FuzzySystems.FuzzyLogic
using Test
using Random

#SEED = trunc(Int, time())
#println("##### Random.seed!($SEED), on VERSION == $VERSION")
Random.seed!(0)

@testset "FuzzySystems" begin
    include("system-test.jl")
    @testset "FuzzyLogic" begin
        include("fuzzy logic/membership-test.jl")
        include("fuzzy logic/implication-test.jl")
        include("fuzzy logic/properties-test.jl")
        include("fuzzy logic/defuzz-test.jl")
        include("fuzzy logic/rule-test.jl")
    end
end
