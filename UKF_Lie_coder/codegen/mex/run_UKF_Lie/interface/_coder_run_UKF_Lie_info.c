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
      "789ced9dcd7322c715c05b5aa49576f581f6fb10979d9c9254654be24bc276a522100824"
      "0d20a12f632578348c6060866161205afe02972fd9432a955b74c8c1"
      "c73de4904ae5903f2007970f762eaef231c71c7d49258ca0a5e199de1989d9f1d0f4ab62"
      "87d7afa7fbd1afe747f3a6358b2692dc0442680175e5dbcfbac7f99e",
      "eeed1d2751bf40fb44eff80ce858a690a7ef3c6cff5def28a8554d3cd7ba4a9557c4ab33"
      "a56aada9edbfac898d8e52171baadc120b9796334916f72545cc1a95"
      "94ae297183e94ad14dfafb6849142ad9a682eaa5c6b587b251b91a8f4f089fd763321e50"
      "e078c07ab8bfda2dfbc3eddf37e90fdbebcd6afe603b9edf91c4befe",
      "ff45687f09b407db9fe879c845d3d9ae3e7da937b4ba542d5eb77f4e681feb88609f06fd"
      "c2feb1fdd975d13793bd7ac617f6e315a11fabe3fc73821f5e60ff38"
      "f6eb8df74f04b52015d5465e124e92d15f1c4a5549909a8d1343109e2bddfa66f36ed1a2"
      "7fa4719a473397c7bffdec9b0927fbfbd36af00f4ef687e587ea8f34",
      "cfadceaf2784febcc09e3eda12c59542a41d39f4d594ca5930b89fe313d77e644cfa31f3"
      "031174a7da77fb753a6c9c1f98f887edb5ba5890044d52fbb14d3db7"
      "f17becc71f09fd581def35821f5e607fe37c90aa0d593a3df97e4c9e2b4ef1e637ef39cb"
      "ef7ffe77ef6327fbc3423bbf374bc5ad4d2117f3a952410e0714395c",
      "ded536e9e1f7a85cafc3aebb17800efdc4f6ac5454f88c2a55b5c625c369e7f71d642fbf"
      "03043fbcc06e653ef4c7a2fbcd4e2bbf5f7fc0317e23fbf9bd9d8986"
      "1301ae9c5bf56fe736b943df9a5f6cc718bf9de6f7b0f15e023af413dbb31daacae28ecc"
      "c7ebaa1213c4b35e39ed1cf7207b39be4af0c30becd6380e62d24139",
      "ad1cfffb29e3b82e76733cb1522a9d1da5cae9c0da6f8f0fd6b2e1705455a28ce36ef9dd"
      "6cd54fc8b96b3fbb968d289717abf4f37a0ad9cb6b3fc10f2fb05b89"
      "bfa02a8a5a3de986a29750a395d7fff99af15a17bb791d696f1c9403fb3bcdb34c399aa9"
      "0552d1dd823fce783d6a799339133fb1bd58e75b92f692530ba2aceb",
      "b4f37b1af5f3fb82d08fd5710e13fcf002fb0df86d0c09be2d422dc77fcca518c791fd1c"
      "3f5d3de4ceb8e6fe722c598ac78e6247ad4834c3f2df23c7f145a043"
      "3fb15d3cafe595a6ac49d998cfbf1fa29ee37791bdebf020c10f2fb05b990f2016970ca7"
      "95df7ff92ccdf88dece7f747675b1bf56db59daee4cabbc7cd702d13",
      "0a4429da7f322ad7ab53eb70830f973ff969e7f70cb297df3e821f5e60bfe17cf03bbd7f"
      "90f1fbedf6e714bfd7d311b9b515d5f67ceb45292315d48da03fcaee"
      "5f3a7ebd3ac56fa1ae361a3e85efe0f5dcd83fadfc9e45aecfa31843427d1e85e5c3bb62"
      "37c75ba7c1ed54480aec1d95655fb1923c8c9deeb718c7472e8f6295",
      "e34ac7053e5f6dca7cbea8ebb473fc1e72ef3adc180bdad7e19eaf338cdfc87e7eefd638"
      "39954806c3413154f3079307ed4d6d95ed3f71fc7a752a0f2eabc5b1"
      "ca83df47f6f2dbcebc1a8805d579f02f79c66f5dece6b7902da4d295a2e27b11393ee6e4"
      "b010f2adefb2f5b7e3d7ab53eb6f830f6391079f43ee5d7f1b6341fb",
      "fa9bf1bb2b76f3bba08acb9195f4723b7e9e112b47f1c3d0d91e1f61fca675fd3d6efb50"
      "e6917bd7df6c1f0ae3f7b0fc66fb50dedcfea8e4bf59fee44afaf8bd"
      "6038eae2267eb3fc09e337cb9fbcb9fd5784f3ddf21cab61b9bd0074e81fb61fd40abc26"
      "5e3fc38a766e2f227bb96de7f34ffa6341f7f34fbe7acdf69de86275",
      "9e3d26f4e705f69a2f180f89ed34dfcc86b6f8ed174139b8ba86e8e1f6a85caf4ee5bd0d"
      "b99b92b17f5af9ed45f6f2fb2de5d14ab4e7bdd9be93aed8bdee6ec8"
      "213e17a973e16432b352e076d2adf3a8c8f2ded4f25b505b7c5de2ab82c4378cfdd3caef"
      "25e45e7e1b63413bbfff2cb0bcb72eb6ef1bccb5b4173b7c5a4da4ca",
      "d5ddcdf6c176a1c89e1febfcf5caf2de83edc3f2fb01b297df2cef7dbbfe58debb2b2cef"
      "7db3f6c765fdcdf69d5c491fbf1f22f7f29bed3b61fc1e96dfb4ef3b"
      "7945387fdcee5b8a4d59ac17f4074cefa99a427fdee411eae7f605a11fabe3fc01c10f2f"
      "b0dfe0efe6fb4342f97364d9f307bb623bbfd7326dad1a0e4796cf53",
      "5b1b1fadfbb4e3953045eb6fb7f3dba9ffb7416cf172b3b3facf6a9d7ff6b86c0cf5fb41"
      "2bc71f237b39fe4b821f5e60bf09c761689e2b8ce38ce35db1ba0fa5"
      "922b16438515211058d9ad6922e7f757729b881e8e5f10ce77eb753becbadcf2f308f545"
      "602c75e04bc536749d769e3f41f6f2fc2d3ccfca1812ea9f6735f13f",
      "b6af5017dbf3e22f3215fe8053574acbb5d50df1b424ca4a9ba27d291784f347edbab5ea"
      "ef14d1dfaea5def9095f40f4f3fb29eae7b7bbee6f5fce83cb50d0be"
      "1fe5f71fb27cb82e76733bb4aed48f5a0ab71d93eb9548f9702bd1d47629da8f724138df"
      "addc66f9f1c1f66139fe0cd9bb0e67f9f1e1fa637995aeb0fcf8cdda",
      "fff4ddc1e7cf5a6cffa7ef0e6e7f12d8d1449233f2e2bb7706b78bcf33eb97345fa67a33"
      "6016d8b18e798a05fb5322f873734ef7b7139764f1a8ced76a623d9f"
      "37f4f7dd8f06f76716d777403d525cffea197cbe595c8f3d6f6e7f12d4f3f4caf4bf793b"
      "eebcbeed9cb0d629fc95e195e8bcf8eacbabef2e92c0d8e3fef10bea",
      "f03509f43b40f7007d0ae8d340bf0bf419a0cf02fd1ed0ef037d0ee8f3405f00fa22d0bd"
      "405f02fa03a03f04fa23a03f06fa13a03f1d100f635cccde4f12caef"
      "10ca3d84f22942f934a1fc2ea17c86503e4b28bf4728bf4f289f2394cf13ca1708e58b84"
      "722fa17c8950fe8050fe9050fe8850fe9850fe8450fe94506e584b7e",
      "4ff47a19c3045800f62bbd37a96ebbce20eda7c4f52f26faed93a03e1ebb69971e0b4845"
      "4d748a642452f5be813454ef6842e7a80b9e0f895e606e3b1fe0f729"
      "acff6f6087f30133829638e2717d6fc8717d067458ff1fc00ec715b3daede36896c7b43a"
      "5e77810eebc3e757c1f1c2c7419f5b17ece7e743fa09d7d5b07ec2c4",
      "4fac5b8dd3a88d2ff3733cfdfc62483f4979465cbf06ecd04fbc74b29b87a31607e6e778"
      "fa591b72bdf213133fbd26bf0bf06fbf715bdf8f0bffbc43ce2f52be"
      "19d77f6df2f9f075e4a679a3cba87182f969af9ff8f7f16dfd24ed5fc7f53f35f113e706"
      "edbc0e8cb986518f8fdb7eef614e1bfd155009f19d11a7c1ef0ce17b",
      "82b8ae20f40feb9bed67b07adf0c11747cdfccedfd7f42687f0ef5cb4dc7778a709f99c5"
      "f3edf63f43185fabf79f3f073a96496087f79f5f11dafda1ee3f63f9"
      "3f17fdce68",
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
                emlrtMxCreateDoubleScalar(740205.6218171297));
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
