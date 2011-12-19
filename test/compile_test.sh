#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertContains "-----> Downloading"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Sonar" "[ -f ${CACHE_DIR}/sonar-2.11.tar.gz ]"
  assertContains "-----> Installing"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed Sonar in build dir: `ls ${BUILD_DIR}`" "[ -d ${BUILD_DIR}/sonar ]"
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertNotContains "-----> Downloading"  "`cat ${STD_OUT}`"
  assertContains "-----> Installing"  "`cat ${STD_OUT}`"
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"
}
