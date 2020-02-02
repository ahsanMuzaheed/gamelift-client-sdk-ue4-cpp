// AMAZON CONFIDENTIAL

/*
* All or portions of this file Copyright (c) Amazon.com, Inc. or its affiliates or
* its licensors.
*
* For complete copyright and license terms please see the LICENSE at the root of this
* distribution (the "License"). All use of this software is governed by the License,
* or, if provided, by the license below or the license accompanying this file. Do not
* remove or modify any license notices. This file is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
*/
#include "GameLiftClientSDKPrivatePCH.h"
#include "Core.h"
#include "ModuleManager.h"
#include "IPluginManager.h"

#define LOCTEXT_NAMESPACE "FGameLiftClientSDKModule"

void* FGameLiftClientSDKModule::GameLiftClientSDKLibraryHandle = nullptr;

void FGameLiftClientSDKModule::StartupModule()
{
#if PLATFORM_WINDOWS
    #if PLATFORM_64BITS
        FString BaseDir = IPluginManager::Get().FindPlugin("GameLiftClientSDK")->GetBaseDir();
        const FString SDKDir = FPaths::Combine(*BaseDir, TEXT("ThirdParty"), TEXT("GameLiftClientSDK"));
        const FString LibDir = FPaths::Combine(*SDKDir, TEXT("Win64"));

        const FString CommonLibName = TEXT("aws-c-common");
        if (!LoadDependency(LibDir, CommonLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-c-common library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString EventStreamLibName = TEXT("aws-c-event-stream");
        if (!LoadDependency(LibDir, EventStreamLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-c-event-stream library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString ChecksumsLibName = TEXT("aws-checksums");
        if (!LoadDependency(LibDir, ChecksumsLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-checksums library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString CognitoIdentityLibName = TEXT("aws-cpp-sdk-cognito-identity");
        if (!LoadDependency(LibDir, CognitoIdentityLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-cognito-identity library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString CognitoIdpLibName = TEXT("aws-cpp-sdk-cognito-idp");
        if (!LoadDependency(LibDir, CognitoIdpLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-cognito-idp library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString CoreLibName = TEXT("aws-cpp-sdk-core");
        if (!LoadDependency(LibDir, CoreLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-core library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString IamLibName = TEXT("aws-cpp-sdk-iam");
        if (!LoadDependency(LibDir, IamLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-iam library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString KinesisLibName = TEXT("aws-cpp-sdk-kinesis");
        if (!LoadDependency(LibDir, KinesisLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-kinesis library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }

        const FString LambdaLibName = TEXT("aws-cpp-sdk-lambda");
        if (!LoadDependency(LibDir, LambdaLibName, GameLiftClientSDKLibraryHandle))
        {
            FMessageDialog::Open(EAppMsgType::Ok, LOCTEXT(LOCTEXT_NAMESPACE, "Failed to aws-cpp-sdk-lambda library. Plug-in will not be functional."));
            FreeDependency(GameLiftClientSDKLibraryHandle);
        }
    #endif
#endif
}

bool FGameLiftClientSDKModule::LoadDependency(const FString& Dir, const FString& Name, void*& Handle)
{
    FString Lib = Name + TEXT(".") + FPlatformProcess::GetModuleExtension();
    FString Path = Dir.IsEmpty() ? *Lib : FPaths::Combine(*Dir, *Lib);

    Handle = FPlatformProcess::GetDllHandle(*Path);

    if (Handle == nullptr)
    {
        return false;
    }

    return true;
}

void FGameLiftClientSDKModule::FreeDependency(void*& Handle)
{
#if !PLATFORM_LINUX
    if (Handle != nullptr)
    {
        FPlatformProcess::FreeDllHandle(Handle);
        Handle = nullptr;
    }
#endif
}

void FGameLiftClientSDKModule::ShutdownModule()
{
    FreeDependency(GameLiftClientSDKLibraryHandle);
}

#undef LOCTEXT_NAMESPACE

IMPLEMENT_MODULE(FGameLiftClientSDKModule, GameLiftClientSDK)
