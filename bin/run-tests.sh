#!/bin/bash

# https://github.com/tmux/tmux/issues/475#issuecomment-231527324
export EVENT_NOKQUEUE=1

echo "Running Unit Tests"

TEST_PLATFORM="editmode"
if [ ! -z $1 ]; then
  TEST_PLATFORM=$1
fi

if [ -z "${UNITY_APP}" ]; then
  echo "UNITY_APP env var not defined. Cannot find installed Unity version."
  exit 1
fi

if [ -z "${UNITY_PROJECT_PATH}" ]; then
  echo "UNITY_PROJECT_PATH env var not defined."
  exit 1
fi

echo "Running Tests in ${UNITY_PROJECT_PATH}"

TEST_LOG_FILE="$(pwd)/test.xml"
LOG_FILE=$"$(pwd)/unity.log"

#clear an old file if one exists
if [ -f "${TEST_LOG_FILE}" ]; then
  rm "${TEST_LOG_FILE}"
fi

if (echo "${UNITY_VERSION}" | grep "2017\|2018" &> /dev/null) ; then

  echo "Running Test Script for 2017 and 2018"
  #Unity 2018 and earlier
  "${UNITY_APP}" \
      -batchmode \
      -nographics \
      -silent-crashes \
      -logFile "${LOG_FILE}" \
      -projectPath "${UNITY_PROJECT_PATH}" \
      -runEditorTests \
      -editorTestsResultFile "${TEST_LOG_FILE}" || exit 1

  cat "$(pwd)/unity.log"

else

  echo "Running 2019+ Test Script" ${TEST_PLATFORM}
  "${UNITY_APP}" \
      -batchmode \
      -nographics \
      -silent-crashes \
      -stackTraceLogType Full \
      -logFile "${LOG_FILE}" \
      -projectPath "${UNITY_PROJECT_PATH}" \
      -runTests \
      -testPlatform ${TEST_PLATFORM} \
      -testsResults "${TEST_LOG_FILE}" || exit 1

fi

if [ ! -f "${TEST_LOG_FILE}" ]; then
  echo "Test result file " $TEST_LOG_FILE "Not Found"
fi

printf '\n%s\n\n' "$(<"${TEST_LOG_FILE}")"

checktests() {

    local TOTAL
    local PASSED
    local FAILED

    TOTAL=$(grep -Eo 'total="([0-9]*)"' "${TEST_LOG_FILE}" | head -1 | grep -Eo '[0-9]+')
    PASSED=$(grep -Eo 'passed="([0-9]*)"' "${TEST_LOG_FILE}" | head -1 | grep -Eo '[0-9]+')
    FAILED=$(grep -Eo 'failed="([0-9]*)"' "${TEST_LOG_FILE}" | head -1 | grep -Eo '[0-9]+')

    printf "Test Results:\n - Total %s\n ✔ Passed %s\n 𐄂 Failed %s\n" "${TOTAL}" "${PASSED}" "${FAILED}"

    if [ "${TOTAL}" -ne "${PASSED}" ]; then
        return 1
    fi

    return 0

}

checktests "${TEST_LOG_FILE}"

CODE=$?

exit $CODE
