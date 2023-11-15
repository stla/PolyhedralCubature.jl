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

