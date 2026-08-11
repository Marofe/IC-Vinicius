/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_run_UKF_Lie_info.c
 *
 * Code generation for function 'run_UKF_Lie'
 *
 */

/* Include files */
#include "_coder_run_UKF_Lie_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

/* Function Declarations */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void);

/* Function Definitions */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void)
{
  const mxArray *nameCaptureInfo;
  const char_T *data[20] = {
      "789ced5dbd73e3c6155fe9289d74a70feabe8b78eca4b233931b895f126d4f2622458a94"
      "049212f5655a090d81100912207820c8e8f817783cc9e48a142955a4"
      "7079458a1429f207a4c8a488dd78c665ca946e3c09217225f0997b84441c0c2ef7cde0c0"
      "f7de62dfe3bedd1f1f1e56383491e42610420ba843df7ed139cf7779",
      "6ff73c897a09ea27bae76780c734853c3dd761fd1fba6741adeae2b9de61aabc225e5d29"
      "556b0d7dff654dacb7194dacab72532c5c6ace2459dc9714316b6652"
      "06a7c44daa2bc650199fa32551a8641b0ad24af56b0f653373351e9f11beaf67c0784082"
      "e301db617bb55bdac3fddf1f600febb546357fb01dcfef48628ffdaf",
      "09fd2f81fe60ff135d0fb9683adbe1a72ff9baae49d5e275ffe784fe318f08fa696017da"
      "c7fa67d7a26f26bbedcc07f6e315c18ed571fe39c10f2fd07f1afbf5"
      "c68727825a908a6a3d2f0927c9e82f0ea5aa24488dfa892908cf954efb41f36ed1a27fa4"
      "719a47331df907df4c3869eff733f9df39690fd38f658f34cfadceaf",
      "27047b5ea04f1f6d89e24a21d28a1cfa6a4ae52c18dccff1896b3f3203ec0cf2031178a7"
      "fa77fb3a1d36ce0f06f887f5354d2c48822ea9bdb04d3d6ee3cfd88f"
      "3f11ec581def35821f5ea07fe37c90aa75593a3df9614c9e2b4ee1cd6fde7316bffff1fd"
      "dea74edac3443b7e6f968a5b9b422ee653a5821c0e2872b8bcab6fd2",
      "83dfa3b25e87cdbb17000ffdc4faac5454f88c2a55f5fa2586d38edf7790bdf81d20f8e1"
      "057a2bf3a137169d5f765af1fbf5471cc36f643f7e6f67a2e144802b"
      "e756fddbb94deed0b7e6175b3186df4ee3f7b0f15e023cf413ebb36d5495c51d998f6baa"
      "1213c4b3ae9c761cf7207b717c95e08717e8ade13888491bca69c5f1",
      "bf9d321c37c86e1c4fac944a6747a9723ab0f6dbe383b56c381c559528c371b7dc375bf5"
      "13e2dcb59f1dcd4694cb8b55faf17a0ad98bd77e821f5ea0b7127f41"
      "5514b57ad20945b7a0462b5efff72b86d706d98dd791d6c64139b0bfd338cb94a3995a20"
      "15dd2df8e30caf47ad6e3237c04fac2f6a7c53d25f726a41940d9e76",
      "fc9e46bdf87d41b063759cc3043fbc407f03fc3687043f16a116c77fcaa5188e23fb71fc"
      "74f5903be31afbcbb164291e3b8a1d3523d10cab7f8f1c8e2f021efa"
      "89f5e2792daf34645dcac67cfefd10f5387e17d99b8707097e7881deca7c00b1b8c4705a"
      "f1fb2f5fa4197e23fbf1fb93b3ad0d6d5b6da52bb9f2ee71235ccb84",
      "02518af69f8cca7a752a0f37f97079cb4f3b7ecf207bf1db47f0c30bf4379c0f7ea7f70f"
      "32fc7ebbf69cc2eff574446e6e45f53ddf7a51ca48057523e88fb2e7"
      "978eaf57a7f05bd0d47adda7f06d783d37dba715bf6791ebeb28e690505f4761f5f00ed9"
      "8de3cdd3e0762a2405f68ecab2af58491ec64ef79b0cc747ae8e6215",
      "c795b60b7cbeda90f97cd1e069c7f17bc8bd79b83916b4e7e19eaf320cbf91fdf8bd5be3"
      "e45422190c07c550cd1f4c1eb436f555b6ffc4f1f5ea541d5c568b63"
      "5507bf8fecc56f3beb6a201654d7c1ffc533fc36c86efc16b28554ba52547c2f22c7c79c"
      "1c1642bef55d967f3bbe5e9dcabf4d3e8c451d7c0eb937ff36c782f6",
      "fc9be17787ecc6ef822a2e4756d2cbadf87946ac1cc50f43677b7c84e137adf9f7b8ed43"
      "9947eecdbfd93e1486dfc3e237db87f2e6fe47a5fecdea2757d483df"
      "0ba6b3416ec26f563f61f8cdea276feeff15e17ab7bcc76a58dc5e003cf40feb0f6a055e"
      "17afdf61453b6e2f227b71dbcef79ff4c682eef79ffcfb35db776290",
      "d579f69860cf0bf4355f301e125b69be910d6df1db2f827270750dd183dba3b25e9daa7b"
      "9b6a3725b37d5af1db8becc5efb754472bd15ef766fb4e3a6477de5d"
      "97437c2ea271e16432b352e076d2cdf3a8c8eaded4e2b7a036794de2ab82c4d7cdf669c5"
      "ef25e45efc36c78276fcfeb3c0eade06d9be6f30d7d45fecf0693591",
      "2a5777375b07db85227b7facf3eb95d5bdfbeb87c5ef07c85efc6675efdbd96375ef0eb1"
      "baf7cdfa1f97fc9bed3bb9a21efc7e88dc8bdf6cdf09c3ef61f19bf6"
      "7d27af08d78fdb734bb1218b5ac178c1f49eaa2bf4d74d1ea15edcbe20d8b13ace1f11fc"
      "f002fd0dfe6ebe372494bf4796bd7fb043b6e3f75aa6a557c3e1c8f2",
      "796a6be393759f7ebc12a628ff763b7e3bf5ff36884d5e6eb4b3ffacdefe678fcbc650af"
      "1fb4e2f863642f8eff92e08717e86f82e33034cf1586e30cc73b6475"
      "1f4a25572c860a2b4220b0b25bd345ceefafe436113d387e41b8deadeb76d8bcdcf2fb08"
      "8d2430963af0a5621b064f3b9e3f41f6e2f95b789f953924d4bfcf6a",
      "e27f6c5fa141b6d7c55f642afc01a7ae94966bab1be2694994951645fb522e08d78fdaba"
      "b5eaef14d1df8e466bdfc21710fdf8fd14f5e2b7bb9e6f5fce83cb50"
      "d0be1fe58f1fb37ab84176e376685dd18e9a0ab71d93b54aa47cb89568e8bb14ed47b920"
      "5cef56dc66f5f1fefa6171fc19b2370f67f5f1e1ecb1ba4a87587dfc",
      "66fd7ffe6effeb672df6fffebbfdfb9f047a3491e4cc78f1dd3bfdfbc5d70db24b9a2f53"
      "dd19300bf498c7788a09fb5322f873739ceeed272ec9e291c6d76aa2"
      "96cf9bec7df793fef606c5f51dd08e14d7bf7afa5f3f28aec79e37f73f09da79ba32e36f"
      "de8edbc7b7ed0bd6dac25f998e44fbe0ab2faf7ebb4804638fede303",
      "f2f09804fc1dc07b003f05f869c0df05fc0ce067017f0ff0f7013f07f879c02f007e11f0"
      "5ec02f01fe01e01f02fe11e01f03fe09e09ff68987392e833e4f12e4"
      "7708720f413e45904f13e47709f219827c9620bf4790df27c8e708f279827c81205f24c8"
      "bd04f91241fe80207f48903f22c81f13e44f08f2a704b92997fc0119",
      "ed32a609b000f4577c7752dd36cf20eda7c4ed2f267af593a03d1ebb69979e0b48450d74"
      "8a642452f5b98e74a4b539a17d3608cf87443730b79d0ff0f714b6ff"
      "0fd0c3f98031829638e2717d6fc8717d0678d8feef400fc71563b5dbc771501dd3ea78dd"
      "053c6c0fdf5f05c70b9ffb7d6f83b09f5f0ee927ccab61fbc4003f31",
      "6f354ea336becccff1f4f39f43fa49aa33e2f635a0877ee2d4c96e3c1cb538303fc7d3cf"
      "da90f9cacf06f8e91d705f80effdc62dbf1f17fcf30e39bf48f566dc"
      "fef580ef87d7919be68d41a38613cc4f7bfdc4f7c7b7f593b47f1db7ff7c809fb83668e7"
      "3a30d71a463d3e6ebbdfc3386df6574025c4b7479c06bf3384df0962",
      "5e41b00fdb0fdacf60f5b91922f0f8b999dbed7f46e87f0ef5d24dc7778af09c99c5f3ed"
      "da9f218cafd5e7cf5f021ed324d0c3e7cfaf08fdfe58cf9f31fd1f40"
      "a4cd8e",
      ""};
  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(&data[0], 43664U, &nameCaptureInfo);
  return nameCaptureInfo;
}

mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xEntryPoints;
  mxArray *xInputs;
  mxArray *xResult;
  const char_T *epFieldName[7] = {
      "QualifiedName",    "NumberOfInputs", "NumberOfOutputs", "ConstantInputs",
      "ResolvedFilePath", "TimeStamp",      "Visible"};
  const char_T *propFieldName[7] = {
      "Version",      "ResolvedFunctions", "Checksum", "EntryPoints",
      "CoverageInfo", "IsPolymorphic",     "AuxData"};
  uint8_T v[216] = {
      0U,   1U,   73U,  77U,  0U,   0U,   0U,   0U,   14U,  0U,   0U,   0U,
      200U, 0U,   0U,   0U,   6U,   0U,   0U,   0U,   8U,   0U,   0U,   0U,
      2U,   0U,   0U,   0U,   0U,   0U,   0U,   0U,   5U,   0U,   0U,   0U,
      8U,   0U,   0U,   0U,   1U,   0U,   0U,   0U,   1U,   0U,   0U,   0U,
      1U,   0U,   0U,   0U,   0U,   0U,   0U,   0U,   5U,   0U,   4U,   0U,
      17U,  0U,   0U,   0U,   1U,   0U,   0U,   0U,   17U,  0U,   0U,   0U,
      67U,  108U, 97U,  115U, 115U, 69U,  110U, 116U, 114U, 121U, 80U,  111U,
      105U, 110U, 116U, 115U, 0U,   0U,   0U,   0U,   0U,   0U,   0U,   0U,
      14U,  0U,   0U,   0U,   112U, 0U,   0U,   0U,   6U,   0U,   0U,   0U,
      8U,   0U,   0U,   0U,   2U,   0U,   0U,   0U,   0U,   0U,   0U,   0U,
      5U,   0U,   0U,   0U,   8U,   0U,   0U,   0U,   1U,   0U,   0U,   0U,
      0U,   0U,   0U,   0U,   1U,   0U,   0U,   0U,   0U,   0U,   0U,   0U,
      5U,   0U,   4U,   0U,   14U,  0U,   0U,   0U,   1U,   0U,   0U,   0U,
      56U,  0U,   0U,   0U,   81U,  117U, 97U,  108U, 105U, 102U, 105U, 101U,
      100U, 78U,  97U,  109U, 101U, 0U,   77U,  101U, 116U, 104U, 111U, 100U,
      115U, 0U,   0U,   0U,   0U,   0U,   0U,   0U,   80U,  114U, 111U, 112U,
      101U, 114U, 116U, 105U, 101U, 115U, 0U,   0U,   0U,   0U,   72U,  97U,
      110U, 100U, 108U, 101U, 0U,   0U,   0U,   0U,   0U,   0U,   0U,   0U};
  xEntryPoints =
      emlrtCreateStructMatrix(1, 1, 7, (const char_T **)&epFieldName[0]);
  xInputs = emlrtCreateLogicalMatrix(1, 19);
  emlrtSetField(xEntryPoints, 0, "QualifiedName",
                emlrtMxCreateString("run_UKF_Lie"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs",
                emlrtMxCreateDoubleScalar(19.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs",
                emlrtMxCreateDoubleScalar(4.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(
      xEntryPoints, 0, "ResolvedFilePath",
      emlrtMxCreateString("D:\\codigos_ic\\IC-Vinicius\\run_UKF_Lie.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp",
                emlrtMxCreateDoubleScalar(740204.7019791667));
  emlrtSetField(xEntryPoints, 0, "Visible", emlrtMxCreateLogicalScalar(true));
  xResult =
      emlrtCreateStructMatrix(1, 1, 7, (const char_T **)&propFieldName[0]);
  emlrtSetField(xResult, 0, "Version",
                emlrtMxCreateString("26.1.0.3312084 (R2026a) Update 4"));
  emlrtSetField(xResult, 0, "ResolvedFunctions",
                (mxArray *)c_emlrtMexFcnResolvedFunctionsI());
  emlrtSetField(xResult, 0, "Checksum",
                emlrtMxCreateString("9vcB4eXsMedimyFDszbWTH"));
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  emlrtSetField(xResult, 0, "AuxData",
                emlrtMxCreateRowVectorUINT8((const uint8_T *)&v, 216U));
  return xResult;
}

/* End of code generation (_coder_run_UKF_Lie_info.c) */
