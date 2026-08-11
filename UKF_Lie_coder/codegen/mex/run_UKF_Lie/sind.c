/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sind.c
 *
 * Code generation for function 'sind'
 *
 */

/* Include files */
#include "sind.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void b_sind(real_T *x)
{
  if (muDoubleScalarIsInf(*x) || muDoubleScalarIsNaN(*x)) {
    *x = rtNaN;
  } else {
    real_T absx;
    real_T b_x;
    int8_T n;
    b_x = muDoubleScalarRem(*x, 360.0);
    absx = muDoubleScalarAbs(b_x);
    if (absx > 180.0) {
      if (b_x > 0.0) {
        b_x -= 360.0;
      } else {
        b_x += 360.0;
      }
      absx = muDoubleScalarAbs(b_x);
    }
    if (absx <= 45.0) {
      b_x *= 0.017453292519943295;
      n = 0;
    } else if (absx <= 135.0) {
      if (b_x > 0.0) {
        b_x = 0.017453292519943295 * (b_x - 90.0);
        n = 1;
      } else {
        b_x = 0.017453292519943295 * (b_x + 90.0);
        n = -1;
      }
    } else if (b_x > 0.0) {
      b_x = 0.017453292519943295 * (b_x - 180.0);
      n = 2;
    } else {
      b_x = 0.017453292519943295 * (b_x + 180.0);
      n = -2;
    }
    if (n == 0) {
      *x = muDoubleScalarSin(b_x);
    } else if (n == 1) {
      *x = muDoubleScalarCos(b_x);
    } else if (n == -1) {
      *x = -muDoubleScalarCos(b_x);
    } else {
      *x = -muDoubleScalarSin(b_x);
    }
  }
}

/* End of code generation (sind.c) */
