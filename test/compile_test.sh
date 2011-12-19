#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertContains "-----> Downloading sonar"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Sonar" "[ -f ${CACHE_DIR}/sonar-2.11.tar.gz ]"
  assertContains "-----> Installing sonar"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed Sonar in build dir: `ls ${BUILD_DIR}`" "[ -d ${BUILD_DIR}/sonar ]"

  assertContains "-----> Downloading jetty-runner"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Jetty Runner `ls ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/jetty-runner-8.1.0.RC1.jar ]"
  assertContains "-----> Installing jetty-runner"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed Jetty Runner in build dir: `ls ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/jetty/runner.jar ]"
  
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture
  
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertNotContains "-----> Downloading sonar"  "`cat ${STD_OUT}`"
  assertContains "-----> Installing sonar"  "`cat ${STD_OUT}`"
  
  assertNotContains "-----> Downloading jetty-runner"  "`cat ${STD_OUT}`"
  assertContains "-----> Installing jetty-runner"  "`cat ${STD_OUT}`"
  
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"
}
