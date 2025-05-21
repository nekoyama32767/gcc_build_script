if ! [ -d /build ]; then
    sudo mkdir /build
fi

sudo chown -R $USER:$USER /build
cd ~
if ! [ -d ~/gcc_build ]; then
    mkdir gcc_build
fi

cd ~/gcc_build

gmp_ver="6.3.0"
mpfr_ver="4.2.2"
mpc_ver="1.3.1"
gcc_ver="14.1.0"
gcc_dir="gcc14"

if ! [ -f gmp-$gmp_ver.tar.xz ];  then
    wget https://gmplib.org/download/gmp/gmp-$gmp_ver.tar.xz
fi
tar xvf gmp-$gmp_ver.tar.xz
cd gmp-$gmp_ver
mkdir build
cd build
../configure --prefix=/build/$gcc_dir/gmp --enable-cxx
make -j
make install
cd ~/gcc_build


if ! [ -f mpfr-$mpfr_ver.tar.xz ];  then
    wget https://www.mpfr.org/mpfr-current/mpfr-$mpfr_ver.tar.xz
fi
tar xvf mpfr-$mpfr_ver.tar.xz
cd mpfr-$mpfr_ver
mkdir build
cd build
../configure --prefix=/build/$gcc_dir/mpfr --with-gmp=/build/$gcc_dir/gmp
make -j
make install
cd ~/gcc_build


if ! [ -f mpc-$mpc_ver.tar.gz ];  then
    wget https://ftp.gnu.org/gnu/mpc/mpc-$mpc_ver.tar.gz
fi
# wget https://ftp.gnu.org/gnu/mpc/mpc-$mpc_ver.tar.gz
tar xvf mpc-$mpc_ver.tar.gz
cd mpc-$mpc_ver
mkdir build
cd build
../configure --prefix=/build/$gcc_dir/mpc --with-gmp=/build/$gcc_dir/gmp --with-mpfr=/build/$gcc_dir/mpfr
make -j
make install
cd ~/gcc_build


if ! [ -f gcc-$gcc_ver.tar.gz ];  then
    wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$gcc_ver/gcc-$gcc_ver.tar.gz
fi
#wget https://ftp.jaist.ac.jp/pub/GNU/gcc/gcc-14.1.0/gcc-14.1.0.tar.gz
tar xvf gcc-$gcc_ver.tar.gz
cd gcc-$gcc_ver
mkdir build
cd build
unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE
../configure --prefix=/build/$gcc_dir/gcc --enable-languages=c,c++,fortran --disable-multilib --disable-bootstrap --with-gmp=/build/$gcc_dir/gmp --with-mpfr=/build/$gcc_dir/mpfr --with-mpc=/build/$gcc_dir/mpc
make -j
make install
