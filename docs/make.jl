push!(LOAD_PATH, "../src/")

using Documenter, PolyhedralCubature

makedocs(sitename = "PolyhedralCubature.jl", modules = [PolyhedralCubature])

deploydocs(
    repo = "github.com/stla/PolyhedralCubature.jl.git"
)
