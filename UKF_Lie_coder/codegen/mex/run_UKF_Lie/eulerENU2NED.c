/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eulerENU2NED.c
 *
 * Code generation for function 'eulerENU2NED'
 *
 */

/* Include files */
#include "eulerENU2NED.h"
#include "cosd.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "sind.h"
#include "mwmathutil.h"
#include <emmintrin.h>
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo uf_emlrtRSI = {
    13,                                                           /* lineNo */
    "eulerENU2NED",                                               /* fcnName */
    "D:\\codigos_ic\\IC-Vinicius\\inslib\\common\\eulerENU2NED.m" /* pathName */
};

/* Function Definitions */
void eulerENU2NED(const emlrtStack *sp, real_T euler[687816])
{
  static const int8_T b_a[9] = {0, 1, 0, 1, 0, 0, 0, 0, -1};
  emlrtStack b_st;
  emlrtStack st;
  real_T a[9];
  real_T dv[9];
  real_T C11_tmp;
  real_T C13_tmp;
  real_T b_C11_tmp;
  real_T c_C11_tmp;
  real_T d_C11_tmp;
  real_T e_C11_tmp;
  int32_T i;
  int32_T i1;
  int32_T k;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  /*  EULERENU2NED - Convert Euler angles from ENU to NED convention */
  /*  */
  /*  Input arguments: */
  /*  euler - Nx3 array of Euler angles in degrees (ENU order) */
  /*  */
  /*  Output arguments: */
  /*  euler - Nx3 array of Euler angles in degrees (NED order) */
  /* NED<->ENU */
  /*  Loop over each Euler triplet and convert via rotation matrices */
  for (k = 0; k < 229272; k++) {
    real_T C[9];
    real_T C_tmp;
    int32_T a_tmp;
    int32_T b_a_tmp;
    /*  input -> euler angle (yaw,pitch,roll) (deg) */
    /*  output -> Cbn (from navigation to body) */
    /* ENU<->RFU */
    /* consider positive clockwise heading */
    C11_tmp = euler[k + 458544];
    b_C11_tmp = C11_tmp;
    b_cosd(&b_C11_tmp);
    C_tmp = euler[k];
    c_C11_tmp = -C_tmp;
    b_sind(&c_C11_tmp);
    b_sind(&C11_tmp);
    C13_tmp = euler[k + 229272];
    d_C11_tmp = C13_tmp;
    b_sind(&d_C11_tmp);
    e_C11_tmp = -C_tmp;
    b_cosd(&e_C11_tmp);
    b_cosd(&C13_tmp);
    st.site = &uf_emlrtRSI;
    C_tmp = C11_tmp * d_C11_tmp;
    C[0] = b_C11_tmp * e_C11_tmp - C_tmp * c_C11_tmp;
    C[3] = b_C11_tmp * c_C11_tmp + C_tmp * e_C11_tmp;
    C[6] = -C11_tmp * C13_tmp;
    C[1] = -C13_tmp * c_C11_tmp;
    C[4] = C13_tmp * e_C11_tmp;
    C[7] = d_C11_tmp;
    d_C11_tmp *= b_C11_tmp;
    C[2] = C11_tmp * e_C11_tmp + d_C11_tmp * c_C11_tmp;
    C[5] = C11_tmp * c_C11_tmp - d_C11_tmp * e_C11_tmp;
    C[8] = b_C11_tmp * C13_tmp;
    memset(&a[0], 0, 9U * sizeof(real_T));
    for (i = 0; i < 3; i++) {
      C_tmp = a[3 * i];
      a_tmp = 3 * i + 1;
      b_a_tmp = 3 * i + 2;
      for (i1 = 0; i1 < 3; i1++) {
        d_C11_tmp = C[i1 + 3 * i];
        C_tmp += (real_T)b_a[3 * i1] * d_C11_tmp;
        a[a_tmp] += (real_T)b_a[3 * i1 + 1] * d_C11_tmp;
        a[b_a_tmp] += (real_T)b_a[3 * i1 + 2] * d_C11_tmp;
      }
      a[3 * i] = C_tmp;
    }
    memset(&dv[0], 0, 9U * sizeof(real_T));
    for (i = 0; i < 3; i++) {
      __m128d r;
      __m128d r1;
      a_tmp = b_a[3 * i];
      r = _mm_loadu_pd(&a[0]);
      r1 = _mm_loadu_pd(&dv[3 * i]);
      _mm_storeu_pd(&dv[3 * i],
                    _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(a_tmp))));
      b_a_tmp = 3 * i + 2;
      dv[b_a_tmp] += a[2] * (real_T)a_tmp;
      a_tmp = b_a[3 * i + 1];
      r = _mm_loadu_pd(&a[3]);
      r1 = _mm_loadu_pd(&dv[3 * i]);
      _mm_storeu_pd(&dv[3 * i],
                    _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(a_tmp))));
      dv[b_a_tmp] += a[5] * (real_T)a_tmp;
      a_tmp = b_a[b_a_tmp];
      r = _mm_loadu_pd(&a[6]);
      r1 = _mm_loadu_pd(&dv[3 * i]);
      _mm_storeu_pd(&dv[3 * i],
                    _mm_add_pd(r1, _mm_mul_pd(r, _mm_set1_pd(a_tmp))));
      dv[b_a_tmp] += a[8] * (real_T)a_tmp;
    }
    for (i = 0; i < 3; i++) {
      C[3 * i] = dv[i];
      C[3 * i + 1] = dv[i + 3];
      C[3 * i + 2] = dv[i + 6];
    }
    /*  input -> Cba (from a-frame to b-frame) */
    /*  return the euler angles [roll,pitch,yaw] (deg) from a given rotation
     * matrix Cba=C(Psi_ab); */
    /*    */
    b_st.site = &nf_emlrtRSI;
    if ((C[6] < -1.0) || (C[6] > 1.0)) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &y_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
    }
    euler[k] = 57.29577951308232 * muDoubleScalarAtan2(C[7], C[8]);
    euler[k + 229272] = 57.29577951308232 * -muDoubleScalarAsin(C[6]);
    euler[k + 458544] = 57.29577951308232 * muDoubleScalarAtan2(C[3], C[0]);
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b((emlrtConstCTX)sp);
    }
  }
}

/* End of code generation (eulerENU2NED.c) */
