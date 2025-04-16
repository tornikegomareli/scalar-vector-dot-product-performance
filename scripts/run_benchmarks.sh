#!/bin/bash

# Vector dot product benchmarking script
# This script runs Swift, C#, Go, and Rust implementations and collects benchmark results

echo "Vector Dot Product Benchmark"
echo "==========================="
echo

# Default vector size
VECTOR_SIZE=${1:-10000000}
echo "Using vector size: $VECTOR_SIZE"

# Create results directory if it doesn't exist
mkdir -p results

# Get current timestamp for output files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_FILE="results/benchmark_${TIMESTAMP}.txt"

echo "Vector Dot Product Benchmark Results" >"$RESULTS_FILE"
echo "Date: $(date)" >>"$RESULTS_FILE"
echo "Vector Size: $VECTOR_SIZE" >>"$RESULTS_FILE"
echo "=======================================" >>"$RESULTS_FILE"
echo >>"$RESULTS_FILE"

# Function to detect OS
detect_os() {
  case "$(uname -s)" in
  Darwin*)
    echo "macOS"
    ;;
  Linux*)
    echo "Linux"
    ;;
  CYGWIN* | MINGW* | MSYS*)
    echo "Windows"
    ;;
  *)
    echo "Unknown"
    ;;
  esac
}

# Function to convert milliseconds to readable format
format_time() {
  local ms=$1
  local seconds=$(echo "scale=3; $ms/1000" | bc)
  local minutes=$(echo "scale=3; $seconds/60" | bc)

  echo "$ms ms ($seconds seconds, $minutes minutes)"
}

# Detect current OS
OS=$(detect_os)
echo "Detected OS: $OS"
echo "Operating System: $OS" >>"$RESULTS_FILE"
echo >>"$RESULTS_FILE"

# Main project directory
PROJECT_DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")

# Run Swift benchmark
echo
echo "Running Swift benchmark..."
echo "Swift Benchmark:" >>"$RESULTS_FILE"

if [ "$OS" = "macOS" ] || [ "$OS" = "Linux" ]; then
  cd "$PROJECT_DIR/swift/VectorDotProduct"

  # Compile Swift with -Ounchecked optimization (maximum performance)
  echo "Compiling Swift with -Ounchecked optimization..."
  swiftc -Ounchecked main.swift -o VectorDotProductBenchmark

  # Run the compiled binary
  echo "Running Swift benchmark..."
  ./VectorDotProductBenchmark $VECTOR_SIZE >temp_output.txt

  # Process the output
  while IFS= read -r line; do
    echo "$line" | tee -a "$PROJECT_DIR/$RESULTS_FILE"

    # Check if line contains time information
    if [[ "$line" == *"Time breakdown:"* ]] || [[ "$line" == *"Total time in seconds:"* ]]; then
      # No need for additional formatting as the program outputs detailed time already
      continue
    fi
  done <temp_output.txt

  # Clean up
  rm temp_output.txt
  cd "$PROJECT_DIR"
else
  echo "Swift not supported on this platform" | tee -a "$RESULTS_FILE"
fi

echo >>"$RESULTS_FILE"

# Run C# benchmark
echo
echo "Running C# benchmark..."
echo "C# Benchmark:" >>"$RESULTS_FILE"

if [ -d "$PROJECT_DIR/csharp/VectorDotProduct" ]; then
  cd "$PROJECT_DIR/csharp/VectorDotProduct"

  # Run C# with release flag
  dotnet run --configuration Release $VECTOR_SIZE >temp_output.txt

  # Process the output
  while IFS= read -r line; do
    echo "$line" | tee -a "$PROJECT_DIR/$RESULTS_FILE"
  done <temp_output.txt

  # Clean up
  rm temp_output.txt
  cd "$PROJECT_DIR"
else
  echo "C# implementation not found" | tee -a "$RESULTS_FILE"
fi

echo >>"$RESULTS_FILE"

# Run Go benchmark
echo
echo "Running Go benchmark..."
echo "Go Benchmark:" >>"$RESULTS_FILE"

if [ -d "$PROJECT_DIR/go/VectorDotProduct" ]; then
  cd "$PROJECT_DIR/go/VectorDotProduct"

  # Build Go with optimizations
  echo "Building Go..."
  go build -o VectorDotProductBenchmark main.go

  # Run the compiled binary
  echo "Running Go benchmark..."
  ./VectorDotProductBenchmark $VECTOR_SIZE >temp_output.txt

  # Process the output
  while IFS= read -r line; do
    echo "$line" | tee -a "$PROJECT_DIR/$RESULTS_FILE"
  done <temp_output.txt

  # Clean up
  rm temp_output.txt
  rm VectorDotProductBenchmark
  cd "$PROJECT_DIR"
else
  echo "Go implementation not found" | tee -a "$RESULTS_FILE"
fi

echo >>"$RESULTS_FILE"

# Run Rust benchmark
echo
echo "Running Rust benchmark..."
echo "Rust Benchmark:" >>"$RESULTS_FILE"

if [ -d "$PROJECT_DIR/rust/VectorDotProduct" ]; then
  cd "$PROJECT_DIR/rust/VectorDotProduct"

  # Build Rust with release optimizations
  echo "Building Rust with --release optimizations..."
  cargo build --release

  # Run the compiled binary
  echo "Running Rust benchmark..."
  ./target/release/vector_dot_product $VECTOR_SIZE >temp_output.txt

  # Process the output
  while IFS= read -r line; do
    echo "$line" | tee -a "$PROJECT_DIR/$RESULTS_FILE"
  done <temp_output.txt

  # Clean up
  rm temp_output.txt
  cd "$PROJECT_DIR"
else
  echo "Rust implementation not found" | tee -a "$RESULTS_FILE"
fi

echo
echo "Benchmarks complete. Results saved to $RESULTS_FILE"

