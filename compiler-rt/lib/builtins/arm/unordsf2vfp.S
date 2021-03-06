//===-- unordsf2vfp.S - Implement unordsf2vfp -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "../assembly.h"

//
// extern int __unordsf2vfp(float a, float b);
//
// Returns one iff a or b is NaN
// Uses Darwin calling convention where single precision arguments are passsed 
// like 32-bit ints
//
	.syntax unified
	.p2align 2
DEFINE_COMPILERRT_FUNCTION(__unordsf2vfp)
#if defined(COMPILER_RT_ARMHF_TARGET)
	vcmp.f32 s0, s1
#else
	vmov	s14, r0     // move from GPR 0 to float register
	vmov	s15, r1	    // move from GPR 1 to float register
	vcmp.f32 s14, s15
#endif
	vmrs	apsr_nzcv, fpscr
	ITE(vs)
	movvs	r0, #1      // set result register to 1 if "overflow" (any NaNs)
	movvc	r0, #0
	bx	lr
END_COMPILERRT_FUNCTION(__unordsf2vfp)

NO_EXEC_STACK_DIRECTIVE

