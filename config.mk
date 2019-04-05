# Project version
NAME    = prog
VERSION = 0.0.1

# Paths
PREFIX     ?= /usr/local
MANPREFIX  ?= $(PREFIX)/share/man

# SLURM parameters
SLURM_HOST ?= yourhost
SLURM_PATH ?= ~/.remote
SLURM_NODE ?= somenode

# Compiler
CXX  ?= clang++

# Compile flags
CXXFLAGS += -O3 -march=native
CXXFLAGS += -DVERSION=\"$(VERSION)\"
CXXFLAGS += -Wall -Wextra -Werror -Wnull-dereference \
                -Wdouble-promotion -Wshadow

# Language
CXXFLAGS += -std=c++17

# Includes
CXXFLAGS += -Iinclude -I$(CUDA_HOME)/include

# CUDA
CUFLAGS  += --cuda-gpu-arch=$(CUDA_GPU_ARCH)

# Linker
LDFLAGS  += -fPIC -O3
LDFLAGS  += -lm -lcudart

