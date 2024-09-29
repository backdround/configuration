.section .text
.global main

main:
  push %rbp
  mov %rsp, %rbp

  mov $1, %rax
  mov $1, %rdi
  lea message(%rip), %rsi
  mov message_length(%rip), %edx
  syscall

  xor %rax, %rax

  mov %rbp, %rsp
  pop %rbp
  ret

.section .rodata
message:
  .ascii "Hello world!\n\0"
message_length:
  .int . - message
