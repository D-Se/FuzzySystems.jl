using FuzzySystems.FuzzyLogic: @var, @rule, @rules, Rule
using FuzzySystems.FuzzyLogic: Trapezoid, Triangular, nilpotent_minimum

@testset "macros" begin
    @testset "@var" begin
        @test (@var {x: Q 0 0 2 4}) == Dict(:x => Trapezoid(0, 0, 2, 4))
        # mixed float and ints in expr
        @test (@var {x: Q 0.3 0 2 4}) == Dict(:x => Trapezoid(0.3, 0, 2, 4))

    end
    @testset "@rule" begin
        @test (@rule a v1 = b v2 & c v3) == Rule((:b, :c), :a)
        @test (@rule a = b & c) == Rule((:b, :c), :a)
        @test Rule((:b,), :a, :MAX) == Rule((:b,), :a, maximum)
        @test (@rule [MIN] a = b & c) == Rule((:b, :c), :a, minimum)
    end

    @testset "@rules" begin
        x₁ = @rules {
            a v1 = b v2 & c v3
            aa v1 = bb v2
        }
        x₂ = @rules {a v1 = b v2 & c v3; aa v1 = bb v2}
        x₃ = @rules {a = b & c; aa = bb}
        y = ((@rule a v1 = b service & c food), (@rule aa v1 = bb service),)
        z = (Rule((:b, :c), :a), Rule((:bb,), :aa))
        @test x₁ == x₂ == x₃
        @test x₁ == y
        @test y == z

        x₄ = @rules {[min] a = b & c; [nilmin] aa = b | d}
        @test x₄[1] == Rule((:b, :c), :a, minimum)
        @test x₄[2] == Rule((:b, :d), :aa, nilpotent_minimum)
    end
end
