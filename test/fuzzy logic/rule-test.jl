want(op = nothing) = isnothing(op) ? Rule((:b, :c), :a) : Rule((:b, :c), :a, op)
@testset "Rule & macros" begin

    @testset "Rule" begin
        # @test want("MAX")   == want(maximum)
        @test want(:MAX)    == want(maximum)
        @test want(:min)    == want()
        @test length(want())== 2
        @test size(want())  == (2, 1)
    end

    @testset "@rule" begin
        @test want() == @rule       a v1 = b v2 & c v3
        @test want() == @rule       a    = b    & c
        @test want() == @rule [MIN] a    = b    & c
    end

    @testset "@rules" begin
        x₁ = @rules {
            a v1 = b v2 & c v3
            aa v1 = bb v2
        }
        x₂ = @rules {      a v1 = b v2 & c v3;       aa v1 = bb v2 }
        x₃ = @rules {      a    = b    & c;          aa    = bb    }
        x₄ = @rules {[min] a    = b    & c; [nilmin] aa    = b | d }
        y = ((@rule a v1 = b service & c food), (@rule aa v1 = bb service),)
        z = (want(), Rule((:bb,), :aa))
        @test x₁ == x₂ == x₃
        @test x₁ == y
        @test y == z
        @test x₄[1] == want()
        # @test x₄[2] == Rule((:b, :d), :aa, nilpotent_minimum)

        @test (@rules {
            {min} x = y
            [min] xx = yy
            [ min ] xxx = yyy
        }) == (Rule((:y,), :x), Rule((:yy, ), :xx), Rule((:yyy,), :xxx))
    end

    @testset "@var" begin
        @test (@var {x: Q 0 0 2 4}) == Dict(:x => Trapezoid(0, 0, 2, 4))
        @test (@var {x: Q .3 0 2 4}) == Dict(:x => Trapezoid(.3, 0, 2, 4))
    end
end
