use rand::Rng;
use std::env;
use std::time::Instant;

struct Vector3D {
    x: f64,
    y: f64,
    z: f64,
}

impl Vector3D {
    fn dot(&self, other: &Vector3D) -> f64 {
        self.x * other.x + self.y * other.y + self.z * other.z
    }

    fn random(rng: &mut rand::rngs::ThreadRng) -> Self {
        Vector3D {
            x: rng.gen::<f64>() * f64::MAX * if rng.gen::<bool>() { 1.0 } else { -1.0 },
            y: rng.gen::<f64>() * f64::MAX * if rng.gen::<bool>() { 1.0 } else { -1.0 },
            z: rng.gen::<f64>() * f64::MAX * if rng.gen::<bool>() { 1.0 } else { -1.0 },
        }
    }
}

fn calculate_all_dot_products(vector_size: usize) -> f64 {
    let mut rng = rand::thread_rng();
    let mut sum = 0.0;

    let mut vectors_a = Vec::with_capacity(vector_size);
    let mut vectors_b = Vec::with_capacity(vector_size);

    for _ in 0..vector_size {
        vectors_a.push(Vector3D::random(&mut rng));
        vectors_b.push(Vector3D::random(&mut rng));
    }

    for i in 0..vector_size {
        sum += vectors_a[i].dot(&vectors_b[i]);
    }

    sum
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let vector_size = if args.len() > 1 {
        args[1].parse().unwrap_or(10_000_000)
    } else {
        10_000_000
    };

    println!("Running Rust vector dot product benchmark with size: {}", vector_size);
    println!("Generating {} random 3D vectors...", vector_size);

    println!("Starting benchmark...");
    let start = Instant::now();
    let result = calculate_all_dot_products(vector_size);
    let duration = start.elapsed();

    let total_seconds = duration.as_secs_f64();
    let minutes = (total_seconds / 60.0) as usize;
    let seconds = (total_seconds % 60.0) as usize;
    let milliseconds = ((total_seconds - total_seconds.floor()) * 1000.0) as usize;

    println!("Result: {}", result);
    println!("Time breakdown: {} minutes, {} seconds, {} milliseconds", minutes, seconds, milliseconds);
    println!("Total time in seconds: {}", total_seconds);
}