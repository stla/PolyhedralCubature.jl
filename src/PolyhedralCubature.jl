module PolyhedralCubature

export integrateOnPolytope
#export integratePolynomialOnPolytope

import MiniQhull
import Polyhedra
import SimplicialCubature

###############################################################################

function _isPolytope(P)
  length(Polyhedra.rays(P)) == 0 && length(Polyhedra.lines(P)) == 0
end

function _getTetrahedra(A::Matrix{S}, b::Vector{T}) where S,T <: Real
  H = Polyhedra.hrep(A, b)
  P = Polyhedra.polyhedron(H)
  if !_isPolytope(P)
    error("Invalid arguments `A` and `b`.")
  end
  rawVertices = collect(Polyhedra.points(P)) 
  vertices = convert(Vector{Vector{Float64}}, rawVertices)
  indices = MiniQhull.delaunay(hcat(vertices...))
  _, ntetrahedra = size(indices)
  T = promote_type(Rational{Int64}, eltype(eltype(rawVertices)))
  tetrahedra = Vector{Vector{Vector{T}}}(undef, ntetrahedra)
  for j in 1:ntetrahedra
    ids = vec(indices[:, j])
    tetrahedra[j] = rawVertices[ids]
  end
  return tetrahedra
end

"""
    integrateOnPolytope(f, A, b; dim, maxEvals, absError, tol, rule, info, fkwargs...)

Integration of a function over a convex polytope.

# Arguments
- `f`: function to be integrated; must return a real scalar value or a real vector
- `A`: matrix corresponding to the coefficients of the variables in the linear inequalities
- `b`: vector made of the upper bounds of the linear inequalities
- `dim`: number of components of `f`
- `maxEvals`: maximum number of calls to `f`
- `absError`: requested absolute error
- `tol`: requested relative error
- `rule`: integration rule, an integer between 1 and 4; a `2*rule+1` degree integration rule is used
- `fkwargs`: keywords arguments of `f`
"""
function integrateOnPolytope(
  f::Function, A, b;
  dim = 1,
  maxEvals = 20000,
  absError = 0.0,
  tol = 1.0e-6,
  rule = 3,
  fkwargs...,
)
  tetrahedra = _getTetrahedra(A, b)
  simplices = convert(Vector{Vector{Vector{Float64}}}, tetrahedra)
  SimplicialCubature.integrateOnSimplex(
    f, simplices; 
    dim = dim, 
    maxEvals = maxEvals, 
    absError = absError,
    tol = tol,
    rule = rule,
    info = false, 
    fkwargs...
  )
end

end # module PolyhedralCubature

