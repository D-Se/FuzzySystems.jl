using FuzzySystems
using FuzzySystems.FuzzyLogic
using Test
using Random

#SEED = trunc(Int, time())
#println("##### Random.seed!($SEED), on VERSION == $VERSION")
Random.seed!(0)

@testset "FuzzySystems" begin
    @testset "FuzzyLogic" begin
        include("membership-test.jl")
        include("implication-test.jl")
        include("properties-test.jl")
        include("defuzz-test.jl")
    end
end