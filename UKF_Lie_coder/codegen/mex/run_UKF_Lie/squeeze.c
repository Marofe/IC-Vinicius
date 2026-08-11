/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * squeeze.c
 *
 * Code generation for function 'squeeze'
 *
 */

/* Include files */
#include "squeeze.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRTEInfo h_emlrtRTEI = {
    88,                  /* lineNo */
    23,                  /* colNo */
    "reshapeSizeChecks", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\reshapeSizeChecks.m" /* pName */
};

static emlrtRTEInfo dd_emlrtRTEI = {
    38,        /* lineNo */
    1,         /* colNo */
    "squeeze", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\elmat\\squeeze.m" /* pName
                                                                          */
};

/* Function Definitions */
void b_squeeze(const emlrtStack *sp, const emxArray_real_T *a)
{
  emlrtStack st;
  int32_T n;
  int32_T nx;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &bd_emlrtRSI;
  nx = 15 * a->size[1];
  n = 15;
  if (a->size[1] > 15) {
    n = a->size[1];
  }
  if (a->size[1] > muIntScalarMax_sint32(nx, n)) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
}

void squeeze(const emlrtStack *sp, const emxArray_real_T *a, emxArray_real_T *b)
{
  emlrtStack st;
  const real_T *a_data;
  real_T *b_data;
  int32_T i;
  int32_T n;
  int32_T nx;
  int32_T szb_idx_1;
  st.prev = sp;
  st.tls = sp->tls;
  a_data = a->data;
  szb_idx_1 = 1;
  if (a->size[2] != 1) {
    szb_idx_1 = a->size[2];
  }
  st.site = &bd_emlrtRSI;
  nx = 3 * a->size[2];
  n = 3;
  if (a->size[2] > 3) {
    n = a->size[2];
  }
  if (szb_idx_1 > muIntScalarMax_sint32(nx, n)) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  if (3 * szb_idx_1 != nx) {
    emlrtErrorWithMessageIdR2018a(
        &st, &h_emlrtRTEI, "Coder:MATLAB:getReshapeDims_notSameNumel",
        "Coder:MATLAB:getReshapeDims_notSameNumel", 0);
  }
  nx = b->size[0] * b->size[1];
  b->size[0] = 3;
  b->size[1] = szb_idx_1;
  emxEnsureCapacity_real_T(sp, b, nx, &dd_emlrtRTEI);
  b_data = b->data;
  nx = 3 * szb_idx_1;
  for (i = 0; i < nx; i++) {
    b_data[i] = a_data[i];
  }
}

/* End of code generation (squeeze.c) */
