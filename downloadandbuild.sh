export PREFIX=$HOME/.avr
export PATH=$PATH:$PREFIX/bin
cd $PREFIX
mkdir download 2> /dev/null
mkdir source 2> /dev/null

cd download

BINUTILS_VER=2.23.1
GCC_VER=4.7.2
AVRLIBC_VER=1.8.0

MPC_VER=1.0.1
MPFR_VER=3.1.1
GMP_VER=5.1.1


wget http://ftp.gnu.org/gnu/binutils/binutils-2.23.1.tar.bz2
wget http://ftp.gnu.org/gnu/gcc/gcc-4.7.2/gcc-4.7.2.tar.bz2
wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2

# GCC dependencies
wget http://ftp.gnu.org/gnu/mpc/mpc-1.0.1.tar.gz
wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.1.tar.bz2
wget http://ftp.gnu.org/gnu/gmp/gmp-5.1.1.tar.bz2

cd $PREFIX/source
tar -xjf $PREFIX/download/binutils*.tar.bz2
cd binutils*
mkdir obj-avr
cd obj-avr
nice ../configure --prefix=$PREFIX --target=avr --disable-nls
make
make install

cd $PREFIX/source

tar -xjf $PREFIX/download/gcc*.tar.bz2

# GCC wants these in it's source directory when configure is run

cd $PREFIX/source

tar -xjf $PREFIX/download/gmp*.tar.bz2
tar -xjf $PREFIX/download/mpfr*.tar.bz2
tar -xzf $PREFIX/download/mpc*.tar.gz

# Need to be named without versions in the name
mv gmp* gmp
mv mpfr* mpfr
mv mpc* mpc

cd $PREFIX/source/gmp*
./configure --prefix=$PREFIX --target=avr --with-gmp=$PREFIX

# mpfr
cd $PREFIX/source/mpfr*
./configure --prefix=$PREFIX --target=avr --with-gmp=$PREFIX

export LD_LIBRARY_PATH=$PREFIX/lib64:$PREFIX/lib:$LD_LIBRARY_PATH
mkdir obj-avr
cd obj-avr
../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --with-gmp=$PREFIX  --with-mpfr=$PREFIX --with-mpc=$PREFIX

cd $PREFIX/source
tar -xjf ../download/avr-libc*

./configure --prefix=$PREFIX --build=`./config.guess` --host=avr


tar -xzvf ~/Downloads/arduino-1.0.3-src.tar.gz */hardware */libraries
