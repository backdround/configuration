.section .text
.global main

print_number:
  push %rbp
  mov %rsp, %rbp

  mov %rdi, %rsi
  lea number_fmt(%rip), %rdi
  xor %rax, %rax
  call printf@plt

  mov %rbp, %rsp
  pop %rbp
  ret

main:
  push %rbp
  mov %rsp, %rbp

  mov $0xff, %rdi
  call print_number

  xor %rax, %rax

  mov %rbp, %rsp
  pop %rbp
  ret

.section .rodata
number_fmt:
  .string "%lu\n"
