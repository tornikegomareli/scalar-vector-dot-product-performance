package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

type Vector3D struct {
	X, Y, Z float64
}

func (v Vector3D) Dot(other Vector3D) float64 {
	return v.X*other.X + v.Y*other.Y + v.Z*other.Z
}

func RandomVector() Vector3D {
	sign1 := 1.0
	if rand.Float64() < 0.5 {
		sign1 = -1.0
	}
	
	sign2 := 1.0
	if rand.Float64() < 0.5 {
		sign2 = -1.0
	}
	
	sign3 := 1.0
	if rand.Float64() < 0.5 {
		sign3 = -1.0
	}
	
	return Vector3D{
		X: rand.Float64() * 1.7976931348623157e+308 * sign1,
		Y: rand.Float64() * 1.7976931348623157e+308 * sign2,
		Z: rand.Float64() * 1.7976931348623157e+308 * sign3,
	}
}

func CalculateAllDotProducts(vectorSize int) float64 {
	var sum float64 = 0.0
	
	vectorsA := make([]Vector3D, 0, vectorSize)
	vectorsB := make([]Vector3D, 0, vectorSize)
	
	for i := 0; i < vectorSize; i++ {
		vectorsA = append(vectorsA, RandomVector())
		vectorsB = append(vectorsB, RandomVector())
		sum += vectorsA[i].Dot(vectorsB[i])
	}
	
	return sum
}

func main() {
	rand.Seed(time.Now().UnixNano())
	
	vectorSize := 10_000_000
	if len(os.Args) > 1 {
		if parsedSize, err := strconv.Atoi(os.Args[1]); err == nil {
			vectorSize = parsedSize
		}
	}
	
	fmt.Printf("Running Go vector dot product benchmark with size: %d\n", vectorSize)
	fmt.Printf("Generating %d random 3D vectors...\n", vectorSize)
	
	fmt.Println("Starting benchmark...")
	startTime := time.Now()
	result := CalculateAllDotProducts(vectorSize)
	duration := time.Since(startTime)
	
	minutes := int(duration.Minutes())
	seconds := int(duration.Seconds()) % 60
	milliseconds := int(duration.Milliseconds()) % 1000
	
	fmt.Printf("Result: %f\n", result)
	fmt.Printf("Time breakdown: %d minutes, %d seconds, %d milliseconds\n", minutes, seconds, milliseconds)
	fmt.Printf("Total time in seconds: %f\n", duration.Seconds())
}