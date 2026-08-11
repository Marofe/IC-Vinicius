/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * diag.c
 *
 * Code generation for function 'diag'
 *
 */

/* Include files */
#include "diag.h"
#include "eml_int_forloop_overflow_error.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"

/* Variable Definitions */
static emlrtRTEInfo ad_emlrtRTEI = {
    83,     /* lineNo */
    5,      /* colNo */
    "diag", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\diag.m" /* pName
                                                                       */
};

/* Function Definitions */
void diag(const emlrtStack *sp, const emxArray_real_T *v, emxArray_real_T *d)
{
  emlrtStack b_st;
  emlrtStack st;
  const real_T *v_data;
  real_T *d_data;
  int32_T j;
  int32_T loop_ub;
  int32_T nv;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  v_data = v->data;
  nv = v->size[0];
  loop_ub = d->size[0] * d->size[1];
  d->size[0] = v->size[0];
  d->size[1] = v->size[0];
  emxEnsureCapacity_real_T(sp, d, loop_ub, &ad_emlrtRTEI);
  d_data = d->data;
  loop_ub = v->size[0] * v->size[0];
  for (j = 0; j < loop_ub; j++) {
    d_data[j] = 0.0;
  }
  st.site = &ve_emlrtRSI;
  if (v->size[0] > 2147483646) {
    b_st.site = &hb_emlrtRSI;
    eml_int_forloop_overflow_error(&b_st);
  }
  st.site = &ve_emlrtRSI;
  for (j = 0; j < nv; j++) {
    d_data[j + d->size[0] * j] = v_data[j];
  }
}

/* End of code generation (diag.c) */
