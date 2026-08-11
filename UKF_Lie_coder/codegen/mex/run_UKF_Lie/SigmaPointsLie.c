/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SigmaPointsLie.c
 *
 * Code generation for function 'SigmaPointsLie'
 *
 */

/* Include files */
#include "SigmaPointsLie.h"
#include "chol.h"
#include "eig.h"
#include "eml_int_forloop_overflow_error.h"
#include "eml_mtimes_helper.h"
#include "eye.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_emxutil.h"
#include "run_UKF_Lie_types.h"
#include "mwmathutil.h"
#include <emmintrin.h>

/* Variable Definitions */
static emlrtRSInfo r_emlrtRSI = {
    21,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo s_emlrtRSI = {
    24,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo t_emlrtRSI = {
    25,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo u_emlrtRSI = {
    26,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo v_emlrtRSI = {
    32,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo w_emlrtRSI = {
    35,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo x_emlrtRSI = {
    37,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo y_emlrtRSI = {
    38,                                                     /* lineNo */
    "SigmaPointsLie",                                       /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pathName */
};

static emlrtRSInfo ab_emlrtRSI = {
    15,     /* lineNo */
    "chol", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\chol.m" /* pathName
                                                                        */
};

static emlrtRSInfo oc_emlrtRSI = {
    15,    /* lineNo */
    "min", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\datafun\\min.m" /* pathName
                                                                        */
};

static emlrtRSInfo pc_emlrtRSI =
    {
        75,         /* lineNo */
        "minOrMax", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax."
        "m" /* pathName */
};

static emlrtRSInfo qc_emlrtRSI =
    {
        143,       /* lineNo */
        "minimum", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax."
        "m" /* pathName */
};

static emlrtRSInfo rc_emlrtRSI = {
    289,             /* lineNo */
    "unaryMinOrMax", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\unaryMinOrMax.m" /* pathName */
};

static emlrtRSInfo sc_emlrtRSI = {
    376,                     /* lineNo */
    "unaryMinOrMaxDispatch", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\unaryMinOrMax.m" /* pathName */
};

static emlrtRSInfo tc_emlrtRSI = {
    417,          /* lineNo */
    "minOrMax1D", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\unaryMinOrMax.m" /* pathName */
};

static emlrtRSInfo xc_emlrtRSI = {
    12,     /* lineNo */
    "chol", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\chol.m" /* pathName
                                                                        */
};

static emlrtRSInfo yc_emlrtRSI = {
    41,    /* lineNo */
    "cat", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m" /* pathName
                                                                          */
};

static emlrtRSInfo ad_emlrtRSI = {
    65,         /* lineNo */
    "cat_impl", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m" /* pathName
                                                                          */
};

static emlrtDCInfo e_emlrtDCI = {
    14,                                                      /* lineNo */
    13,                                                      /* colNo */
    "SigmaPointsLie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m", /* pName */
    1                                                        /* checkKind */
};

static emlrtECInfo emlrtECI = {
    -1,                                                     /* nDims */
    17,                                                     /* lineNo */
    1,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtECInfo b_emlrtECI = {
    1,                                                      /* nDims */
    18,                                                     /* lineNo */
    12,                                                     /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtECInfo c_emlrtECI = {
    2,                                                      /* nDims */
    18,                                                     /* lineNo */
    12,                                                     /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtECInfo d_emlrtECI = {
    1,                                                      /* nDims */
    25,                                                     /* lineNo */
    9,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtECInfo e_emlrtECI = {
    2,                                                      /* nDims */
    25,                                                     /* lineNo */
    9,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtDCInfo f_emlrtDCI = {
    34,                                                      /* lineNo */
    30,                                                      /* colNo */
    "SigmaPointsLie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m", /* pName */
    1                                                        /* checkKind */
};

static emlrtECInfo f_emlrtECI = {
    1,                                                      /* nDims */
    38,                                                     /* lineNo */
    9,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo j_emlrtRTEI = {
    16,     /* lineNo */
    5,      /* colNo */
    "chol", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\chol.m" /* pName
                                                                        */
};

static emlrtRTEInfo k_emlrtRTEI = {
    225,                   /* lineNo */
    27,                    /* colNo */
    "check_non_axis_size", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m" /* pName
                                                                          */
};

static emlrtRTEInfo m_emlrtRTEI = {
    197,             /* lineNo */
    27,              /* colNo */
    "unaryMinOrMax", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\unaryMinOrMax.m" /* pName */
};

static emlrtBCInfo k_emlrtBCI = {
    -1,                                                      /* iFirst */
    -1,                                                      /* iLast */
    15,                                                      /* lineNo */
    1,                                                       /* colNo */
    "P",                                                     /* aName */
    "SigmaPointsLie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m", /* pName */
    0                                                        /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = {
    -1,                                                      /* iFirst */
    -1,                                                      /* iLast */
    16,                                                      /* lineNo */
    1,                                                       /* colNo */
    "P",                                                     /* aName */
    "SigmaPointsLie",                                        /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m", /* pName */
    0                                                        /* checkKind */
};

static emlrtRTEInfo nb_emlrtRTEI = {
    14,                                                     /* lineNo */
    1,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo qb_emlrtRTEI = {
    15,     /* lineNo */
    6,      /* colNo */
    "chol", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\matfun\\chol.m" /* pName
                                                                        */
};

static emlrtRTEInfo rb_emlrtRTEI = {
    28,                                                     /* lineNo */
    5,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo sb_emlrtRTEI = {
    34,                                                     /* lineNo */
    1,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo tb_emlrtRTEI = {
    35,                                                     /* lineNo */
    1,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo ub_emlrtRTEI = {
    26,                                                     /* lineNo */
    5,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo vb_emlrtRTEI = {
    38,                                                     /* lineNo */
    20,                                                     /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo wb_emlrtRTEI = {
    38,                                                     /* lineNo */
    9,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo xb_emlrtRTEI = {
    38,                                                     /* lineNo */
    1,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo yb_emlrtRTEI = {
    21,                                                     /* lineNo */
    2,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo ac_emlrtRTEI = {
    24,                                                     /* lineNo */
    18,                                                     /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRTEInfo od_emlrtRTEI = {
    25,                                                     /* lineNo */
    9,                                                      /* colNo */
    "SigmaPointsLie",                                       /* fName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\SigmaPointsLie.m" /* pName */
};

static emlrtRSInfo yf_emlrtRSI =
    {
        76,                  /* lineNo */
        "eml_mtimes_helper", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2026a\\toolbox\\eml\\lib\\matlab\\ops\\eml_mtimes_"
        "helper.m" /* pathName */
};

/* Function Declarations */
static void binary_expand_op(const emlrtStack *sp, emxArray_real_T *in1,
                             const emxArray_real_T *in2);

static void binary_expand_op_1(const emlrtStack *sp, emxArray_real_T *in1,
                               const emxArray_real_T *in2,
                               const emxArray_real_T *in3);

static void plus(const emlrtStack *sp, emxArray_real_T *in1,
                 const emxArray_real_T *in2);

/* Function Definitions */
static void binary_expand_op(const emlrtStack *sp, emxArray_real_T *in1,
                             const emxArray_real_T *in2)
{
  emxArray_real_T *b_in2;
  const real_T *in2_data;
  real_T *b_in2_data;
  real_T *in1_data;
  int32_T b_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T in2_idx_0;
  int32_T loop_ub;
  int32_T stride_1_0;
  in2_data = in2->data;
  in1_data = in1->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  in2_idx_0 = in2->size[0];
  emxInit_real_T(sp, &b_in2, 2, &vb_emlrtRTEI);
  if (in1->size[0] == 1) {
    loop_ub = in2_idx_0;
  } else {
    loop_ub = in1->size[0];
  }
  stride_1_0 = b_in2->size[0] * b_in2->size[1];
  b_in2->size[0] = loop_ub;
  b_loop_ub = in1->size[1];
  b_in2->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, b_in2, stride_1_0, &vb_emlrtRTEI);
  b_in2_data = b_in2->data;
  in2_idx_0 = (in2_idx_0 != 1);
  stride_1_0 = (in1->size[0] != 1);
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_in2_data[i1 + b_in2->size[0] * i] =
          in2_data[i1 * in2_idx_0] -
          in1_data[i1 * stride_1_0 + in1->size[0] * i];
    }
  }
  in2_idx_0 = in1->size[0] * in1->size[1];
  in1->size[0] = loop_ub;
  emxEnsureCapacity_real_T(sp, in1, in2_idx_0, &vb_emlrtRTEI);
  in1_data = in1->data;
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      in1_data[i1 + in1->size[0] * i] = b_in2_data[i1 + b_in2->size[0] * i];
    }
  }
  emxFree_real_T(sp, &b_in2);
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

static void binary_expand_op_1(const emlrtStack *sp, emxArray_real_T *in1,
                               const emxArray_real_T *in2,
                               const emxArray_real_T *in3)
{
  const real_T *in2_data;
  const real_T *in3_data;
  real_T *in1_data;
  int32_T b_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T in2_idx_0;
  int32_T loop_ub;
  int32_T stride_0_0;
  in3_data = in3->data;
  in2_data = in2->data;
  in2_idx_0 = in2->size[0];
  if (in3->size[0] == 1) {
    loop_ub = in2_idx_0;
  } else {
    loop_ub = in3->size[0];
  }
  stride_0_0 = in1->size[0] * in1->size[1];
  in1->size[0] = loop_ub;
  emxEnsureCapacity_real_T(sp, in1, stride_0_0, &wb_emlrtRTEI);
  b_loop_ub = in3->size[1];
  stride_0_0 = in1->size[0] * in1->size[1];
  in1->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, in1, stride_0_0, &wb_emlrtRTEI);
  in1_data = in1->data;
  stride_0_0 = (in2_idx_0 != 1);
  in2_idx_0 = (in3->size[0] != 1);
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      in1_data[i1 + in1->size[0] * i] =
          in2_data[i1 * stride_0_0] +
          in3_data[i1 * in2_idx_0 + in3->size[0] * i];
    }
  }
}

static void plus(const emlrtStack *sp, emxArray_real_T *in1,
                 const emxArray_real_T *in2)
{
  emxArray_real_T *b_in1;
  const real_T *in2_data;
  real_T *b_in1_data;
  real_T *in1_data;
  int32_T b_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T loop_ub;
  int32_T stride_0_0;
  int32_T stride_0_1;
  int32_T stride_1_0;
  int32_T stride_1_1;
  in2_data = in2->data;
  in1_data = in1->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  emxInit_real_T(sp, &b_in1, 2, &od_emlrtRTEI);
  if (in2->size[0] == 1) {
    loop_ub = in1->size[0];
  } else {
    loop_ub = in2->size[0];
  }
  stride_0_0 = b_in1->size[0] * b_in1->size[1];
  b_in1->size[0] = loop_ub;
  if (in2->size[1] == 1) {
    b_loop_ub = in1->size[1];
  } else {
    b_loop_ub = in2->size[1];
  }
  b_in1->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, b_in1, stride_0_0, &od_emlrtRTEI);
  b_in1_data = b_in1->data;
  stride_0_0 = (in1->size[0] != 1);
  stride_0_1 = (in1->size[1] != 1);
  stride_1_0 = (in2->size[0] != 1);
  stride_1_1 = (in2->size[1] != 1);
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_in1_data[i1 + b_in1->size[0] * i] =
          in1_data[i1 * stride_0_0 + in1->size[0] * (i * stride_0_1)] +
          in2_data[i1 * stride_1_0 + in2->size[0] * (i * stride_1_1)];
    }
  }
  stride_0_0 = in1->size[0] * in1->size[1];
  in1->size[0] = loop_ub;
  in1->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, in1, stride_0_0, &od_emlrtRTEI);
  in1_data = in1->data;
  for (i = 0; i < b_loop_ub; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      in1_data[i1 + in1->size[0] * i] = b_in1_data[i1 + b_in1->size[0] * i];
    }
  }
  emxFree_real_T(sp, &b_in1);
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

void SigmaPointsLie(const emlrtStack *sp, const emxArray_real_T *Eta,
                    real_T alpha, real_T beta, real_T kappa,
                    const real_T P_t[225], const real_T Pqq[225],
                    const real_T Prr[9], real_T L, emxArray_real_T *Xi,
                    emxArray_real_T *Wm, emxArray_real_T *Wc)
{
  __m128d r;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack st;
  emxArray_creal_T *varargin_1;
  emxArray_real_T *A;
  emxArray_real_T *P;
  emxArray_real_T *sqrP;
  creal_T *varargin_1_data;
  const real_T *Eta_data;
  real_T minEig_im;
  real_T minEig_re;
  real_T x;
  real_T y;
  real_T y_tmp;
  real_T *A_data;
  real_T *P_data;
  real_T *sqrP_data;
  int32_T b_Eta[2];
  int32_T sizes[2];
  int32_T b_loop_ub;
  int32_T c_loop_ub;
  int32_T d_loop_ub;
  int32_T i;
  int32_T input_sizes_idx_1;
  int32_T k;
  int32_T loop_ub;
  int8_T b_input_sizes_idx_1;
  boolean_T empty_non_axis_sizes;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  Eta_data = Eta->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  /*   */
  /*  Eta=[eps q r] */
  /*                                [ P_t-1|t-1 */
  /*  Matriz de Covariancia P =                Pqq                   */
  /*                                                Prr ]   dimensão =  2*p+q */
  /*  */
  /*  Sigma Points Xi(i) = [E(i) Q(i) R(i)] dimensão = (2*p+q)x1 = 21x1 */
  /*  matriz de covariancia eta ~N(0 , blkdiag(Pt,Pqq,Prr) ) */
  /*  Build block-diagonal P without calling blkdiag (saves allocation overhead)
   */
  /*  15 */
  /*  3 */
  if (L != (int32_T)muDoubleScalarFloor(L)) {
    emlrtIntegerCheckR2012b(L, &e_emlrtDCI, (emlrtConstCTX)sp);
  }
  emxInit_real_T(sp, &P, 2, &nb_emlrtRTEI);
  loop_ub = P->size[0] * P->size[1];
  b_loop_ub = (int32_T)L;
  P->size[0] = b_loop_ub;
  P->size[1] = b_loop_ub;
  emxEnsureCapacity_real_T(sp, P, loop_ub, &nb_emlrtRTEI);
  P_data = P->data;
  loop_ub = b_loop_ub * b_loop_ub;
  for (k = 0; k < loop_ub; k++) {
    P_data[k] = 0.0;
  }
  for (i = 0; i < 15; i++) {
    for (k = 0; k < 15; k++) {
      if (k + 1 > b_loop_ub) {
        emlrtDynamicBoundsCheckR2012b(k + 1, 1, b_loop_ub, &k_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      if (i + 1 > b_loop_ub) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_loop_ub, &k_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      P_data[k + P->size[0] * i] = P_t[k + 15 * i];
    }
  }
  for (k = 0; k < 15; k++) {
    for (i = 0; i < 15; i++) {
      if (i + 16 > P->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i + 16, 1, P->size[0], &l_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      if (k + 16 > P->size[1]) {
        emlrtDynamicBoundsCheckR2012b(k + 16, 1, P->size[1], &l_emlrtBCI,
                                      (emlrtConstCTX)sp);
      }
      P_data[(i + P->size[0] * (k + 15)) + 15] = Pqq[i + 15 * k];
    }
  }
  if (P->size[0] < 31) {
    c_loop_ub = 0;
    loop_ub = 0;
  } else {
    c_loop_ub = 30;
    loop_ub = P->size[0];
  }
  if (P->size[1] < 31) {
    d_loop_ub = 0;
    b_loop_ub = 0;
  } else {
    d_loop_ub = 30;
    b_loop_ub = P->size[1];
  }
  input_sizes_idx_1 = loop_ub - c_loop_ub;
  b_Eta[0] = input_sizes_idx_1;
  loop_ub = b_loop_ub - d_loop_ub;
  b_Eta[1] = loop_ub;
  sizes[0] = 3;
  sizes[1] = 3;
  emlrtSubAssignSizeCheckR2012b(&b_Eta[0], 2, &sizes[0], 2, &emlrtECI,
                                (emlrtCTX)sp);
  for (i = 0; i < loop_ub; i++) {
    for (k = 0; k < input_sizes_idx_1; k++) {
      P_data[(c_loop_ub + k) + P->size[0] * (d_loop_ub + i)] =
          Prr[k + input_sizes_idx_1 * i];
    }
  }
  b_loop_ub = P->size[0];
  input_sizes_idx_1 = P->size[1];
  if ((P->size[0] != P->size[1]) && ((P->size[0] != 1) && (P->size[1] != 1))) {
    emlrtDimSizeImpxCheckR2021b(P->size[0], P->size[1], &b_emlrtECI,
                                (emlrtConstCTX)sp);
  }
  if ((P->size[0] != P->size[1]) && ((P->size[1] != 1) && (P->size[0] != 1))) {
    emlrtDimSizeImpxCheckR2021b(P->size[1], P->size[0], &c_emlrtECI,
                                (emlrtConstCTX)sp);
  }
  emxInit_real_T(sp, &A, 2, &qb_emlrtRTEI);
  if (P->size[0] == P->size[1]) {
    loop_ub = A->size[0] * A->size[1];
    A->size[0] = P->size[0];
    A->size[1] = P->size[1];
    emxEnsureCapacity_real_T(sp, A, loop_ub, &ob_emlrtRTEI);
    A_data = A->data;
    for (i = 0; i < input_sizes_idx_1; i++) {
      for (k = 0; k < b_loop_ub; k++) {
        A_data[k + A->size[0] * i] =
            0.5 * (P_data[k + P->size[0] * i] + P_data[i + P->size[0] * k]);
      }
    }
    loop_ub = P->size[0] * P->size[1];
    P->size[0] = b_loop_ub;
    P->size[1] = input_sizes_idx_1;
    emxEnsureCapacity_real_T(sp, P, loop_ub, &pb_emlrtRTEI);
    P_data = P->data;
    loop_ub = A->size[0] * A->size[1];
    for (k = 0; k < loop_ub; k++) {
      P_data[k] = A_data[k];
    }
  } else {
    st.site = &yf_emlrtRSI;
    binary_expand_op_2(&st, P);
    P_data = P->data;
  }
  /*  force symmetry */
  /*  Replace eig() check with faster chol() attempt */
  st.site = &r_emlrtRSI;
  loop_ub = A->size[0] * A->size[1];
  A->size[0] = P->size[0];
  A->size[1] = P->size[1];
  emxEnsureCapacity_real_T(&st, A, loop_ub, &qb_emlrtRTEI);
  A_data = A->data;
  d_loop_ub = P->size[0] * P->size[1];
  for (k = 0; k < d_loop_ub; k++) {
    A_data[k] = P_data[k];
  }
  b_st.site = &ab_emlrtRSI;
  loop_ub = chol(&b_st, A, &b_loop_ub);
  A_data = A->data;
  if ((b_loop_ub > A->size[0]) || (b_loop_ub > A->size[1])) {
    emlrtErrorWithMessageIdR2018a(&st, &j_emlrtRTEI,
                                  "Coder:builtins:AssertionFailed",
                                  "Coder:builtins:AssertionFailed", 0);
  }
  if (b_loop_ub < 1) {
    b_loop_ub = 0;
  }
  emxInit_real_T(sp, &sqrP, 2, &yb_emlrtRTEI);
  if (loop_ub != 0) {
    /*  Not PD: regularise with smallest diagonal dominance shift */
    st.site = &s_emlrtRSI;
    emxInit_creal_T(&st, &varargin_1, &ac_emlrtRTEI);
    b_st.site = &s_emlrtRSI;
    eig(&b_st, P, varargin_1);
    varargin_1_data = varargin_1->data;
    b_st.site = &oc_emlrtRSI;
    c_st.site = &pc_emlrtRSI;
    d_st.site = &qc_emlrtRSI;
    if (varargin_1->size[0] < 1) {
      emlrtErrorWithMessageIdR2018a(
          &d_st, &m_emlrtRTEI, "Coder:toolbox:eml_min_or_max_varDimZero",
          "Coder:toolbox:eml_min_or_max_varDimZero", 0);
    }
    e_st.site = &rc_emlrtRSI;
    loop_ub = varargin_1->size[0];
    f_st.site = &sc_emlrtRSI;
    minEig_re = varargin_1_data[0].re;
    minEig_im = varargin_1_data[0].im;
    g_st.site = &tc_emlrtRSI;
    if (varargin_1->size[0] > 2147483646) {
      h_st.site = &hb_emlrtRSI;
      eml_int_forloop_overflow_error(&h_st);
    }
    for (k = 2; k <= loop_ub; k++) {
      if (muDoubleScalarIsNaN(varargin_1_data[k - 1].re) ||
          muDoubleScalarIsNaN(varargin_1_data[k - 1].im)) {
        empty_non_axis_sizes = false;
      } else if (muDoubleScalarIsNaN(minEig_re) ||
                 muDoubleScalarIsNaN(minEig_im)) {
        empty_non_axis_sizes = true;
      } else {
        boolean_T SCALEB;
        if ((muDoubleScalarAbs(minEig_re) > 8.988465674311579E+307) ||
            (muDoubleScalarAbs(minEig_im) > 8.988465674311579E+307)) {
          empty_non_axis_sizes = true;
        } else {
          empty_non_axis_sizes = false;
        }
        if ((muDoubleScalarAbs(varargin_1_data[k - 1].re) >
             8.988465674311579E+307) ||
            (muDoubleScalarAbs(varargin_1_data[k - 1].im) >
             8.988465674311579E+307)) {
          SCALEB = true;
        } else {
          SCALEB = false;
        }
        if (empty_non_axis_sizes || SCALEB) {
          x = muDoubleScalarHypot(minEig_re / 2.0, minEig_im / 2.0);
          y = muDoubleScalarHypot(varargin_1_data[k - 1].re / 2.0,
                                  varargin_1_data[k - 1].im / 2.0);
        } else {
          x = muDoubleScalarHypot(minEig_re, minEig_im);
          y = muDoubleScalarHypot(varargin_1_data[k - 1].re,
                                  varargin_1_data[k - 1].im);
        }
        if (x == y) {
          real_T b_y_tmp;
          x = muDoubleScalarAtan2(minEig_im, minEig_re);
          y_tmp = varargin_1_data[k - 1].re;
          b_y_tmp = varargin_1_data[k - 1].im;
          y = muDoubleScalarAtan2(b_y_tmp, y_tmp);
          if (x == y) {
            if (minEig_re != y_tmp) {
              if (x >= 0.0) {
                x = y_tmp;
                b_y_tmp = minEig_re;
              } else {
                x = minEig_re;
                b_y_tmp = y_tmp;
              }
            } else if (minEig_re < 0.0) {
              x = b_y_tmp;
              b_y_tmp = minEig_im;
            } else {
              x = minEig_im;
            }
            y = b_y_tmp;
            if (x == b_y_tmp) {
              x = 0.0;
              y = 0.0;
            }
          }
        }
        empty_non_axis_sizes = (x > y);
      }
      if (empty_non_axis_sizes) {
        minEig_re = varargin_1_data[k - 1].re;
        minEig_im = varargin_1_data[k - 1].im;
      }
    }
    emxFree_creal_T(&f_st, &varargin_1);
    /*  only called if chol fails (rare) */
    st.site = &t_emlrtRSI;
    eye(&st, L, A);
    A_data = A->data;
    minEig_re = minEig_re * 2.0 + 1.0E-14;
    minEig_im *= 2.0;
    minEig_re = muDoubleScalarHypot(minEig_re, minEig_im);
    loop_ub = A->size[0] * A->size[1];
    b_loop_ub = (loop_ub / 2) << 1;
    input_sizes_idx_1 = b_loop_ub - 2;
    for (i = 0; i <= input_sizes_idx_1; i += 2) {
      _mm_storeu_pd(&A_data[i], _mm_mul_pd(_mm_loadu_pd(&A_data[i]),
                                           _mm_set1_pd(minEig_re)));
    }
    for (i = b_loop_ub; i < loop_ub; i++) {
      A_data[i] *= minEig_re;
    }
    if ((P->size[0] != A->size[0]) &&
        ((P->size[0] != 1) && (A->size[0] != 1))) {
      emlrtDimSizeImpxCheckR2021b(P->size[0], A->size[0], &d_emlrtECI,
                                  (emlrtConstCTX)sp);
    }
    if ((P->size[1] != A->size[1]) &&
        ((P->size[1] != 1) && (A->size[1] != 1))) {
      emlrtDimSizeImpxCheckR2021b(P->size[1], A->size[1], &e_emlrtECI,
                                  (emlrtConstCTX)sp);
    }
    if ((P->size[0] == A->size[0]) && (P->size[1] == A->size[1])) {
      loop_ub = (d_loop_ub / 2) << 1;
      b_loop_ub = loop_ub - 2;
      for (i = 0; i <= b_loop_ub; i += 2) {
        _mm_storeu_pd(&P_data[i], _mm_add_pd(_mm_loadu_pd(&P_data[i]),
                                             _mm_loadu_pd(&A_data[i])));
      }
      for (i = loop_ub; i < d_loop_ub; i++) {
        P_data[i] += A_data[i];
      }
    } else {
      st.site = &t_emlrtRSI;
      plus(&st, P, A);
    }
    st.site = &u_emlrtRSI;
    b_st.site = &xc_emlrtRSI;
    b_chol(&b_st, P);
    P_data = P->data;
    b_loop_ub = P->size[1];
    loop_ub = sqrP->size[0] * sqrP->size[1];
    sqrP->size[0] = P->size[1];
    input_sizes_idx_1 = P->size[0];
    sqrP->size[1] = P->size[0];
    emxEnsureCapacity_real_T(sp, sqrP, loop_ub, &ub_emlrtRTEI);
    sqrP_data = sqrP->data;
    for (i = 0; i < input_sizes_idx_1; i++) {
      for (k = 0; k < b_loop_ub; k++) {
        sqrP_data[k + sqrP->size[0] * i] = P_data[i + P->size[0] * k];
      }
    }
  } else {
    loop_ub = sqrP->size[0] * sqrP->size[1];
    sqrP->size[0] = b_loop_ub;
    sqrP->size[1] = b_loop_ub;
    emxEnsureCapacity_real_T(sp, sqrP, loop_ub, &rb_emlrtRTEI);
    sqrP_data = sqrP->data;
    for (i = 0; i < b_loop_ub; i++) {
      for (k = 0; k < b_loop_ub; k++) {
        sqrP_data[k + sqrP->size[0] * i] = A_data[i + A->size[0] * k];
      }
    }
    /*  chol returns upper-tri; we need lower-tri */
  }
  emxFree_real_T(sp, &P);
  /*  */
  st.site = &v_emlrtRSI;
  b_st.site = &tb_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  minEig_im = alpha * alpha;
  minEig_re = minEig_im * (L + kappa) - L;
  /*  pesos */
  x = 2.0 * L;
  if (x != (int32_T)x) {
    emlrtIntegerCheckR2012b(x, &f_emlrtDCI, (emlrtConstCTX)sp);
  }
  y = minEig_re + L;
  y_tmp = 1.0 / (2.0 * y);
  loop_ub = Wm->size[0];
  Wm->size[0] = (int32_T)x + 1;
  emxEnsureCapacity_real_T(sp, Wm, loop_ub, &sb_emlrtRTEI);
  P_data = Wm->data;
  minEig_re /= y;
  P_data[0] = minEig_re;
  b_loop_ub = (int32_T)x;
  for (k = 0; k < b_loop_ub; k++) {
    P_data[k + 1] = y_tmp;
  }
  st.site = &w_emlrtRSI;
  b_st.site = &tb_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  loop_ub = Wc->size[0];
  Wc->size[0] = (int32_T)x + 1;
  emxEnsureCapacity_real_T(sp, Wc, loop_ub, &tb_emlrtRTEI);
  P_data = Wc->data;
  P_data[0] = minEig_re + ((1.0 - minEig_im) + beta);
  for (k = 0; k < b_loop_ub; k++) {
    P_data[k + 1] = y_tmp;
  }
  /*  raiz de P e L+lambda */
  st.site = &x_emlrtRSI;
  if (y < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  minEig_re = muDoubleScalarSqrt(y);
  loop_ub = sqrP->size[0] * sqrP->size[1];
  b_loop_ub = (loop_ub / 2) << 1;
  input_sizes_idx_1 = b_loop_ub - 2;
  for (i = 0; i <= input_sizes_idx_1; i += 2) {
    _mm_storeu_pd(&sqrP_data[i], _mm_mul_pd(_mm_set1_pd(minEig_re),
                                            _mm_loadu_pd(&sqrP_data[i])));
  }
  for (i = b_loop_ub; i < loop_ub; i++) {
    sqrP_data[i] *= minEig_re;
  }
  c_loop_ub = Eta->size[0];
  if ((Eta->size[0] != sqrP->size[0]) &&
      ((Eta->size[0] != 1) && (sqrP->size[0] != 1))) {
    emlrtDimSizeImpxCheckR2021b(Eta->size[0], sqrP->size[0], &f_emlrtECI,
                                (emlrtConstCTX)sp);
  }
  st.site = &y_emlrtRSI;
  if (Eta->size[0] == sqrP->size[0]) {
    loop_ub = A->size[0] * A->size[1];
    A->size[0] = Eta->size[0];
    input_sizes_idx_1 = sqrP->size[1];
    A->size[1] = sqrP->size[1];
    emxEnsureCapacity_real_T(&st, A, loop_ub, &wb_emlrtRTEI);
    A_data = A->data;
    for (i = 0; i < input_sizes_idx_1; i++) {
      loop_ub = (c_loop_ub / 2) << 1;
      b_loop_ub = loop_ub - 2;
      for (k = 0; k <= b_loop_ub; k += 2) {
        r = _mm_loadu_pd(&sqrP_data[k + sqrP->size[0] * i]);
        _mm_storeu_pd(&A_data[k + A->size[0] * i],
                      _mm_add_pd(_mm_loadu_pd(&Eta_data[k]), r));
      }
      for (k = loop_ub; k < c_loop_ub; k++) {
        A_data[k + A->size[0] * i] = sqrP_data[k + sqrP->size[0] * i];
      }
    }
  } else {
    b_st.site = &y_emlrtRSI;
    binary_expand_op_1(&b_st, A, Eta, sqrP);
    A_data = A->data;
  }
  if (Eta->size[0] == sqrP->size[0]) {
    loop_ub = sqrP->size[0] * sqrP->size[1];
    sqrP->size[0] = Eta->size[0];
    emxEnsureCapacity_real_T(&st, sqrP, loop_ub, &vb_emlrtRTEI);
    sqrP_data = sqrP->data;
    loop_ub = sqrP->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = (c_loop_ub / 2) << 1;
      input_sizes_idx_1 = b_loop_ub - 2;
      for (k = 0; k <= input_sizes_idx_1; k += 2) {
        r = _mm_loadu_pd(&sqrP_data[k + sqrP->size[0] * i]);
        _mm_storeu_pd(&sqrP_data[k + sqrP->size[0] * i],
                      _mm_sub_pd(_mm_loadu_pd(&Eta_data[k]), r));
      }
      for (k = b_loop_ub; k < c_loop_ub; k++) {
        sqrP_data[k + sqrP->size[0] * i] =
            0.0 - sqrP_data[k + sqrP->size[0] * i];
      }
    }
  } else {
    b_st.site = &y_emlrtRSI;
    binary_expand_op(&b_st, sqrP, Eta);
    sqrP_data = sqrP->data;
  }
  b_st.site = &yc_emlrtRSI;
  if (Eta->size[0] != 0) {
    b_loop_ub = Eta->size[0];
  } else if ((A->size[0] != 0) && (A->size[1] != 0)) {
    b_loop_ub = A->size[0];
  } else if ((sqrP->size[0] != 0) && (sqrP->size[1] != 0)) {
    b_loop_ub = sqrP->size[0];
  } else {
    b_loop_ub = 0;
    if (A->size[0] > 0) {
      b_loop_ub = A->size[0];
    }
    if (sqrP->size[0] > b_loop_ub) {
      b_loop_ub = sqrP->size[0];
    }
  }
  c_st.site = &ad_emlrtRSI;
  if ((Eta->size[0] != b_loop_ub) && (Eta->size[0] != 0)) {
    emlrtErrorWithMessageIdR2018a(&c_st, &k_emlrtRTEI,
                                  "MATLAB:catenate:matrixDimensionMismatch",
                                  "MATLAB:catenate:matrixDimensionMismatch", 0);
  }
  if ((A->size[0] != b_loop_ub) && ((A->size[0] != 0) && (A->size[1] != 0))) {
    emlrtErrorWithMessageIdR2018a(&c_st, &k_emlrtRTEI,
                                  "MATLAB:catenate:matrixDimensionMismatch",
                                  "MATLAB:catenate:matrixDimensionMismatch", 0);
  }
  if ((sqrP->size[0] != b_loop_ub) &&
      ((sqrP->size[0] != 0) && (sqrP->size[1] != 0))) {
    emlrtErrorWithMessageIdR2018a(&c_st, &k_emlrtRTEI,
                                  "MATLAB:catenate:matrixDimensionMismatch",
                                  "MATLAB:catenate:matrixDimensionMismatch", 0);
  }
  empty_non_axis_sizes = (b_loop_ub == 0);
  if (empty_non_axis_sizes || (Eta->size[0] != 0)) {
    b_input_sizes_idx_1 = 1;
  } else {
    b_input_sizes_idx_1 = 0;
  }
  if (empty_non_axis_sizes || ((A->size[0] != 0) && (A->size[1] != 0))) {
    input_sizes_idx_1 = A->size[1];
  } else {
    input_sizes_idx_1 = 0;
  }
  if (empty_non_axis_sizes || ((sqrP->size[0] != 0) && (sqrP->size[1] != 0))) {
    sizes[1] = sqrP->size[1];
  } else {
    sizes[1] = 0;
  }
  b_Eta[0] = b_loop_ub;
  loop_ub = Xi->size[0] * Xi->size[1];
  Xi->size[0] = b_loop_ub;
  Xi->size[1] = (b_input_sizes_idx_1 + input_sizes_idx_1) + sizes[1];
  emxEnsureCapacity_real_T(&b_st, Xi, loop_ub, &xb_emlrtRTEI);
  P_data = Xi->data;
  loop_ub = b_input_sizes_idx_1;
  for (i = 0; i < loop_ub; i++) {
    for (k = 0; k < b_loop_ub; k++) {
      P_data[k] = 0.0;
    }
  }
  for (i = 0; i < input_sizes_idx_1; i++) {
    for (k = 0; k < b_loop_ub; k++) {
      P_data[k + Xi->size[0] * (i + b_input_sizes_idx_1)] =
          A_data[k + b_loop_ub * i];
    }
  }
  emxFree_real_T(&b_st, &A);
  loop_ub = sizes[1];
  for (i = 0; i < loop_ub; i++) {
    for (k = 0; k < b_loop_ub; k++) {
      P_data[k +
             Xi->size[0] * ((i + b_input_sizes_idx_1) + input_sizes_idx_1)] =
          sqrP_data[k + b_Eta[0] * i];
    }
  }
  emxFree_real_T(&b_st, &sqrP);
  /*  (2*p+q , 2*L+1) */
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
}

/* End of code generation (SigmaPointsLie.c) */
