using FuzzySystems
using Test

macro alloc(expr)
    argnames = [gensym() for a in expr.args]
    quote
        function g($(argnames...))
            @allocated $(Expr(expr.head, argnames...))
        end
        $(Expr(:call, :g, [esc(a) for a in expr.args]...))
    end
end

@testset "FuzzySystems" begin
    include("system-test.jl")
    @testset "FuzzyLogic" begin
        include("fuzzy logic/membership-test.jl")
        include("fuzzy logic/properties-test.jl")
        include("fuzzy logic/defuzz-test.jl")
        include("fuzzy logic/rule-test.jl")
        include("fuzzy logic/setops-test.jl")
        include("fuzzy logic/logic-test.jl")
    end
end
