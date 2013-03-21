export PREFIX=$HOME/.avr
export PATH=$PATH:$PREFIX/bin
rm -rf $PREFIX/include $$PREFIX/share $PREFIX/source $PREFIX/lib $PREFIX/bin $PREFIX/avr 2> /dev/null
mkdir -p $PREFIX 2> /dev/null
cd $PREFIX
mkdir $PREFIX/download 2> /dev/null
mkdir $PREFIX/source 2> /dev/null

cd $PREFIX/download

BINUTILS_VER=2.23.1
GCC_VER=4.7.2
AVRLIBC_VER=1.8.0

MPC_VER=1.0.1
MPFR_VER=3.1.1
GMP_VER=5.1.1

CORES=4

ARDUINO_VER=1.0.4

if [ ! -f binutils-${BINUTILS_VER}.tar.bz2 ]
  then
    wget http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2
fi
if [ ! -f gcc-${GCC_VER}.tar.bz2 ]
  then
    wget http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2
fi

if [ ! -f avr-libc-${AVRLIBC_VER}.tar.bz2 ]
  then
    wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-${AVRLIBC_VER}.tar.bz2
fi

# GCC dependencies
if [ ! -f mpc-${MPC_VER}.tar.gz ]
  then
    wget http://ftp.gnu.org/gnu/mpc/mpc-${MPC_VER}.tar.gz
fi

if [ ! -f mpfr-${MPFR_VER}.tar.bz2 ]
  then
    wget http://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.bz2
fi

if [ ! -f gmp-${GMP_VER}.tar.bz2 ]
  then
    wget http://ftp.gnu.org/gnu/gmp/gmp-${GMP_VER}.tar.bz2
fi

cd $PREFIX/source
tar -xjf $PREFIX/download/binutils*.tar.bz2
cd binutils*
mkdir obj-avr
cd obj-avr
nice ../configure --prefix=$PREFIX --target=avr --disable-nls
make -j ${CORES}
if [ $? != 0 ]
  then 
    exit
fi

make install

cd $PREFIX/source

tar -xjf $PREFIX/download/gcc*.tar.bz2

# GCC wants these in it's source directory when configure is run

cd $PREFIX/source

tar -xjf $PREFIX/download/gmp*.tar.bz2
tar -xjf $PREFIX/download/mpfr*.tar.bz2
tar -xzf $PREFIX/download/mpc*.tar.gz

# Need to be named without versions in the name
mv gmp* ./gmp
mv mpfr* ./mpfr
mv mpc* ./mpc


cd $PREFIX/source/gmp*
./configure --prefix=$PREFIX --with-gmp=$PREFIX
make -j ${CORES}
if [ $? != 0 ]
  then 
    echo "Error building gmp"
    exit
fi
make install
if [ $? != 0 ]
  then 
    echo "Error installing gmp"
    exit
fi


# mpfr
cd $PREFIX/source/mpfr*
./configure --prefix=$PREFIX --target=avr --with-gmp=$PREFIX
make -j ${CORES}
if [ $? != 0 ]
  then 
    echo "Error building mpfr"
    exit
fi
make install
if [ $? != 0 ]
  then 
    echo "Error installing mpfr"
    exit
fi

# mpc
cd $PREFIX/source/mpc*
./configure --prefix=$PREFIX --target=avr --with-gmp=$PREFIX
make -j ${CORES}
if [ $? != 0 ]
  then 
    echo "Error building mpc"
    exit
fi
make install
if [ $? != 0 ]
  then 
    echo "Error installing mpc"
    exit
fi


cd $PREFIX/source/gcc*
export LD_LIBRARY_PATH=$PREFIX/lib64:$PREFIX/lib:$LD_LIBRARY_PATH
mkdir obj-avr
cd obj-avr
../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --with-gmp=$PREFIX  --with-mpfr=$PREFIX --with-mpc=$PREFIX
make -j ${CORES}
if [ $? != 0 ]
  then 
    echo "Error building gcc"
    exit
fi

make install
if [ $? != 0 ]
  then 
    echo "Error building gcc"
    exit
fi

cd $PREFIX/source
tar -xjf ../download/avr-libc*
cd avr-libc*
./configure --prefix=$PREFIX --build=`./config.guess` --host=avr
make  -j ${CORES}
if [ $? != 0 ]
  then
    echo "Error building avr-libc"
    exit
fi

cd $PREFIX/download
if [ ! -f arduino-${ARDUINO_VER}.tar.bz2 ]
  then
    wget https://arduino.googlecode.com/files/arduino-${ARDUINO_VER}-src.tar.gz
fi
cd $PREFIX
if [ ! -d arduino ]
  then
    tar -xzf $PREFIX/download/arduino-$ARDUINO_VER-src.tar.gz */hardware */libraries
    mv arduino* ./arduino
fi
