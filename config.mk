# Project version
NAME    = prog
VERSION = 0.0.1

# Paths
PREFIX     ?= /usr/local
MANPREFIX  ?= $(PREFIX)/share/man

# Remote exec
SLURM_HOST ?= yourhost
SLURM_PATH ?= ~/.remote
SLURM_NODE ?= somenode

# Compilers
CXX  ?= clang++
CC   ?= clang
NVCC ?= nvcc

# Compile flags
COMMON_FLAGS += -O3 -march=native
COMMON_FLAGS += -DVERSION=\"$(VERSION)\"
COMMON_FLAGS += -Wall -Wextra -Werror -Wnull-dereference \
                -Wdouble-promotion -Wshadow

# Link flags
CXXFLAGS += -std=c++17
CXXFLAGS += -Iinclude -I$(CUDA_HOME)/include

# Includes/Libs
CCFLAGS  += -std=c11
CCFLAGS  += -Iinclude -I$(CUDA_HOME)/include

LDFLAGS  += -fPIC -O3
LDFLAGS  += -lm -lcudart
