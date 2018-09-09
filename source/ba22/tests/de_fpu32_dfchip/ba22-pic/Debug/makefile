################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(SX_DEPS)),)
-include $(SX_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
BA_SIZE_DISPLAY += \
ba-size-display \

BA_OBJCOPY_OUTPUT += \
ba22-pic.bin \


# All Target
all: ba22-pic.elf secondary-outputs

# Tool invocations
ba22-pic.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: BA ELF GNU C linker'
	ba-elf-gcc -nostartfiles -T ../ram.ld -march=ba2 -mbe -o "ba22-pic.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

ba-size-display: ba22-pic.elf
	@echo 'Showing the size of executable'
	ba-elf-size -B ba22-pic.elf
	@echo 'Finished building: $@'
	@echo ' '

ba22-pic.bin: ba22-pic.elf
	@echo 'Invoking: BA ELF GNU objcopy'
	ba-elf-objcopy -O binary ba22-pic.elf  "ba22-pic.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BA_SIZE_DISPLAY)$(OBJS)$(C_DEPS)$(SX_DEPS)$(S_DEPS)$(EXECUTABLES)$(BA_OBJCOPY_OUTPUT)$(S_UPPER_DEPS) ba22-pic.elf
	-@echo ' '

post-build:
	-ba-elf-objcopy -O verilog ba22-pic.elf ba22-pic.verilog
	-@echo ' '

secondary-outputs: $(BA_SIZE_DISPLAY) $(BA_OBJCOPY_OUTPUT)

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets
