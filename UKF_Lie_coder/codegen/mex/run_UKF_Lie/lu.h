/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lu.h
 *
 * Code generation for function 'lu'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void LUP(const emlrtStack *sp, const real_T A[169], real_T L[169],
         real_T U[169], real_T P[169]);

/* End of code generation (lu.h) */
