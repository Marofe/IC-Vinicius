/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * evaluateStateRMSE.h
 *
 * Code generation for function 'evaluateStateRMSE'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "run_UKF_Lie_types.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
real_T evaluateStateRMSE(run_UKF_LieStackData *SD, const emlrtStack *sp,
                         const real_T euler[687816], const real_T pe[687816],
                         const real_T ve[687816], const real_T ref_pe[687816],
                         const real_T ref_euler[687816],
                         const real_T ref_ve[687816]);

/* End of code generation (evaluateStateRMSE.h) */
