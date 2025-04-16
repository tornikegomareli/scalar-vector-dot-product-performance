# Vector Dot Product Benchmark

This repository contains benchmarks for vector dot product calculations implemented in Swift and C#. It's designed to compare the performance of these languages across different platforms.

## Overview

The benchmark performs a dot product operation on two very large vectors (arrays of doubles), measuring the execution time. The implementations are deliberately kept simple to focus on the raw computational performance of each language.

## Project Structure

```
vector-dot-product-benchmark/
├── csharp/                  # C# implementation
│   └── VectorDotProduct/    
│       ├── Program.cs       # Main C# program
│       └── VectorDotProduct.csproj
├── swift/                   # Swift implementation
│   └── VectorDotProduct/
│       ├── main.swift       # Main Swift program
│       └── Package.swift    # Swift package definition
├── scripts/
│   └── run_benchmarks.sh    # Script to run benchmarks
├── Dockerfile               # Docker configuration
└── README.md                # This file
```

## Requirements

To run locally:
- Swift 5.5+ (for macOS and Linux)
- .NET 8.0+ (for C# on all platforms)

To run with Docker:
- Docker

## Running the Benchmarks

### Locally

1. Make the script executable:
   ```bash
   chmod +x scripts/run_benchmarks.sh
   ```

2. Run the benchmarks:
   ```bash
   ./scripts/run_benchmarks.sh [vector_size]
   ```
   If no vector size is provided, defaults to 100,000,000.

### With Docker

1. Build the Docker image:
   ```bash
   docker build -t vector-benchmark .
   ```

2. Run the benchmarks:
   ```bash
   docker run vector-benchmark [vector_size]
   ```

## Results

Benchmark results are stored in the `results/` directory with timestamps.

## Implementation Details

Both implementations:
- Use a custom `Vector3D` struct with x, y, z coordinates as double-precision floating point numbers
- Generate 10 million random 3D vectors by default (configurable via command line)
- Initialize vectors with random values in the range from smallest to largest possible double values
- Calculate dot products between corresponding vector pairs
- Perform a warm-up run before measuring
- Use the same algorithm for the dot product calculation (x*x + y*y + z*z)

## Modifying the Benchmarks

- To change the vector size, pass it as an argument to the script
- To modify the implementation details, edit the respective source files

## License

This project is open source and available under the MIT License.