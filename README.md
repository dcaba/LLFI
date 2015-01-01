LLFI
====

LLFI is an LLVM based fault injection tool, that injects faults into the LLVM IR of the application source code.  The faults can be injected into specific program points, and the effect can be easily tracked back to the source code.  LLFI is typically used to map fault characteristics back to source code, and hence understand source level or program characteristics for various kinds of fault outcomes.    

Please join the following Google Groups for information related to LLFI development: llfi-development@googlegroups.com

Auto-Installer
--------------
This is the recommended method for building the LLFI. If you wish to build the LLFI via the auto-installer, you *do not need* to clone the LLFI git repository. Simply download the installer script by itself, and it will fetch the latest version of the git repository for you. The LLFI auto-installer takes the form of a single python script (installer/installLLFI.py). To run the script, simply copy it into the directory where you would like to build the LLFI and, from the command line, run "python installLLFI.py". You may run the installer with python2 or python3, but python3 is required to succesfully install and run the LLFI.
  
Dependencies:
  1. 32/64 Bit Linux or OS X
  2. Cmake (mininum v2.8)
  3. Python 3 or above
  4. Java Development kit 1.7
  5. Apache Ant 
  6. tcsh
  7. GraphViz package (for visualizing error propagation)
  8. Internet Connection

Usage:
run "python InstallLLFI.py -h" to see all running options/guidelines
  1. Copy the InstallLLFI.py script to where you want to build the LLFI
  2. Make sure you are _not_ logged in as root
  2. Run "python InstallLLFI.py"
  3. Wait for compilation to finish
  4. Run the GUI by executing "./LLFI-GUI"

About tcsh:

The LLFI-GUI uses tcsh to read environment variables describing the location of the LLFI build. The installer will automatically add those environmnet variables to your ~/.tcshrc file. You do not need to actively use tcsh as your primary shell, simply having it installed is enough.

Manual Install
---------------
This method is also available, and may be more suitable if you want more control over the location of the LLVM build that the LLFI requires (ie, you already have LLVM built and wish to use that build).

Dependencies:
  
  1. 32/64 bit Linux or OS X
  2. CMake (minimum v2.8)
  3. Python 3 and above
  4. Python YAML library (PyYAML)
  5. Clang v3.4
  6. LLVM v3.4, built with CMake
    * Build llvm-3.4 **WITH CMAKE** using flag `-DLLVM_REQUIRES_RTTI=1`. [Instructions](http://llvm.org/docs/CMake.html)
    * Remember to run `make` in the llvm build directory after running `cmake`.
  7. Oracle JDK7 with JavaFX (For GUI)

Building:
  
  Run `./setup --help` for build instructions.
```
  $ ./setup --help

  Usage: setup OPTIONS
  List of options:
  -LLVM_DST_ROOT <LLVM CMake build root dir>:
      Make sure you build LLVM with CMake and pass build root directory here
  -LLVM_SRC_ROOT <LLVM source root dir>
  -LLFI_BUILD_ROOT <path where you want to build LLFI>
  -LLVM_GXX_BIN_DIR <llvm-gcc/g++'s parent dir> (optional):
      You don't need to set it if it is in system path
  -JAVA_HOME_DIR <java home directory for oracle jdk 7 or higher> (optional):
    You don't need to set it if your default jdk is oracle jdk 7 or higher and in system path


  --help(-h): show help information
  --no_gui: Add this option if you do not want GUI.
```

  Here is a sample build command if `clang` and `javac` are already in $PATH:
```
  ./setup -LLFI_BUILD_ROOT $BUILD/LLFI -LLVM_SRC_ROOT $SRC/llvm-3.4 -LLVM_DST_ROOT $BUILD/llvm-3.4
```

Build without GUI:
To build LLFI without GUI, just add option: `--no_gui` in the command line for setup, for example:
```
./setup -LLFI_BUILD_ROOT $BUILD/LLFI -LLVM_SRC_ROOT $SRC/llvm-3.4 -LLVM_DST_ROOT $BUILD/llvm-3.4 --no_gui
```


Running
-------
You can use test programs in the *test_suite/PROGRAMS/* directory to test LLFI.
####Command line
Example program: `factorial`
  1. Copy the *factorial/* directory from *test_suite/PROGRAMS/* to your project directory. 
  2. Change to your *factorial* directory Build a single IR file with the LLFI tool `GenerateMakefile`
      ```
      <LLFI_BUILD_ROOT>/tools/GenerateMakefile --readable --all -o factorial.ll
      ```
     Alternatively, you can build your own IR file with `clang`.
  3. Instrument factorial with calls to LLFI libraries and create executables under *llfi* directory
      ```
      <LLFI_BUILD_ROOT>/bin/instrument --readable factorial.ll
      ```
  4. Run factorial executable with profiling functions instrumented
      ```
      <LLFI_BUILD_ROOT>/bin/profile ./llfi/factorial-profiling.exe 6
      ```
     In file *llfi/baseline/golden_std_output*, you should be able to see 720
  5. Run `factorial` executable with fault injection functions instrumented
      ```
      <LLFI_BUILD_ROOT>/bin/injectfault ./llfi/factorial-faultinjection.exe 6
      ```

  For complete test of whole of LLFI, please use LLFI test suite and refer to wiki page: [[Test suite for regression test|https://github.com/DependableSystemsLab/LLFI/wiki/Test-Suite-for-Regression-Test]] for details.

####GUI
To run the **GUI** of LLFI, use `<LLFI_BUILD_ROOT>/bin/llfi-gui` to start the GUI.
```
<LLFI_BUILD_ROOT>/bin/llfi-gui
```

Results
-------
After fault injection, output from LLFI and the tested application can be found
in the *llfi* directory.

|     Directory      |                 Contents                       |
| ------------------ | ---------------------------------------------- |
| *std_output*       | Piped STDOUT from the tested application       |
| *llfi_stat_output* | Fault injection statistics                     |
| *error_output*     | Failure reports (program crashes, hangs, etc.) |



References
----------
* [LLFI Paper](http://blogs.ubc.ca/karthik/2013/02/15/llfi-an-intermediate-code-level-fault-injector-for-soft-computing-applications/)
* [LLFI Wiki](https://github.com/DependableSystemsLab/LLFI/wiki)

======		
Read *caveats.txt* for caveats and known problems.
