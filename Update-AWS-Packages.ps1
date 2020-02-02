$INCLUDE_STATEMENT_OLD="#include <aws/core/platform/Time.h>"
$INCLUDE_STATEMENT_NEW="#include <aws/core/platform/AWSTime.h>"
$AWS_SDK_CPP_LOCATION="./"
$ANDROID_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/android/Time.cpp"
$WINDOWS_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/windows/Time.cpp"
$LINUX_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/linux-shared/Time.cpp"
$UTILS_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/utils/DateTimeCommon.cpp"

$TIME_H_FILE_LOCATION="./aws-cpp-sdk-core/include/aws/core/platform/"

# clone the awsk sdk for c++ repository
mkdir aws-sdk-cpp
cd aws-sdk-cpp
git init
git config core.sparsecheckout true
# add the directories you want to download here
Set-Content .git\info\sparse-checkout "aws-cpp-sdk-core/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-cognito-idp/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-lambda/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-access-management/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-cognito-identity/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-iam/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-kinesis/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-core-tests/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-lambda-integration-tests/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-cognitoidentity-integration-tests/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "aws-cpp-sdk-kinesis-integration-tests/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "cmake/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "code-generation/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "doc_crosslinks/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "doxygen/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "scripts/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "testing-resources/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "third-party/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "toolchains/*" -Encoding Ascii
Add-Content .git\info\sparse-checkout "CMakeLists.txt" -Encoding Ascii
git remote add -f origin https://github.com/aws/aws-sdk-cpp.git
git pull origin master

# rename the Time.h file in aws-sdk-cpp\aws-cpp-sdk-core\include\aws\core\platform
move "${TIME_H_FILE_LOCATION}Time.h" "${TIME_H_FILE_LOCATION}AWSTime.h"

# inside files that include the Time.h file from above, replace the include statements to say Time.h instead of AWSTime.h
((Get-Content -path "${ANDROID_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${ANDROID_TIME_FILE_LOCATION}"
((Get-Content -path "${WINDOWS_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${WINDOWS_TIME_FILE_LOCATION}"
((Get-Content -path "${LINUX_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${LINUX_TIME_FILE_LOCATION}"
((Get-Content -path "${UTILS_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${UTILS_TIME_FILE_LOCATION}"

# build the dll and lib files
cmake -G "Visual Studio 16 2019" -DTARGET_ARCH="WINDOWS" -DBUILD_ONLY="core;lambda;cognito-idp" -DCMAKE_BUILD_TYPE="release" "${AWS_SDK_CPP_LOCATION}"
msbuild "INSTALL.vcxproj" /p:Configuration=Release 

# delete the entire repo when we're done