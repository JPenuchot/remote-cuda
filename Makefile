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
	nvcc $(CUFLAGS) -c -o $@ $<

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
remote: $(NAME)
	ssh $(REMOTEHOST) mkdir -p $(REMOTEPATH)
	scp $(NAME) $(REMOTEHOST):$(REMOTEPATH)/$(NAME)
	ssh $(REMOTEHOST) srun -p $(REMOTENODE) $(REMOTEPATH)/$(NAME)

dump: $(NAME)
	objdump -dC $(NAME) > $(NAME).asm

.PHONY: all clean remote run dump
