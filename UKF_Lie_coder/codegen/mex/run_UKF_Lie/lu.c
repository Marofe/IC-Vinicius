/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lu.c
 *
 * Code generation for function 'lu'
 *
 */

/* Include files */
#include "lu.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "lapacke.h"
#include <stddef.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo he_emlrtRSI =
    {
        69,    /* lineNo */
        "LUP", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\lu.m" /* pathName
                                                                          */
};

static emlrtRSInfo ie_emlrtRSI = {
    33,       /* lineNo */
    "xgetrf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgetrf.m" /* pathName */
};

static emlrtRSInfo je_emlrtRSI = {
    97,             /* lineNo */
    "ceval_xgetrf", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "lapack\\xgetrf.m" /* pathName */
};

/* Function Definitions */
void LUP(const emlrtStack *sp, const real_T A[169], real_T L[169],
         real_T U[169], real_T P[169])
{
  ptrdiff_t ipiv_t[13];
  ptrdiff_t info_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T b_A[169];
  int32_T ipiv[13];
  int32_T U_tmp;
  int32_T j;
  int32_T k;
  int8_T perm[13];
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  st.site = &he_emlrtRSI;
  memcpy(&b_A[0], &A[0], 169U * sizeof(real_T));
  b_st.site = &ie_emlrtRSI;
  info_t = LAPACKE_dgetrf_work(102, (ptrdiff_t)13, (ptrdiff_t)13, &b_A[0],
                               (ptrdiff_t)13, &ipiv_t[0]);
  c_st.site = &je_emlrtRSI;
  if ((int32_T)info_t < 0) {
    if ((int32_T)info_t == -1010) {
      emlrtErrorWithMessageIdR2018a(&c_st, &o_emlrtRTEI, "MATLAB:nomem",
                                    "MATLAB:nomem", 0);
    } else {
      emlrtErrorWithMessageIdR2018a(&c_st, &p_emlrtRTEI,
                                    "Coder:toolbox:LAPACKCallErrorInfo",
                                    "Coder:toolbox:LAPACKCallErrorInfo", 5, 4,
                                    19, &cv[0], 12, (int32_T)info_t);
    }
  }
  for (k = 0; k < 13; k++) {
    ipiv[k] = (int32_T)ipiv_t[k];
  }
  for (k = 0; k < 13; k++) {
    perm[k] = (int8_T)(k + 1);
  }
  for (k = 0; k < 12; k++) {
    U_tmp = ipiv[k];
    if (U_tmp > k + 1) {
      int32_T pipk;
      pipk = perm[U_tmp - 1];
      perm[U_tmp - 1] = perm[k];
      perm[k] = (int8_T)pipk;
    }
  }
  memset(&P[0], 0, 169U * sizeof(real_T));
  memset(&L[0], 0, 169U * sizeof(real_T));
  memset(&U[0], 0, 169U * sizeof(real_T));
  for (j = 0; j < 13; j++) {
    for (k = 0; k <= j; k++) {
      U_tmp = k + 13 * j;
      U[U_tmp] = b_A[U_tmp];
    }
    L[j + 13 * j] = 1.0;
    U_tmp = 12 - j;
    if (U_tmp - 1 >= 0) {
      memcpy(&L[j * 14 + 1], &b_A[j * 14 + 1],
             (uint32_T)U_tmp * sizeof(real_T));
    }
    P[j + 13 * (perm[j] - 1)] = 1.0;
  }
}

/* End of code generation (lu.c) */
