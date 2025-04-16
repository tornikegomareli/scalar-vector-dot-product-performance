using System;
using System.Collections.Generic;
using System.Diagnostics;

class Program
{
    static void Main(string[] args)
    {
        // Parse vector size from command line or use default
        int vectorSize = args.Length > 0 ? int.Parse(args[0]) : 10_000_000;
        Console.WriteLine($"Running C# vector dot product benchmark with size: {vectorSize}");
        Console.WriteLine($"Generating {vectorSize} random 3D vectors...");

        // Use dynamic lists instead of pre-allocated arrays
        var vectorsA = new List<Vector3D>();
        var vectorsB = new List<Vector3D>();

        Console.WriteLine("Starting benchmark...");
        var stopwatch = Stopwatch.StartNew();
        double result = CalculateAllDotProducts(vectorsA, vectorsB, vectorSize);
        stopwatch.Stop();

        TimeSpan timeElapsed = stopwatch.Elapsed;
        int minutes = timeElapsed.Minutes;
        int seconds = timeElapsed.Seconds;
        int milliseconds = timeElapsed.Milliseconds;

        Console.WriteLine($"Result: {result}");
        Console.WriteLine($"Time breakdown: {minutes} minutes, {seconds} seconds, {milliseconds} milliseconds");
        Console.WriteLine($"Total time in seconds: {timeElapsed.TotalSeconds}");
    }

    static double CalculateAllDotProducts(List<Vector3D> a, List<Vector3D> b, int vectorSize)
    {
        double sum = 0.0;
        int i = 0;

        while (i < vectorSize)
        {
            a.Add(Vector3D.Random());
            b.Add(Vector3D.Random());
            sum += a[i].Dot(b[i]);
            i++;
        }

        return sum;
    }
}

struct Vector3D
{
    public double X { get; }
    public double Y { get; }
    public double Z { get; }

    public Vector3D(double x, double y, double z)
    {
        X = x;
        Y = y;
        Z = z;
    }

    public double Dot(Vector3D other)
    {
        return X * other.X + Y * other.Y + Z * other.Z;
    }

    public static Vector3D Random()
    {
        // Create a new random instance each time to match Swift behavior
        var random = new Random();

        // Match Swift's range from leastNormalMagnitude to greatestFiniteMagnitude
        return new Vector3D(
            x: (random.NextDouble() * double.MaxValue) * (random.Next(2) == 0 ? 1 : -1),
            y: (random.NextDouble() * double.MaxValue) * (random.Next(2) == 0 ? 1 : -1),
            z: (random.NextDouble() * double.MaxValue) * (random.Next(2) == 0 ? 1 : -1)
        );
    }
}