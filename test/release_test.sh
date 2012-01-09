#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testRelease_default_process_types()
{
  expected_release_output=`cat <<EOF
---

config_vars:
  JAVA_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops
addons:
  shared-database:5mb
default_process_types:
  web: sh sonar/war/boot.sh
EOF`

  capture ${BUILDPACK_HOME}/bin/release ${BUILD_DIR}
  assertEquals 0 ${RETURN}
  assertEquals "${expected_release_output}" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
}


testRelease_Procfile()
{
  touch ${BUILD_DIR}/Procfile

  expected_release_output=`cat <<EOF
---

config_vars:
  JAVA_OPTS: -Xmx384m -Xss512k -XX:+UseCompressedOops
addons:
  shared-database:5mb
EOF`

  capture ${BUILDPACK_HOME}/bin/release ${BUILD_DIR}
  assertEquals 0 ${RETURN}
  assertEquals "${expected_release_output}" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
}
