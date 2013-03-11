INSTALL_DIR=/home/dwilkins/.avr
ARDUINO=$(INSTALL_DIR)/arduino/hardware/arduino/cores/arduino
TOOLS_DIR=/home/dwilkins/.avr
VARIANTS= $(INSTALL_DIR)/arduino/hardware/arduino/variants/mega
AVRDUDE_PATH=$(INSTALL_DIR)/bin

MCU = atmega1280
F_CPU = 16000000

CDEFS = -DF_CPU=$(F_CPU) -D__AVR_LIBC_DEPRECATED_ENABLE__
CXXDEFS = -DF_CPU=$(F_CPU) -D__AVR_LIBC_DEPRECATED_ENABLE__
CDEBUG = -g$(DEBUG)
CWARN = -Wall
CTUNING = -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
OPT = s

CINCS = -I$(ARDUINO) -I$(VARIANTS)
CXXINCS = -I$(ARDUINO) -I$(VARIANTS)


AM_CFLAGS = $(CDEBUG) $(CDEFS) $(CINCS) -O$(OPT) $(CWARN) $(CSTANDARD) $(CEXTRA) -mmcu=$(MCU)
AM_CXXFLAGS = $(CDEFS) $(CINCS) -O$(OPT) -mmcu=$(MCU)
# AM_CCASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs -mmcu=$(MCU)
AM_LDFLAGS = -lm

CC=avr-gcc
CXX=avr-g++
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AR=avr-ar
SIZE=avr-size
NM=avr-nm
AVRDUDE=avrdude


ACLOCAL_AMFLAGS = -I m4
EXTRA_DIST = autogen.sh

projectname_SOURCES = $(ARDUINO)/wiring.c $(ARDUINO)/wiring_analog.c $(ARDUINO)/wiring_digital.c $(ARDUINO)/wiring_pulse.c $(ARDUINO)/wiring_shift.c $(ARDUINO)/Print.cpp $(ARDUINO)/WString.cpp $(ARDUINO)/HardwareSerial.cpp $(ARDUINO)/WInterrupts.c main.cpp
bin_PROGRAMS = projectname
