#!/bin/bash

# Vector dot product benchmarking script
# This script runs both Swift and C# implementations and collects benchmark results

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

# Run Swift benchmark
echo
echo "Running Swift benchmark..."
echo "Swift Benchmark:" >>"$RESULTS_FILE"

if [ "$OS" = "macOS" ] || [ "$OS" = "Linux" ]; then
  cd ../swift/VectorDotProduct

  # Run Swift with release flag
  echo "Building and running Swift in release mode..."
  swift run -c release VectorDotProduct $VECTOR_SIZE >temp_output.txt

  # Process the output to add time in different formats
  while IFS= read -r line; do
    echo "$line" | tee -a ../../"$RESULTS_FILE"

    # If this is the time line, add the conversions
    if [[ "$line" == Time:* ]]; then
      # Extract milliseconds value
      ms=$(echo "$line" | grep -o '[0-9]\+')
      formatted=$(format_time $ms)
      echo "Time (formatted): $formatted" | tee -a ../../"$RESULTS_FILE"
    fi
  done <temp_output.txt

  rm temp_output.txt
  cd ../../
else
  echo "Swift not supported on this platform" | tee -a "$RESULTS_FILE"
fi

echo >>"$RESULTS_FILE"

# Run C# benchmark
echo
echo "Running C# benchmark..."
echo "C# Benchmark:" >>"$RESULTS_FILE"

if [ "$OS" = "Windows" ]; then
  cd csharp/VectorDotProduct

  # Run C# with release flag
  dotnet run --configuration Release $VECTOR_SIZE >temp_output.txt

  # Process the output to add time in different formats
  while IFS= read -r line; do
    echo "$line" | tee -a ../../"$RESULTS_FILE"

    # If this is the time line, add the conversions
    if [[ "$line" == Time:* ]]; then
      # Extract milliseconds value
      ms=$(echo "$line" | grep -o '[0-9]\+')
      formatted=$(format_time $ms)
      echo "Time (formatted): $formatted" | tee -a ../../"$RESULTS_FILE"
    fi
  done <temp_output.txt

  rm temp_output.txt
  cd ../../
elif [ "$OS" = "macOS" ] || [ "$OS" = "Linux" ]; then
  cd csharp/VectorDotProduct

  # Run C# with release flag
  dotnet run --configuration Release $VECTOR_SIZE >temp_output.txt

  # Process the output to add time in different formats
  while IFS= read -r line; do
    echo "$line" | tee -a ../../"$RESULTS_FILE"

    # If this is the time line, add the conversions
    if [[ "$line" == Time:* ]]; then
      # Extract milliseconds value
      ms=$(echo "$line" | grep -o '[0-9]\+')
      formatted=$(format_time $ms)
      echo "Time (formatted): $formatted" | tee -a ../../"$RESULTS_FILE"
    fi
  done <temp_output.txt

  rm temp_output.txt
  cd ../../
else
  echo "C# not supported on this platform" | tee -a "$RESULTS_FILE"
fi

echo
echo "Benchmarks complete. Results saved to $RESULTS_FILE"
