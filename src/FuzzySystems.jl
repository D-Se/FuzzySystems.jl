module FuzzySystems

using Reexport
# Fuzzy logic fundamentals
include("fuzzy logic/FuzzyLogic.jl")
@reexport using .FuzzyLogic
@reexport using .FuzzyLogic: MF, WTAV

include("system.jl")
include("_documentation.jl")
export
    Mamdani, predict

# Fuzzy inference engines
# include("fuzzy engines/FuzzyEngines.jl")

end
