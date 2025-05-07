// build.rs
use std::env;
use std::path::PathBuf;

fn main() {
    // 1) compile the C code FOR the target (AArch64)
    cc::Build::new()
        .file("c_src/library.c")
        .include("c_src")
        .compile("library");

    // 2) generate Rust bindings ON THE HOST via bindgen
    let bindings = bindgen::Builder::default()
        .header("c_src/library.h")
        .clang_arg("-Ic_src")
        .generate()
        .expect("bindgen failed");

    let out = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out.join("bindings.rs"))
        .expect("couldn’t write bindings");
}
