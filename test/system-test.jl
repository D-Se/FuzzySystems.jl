using FuzzySystems: Mamdani, predict

make_system = quote
        service = @var {
            poor     : Q 0 0 2 4
            good     : T 3 5 7
            excellent: Q 6 8 10 10
        }

        food = @var {
            rancid   : Q 0 0 3 6
            delicious: Q 4 7 10 10
        }

        tip = @var {
            cheap    : Q 10 10 20 30
            average  : T 20 30 40
            generous : Q 30 40 50 50
        }

        rules = @rules {
            {max} cheap tip    = poor service & rancid food
            [max] average tip  = good service
            [max] generous tip = excellent service & delicious food
        }
        inputs = (service, food)
        fis_tips = Mamdani(inputs, tip, rules)
end

@time "1st system " eval(make_system)
@time "2nd system " eval(make_system)

@testset "Mamdani" begin
    x₁, x₂, x₃, x₄ = (7.0, 8), (7.0, 8.0), (7, 8), (service = 7, food = 8)

    @test predict(fis_tips, x₁) == 45.0
    @test predict(fis_tips, x₂) == 45.0
    @test predict(fis_tips, x₃) == 45.0
    @test predict(fis_tips, x₄) == 45.0
end
