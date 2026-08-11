/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * exp_multiSE23T6.c
 *
 * Code generation for function 'exp_multiSE23T6'
 *
 */

/* Include files */
#include "exp_multiSE23T6.h"
#include "norm.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie_data.h"
#include "mwmathutil.h"
#include <emmintrin.h>
#include <string.h>

/* Function Definitions */
void exp_multiSE23T6(const real_T a[15], real_T expo[169])
{
  real_T Xi[25];
  real_T Xi2[25];
  real_T b_Xi2[25];
  real_T b_a[3];
  real_T theta;
  int32_T Xi_tmp;
  int32_T i;
  int32_T k;
  /* a=[w a v ba0 bg0](15x1) */
  /*  para o SE2(3)xT6 exp([w a v ba0 bg0])=blkdiag([exp([w a v]^)],[eye ba0;0
   * 1],[eye bg0;0 1]) */
  b_a[0] = a[0];
  b_a[1] = a[1];
  b_a[2] = a[2];
  theta = b_norm(b_a);
  if (theta == 0.0) {
    real_T c_a[6];
    memset(&Xi[0], 0, 25U * sizeof(real_T));
    for (k = 0; k < 5; k++) {
      Xi[k + 5 * k] = 1.0;
    }
    for (k = 0; k < 6; k++) {
      c_a[k] = a[k + 3];
    }
    for (k = 0; k < 2; k++) {
      Xi_tmp = 5 * (k + 3);
      Xi[Xi_tmp] = c_a[3 * k];
      Xi[Xi_tmp + 1] = c_a[3 * k + 1];
      Xi[Xi_tmp + 2] = c_a[3 * k + 2];
    }
  } else {
    __m128d r;
    __m128d r1;
    __m128d r2;
    real_T c_a[6];
    real_T d_a;
    real_T e_a;
    int32_T Xi2_tmp;
    int8_T b_I[25];
    memset(&Xi[0], 0, 25U * sizeof(real_T));
    /*  return the cross product matrix [a]x */
    /*    */
    Xi[0] = 0.0;
    Xi[5] = -a[2];
    Xi[10] = a[1];
    Xi[1] = a[2];
    Xi[6] = 0.0;
    Xi[11] = -a[0];
    Xi[2] = -a[1];
    Xi[7] = a[0];
    Xi[12] = 0.0;
    /* . */
    for (k = 0; k < 6; k++) {
      c_a[k] = a[k + 3];
    }
    for (k = 0; k < 2; k++) {
      Xi_tmp = 5 * (k + 3);
      Xi[Xi_tmp] = c_a[3 * k];
      Xi[Xi_tmp + 1] = c_a[3 * k + 1];
      Xi[Xi_tmp + 2] = c_a[3 * k + 2];
    }
    memset(&Xi2[0], 0, 25U * sizeof(real_T));
    for (k = 0; k < 5; k++) {
      Xi_tmp = 5 * k + 2;
      Xi2_tmp = 5 * k + 4;
      for (i = 0; i < 5; i++) {
        d_a = Xi[i + 5 * k];
        r = _mm_loadu_pd(&Xi[5 * i]);
        r1 = _mm_loadu_pd(&Xi2[5 * k]);
        r2 = _mm_set1_pd(d_a);
        _mm_storeu_pd(&Xi2[5 * k], _mm_add_pd(r1, _mm_mul_pd(r, r2)));
        r = _mm_loadu_pd(&Xi[5 * i + 2]);
        r1 = _mm_loadu_pd(&Xi2[Xi_tmp]);
        _mm_storeu_pd(&Xi2[Xi_tmp], _mm_add_pd(r1, _mm_mul_pd(r, r2)));
        Xi2[Xi2_tmp] += Xi[5 * i + 4] * d_a;
      }
    }
    e_a = 1.0 / (theta * theta) * (1.0 - muDoubleScalarCos(theta));
    d_a = 1.0 / muDoubleScalarPower(theta, 3.0) *
          (theta - muDoubleScalarSin(theta));
    for (k = 0; k < 25; k++) {
      b_I[k] = 0;
    }
    memset(&b_Xi2[0], 0, 25U * sizeof(real_T));
    for (k = 0; k < 5; k++) {
      b_I[k + 5 * k] = 1;
      Xi_tmp = 5 * k + 2;
      Xi2_tmp = 5 * k + 4;
      for (i = 0; i < 5; i++) {
        theta = Xi[i + 5 * k];
        r = _mm_loadu_pd(&Xi2[5 * i]);
        r1 = _mm_loadu_pd(&b_Xi2[5 * k]);
        r2 = _mm_set1_pd(theta);
        _mm_storeu_pd(&b_Xi2[5 * k], _mm_add_pd(r1, _mm_mul_pd(r, r2)));
        r = _mm_loadu_pd(&Xi2[5 * i + 2]);
        r1 = _mm_loadu_pd(&b_Xi2[Xi_tmp]);
        _mm_storeu_pd(&b_Xi2[Xi_tmp], _mm_add_pd(r1, _mm_mul_pd(r, r2)));
        b_Xi2[Xi2_tmp] += Xi2[5 * i + 4] * theta;
      }
    }
    for (k = 0; k < 25; k++) {
      Xi[k] = (((real_T)b_I[k] + Xi[k]) + e_a * Xi2[k]) + d_a * b_Xi2[k];
    }
  }
  /*  resulta em matriz(5x5) */
  /*  resulta em matriz(4x4) */
  memset(&expo[0], 0, 169U * sizeof(real_T));
  for (k = 0; k < 5; k++) {
    for (i = 0; i < 5; i++) {
      expo[i + 13 * k] = Xi[i + 5 * k];
    }
  }
  for (k = 0; k < 3; k++) {
    Xi_tmp = 13 * (k + 5);
    expo[Xi_tmp + 5] = iv[3 * k];
    expo[Xi_tmp + 6] = iv[3 * k + 1];
    expo[Xi_tmp + 7] = iv[3 * k + 2];
    expo[k + 109] = a[k + 9];
  }
  expo[73] = 0.0;
  expo[86] = 0.0;
  expo[99] = 0.0;
  expo[112] = 1.0;
  for (k = 0; k < 3; k++) {
    Xi_tmp = 13 * (k + 9);
    expo[Xi_tmp + 9] = iv[3 * k];
    expo[Xi_tmp + 10] = iv[3 * k + 1];
    expo[Xi_tmp + 11] = iv[3 * k + 2];
    expo[k + 165] = a[k + 12];
  }
  expo[129] = 0.0;
  expo[142] = 0.0;
  expo[155] = 0.0;
  expo[168] = 1.0;
  /* dimensao 13x13 */
}

/* End of code generation (exp_multiSE23T6.c) */
