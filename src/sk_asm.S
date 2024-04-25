  #Author: Subrata M. Brhaspatih
  .cfi_startproc
  .cfi_undefined ra
  .option push
  .option norelax
  la gp, __global_pointer$
  .option pop
   la sp, _stack_start
  add s0, sp, zero
  jal zero, _main
  .cfi_endproc
  .end

