# BWRC Setup Stuff

## BWRC Info

- BWRC sysadmin email: bwrc-sysadmins@lists.eecs.berkeley.edu
- BWRC Wiki: bwrcwiki.eecs.berkeley.edu (only accessible within EECS network)
    - Username: NameSurname
- BWRC website: bwrc.eecs.berkeley.edu
    - Username/password: CalNet ID
** For a list of server resources, please see:
   https://bwrcwiki.eecs.berkeley.edu/

** For more information on printing, CAD Tools, wireless networking, and more:
   https://bwrcwiki.eecs.berkeley.edu/Computing
-  For UNIX, use the "yppasswd" command

## VPN

- ssh tunnel alternative
- use globalprotect client on OSX or Windows
- use openconnect package from AUR
    - gpclient for SAML auth
- `sshuttle -vvvv -r cs199-ban@eda-1.eecs.berkeley.edu 0/0 -x eda-1.eecs.berkeley.edu`

## SSH Setup - Keys

## Basic Bash Setup

- .bashrc
    - flexlm, lsf scripts
    - set PS1
   - set colors
   - ser aliases
- set .bash_profile

## LSF

- bhosts, bjobs, bkill, bsub

## GUI sessions

- x2go and nomachine only options

- avoid executing any .bashrc stuff for a login shell
- add the following at the top of .bashrc
```bash
[[ $- == *i* ]] || return
```

## Modern Tooling

- BWRC servers run on RHEL 6, most software is very old (e.g. git 1.7, gcc 4.4)
- Previously I had used Linuxbrew/Homebrew as a local package manager, but it is hard to keep up to date and ruby is very slow
   - https://github.com/Linuxbrew/brew/wiki/CentOS6
   - https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen
- I tried using Junest, but CentOS 6 is too old for it to work even with all the workarounds
- Finally settled on **conda** (Miniconda3) which has a bunch of useful packages on the conda-forge channel

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
# go through install process
# add conda to your .bashrc
conda install -c conda-forge git tmux make bison flex coreutils tree
```

### Neovim

- Using the neovim AppImage doesn't work nicely since it is built for glibc 2.14, build from source
- https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source
   1. Modify .bashrc
   ```bash
   source /opt/rh/devtoolset-8/enable
   ```
   2. Install dependencies
   ```bash
   conda install -c conda-forge cmake ninja
   ```

   3. Build
   ```bash
   mkdir ~/neovim

   # download v0.4.4 tarball
   wget https://github.com/neovim/neovim/archive/v0.4.4.tar.gz
   tar -xzvf v0.4.4.tar.gz
   cd neovim-0.4.4

   # patch a file
   vim third-party/cmake/BuildLibvterm.cmake # (remove line 30 - CONFIGURE_COMMAND "") # see: https://github.com/neovim/neovim/issues/12675

   bsub -Is "make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS=\"-DCMAKE_INSTALL_PREFIX=$HOME/neovim\""
   make install
   ```

## Chipyard on BWRC

### Basic Setup

- Run the steps from the Chipyard docs as usual to set up the repo
    ```bash
    cd /tools/B/<your username>
    git clone git@github.com:ucb-bar/chipyard
    cd chipyard
    ./scripts/init-submodules-no-riscv-tools.sh
    ```
        - this will take a while, 20-30 minutes

### Install Verilator

- Chipyard requires Verilator version 4.034 (as of Chipyard 1.4), build from source
    1. Modify your `.bashrc` to use a specific version of bison and the regular devtoolset-8 (don't add any other stuff to PATH/LD_LIBRARY_PATH):
        ```bash
        source /opt/rh/devtoolset-8/enable
        export PATH="/users/vighnesh.iyer/bison-3.4:$PATH"
        ```

   2. Then build:
      ```bash
      mkdir ~/verilator-4.034
      git clone http://git.veripool.org/git/verilator
      cd verilator
      git checkout v4.034
      autoconf
      ./configure --prefix /users/vighnesh.iyer/verilator-4.034
      bsub -Is "make"
      make install
      cd ~/verilator-4.034 && verilator --version
      Verilator 4.034 2020-05-03 rev v4.034
      ```

   3. Finally put verilator on your PATH:
      ```bash
      export PATH="$HOME/verilator-4.034/bin:$PATH"
      ```

### Install RISCV toolchain

#### Quick

##### GCC 8.x (good enough for most)

```bash
wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6.tar.gz
tar -xzvf riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6.tar.gz
mv riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-centos6 ~/riscv-sifive
```
- Set $RISCV and add to $PATH
```bash
export RISCV="$HOME/riscv-sifive"
export PATH="$RISCV/bin:$PATH"
```

##### GCC 9.x

- Copy the prebuilt and patched tools to your home
```bash
cp -r /users/vighnesh.iyer/riscv-1.4 ~/.
```

- Set $RISCV and add to $PATH
```bash
export RISCV="$HOME/riscv-1.4"
export PATH="$RISCV/bin:$PATH"
```

#### Full Details

1. Download and unpack the prebuilt tools
   ```bash
   mkdir ~/riscv-1.4
   wget https://github.com/ucb-bar/chipyard-toolchain-prebuilt/archive/chipyard-1.4-bump.zip
   unzip chipyard-toolchain-prebuilt-chipyard-1.4-bump.zip
   cd chipyard-toolchain-prebuilt-chipyard-1.4-bump
   make DESTDIR=$HOME/riscv-1.4 install
   ```

   If you try running the tools as-is, you will get dynamic loading errors:
   ```bash
   ~/riscv-1.4/bin/riscv64-unknown-elf-gcc
   ./riscv64-unknown-elf-gcc: /lib64/libc.so.6: version GLIBC_2.14 not found (required by ./riscv64-unknown-elf-gcc)
   ```

   We need to patch these binaries with a custom dynamic loader and associated libc.

2. Analyze dynamic dependencies
   ```bash
   cd ~/riscv-1.4/bin && ldd *
   cd ~/riscv-1.4/libexec/gcc/riscv64-unknown-elf/9.2.0 && ldd *
   cd ~/riscv-1.4/riscv64-unknown-elf/bin && ldd *
   ```

   Note the dependencies of each binary. Here is a list of all the dependencies we care about.
   - libc.so.6 => /lib64/libc.so.6
   - libm.so.6 => /lib64/libm.so.6
   - libdl.so.2 => /lib64/libdl.so.2
   - libz.so.1 => /lib64/libz.so.1
   - libmpc.so.3 => not found
   - libmpfr.so.4 => not found
   - libgmp.so.10 => not found
   - /lib64/ld-linux-x86-64.so.2 (program interpreter)

   - for gdb specifically: (not going to bother fixing)
      - libpython2.7.so.1.0 => not found
      - liblzma.so.5 => not found
      - libncursesw.so.5 => /lib64/libncursesw.so.5 (0x0000003ee4a00000)
      - libtinfo.so.5 => /lib64/libtinfo.so.5 (0x0000003eee600000)
      - libexpat.so.1 => /lib64/libexpat.so.1 (0x0000003ee2200000)

3. Evaluate our plan
   - These binaries depend on:
      - GNU libc with version GLIBC 2.14+ (libc, libm, libdl)
      - libmpc, libmpfr, and libgmp (multiprecision arithmetic libraries)
      - libz (zlib compression/decompression)
   - Our plan is to gather all these libraries' shared objects in our home directory and use `patchelf` to direct the precompiled RISC-V toolchain binaries to use our custom loader, glibc, and other .so's

4. Build glibc
   - **IMPORTANT**: remove any changes to your $PATH (e.g. adding devtoolset-8, bison); you need the **system** build tools to build glibc 2.14
   - Reference: https://unix.stackexchange.com/questions/176489/how-to-update-glibc-to-2-14-in-centos-6-5
   ```bash
   mkdir ~/glibc-2.14
   wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
   tar -xzvf glibc-2.14.tar.gz
   cd glibc-2.14
   mkdir build && cd build
   ../configure --prefix=/users/vighnesh.iyer/glibc-2.14
   bsub -Is "make -j4"
   make install
   ```
   - This will mostly succeed, but will fail at the end with the following message:
   ```text
   /users/vighnesh.iyer/sources/glibc-2.14/build/elf/ldconfig: Can't open configuration file /users/vighnesh.iyer/glibc_214/etc/ld.so.conf: No such file or directory
   make[1]: Leaving directory /users/vighnesh.iyer/sources/glibc-2.14
   ```
   - To fix:
   ```bash
   cp /etc/ld.so.conf ~/glibc_214/etc/.
   cp -r /etc/ld.so.conf.d ~/glibc_214/etc/.
   ```
   - Rerun `make install`

5. Install other dependencies
   - Reference https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen
   - To avoid building from source, download RPMs (CentOS 7) of the required dependencies (use https://pkgs.org/) and extract them
   ```bash
   mkdir ~/sources/rpm && cd ~/sources/rpm
   wget http://mirror.centos.org/centos/7/os/x86_64/Packages/gmp-6.0.0-15.el7.x86_64.rpm
   rpm2cpio gmp-6.0.0-15.el7.x86_64.rpm | cpio -id
   wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libmpc-1.0.1-3.el7.x86_64.rpm
   rpm2cpio libmpc-1.0.1-3.el7.x86_64.rpm | cpio -id
   wget http://mirror.centos.org/centos/7/os/x86_64/Packages/mpfr-3.1.1-4.el7.x86_64.rpm
   rpm2cpio mpfr-3.1.1-4.el7.x86_64.rpm | cpio -id
   http://mirror.centos.org/centos/7/os/x86_64/Packages/zlib-1.2.7-18.el7.x86_64.rpm
   rpm2cpio zlib-1.2.7-18.el7.x86_64.rpm | cpio -id

   cp -r ~/sources/rpm/usr/lib64/* ~/glibc-2.14/lib/.
   ```

6. Patch binaries
   - Readd devtoolset-8 to your $PATH
   - Install patchelf
      ```bash
      mkdir ~/patchelf-0.12
      git clone git@github.com:NixOS/patchelf.git
      git checkout 0.12
      ./bootstrap.sh
      ./configure --prefix=/users/vighnesh.iyer/patchelf-0.12
      make
      make check
      make install
      ```
      - add patchelf to your $PATH
   - Run `find . -type f -executable -exec patchelf --set-interpreter ~/glibc-2.14/lib/ld-linux-x86-64.so.2 --set-rpath ~/glibc-2.14/lib/ {} \;` in
      - `riscv-1.4/bin`
      - `riscv-1.4/libexec/gcc/riscv64-unknown-elf/9.2.0`
      - `riscv-1.4/riscv64-unknown-elf/bin`
      - Some errors are expected (patchelf: unsupported overlap of SHT_NOTE and PT_NOTE), all the important binaries have been patched regardless (gdb won't work yet)

7. Set $RISCV and $PATH
   ```bash
   export RISCV="$HOME/riscv-1.4"
   export PATH="$RISCV/bin:$PATH"
   ```

8. Build DTC (device tree compiler)
   ```bash
   cd ~/ && wget https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-1.6.0.tar.gz
   tar -xzvf dtc-1.6.0.tar.gz
   cd dtc-1.6.0
   make
   make install
   mv ~/bin ~/dtc-1.6.0
   ```
   Put dtc-1.6.0 on your $PATH
   ```bash
   export PATH="$HOME/dtc-1.6.0:$PATH"
   ```

### Build RISC-V Tools and Tests

- Spike (RISC-V ISA simulator) + Fesvr (host interaction library)
```bash
cd /tools/B/vighnesh.iyer/chipyard/toolchains/riscv-tools/riscv-isa-sim
git submodule update --init --recursive . # clone only the riscv-isa-sim submodule (requires git in /users/vighnesh.iyer/miniconda3/bin/git)
mkdir build
cd build
../configure --prefix=$RISCV
make
make install
```

- pk (proxy kernel)
```bash
cd .../chipyard/toolchains/riscv-tools/riscv-pk
git submodule update --init --recursive .
mkdir build
cd build
../configure --prefix=$RISCV --host=riscv64-unknown-elf
make
make install
```

- riscv-tests (RISCV ISA microtests and benchmarks)
```bash
cd .../chipyard/toolchains/riscv-tools/riscv-tests
git submodule update --init --recursive .
autoconf
./configure --prefix=$RISCV/target
make
make install
```

- Test out the tools
```bash
$ which spike
/users/vighnesh.iyer/riscv-1.4/bin/spike

$ spike -l ~/riscv-1.4/target/share/riscv-tests/isa/rv64ui-p-add
...
$ echo $?
0

$ spike ~/riscv-1.4/target/share/riscv-tests/benchmarks/dhrystone.riscv
Microseconds for one run through Dhrystone: 392
Dhrystones per Second:                      2550
mcycle = 196024
minstret = 196029
```

### Build an RTL Simulator

```bash
cd chipyard/sims/verilator
LD_LIBRARY_PATH=/tools/projects/johnwright/install/hack/lib:$LD_LIBRARY_PATH bsub -Is "make"
```
- If you don't use John's libc hack, you will get an error like this when compiling FIRRTL:
   ```text
   /tmp/protocjar10293879504066272150/bin/protoc.exe: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /tmp/protocjar10293879504066272150/bin/protoc.exe)
   [error] java.lang.RuntimeException: protoc returned exit code: 1
   ```
- In the future, you don't have to prepend make invocations with the LD_LIBRARY_PATH hack unless you delete the firrtl build artifacts
- In the end, you should get a simulator binary:
```bash
$ ls chipyard/sims/verilator
simulator-chipyard-RocketConfig
$ make run-binary-fast-hex BINARY=~/riscv-1.4/target/share/riscv-tests/isa/rv64ui-p-add
$ make run-binary-fast-hex BINARY=~/riscv-1.4/target/share/riscv-tests/benchmarks/dhrystone.riscv
```

### Setup HAMMER for VLSI Flow (tsmc28)

Clone the VLSI repos.
```bash
./scripts/init-vlsi.sh
cd vlsi
git clone git@bwrcrepo.eecs.berkeley.edu:tstech28/hammer-tstech28-plugin
```

If you get permission errors when cloning, make sure you are added to the [ucb-bar](https://github.com/ucb-bar) Github group.
If you have Github 2FA enabled, you will need to [create a personal access token](https://github.com/settings/tokens) to clone private repos via https.

Create the following configuration files in `chipyard/vlsi`:

1. `bwrc-env.yml` (CAD tool install locations, license servers, LSF configuration)
   ```yaml
      mentor.mentor_home: "/tools/mentor"
      mentor.MGLS_LICENSE_FILE: "1717@bwrcflex-1.eecs.berkeley.edu:1717@bwrcflex-2.eecs.berkeley.edu"
      cadence.cadence_home: "/tools/cadence"
      cadence.CDS_LIC_FILE: "5280@bwrcflex-1.eecs.berkeley.edu:5280@bwrcflex-2.eecs.berkeley.edu"
      synopsys.synopsys_home: "/tools/synopsys"
      synopsys.SNPSLMD_LICENSE_FILE: "1701@bwrcflex-1.eecs.berkeley.edu:1701@bwrcflex-2.eecs.berkeley.edu"
      synopsys.MGLS_LICENSE_FILE: "1717@bwrcflex-1.eecs.berkeley.edu:1717@bwrcflex-2.eecs.berkeley.edu"

      #submit command (use LSF)
      vlsi.submit:
          command: "lsf"
          settings: [{"lsf": {
              "bsub_binary": "/tools/support/lsf/9.1/linux2.6-glibc2.3-x86_64/bin/bsub",
              "num_cpus": 8,
              "queue": "bora",
              "extra_args": ["-R", "span[hosts=1]"]
              }
          }]
          settings_meta: "append"
      vlsi.core.max_threads: 8
   ```

2. `tstech28-tools.yml` (HAMMER plugin locations, CAD tool selections, CAD tool versions)
   ```yaml
      # Genus options
      vlsi.core.synthesis_tool: "genus"
      vlsi.core.synthesis_tool_path: ["hammer-cadence-plugins/synthesis"]
      vlsi.core.synthesis_tool_path_meta: "append"
      #synthesis.genus.version: "1813"
      synthesis.genus.version: "171" # this version must match Joules version

      # Innovus options
      vlsi.core.par_tool: "innovus"
      vlsi.core.par_tool_path: ["hammer-cadence-plugins/par"]
      vlsi.core.par_tool_path_meta: "append"
      par.innovus.version: "191_ISR3"
      par.innovus.design_flow_effort: "standard"
      par.inputs.gds_merge: true

      # Calibre options
      vlsi.core.drc_tool: "calibre"
      vlsi.core.drc_tool_path: ["hammer-mentor-plugins/drc"]
      vlsi.core.lvs_tool: "calibre"
      vlsi.core.lvs_tool_path: ["hammer-mentor-plugins/lvs"]

      # Voltus options
      vlsi.core.power_tool: "voltus"
      vlsi.core.power_tool_path: ["hammer-cadence-plugins/power"]
      vlsi.core.power_tool_path_meta: "append"

      # VCS options
      vlsi.core.sim_tool: "vcs"
      vlsi.core.sim_tool_path: ["hammer-synopsys-plugins/sim"]
      sim.vcs.version: "P-2019.06-SP2-5"
   ```

3. `tstech28.yml` (technology)
    ```yaml
      # Technology Setup
      vlsi.core.technology: tstech28
      vlsi.core.technology_path: ["hammer-tstech28-plugin"]
      vlsi.core.technology_path_meta: append
      vlsi.core.node: 28
      technology.tstech28.install_dir: "/tools/tstech28"

      # SRAM Compiler compiler options
      vlsi.core.sram_generator_tool: "sram_compiler"
      # You should specify a location for the SRAM generator in the tech plugin
      vlsi.core.sram_generator_tool_path: ["hammer-tstech28-plugin"]
      vlsi.core.sram_generator_tool_path_meta: "append"

      # Generate Make include to aid in flow
      vlsi.core.build_system: make
    ```

4. `design.yml` (Design specific concerns - constraints, power pins, pin placement)
   ```yaml
       #supplies, and corners in tech plugin
      vlsi.inputs.supplies.power: [
        {name: "VDD", pin: "VDD"},
        {name: "VPP", pin: "VPP", tie: "VDD"}
      ]
      vlsi.inputs.supplies.ground: [
        {name: "VSS", pin: "VSS"},
        {name: "VBB", pin: "VBB", tie: "VSS"}
      ]

      vlsi.inputs.default_output_load: 0.05

      vlsi.inputs.delays: [
        {name: "*", clock: "clock", delay: "0.2", direction: "input"}
      ]

      # Hammer will auto-generate a CPF for simple power designs; see hammer/src/hammer-vlsi/defaults.yml for more info
      vlsi.inputs.power_spec_mode: "auto"
      vlsi.inputs.power_spec_type: "cpf"

      # Specify clock signals
      vlsi.inputs.clocks: [
        {name: "clock", period: "5ns", uncertainty: "0.1ns"}
      ]

      synthesis.clock_gating_mode: empty

      # Power Straps
      par.power_straps_mode: generate
      par.generate_power_straps_method: by_tracks
      par.blockage_spacing: 2.0
      # par.blockage_spacing_top_layer: "m4"
      par.generate_power_straps_options:
        by_tracks:
          strap_layers:
            - m3
            - m4
            - m5
            - m6
              #- m7
              #- m8
              #   # pin_layers:
            - m8
          track_width: 1
          track_width_m5: 2
          track_width_m6: 4
          track_spacing: 0
          track_spacing_M3: 2
          track_spacing_M4: 2
          track_start: 10
          power_utilization: 0.2
          power_utilization_M5: 0.1
          power_utilization_M7: 0.8
          power_utilization_M8: 0.9

      # Placement Constraints
      par.innovus.floorplan_mode: "auto"
      vlsi.inputs.placement_constraints:
        - path: "ChipTop"
          type: toplevel
          x: 0
          y: 0
          width: 300
          height: 300
          margins:
            left: 0
            right: 0
            top: 0
            bottom: 0

      # Pin placement constraints
      vlsi.inputs.pin_mode: generated
      vlsi.inputs.pin.generate_mode: semi_auto
      vlsi.inputs.pin.assignments: [
        {pins: "*", layers: ["m3", "m5"], side: "bottom"}
      ]
   ```

Source the HAMMER environment.
```bash
   cd vlsi/hammer && source sourceme.sh
```

Create the HAMMER Makefile fragment (which builds a Chipyard SoC in `generated-src`, sets up the SRAM compiler, and generates a Makefile fragment in `build/chipyard.TestHarness.RocketConfig-ChipTop/hammer.d`).
```bash
make buildfile ENV_YML="bwrc-env.yml" INPUT_CONFS="tstech28-tools.yml tstech28.yml design.yml" tech_name=tstech28 USE_SRAM_COMPILER=1
```

Build an RTL simulator and run a binary.
```bash
make sim-rtl ENV_YML="bwrc-env.yml" INPUT_CONFS="tstech28-tools.yml tstech28.yml design.yml" tech_name=tstech28 USE_SRAM_COMPILER=1 BINARY=/users/vighnesh.iyer/riscv-1.4/target/share/riscv-tests/benchmarks/dhrystone.riscv
```

Use the `redo-sim-rtl` target to rerun simulation with a different `BINARY` (the entire simulator is still rebuilt however).
Use the `syn` target to synthesize the design and the `sim-syn-debug` target to build a post-syn simulator.

## Old (Broken) BWRC Setup Notes

### Linuxbrew

Here are instructions from the linuxbrew Github wiki (https://github.com/Linuxbrew/brew/wiki/CentOS6). Be aware, this compiles a bunch of stuff from source, so it will take a while.

### Install Linuxbrew on CentOS 6 without sudo

Building glibc 2.23 requires GCC 4.7 or later, and CentOS 6 provides GCC 4.4, so build GCC from source before building glibc.

```bash
bsub -Is "bash" # Execute the commands below from a LSF node
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_BUILD_FROM_SOURCE=1 brew install gcc --without-glibc
HOMEBREW_NO_AUTO_UPDATE=1 brew install glibc
# If encountering locale errors in postinstall of glibc, run
# HOMEBREW_NO_AUTO_UPDATE=1 LC_CTYPE=en_GB.UTF-8 brew postinstall glibc
# see issue - https://github.com/Linuxbrew/legacy-linuxbrew/issues/929
HOMEBREW_NO_AUTO_UPDATE=1 brew remove gcc
HOMEBREW_NO_AUTO_UPDATE=1 brew install gcc
```

### Trying to build GMP, MPC, MPFR from source

- Add devtoolset-8 to your $PATH for the following steps
    - Reference: https://stackoverflow.com/questions/9450394/how-to-install-gcc-piece-by-piece-with-gmp-mpfr-mpc-elf-without-shared-libra
    - This was a bad idea since gcc has these libraries themselves as a dependency which makes the build tricky
    - In the end, building MPC didn't work due to linker errors

- Building GMP
   ```bash
   wget https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz
   tar -xvf gmp-6.2.1.tar.xz
   cd gmp-6.2.1
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14
   bsub -Is "make"
   make install
   ```

- Building MPFR
   ```bash
   wget https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.gz
   tar -xzvf mpfr-4.1.0.tar.gz
   cd mpfr-4.1.0
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14 --with-gmp-build=/users/vighnesh.iyer/source/gmp-6.2.1
   bsub -Is "make"
   make install
   cd ~/glibc-2.14/lib
   ln -s libmpfr.so libmpfr.so.4
   ```

- Building MPC
   ```bash
   wget https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
   tar -xzvf mpc-1.2.1.tar.gz
   cd mpc-1.2.1
   ./configure --prefix=/users/vighnesh.iyer/glibc-2.14 --with-gmp=/users/vighnesh.iyer/glibc-2.14 --with-mpfr=/users/vighnesh.iyer/glibc-2.14
   configure: error: in /users/vighnesh.iyer/sources/mpc-1.2.1
   configure: error: C compiler cannot create executables
   ```
   ```text
   # config.log

   configure:3766: checking whether the C compiler works
   configure:3788: gcc -O2 -pedantic -fomit-frame-pointer -m64 -mtune=skylake -march=broadwell -I/users/vighnesh.iyer/glibc-2.14/include -I/users/vighnesh.iyer/glibc-2.14/include  -    L/users/vighnesh.iyer/glibc-2.14/lib -L/users/vighnesh.iyer/glibc-2.14/lib  conftest.c  >&5
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/libc.so.6
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/libc_nonshared.a
   /opt/rh/devtoolset-8/root/usr/libexec/gcc/x86_64-redhat-linux/8/ld: cannot find /users/vighnesh.iyer/glibc_214/lib/ld-linux-x86-64.so.2
   collect2: error: ld returned 1 exit status
   ```
- this failed and I have no way to fix it without rebuilding gcc with the custom glibc, don't bother with this method
