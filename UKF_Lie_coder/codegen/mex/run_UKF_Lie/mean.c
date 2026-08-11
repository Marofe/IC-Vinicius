/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mean.c
 *
 * Code generation for function 'mean'
 *
 */

/* Include files */
#include "mean.h"
#include "rt_nonfinite.h"
#include "sumMatrixIncludeNaN.h"

/* Function Definitions */
void mean(const real_T x[2063448], real_T y[9])
{
  int32_T col;
  int32_T ib;
  for (col = 0; col < 9; col++) {
    real_T s;
    s = sumColumnB4(x, col + 1, 1);
    for (ib = 0; ib < 54; ib++) {
      s += sumColumnB4(x, col + 1, ((ib + 1) << 12) + 1);
    }
    y[col] = (s + b_sumColumnB(x, col + 1)) / 229272.0;
  }
}

/* End of code generation (mean.c) */
