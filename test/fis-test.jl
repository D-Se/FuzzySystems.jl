#= service = Dict("poor" => trapezoid(0.0, 0.0, 2.0, 4.0),
    "good" => triangular(3.0, 5.0, 7.0),
    "excellent" => trapezoid(6.0, 8.0, 10.0, 10.0))

food = Dict("rancid" => trapezoid(0.0, 0.0, 3.0, 6.0),
    "delicious" => trapezoid(4.0, 7.0, 10.0, 10.0))

inputs = [service, food]

tip = Dict("cheap" => trapezoid(10.0, 10.0, 20.0, 30.0),
    "average" => triangular(20.0, 30.0, 40.0),
    "generous" => trapezoid(30.0, 40.0, 50.0, 50.0))

rule1 = Rule(["poor", "rancid"], "cheap", "MAX")
rule2 = Rule(["good", ""], "average", "MAX")
rule3 = Rule(["excellent", "delicious"], "generous", "MAX")
rules = [rule1, rule2, rule3]
fis_tips = FISMamdani(inputs, tip, rules)

in_vals = [7.0, 8.0]

eval_fis(fis_tips, in_vals, WTAV) =#