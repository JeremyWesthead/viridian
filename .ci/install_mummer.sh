# We have to handle mummer slightly differently as it can't just be copied in
# as it is used as a dependency of cylon

# Basic requirements
apt update
apt install -y wget gcc g++ make

# Extra runtime dependencies
apt install -y zlib1g-dev \
  libbz2-dev \
  liblzma-dev \
  libhts-dev \
  samtools \
  gawk bison

#________________________ mummer ____________________________#
wget -q https://github.com/mummer4/mummer/releases/download/v4.0.0rc1/mummer-4.0.0rc1.tar.gz
tar -xvf mummer-4.0.0rc1.tar.gz
cd mummer-4.0.0rc1
./configure LDFLAGS=-static
make
make install
ldconfig
cd ..
rm -rf mummer-4.0.0rc1

#_________________________ glibc ____________________________#
# This is a bit of a hack to get glibc 2.29 installed on the system
wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.29.tar.gz
tar -zxvf glibc-2.29.tar.gz
mkdir glibc-2.29/build
cd glibc-2.29/build
../configure --prefix=/opt/glibc
make 
make install
cd ../..
# rm -rf glibc-2.29
