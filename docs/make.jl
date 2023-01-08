push!(LOAD_PATH, "../src/")

using Documenter
using FuzzySystems

DocMeta.setdocmeta!(FuzzySystems, :DocTestSetup, :(using FuzzySystems); recursive = true)

makedocs(
    #root = joinpath(dirname(pathof(MyModule)), "..", "docs")
    modules = [FuzzySystems],
    sitename = "FuzzySystems",
    repo = "none",
    clean = true,
    authors = "Donald Seinen",
    linkcheck = false,
    doctest = false,
    checkdocs = :exports,
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "Quick Start" => "guide/tipper.md"
        ],
        "Explanations" => [
            "Fuzzy System"      => "explanations/system.md",
            "Membership"        => "explanations/membership.md"
        ],
        "Reference" => [
            "Alphabetical function list" => "reference/functionindex.md",
            "Function reference"         => "reference/api.md"
        ]
    ],
    draft = true
)

deploydocs(
    repo = "github.com/D-Se/FRBS.git", # update to FuzzySystems.jl
    target = "build",
    deps = nothing,
    make = nothing,
    devbranch = "main"
)