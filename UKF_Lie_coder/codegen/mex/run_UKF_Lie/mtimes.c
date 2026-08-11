/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mtimes.c
 *
 * Code generation for function 'mtimes'
 *
 */

/* Include files */
#include "mtimes.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo yd_emlrtRSI = {
    142,      /* lineNo */
    "mtimes", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "blas\\mtimes.m" /* pathName */
};

static emlrtRSInfo ae_emlrtRSI = {
    177,           /* lineNo */
    "mtimes_blas", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "blas\\mtimes.m" /* pathName */
};

static emlrtRTEInfo bd_emlrtRTEI = {
    140,      /* lineNo */
    5,        /* colNo */
    "mtimes", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "blas\\mtimes.m" /* pName */
};

static emlrtRTEInfo cd_emlrtRTEI = {
    218,      /* lineNo */
    20,       /* colNo */
    "mtimes", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\+"
    "blas\\mtimes.m" /* pName */
};

/* Function Definitions */
void b_mtimes(const emlrtStack *sp, const emxArray_real_T *A,
              const emxArray_real_T *B, emxArray_real_T *C)
{
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack st;
  const real_T *A_data;
  const real_T *B_data;
  real_T alpha1;
  real_T beta1;
  real_T *C_data;
  int32_T i;
  char_T TRANSA1;
  char_T TRANSB1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  B_data = B->data;
  A_data = A->data;
  if (A->size[1] == 0) {
    int32_T loop_ub;
    loop_ub = C->size[0] * C->size[1];
    C->size[0] = 15;
    C->size[1] = B->size[1];
    emxEnsureCapacity_real_T(sp, C, loop_ub, &bd_emlrtRTEI);
    C_data = C->data;
    loop_ub = 15 * B->size[1];
    for (i = 0; i < loop_ub; i++) {
      C_data[i] = 0.0;
    }
  } else {
    int32_T loop_ub;
    st.site = &yd_emlrtRSI;
    b_st.site = &ae_emlrtRSI;
    TRANSB1 = 'N';
    TRANSA1 = 'N';
    alpha1 = 1.0;
    beta1 = 0.0;
    m_t = (ptrdiff_t)15;
    n_t = (ptrdiff_t)B->size[1];
    k_t = (ptrdiff_t)A->size[1];
    lda_t = (ptrdiff_t)15;
    ldb_t = (ptrdiff_t)B->size[0];
    ldc_t = (ptrdiff_t)15;
    loop_ub = C->size[0] * C->size[1];
    C->size[0] = 15;
    C->size[1] = B->size[1];
    emxEnsureCapacity_real_T(&b_st, C, loop_ub, &cd_emlrtRTEI);
    C_data = C->data;
    dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, (real_T *)&A_data[0],
          &lda_t, (real_T *)&B_data[0], &ldb_t, &beta1, &C_data[0], &ldc_t);
  }
}

void c_mtimes(const emxArray_real_T *A, const emxArray_real_T *B, real_T C[225])
{
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  const real_T *A_data;
  const real_T *B_data;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA1;
  char_T TRANSB1;
  B_data = B->data;
  A_data = A->data;
  TRANSB1 = 'T';
  TRANSA1 = 'N';
  alpha1 = 1.0;
  beta1 = 0.0;
  m_t = (ptrdiff_t)15;
  n_t = (ptrdiff_t)15;
  k_t = (ptrdiff_t)A->size[1];
  lda_t = (ptrdiff_t)15;
  ldb_t = (ptrdiff_t)15;
  ldc_t = (ptrdiff_t)15;
  dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, (real_T *)&A_data[0],
        &lda_t, (real_T *)&B_data[0], &ldb_t, &beta1, &C[0], &ldc_t);
}

void d_mtimes(const emlrtStack *sp, const emxArray_real_T *A,
              const emxArray_real_T *B, emxArray_real_T *C)
{
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack st;
  const real_T *A_data;
  const real_T *B_data;
  real_T alpha1;
  real_T beta1;
  real_T *C_data;
  int32_T i;
  char_T TRANSA1;
  char_T TRANSB1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  B_data = B->data;
  A_data = A->data;
  if (A->size[1] == 0) {
    int32_T loop_ub;
    loop_ub = C->size[0] * C->size[1];
    C->size[0] = 3;
    C->size[1] = B->size[1];
    emxEnsureCapacity_real_T(sp, C, loop_ub, &bd_emlrtRTEI);
    C_data = C->data;
    loop_ub = 3 * B->size[1];
    for (i = 0; i < loop_ub; i++) {
      C_data[i] = 0.0;
    }
  } else {
    int32_T loop_ub;
    st.site = &yd_emlrtRSI;
    b_st.site = &ae_emlrtRSI;
    TRANSB1 = 'N';
    TRANSA1 = 'N';
    alpha1 = 1.0;
    beta1 = 0.0;
    m_t = (ptrdiff_t)3;
    n_t = (ptrdiff_t)B->size[1];
    k_t = (ptrdiff_t)A->size[1];
    lda_t = (ptrdiff_t)3;
    ldb_t = (ptrdiff_t)B->size[0];
    ldc_t = (ptrdiff_t)3;
    loop_ub = C->size[0] * C->size[1];
    C->size[0] = 3;
    C->size[1] = B->size[1];
    emxEnsureCapacity_real_T(&b_st, C, loop_ub, &cd_emlrtRTEI);
    C_data = C->data;
    dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, (real_T *)&A_data[0],
          &lda_t, (real_T *)&B_data[0], &ldb_t, &beta1, &C_data[0], &ldc_t);
  }
}

void mtimes(const real_T A[169], const real_T B[169], real_T C[169])
{
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA1;
  char_T TRANSB1;
  TRANSB1 = 'N';
  TRANSA1 = 'N';
  alpha1 = 1.0;
  beta1 = 0.0;
  m_t = (ptrdiff_t)13;
  n_t = (ptrdiff_t)13;
  k_t = (ptrdiff_t)13;
  lda_t = (ptrdiff_t)13;
  ldb_t = (ptrdiff_t)13;
  ldc_t = (ptrdiff_t)13;
  dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, (real_T *)&A[0], &lda_t,
        (real_T *)&B[0], &ldb_t, &beta1, &C[0], &ldc_t);
}

/* End of code generation (mtimes.c) */
