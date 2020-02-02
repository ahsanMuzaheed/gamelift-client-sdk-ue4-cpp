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
#pragma once


#include "ModuleManager.h"
#include "DelegateCombinations.h"

#if PLATFORM_WINDOWS
#include "AllowWindowsPlatformTypes.h"
#endif

#if PLATFORM_WINDOWS
#include "HideWindowsPlatformTypes.h"
#endif

class FGameLiftClientSDKModule : public IModuleInterface
{
public:

    /** IModuleInterface implementation */
    virtual void StartupModule() override;
    virtual void ShutdownModule() override;

private:
    /** Handle to the dll we will load */
    static void* GameLiftClientSDKLibraryHandle;
    static bool LoadDependency(const FString& Dir, const FString& Name, void*& Handle);
    static void FreeDependency(void*& Handle);
};
