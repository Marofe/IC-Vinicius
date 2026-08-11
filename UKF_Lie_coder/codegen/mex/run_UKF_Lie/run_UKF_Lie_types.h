/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * run_UKF_Lie_types.h
 *
 * Code generation for function 'run_UKF_Lie'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"

/* Type Definitions */
#ifndef typedef_struct0_T
#define typedef_struct0_T
typedef struct {
  real_T time[229272];
  real_T pe[687816];
  real_T fib[687816];
  real_T wib[687816];
  real_T euler[687816];
  real_T g0;
  real_T dt;
  real_T ve[687816];
  real_T ba[3];
  real_T bg[3];
  real_T leverarm[3];
} struct0_T;
#endif /* typedef_struct0_T */

#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T {
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_real_T */
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /* typedef_emxArray_real_T */

#ifndef typedef_emxArray_creal_T
#define typedef_emxArray_creal_T
typedef struct {
  creal_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
} emxArray_creal_T;
#endif /* typedef_emxArray_creal_T */

#ifndef typedef_b_evaluateStateRMSE
#define typedef_b_evaluateStateRMSE
typedef struct {
  real_T a[2063448];
  real_T y[2063448];
  real_T eulerRef[687816];
  real_T x[687816];
} b_evaluateStateRMSE;
#endif /* typedef_b_evaluateStateRMSE */

#ifndef typedef_b_run_UKF_Lie
#define typedef_b_run_UKF_Lie
typedef struct {
  real_T hx[687816];
  real_T b_hx[687816];
} b_run_UKF_Lie;
#endif /* typedef_b_run_UKF_Lie */

#ifndef typedef_b_run_UKF_Lie_api
#define typedef_b_run_UKF_Lie_api
typedef struct {
  struct0_T ref;
} b_run_UKF_Lie_api;
#endif /* typedef_b_run_UKF_Lie_api */

#ifndef typedef_run_UKF_LieStackData
#define typedef_run_UKF_LieStackData
typedef struct {
  b_evaluateStateRMSE f0;
  b_run_UKF_Lie f1;
  b_run_UKF_Lie_api f2;
} run_UKF_LieStackData;
#endif /* typedef_run_UKF_LieStackData */

/* End of code generation (run_UKF_Lie_types.h) */
