.POSIX:
.SUFFIXES: .cpp .hpp .h .cu .o .d .asm

include config.mk

# Sources
CXXSRC = $(shell find src -name "*.cpp")
CUSRC  = $(shell find src -name "*.cu")

# Objects
CXXOBJ = $(CXXSRC:.cpp=.o)
CUOBJ  = $(CUSRC:.cu=.o)

OBJ    = $(CXXOBJ) $(CUOBJ)

# Dependency files
DEPS   = $(OBJ:.o=.d)

all: $(NAME)

# Compilation
.cpp.o:
	$(CXX) $(CXXFLAGS) -MMD -c -o $@ $<
.cu.o:
	$(CXX) $(CXXFLAGS) $(CUFLAGS) -MMD -c -o $@ $<

# Linking
$(NAME): $(OBJ)
	$(CXX) -o $@ $(OBJ) $(LDFLAGS)

# Dependencies
-include $(DEPS)

debug: CXXFLAGS += -DDEBUG -g
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
