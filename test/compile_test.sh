#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertContains "-----> Downloading sonar"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Sonar `ls -la ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/sonar-2.11.tar.gz ]"
  assertContains "-----> Installing sonar"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed Sonar in build dir: `ls -la ${BUILD_DIR}`" "[ -d ${BUILD_DIR}/sonar ]"
  assertTrue "Should have created Sonar home directory: `ls -la ${BUILD_DIR}/sonar`" "[ -d ${BUILD_DIR}/sonar/home ]"
  assertContains "sonarHome" "`cat ${BUILD_DIR}/sonar/war/build-war.sh`"
  assertTrue "Sonar WAR should have been created `ls -la ${BUILD_DIR}/sonar/war`" "[ -f ${BUILD_DIR}/sonar/war/sonar.war ]"
  assertTrue "boot.sh should be present and executable `ls -la ${BUILD_DIR}/sonar/war`" "[ -x ${BUILD_DIR}/sonar/war/boot.sh ]"

  assertContains "-----> Downloading jetty-runner"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Jetty Runner `ls -la ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/jetty-runner-8.1.0.RC1.jar ]"
  assertContains "-----> Installing jetty-runner"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed Jetty Runner in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/jetty/runner.jar ]"
  
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
