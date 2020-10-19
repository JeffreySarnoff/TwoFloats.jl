# PairArithmetic.jl

### Copyright ©2020 by Jeffrey Sarnoff. This material is made available under the MIT License.

----

## The Concept

### implement more performant, less demanding analog of `Double64s`
   - introduce hardwon improvements in error-free transformations
   - allow faithful rounding within the least significant octet

### the extended precision arithmetic
   - when working with unexceptional values
        - improves on `DoubleFloats.jl Double64 type` throughput
        - individual operations are accurate to 100 significant bits or more
   - when working with `NaNs`, `subnormals`, values > sqrt(floatmax)
        - special case logic requires branching
        - indivdual operations are computed without accuracy guards
        - subnormal processing is inherently slow
 
### design for interoperable advantage   
   - make ready the use of `StructArrays.jl` with Vectors and Matricies of `Pairs`
       - this is a requirement for best success in applying LoopVectorization.jl
 
----

## References

- for the _Pair Arithmetic_ defintions
```
Faithfully Rounded Floating-point Computations
by Marko Lange and Siegfried M. Rump
ACM Transactions on Mathematical Software, July 2020, Article No.: 21
https://doi.org/10.1145/3290955
```
