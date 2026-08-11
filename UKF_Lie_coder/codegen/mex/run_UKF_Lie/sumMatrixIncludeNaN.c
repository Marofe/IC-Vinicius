/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sumMatrixIncludeNaN.c
 *
 * Code generation for function 'sumMatrixIncludeNaN'
 *
 */

/* Include files */
#include "sumMatrixIncludeNaN.h"
#include "rt_nonfinite.h"

/* Function Definitions */
real_T b_sumColumnB(const real_T x[2063448], int32_T col)
{
  real_T b_y;
  real_T y;
  int32_T b_k;
  int32_T i0_tmp;
  int32_T k;
  i0_tmp = (col - 1) * 229272;
  y = x[i0_tmp + 225280];
  for (k = 0; k < 1023; k++) {
    y += x[(i0_tmp + k) + 225281];
  }
  for (k = 0; k < 2; k++) {
    int32_T i0;
    i0 = (((k + 1) << 10) + i0_tmp) + 225280;
    b_y = x[i0];
    for (b_k = 0; b_k < 1023; b_k++) {
      b_y += x[(i0 + b_k) + 1];
    }
    y += b_y;
  }
  b_y = x[i0_tmp + 228352];
  for (k = 0; k < 919; k++) {
    b_y += x[(i0_tmp + k) + 228353];
  }
  y += b_y;
  return y;
}

real_T c_sumColumnB(const real_T x[9])
{
  real_T y;
  int32_T k;
  y = x[0];
  for (k = 0; k < 8; k++) {
    y += x[k + 1];
  }
  return y;
}

real_T sumColumnB(const real_T x[15])
{
  real_T y;
  int32_T k;
  y = x[0];
  for (k = 0; k < 14; k++) {
    y += x[k + 1];
  }
  return y;
}

real_T sumColumnB4(const real_T x[2063448], int32_T col, int32_T vstart)
{
  real_T psum2;
  real_T psum3;
  real_T psum4;
  real_T y;
  int32_T i1;
  int32_T k;
  i1 = vstart + (col - 1) * 229272;
  y = x[i1 - 1];
  psum2 = x[i1 + 1023];
  psum3 = x[i1 + 2047];
  psum4 = x[i1 + 3071];
  for (k = 0; k < 1023; k++) {
    int32_T psum1_tmp;
    psum1_tmp = i1 + k;
    y += x[psum1_tmp];
    psum2 += x[psum1_tmp + 1024];
    psum3 += x[psum1_tmp + 2048];
    psum4 += x[psum1_tmp + 3072];
  }
  return (y + psum2) + (psum3 + psum4);
}

/* End of code generation (sumMatrixIncludeNaN.c) */
