# Nix Rust Bindgen CC

Example flake to build a binary for an aarch64 target on an x86 host from a rust project that uses bindgen to generate rust bindings.


## build
```bash
nix build .#default
```

### resulting binary for aarch64
```bash
file result/bin/example
```
```bash
result/bin/example: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /nix/store/7q1jf43dwd90fmnzzbp84pcmhlsv2mja-glibc-aarch64-unknown-linux-gnu-2.40-66/lib/ld-linux-aarch64.so.1, for GNU/Linux 3.10.0, not stripped
```
### run binary (with qemu support on x86)
```bash
./result/bin/example
```
```bash
2 + 3 = 5
```