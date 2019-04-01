.POSIX:
.SUFFIXES: .c .cpp .hpp .h .cu .o .d .asm

include config.mk

# Sources
CXXSRC = $(shell find src -name "*.cpp")
CCSRC  = $(shell find src -name "*.c")
CUSRC  = $(shell find src -name "*.cu")

# Objects
CXXOBJ = $(CXXSRC:.cpp=.o)
CCOBJ  = $(CCSRC:.c=.o)
CUOBJ  = $(CUSRC:.cu=.o)

OBJ    = $(CXXOBJ) $(CCOBJ) $(CUOBJ)

# Dependency files
DEPS   = $(OBJ:.o=.d)

all: $(NAME)

# Compilation
.cpp.o:
	$(CXX) $(COMMON_FLAGS) $(CXXFLAGS) -MMD -c -o $@ $<
.c.o:
	$(CC) $(COMMON_FLAGS) $(CCFLAGS) -MMD -c -o $@ $<
.cu.o:
	$(NVCC) $(CUFLAGS) -MM -MF $(@:.o=.d) $<
	$(NVCC) $(CUFLAGS) -c -o $@ $<

# Linking
$(NAME): $(OBJ)
	$(CXX) -o $@ $(OBJ) $(LDFLAGS)

# Dependencies
-include $(DEPS)

debug: CXXFLAGS += -DDEBUG -g
debug: CCFLAGS  += -DDEBUG -g
debug: CUFLAGS  += -DDEBUG -g
debug: $(NAME)

clean:
	rm -f $(NAME) $(NAME).asm $(OBJ) $(DEPS)

run: $(NAME)
	./$(NAME)

# Run on a remote host using SLURM
slurm: $(NAME)
	ssh $(SLURM_HOST) mkdir -p $(SLURM_PATH)
	scp $(NAME) $(SLURM_HOST):$(SLURM_PATH)/$(NAME)
	ssh $(SLURM_HOST) srun -p $(SLURM_NODE) $(SLURM_PATH)/$(NAME)

dump: $(NAME)
	objdump -dC $(NAME) > $(NAME).asm

.PHONY: all clean slurm run dump
