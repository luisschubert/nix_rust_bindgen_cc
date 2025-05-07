// src/main.rs
include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

fn main() {
    // call the C function (unsafe FFI)
    let sum = unsafe { add(2, 3) };
    println!("2 + 3 = {}", sum);
}
