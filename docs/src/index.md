# PolyhedralCubature.jl documentation

This package allows to evaluate multiple integrals like

```math
\int\_{-5}^4\int\_{-5}^{3-x}\int\_{-10}^{6-x-y} f(x, y, z)\,\text{d}z\,\text{d}y\,\text{d}x.
```

In other words, the domain of integration is given by a set of linear 
inequalities:

```math
\left\{\begin{matrix} -5  & \leqslant & x & \leqslant & 4 \\ -5  & \leqslant & y & \leqslant & 3-x \\ -10 & \leqslant & z & \leqslant & 6-x-y \end{matrix}\right..
```

These linear inequalities define a convex polytope (in dimension 3, a 
polyhedron). 
In order to use the package, one has to get the *matrix-vector representation* 
of these inequalities, of the form

```math
A {(x,y,z)}' \leqslant b.
```

The matrix ``A`` and the vector ``b`` appear when one rewrites the linear 
inequalities above as:

```math
\left\{\begin{matrix} -x & \leqslant & 5 \\ x & \leqslant & 4 \\ -y & \leqslant & 5 \\ x+y & \leqslant & 3 \\ -z & \leqslant & 10 \\ x+y+z & \leqslant & 6 \end{matrix}\right..
```

The matrix ``A`` is given by the coefficients of ``x``, ``y``, ``z`` at the 
left-hand sides, and the vector ``b`` is made of the upper bounds at the 
right-hand sides:

```julia
A = [
  -1  0  0;   # -x
   1  0  0;   # x
   0 -1  0;   # -y
   1  1  0;   # x + y
   0  0 -1;   # -z
   1  1  1    # x + y + z
]
b = [5; 4; 5; 3; 10; 6]
```

Now assume for example that ``f(x,y,z) = x(x+1) - yz^2``. Once we have ``A`` 
and ``b``, here is how to evaluate the integral of ``f`` over the convex polytope:

```julia
using PolyhedralCubature
function f(x, y, z)
  return x*(x+1) - y*z^2
end
function g(v)
  return f(v[1], v[2], v[3])
end
I_f = integrateOnPolytope(g, A, b)
I_f.integral
# 57892.27499999998
```

....

___

## Member functions

```@autodocs
Modules = [PolyhedralCubature]
Order   = [:type, :function]
```
