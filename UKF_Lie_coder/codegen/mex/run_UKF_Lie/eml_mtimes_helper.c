/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eml_mtimes_helper.c
 *
 * Code generation for function 'eml_mtimes_helper'
 *
 */

/* Include files */
#include "eml_mtimes_helper.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"

/* Function Definitions */
void binary_expand_op_2(const emlrtStack *sp, emxArray_real_T *in1)
{
  emxArray_real_T *r;
  real_T *in1_data;
  real_T *r1;
  int32_T b_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T loop_ub;
  int32_T stride_0_0;
  int32_T stride_0_1;
  in1_data = in1->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  emxInit_real_T(sp, &r, 2, &ob_emlrtRTEI);
  if (in1->size[1] == 1) {
    loop_ub = in1->size[0];
  } else {
    loop_ub = in1->size[1];
  }
  stride_0_0 = r->size[0] * r->size[1];
  r->size[0] = loop_ub;
  if (in1->size[0] == 1) {
    b_loop_ub = in1->size[1];
  } else {
    b_loop_ub = in1->size[0];
  }
  r->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, r, stride_0_0, &ob_emlrtRTEI);
  r1 = r->data;
  stride_0_0 = (in1->size[0] != 1);
  stride_0_1 = (in1->size[1] != 1);
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      r1[i1 + r->size[0] * i] =
          0.5 * (in1_data[i1 * stride_0_0 + in1->size[0] * (i * stride_0_1)] +
                 in1_data[i * stride_0_0 + in1->size[0] * (i1 * stride_0_1)]);
    }
  }
  stride_0_0 = in1->size[0] * in1->size[1];
  in1->size[0] = loop_ub;
  in1->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, in1, stride_0_0, &pb_emlrtRTEI);
  in1_data = in1->data;
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      in1_data[i1 + in1->size[0] * i] = r1[i1 + r->size[0] * i];
    }
  }
  emxFree_real_T(sp, &r);
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

/* End of code generation (eml_mtimes_helper.c) */
