module TestUtils

using FuzzySystems
using Test

using FuzzySystems: normalize, denormalize #, standardize!

#= @testset "standardize" begin
    m = reshape(collect(1:9), (3, 3))
    m = convert(Matrix{Float64}, m)
    @test standardize!(m) == [0.0 0.0 0.0; 0.5 0.5 0.5; 1.0 1.0 1.0]
end =#

@testset "normalize matrices" begin
    m = [
        8.15609 11.5379 11.1401 8.95186 7.95722;
        339.89800 856.3470 691.3490 590.28600 543.67200;
        2.12776 46.4561 136.8860 118.09100 119.86400]
    mnorm, mmin, mmax, mflag = normalize(m, 2)
    @test denormalize(mnorm, mmin, mmax) == m
end

end # module