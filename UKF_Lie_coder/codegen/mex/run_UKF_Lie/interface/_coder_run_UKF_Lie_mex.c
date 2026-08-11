/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_run_UKF_Lie_mex.c
 *
 * Code generation for function '_coder_run_UKF_Lie_mex'
 *
 */

/* Include files */
#include "_coder_run_UKF_Lie_mex.h"
#include "_coder_run_UKF_Lie_api.h"
#include "rt_nonfinite.h"
#include "run_UKF_Lie.h"
#include "run_UKF_Lie_data.h"
#include "run_UKF_Lie_initialize.h"
#include "run_UKF_Lie_terminate.h"
#include "run_UKF_Lie_types.h"
#include "omp.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  static jmp_buf emlrtJBEnviron;
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  run_UKF_LieStackData *run_UKF_LieStackDataGlobal = NULL;
  run_UKF_LieStackDataGlobal = (run_UKF_LieStackData *)emlrtMxCalloc(
      (size_t)1, (size_t)1U * sizeof(run_UKF_LieStackData));
  mexAtExit(&run_UKF_Lie_atexit);
  emlrtLoadLibrary("C:\\ProgramData\\MATLAB\\SupportPackages\\R2026a\\3P."
                   "instrset\\mingw_w64.instrset\\bin\\libgomp-1.dll");
  /* Initialize the memory manager. */
  omp_init_lock(&emlrtLockGlobal);
  omp_init_nest_lock(&run_UKF_Lie_nestLockGlobal);
  run_UKF_Lie_initialize();
  st.tls = emlrtRootTLSGlobal;
  emlrtSetJmpBuf(&st, &emlrtJBEnviron);
  if (setjmp(emlrtJBEnviron) == 0) {
    run_UKF_Lie_mexFunction(run_UKF_LieStackDataGlobal, nlhs, plhs, nrhs, prhs);
    run_UKF_Lie_terminate();
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&run_UKF_Lie_nestLockGlobal);
  } else {
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&run_UKF_Lie_nestLockGlobal);
    emlrtReportParallelRunTimeError(&st);
  }
  emlrtMxFree(run_UKF_LieStackDataGlobal);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal,
                           &emlrtLockerFunction, omp_get_num_procs(), NULL,
                           "windows-1252", true);
  return emlrtRootTLSGlobal;
}

void run_UKF_Lie_mexFunction(run_UKF_LieStackData *SD, int32_T nlhs,
                             mxArray *plhs[4], int32_T nrhs,
                             const mxArray *prhs[19])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[4];
  int32_T i;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 19) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 19, 4,
                        11, "run_UKF_Lie");
  }
  if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 11,
                        "run_UKF_Lie");
  }
  /* Call the function. */
  run_UKF_Lie_api(SD, prhs, nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    i = 1;
  } else {
    i = nlhs;
  }
  emlrtReturnArrays(i, &plhs[0], &outputs[0]);
}

/* End of code generation (_coder_run_UKF_Lie_mex.c) */
