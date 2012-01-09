#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect()
{
  #touch ${BUILD_DIR}/build.gradle
  
  capture ${BUILDPACK_HOME}/bin/detect ${BUILD_DIR}
  
  assertEquals 0 ${RETURN}
  assertEquals "Sonar" "`cat ${STD_OUT}`"
  assertNull "`cat ${STD_ERR}`"
}
