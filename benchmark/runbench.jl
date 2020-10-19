using BenchmarkTools
const BT=BenchmarkTools.DEFAULT_PARAMETERS;
BT.seconds = 10; BT.samples = 10_000; BT.time_tolerance = 1.0e-10;

using LinearAlgebra, Statistics
using Quadmath, RandomNumbers 
using PairArithmetic


