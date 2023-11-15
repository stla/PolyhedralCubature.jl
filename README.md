# PolyhedralCubature.jl

[![Build Status](https://github.com/stla/PolyhedralCubature.jl/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/stla/PolyhedralCubature.jl/actions/workflows/test.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/stla/PolyhedralCubature.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/stla/PolyhedralCubature.jl)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://stla.github.io/PolyhedralCubature.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://stla.github.io/PolyhedralCubature.jl/dev)

*Multiple integration on convex polytopes.*

___

This package allows to evaluate a multiple integral whose integration 
bounds are (roughly speaking) some linear combinations of the variables, e.g.

$$\int\_{-5}^4\int\_{-5}^{3-x}\int\_{-10}^{6-2x-y} f(x, y, z)\\,\text{d}z\\,\text{d}y\\,\text{d}x.$$

In other words, the domain of integration is given by a set of linear 
inequalities:

$$\left\{\begin{matrix} -5  & \leqslant & x & \leqslant & 4 \\\ -5  & \leqslant & y & \leqslant & 3-x \\\ -10 & \leqslant & z & \leqslant & 6-2x-y \end{matrix}\right..$$

These linear inequalities define a convex polytope (in dimension 3, a 
polyhedron). 
In order to use the package, one has to get the *matrix-vector representation* 
of these inequalities, of the form

$$A \begin{pmatrix} x \\\ y \\\ z \end{pmatrix} \leqslant b.$$

More technically speaking, this is called a *H-representation* of the convex polytope.
The matrix $A$ and the vector $b$ appear when one rewrites the linear 
inequalities above as:

$$\left\{\begin{matrix} -x & \leqslant & 5 \\\ x & \leqslant & 4 \\\ -y & \leqslant & 5 \\\ x+y & \leqslant & 3 \\\ -z & \leqslant & 10 \\\ 2x+y+z & \leqslant & 6 \end{matrix}\right..$$

The matrix $A$ is given by the coefficients of $x$, $y$, $z$ at the 
left-hand sides, and the vector $b$ is made of the upper bounds at the 
right-hand sides:

```julia
A = [
  -1  0  0;   # -x
   1  0  0;   # x
   0 -1  0;   # -y
   1  1  0;   # x + y
   0  0 -1;   # -z
   2  1  1    # 2x + y + z
]
b = [5; 4; 5; 3; 10; 6]
```

See the documentation for examples. 
The package provides two functions:

- `integrateOnPolytope`, to integrate an arbitrary function with a desired 
tolerance on the error;

- `integratePolynomialOnPolytope`, to get the exact value of the integral of 
a polynomial. 


## Getting `A` and `b` (help wanted)

It can be a bit annoying to write down the matrix `A` and the vector `b`. 
In the [R version](https://github.com/stla/polyhedralCubature) 
and in the [Python version](https://github.com/stla/PyPolyhedralCubature) 
of this package, I have a way to get `A` and `b` from symbolic linear 
inequalities. I have found such a way in Julia, but it has an inconvenient: 
it returns `A` and `b` with the `Float64` element type, while it is better 
to use, when possible, the `Int64` type or `Rational{Int64}` or 
`Rational{BigInt}`. Here is an example of this Julia way:

```julia
using JuMP

model = Model()
@variable(model, x)
@variable(model, y)
@variable(model, z)

@constraint(model, x >= -5)
@constraint(model, x <= 4)
@constraint(model, y >= -5)
@constraint(model, x+y <= 3)
@constraint(model, z >= -10)
@constraint(model, 2*x+y+z <= 6)

relax = relax_integrality(model)
sfm = JuMP._standard_form_matrix(model)
m, p = size(sfm.A)

A = sfm.A[:, 1:(p-m)]
```

This gives `A`, and it is possible to get `b` from `sfm.lower` and `sfm.upper`.

Please let me know if you have an idea for something similar which is not 
limited to the `Float64` element type.
