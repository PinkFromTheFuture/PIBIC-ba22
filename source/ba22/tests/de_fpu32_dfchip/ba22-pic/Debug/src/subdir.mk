################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/ba22-pic.c 

S_UPPER_SRCS += \
../src/vectors.S 

OBJS += \
./src/ba22-pic.o \
./src/vectors.o 

C_DEPS += \
./src/ba22-pic.d 

S_UPPER_DEPS += \
./src/vectors.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: BA ELF GNU C compiler'
	ba-elf-gcc -I"C:\workspace_be\ba22-pic\src" -Os -g -Wall -c -fmessage-length=0 -march=ba2 -mbe -mabi=3 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: BA ELF GNU C compiler'
	ba-elf-gcc -I"C:\workspace_be\ba22-pic\src" -Os -g -Wall -c -fmessage-length=0 -march=ba2 -mbe -mabi=3 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


