## Compiler environments

GNU compiler (gcc) is the default compiler on both sides of Roihu, and is loaded automatically on login.
Use it by default unless otherwise stated, or if the user has loaded something else.

### Roihu-CPU
| Compiler suite | Modules | Compiler executables |
|---|---|---|
| GNU(GCC) | gcc openmpi | `gcc`, `g++`, `gfortran` |
| AMD AOCC | aocc openmp | `clang`, `clang++`, `flang` |

### Roihu-GPU
| Compiler suite | Modules | Compiler executables |
|---|---|---|
| GNU + CUDA | gcc cuda openmpi openblas | `nvcc` (Cuda) |
| NVIDIA HPC | nvhpc/26.3 | `nvc`, `nvc++`, `nvfortran` |

Different versions of gcc have specific versions of Cuda they are compatible with, but Lmod module hierarchy ensures you can't load incompatible combinations.
If user requires a specific version of Cuda, use `module spider cuda/<version>` to see which version of gcc it requires.

## Detailed instructions
Here are detailed instructions for compiling different kinds of programs. Figure out what kind of case your code belongs into by reading the code or asking the user.
Note down the modules you have loaded during compilation in all cases. These will likely need to be loaded during runtime as well to ensure correct shared libraries are available.

### General CPU
Use the correct tuning flags: 
`-march=znver5` on Roihu-CPU for both gcc and aocc.
`-mcpu=grace` on Roihu-GPU for gcc, nvhpc should autodetect correctly.

### Multi-threaded(OpenMP)
Remember `-openmp` flag.

### MPI
Use MPI compiler wrappers: `mpicc` (C), `mpicxx` (C++), `mpif90` (Fortran).
The MPI implementation on Roihu is OpenMPI, and the module is loaded by default unless the user has manually unloaded it.

### GPU(Cuda)
Use `nvcc` to compile Cuda code. Roihu has Hopper GPUs, which have compute capability 90. 
Build for this compute capability with `-gencode arch=compute_90,code=sm_90`, or `-gencode arch=compute_90a,code=sm_90a` (Hopper specific, may give slightly better performance.)

### Cuda+MPI
OpenMPI and nvhpc both provide cuda-aware MPI libraries, and provide same wrappers as mentioned in the MPI section.
OpenMPI is the default, use it unless the user asks otherwise or has already loaded `nvhpc`.

If the structure of the code allows it, easiest way to do this is in parts:
1. Compile CUDA kernels to object files with `nvcc -c`
2. Compile host code to object files with the MPI compiler wrappers (`mpicc -c`/`mpicxx -c`/`mpif90 -c`)
3. Link all the object files with the relevant MPI wrapper.

If the code isn't nicely separated like that, use `nvcc` in the following way to compile the whole codebase:
```bash
# Parse MPI options for compiler
Xcompiler="-Xcompiler $(mpicxx --showme | tr ' ' '\n' | sed '/^-Wl,/d;1d' | paste -sd, -)"

# Parse MPI options for linker
Xlinker="-Xlinker $(mpicxx --showme | tr ' ' '\n' | sed -n 's/^-Wl,//p' | paste -sd, -)"

# Compile MPI code using nvcc
nvcc -gencode arch=compute_90a,code=sm_90a $Xcompiler $Xlinker mpi_cuda_code.cu
```

### OpenMP offload, OpenACC, and C++ stdpar
Using `nvhpc` in this case is recommended.
Specify correct target with `-gpu=cc90` flag.

Use the relevant compiler flags for enabling each of these options:
- OpenMP offload: `-mp=gpu`
- OpenACC: `-acc=gpu`
- C++ stdpar `-stdpar=gpu` (nvc++ only)

## Potential problems and fixes
- User has old code that worked on older machines.
    - Potential quick fix: try using an older C/C++ dialect. On gcc this is done with `-std` flag, for example `-std=gnu11`/`-std=gnu++14`. Defaults for these change with newer compilers, which sometimes breaks older codes.
