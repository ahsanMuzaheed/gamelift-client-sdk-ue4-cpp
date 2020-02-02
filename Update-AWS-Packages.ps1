$INCLUDE_STATEMENT_OLD="#include <aws/core/platform/Time.h>"
$INCLUDE_STATEMENT_NEW="#include <aws/core/platform/AWSTime.h>"
$AWS_SDK_CPP_LOCATION="./"
$ANDROID_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/android/Time.cpp"
$WINDOWS_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/windows/Time.cpp"
$LINUX_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/platform/linux-shared/Time.cpp"
$UTILS_TIME_FILE_LOCATION="./aws-cpp-sdk-core/source/utils/DateTimeCommon.cpp"

$TIME_H_FILE_LOCATION="./aws-cpp-sdk-core/include/aws/core/platform"
$THIRD_PARTY_WINDOWS_LOCATION="ThirdParty/Win64"
$AWS_DLL_FILE_LOCATION="./aws-sdk-cpp/bin/Release"
$SOURCE_PUBLIC_LOCATION="Source/GameLiftClientSDK/Public/aws"

# clone the aws sdk for c++ repository
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
move "${TIME_H_FILE_LOCATION}/Time.h" "${TIME_H_FILE_LOCATION}/AWSTime.h"

# inside files that include the Time.h file from above, replace the include statements to say Time.h instead of AWSTime.h
((Get-Content -path "${ANDROID_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${ANDROID_TIME_FILE_LOCATION}"
((Get-Content -path "${WINDOWS_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${WINDOWS_TIME_FILE_LOCATION}"
((Get-Content -path "${LINUX_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${LINUX_TIME_FILE_LOCATION}"
((Get-Content -path "${UTILS_TIME_FILE_LOCATION}" -Raw) -replace ${INCLUDE_STATEMENT_OLD},${INCLUDE_STATEMENT_NEW}) | Set-Content -Path "${UTILS_TIME_FILE_LOCATION}"

# build the dll and lib files
cmake -G "Visual Studio 16 2019" -DTARGET_ARCH="WINDOWS" -DBUILD_ONLY="core;lambda;cognito-idp" -DCMAKE_BUILD_TYPE="release" "${AWS_SDK_CPP_LOCATION}"
msbuild "INSTALL.vcxproj" /p:Configuration=Release 

# move the dll and lib files to ThirdParty/Win64 directory (assume it has not even been made)
cd ../
if(Test-Path -Path $THIRD_PARTY_WINDOWS_LOCATION) {
	Remove-Item -LiteralPath $THIRD_PARTY_WINDOWS_LOCATION -Force -Recurse
}

mkdir $THIRD_PARTY_WINDOWS_LOCATION

Move-Item -Path "./aws-sdk-cpp/bin/Release/aws-c-common.dll" -Destination "ThirdParty/Win64"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-c-event-stream.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-checksums.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-cognito-identity.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-cognito-idp.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-core.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-iam.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-kinesis.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "${AWS_DLL_FILE_LOCATION}/aws-cpp-sdk-lambda.dll" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"

Move-Item -Path "./aws-sdk-cpp/.deps/install/lib/aws-c-common.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/.deps/install/lib/aws-c-event-stream.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/.deps/install/lib/aws-checksums.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-cognito-identity/Release/aws-cpp-sdk-cognito-identity.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-cognito-idp/Release/aws-cpp-sdk-cognito-idp.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-core/Release/aws-cpp-sdk-core.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-iam/Release/aws-cpp-sdk-iam.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-kinesis/Release/aws-cpp-sdk-kinesis.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-lambda/Release/aws-cpp-sdk-lambda.lib" -Destination "${THIRD_PARTY_WINDOWS_LOCATION}"

# move the aws source code include/header directories to Source/Public
if(Test-Path -Path $SOURCE_PUBLIC_LOCATION) {
	Remove-Item -LiteralPath $SOURCE_PUBLIC_LOCATION -Force -Recurse
}

mkdir $SOURCE_PUBLIC_LOCATION
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-core/include/aws/core" -Destination "${SOURCE_PUBLIC_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-cognito-idp/include/aws/cognito-idp" -Destination "${SOURCE_PUBLIC_LOCATION}"
Move-Item -Path "./aws-sdk-cpp/aws-cpp-sdk-lambda/include/aws/lambda" -Destination "${SOURCE_PUBLIC_LOCATION}"

# delete the entire aws sdk repo when we're done
Remove-Item -LiteralPath "./aws-sdk-cpp" -Force -Recurse