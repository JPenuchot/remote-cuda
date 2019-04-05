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
CU   ?= clang++

# Compile flags
COMMON_FLAGS += -O3 -march=native
COMMON_FLAGS += -DVERSION=\"$(VERSION)\"
COMMON_FLAGS += -Wall -Wextra -Werror -Wnull-dereference \
                -Wdouble-promotion -Wshadow

INCLUDES += -Iinclude -I$(CUDA_HOME)/include

CXXFLAGS += -std=c++17
CXXFLAGS += $(INCLUDES)

CUFLAGS  += -std=c++17 --cuda-gpu-arch=sm_35
CUFLAGS  += $(INCLUDES)

LDFLAGS  += -fPIC -O3
LDFLAGS  += -lm -lcudart
