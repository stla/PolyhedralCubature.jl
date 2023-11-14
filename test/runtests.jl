using PolyhedralCubature
using Test
using TypedPolynomials

println("Testing...")

@testset "Function `x+yz` with A and b: Int64." begin
  function f(x)
      return x[1] + x[2]*x[3]
  end
  A = [
   -1  0  0;   # -x
    1  0  0;   # x
    0 -1  0;   # -y
    1  1  0;   # x + y
    0  0 -1;   # -z
    1  1  1    # x + y + z
  ]
  b = [5; 4; 5; 3; 10; 6]
  I_f1 = integrateOnPolytope(f, A, b; rule = 1)
  I_f2 = integrateOnPolytope(f, A, b; rule = 2)
  I_f3 = integrateOnPolytope(f, A, b; rule = 3)
  I_f4 = integrateOnPolytope(f, A, b; rule = 4)
  @test isapprox(
      I_f1.integral, -5358.3
  )
  @test isapprox(
      I_f2.integral, -5358.3
  )
  @test isapprox(
      I_f3.integral, -5358.3
  )
  @test isapprox(
      I_f4.integral, -5358.3
  )
end

@testset "Function `x+yz` with A and b: Float64." begin
  function f(x)
      return x[1] + x[2]*x[3]
  end
  A = [
   -0.5 0  0;   # -x/2
    1   0  0;   # x
    0  -1  0;   # -y
    1   1  0;   # x + y
    0   0 -1;   # -z
    1   1  1    # x + y + z
  ]
  b = [2.5; 4; 5; 3; 10; 6]
  I_f1 = integrateOnPolytope(f, A, b; rule = 1)
  I_f2 = integrateOnPolytope(f, A, b; rule = 2)
  I_f3 = integrateOnPolytope(f, A, b; rule = 3)
  I_f4 = integrateOnPolytope(f, A, b; rule = 4)
  @test isapprox(
      I_f1.integral, -5358.3
  )
  @test isapprox(
      I_f2.integral, -5358.3
  )
  @test isapprox(
      I_f3.integral, -5358.3
  )
  @test isapprox(
      I_f4.integral, -5358.3
  )
end

@testset "Polynomial `x+yz` with A and b: Int64." begin
  @polyvar x y z
  poly = 1//1*x + y*z
  A = [
   -1  0  0;   # -x
    1  0  0;   # x
    0 -1  0;   # -y
    1  1  0;   # x + y
    0  0 -1;   # -z
    1  1  1    # x + y + z
  ]
  b = [5; 4; 5; 3; 10; 6]
  I_poly = integratePolynomialOnPolytope(poly, A, b)
  @test I_poly == 53583 // 10
end

@testset "Polynomial `x+yz` with A and b: Float64." begin
  @polyvar x y z
  poly = x + y*z
  A = [
   -0.5 0  0;   # -x/2
    1   0  0;   # x
    0  -1  0;   # -y
    1   1  0;   # x + y
    0   0 -1;   # -z
    1   1  1    # x + y + z
  ]
  b = [2.5; 4; 5; 3; 10; 6]
  I_poly = integratePolynomialOnPolytope(poly, A, b)
  @test isapprox(
      I_poly, -5358.3
  )
end
