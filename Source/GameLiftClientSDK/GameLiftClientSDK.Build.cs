using UnrealBuildTool;

public class GameLiftClientSDK : ModuleRules
{
    public GameLiftClientSDK(ReadOnlyTargetRules Target) : base(Target)
    {
        PublicIncludePaths.Add(System.IO.Path.Combine(ModuleDirectory, "Public"));

        PublicDependencyModuleNames.AddRange(
            new string[]
            {
            "Core",
            "Projects"
            }
            );


        PrivateDependencyModuleNames.AddRange(
            new string[]
            {
            }
            );


        DynamicallyLoadedModuleNames.AddRange(
            new string[]
            {
            }
            );

        // This is required to fix a warning for Unreal Engine 4.21 and later
        PrivatePCHHeaderFile = "Private/GameLiftClientSDKPrivatePCH.h";

        bEnableExceptions = true;

        string BaseDirectory = System.IO.Path.GetFullPath(System.IO.Path.Combine(ModuleDirectory, "..", ".."));
        string SDKDirectory = System.IO.Path.Combine(BaseDirectory, "ThirdParty", "GameLiftClientSDK", Target.Platform.ToString());

        bool bHasGameLiftSDK = System.IO.Directory.Exists(SDKDirectory);

        if (bHasGameLiftSDK)
        {
            if (Target.Type == TargetRules.TargetType.Server)
            {
                if (Target.Platform == UnrealTargetPlatform.Linux)
                {
                    /*SDKDirectory = System.IO.Path.Combine(SDKDirectory, "x86_64-unknown-linux-gnu");
                    string SDKLib = System.IO.Path.Combine(SDKDirectory, "libaws-cpp-sdk-gamelift-server.so");

                    //PublicAdditionalLibraries.Add(SDKDirectory);
                    PublicAdditionalLibraries.Add(SDKLib);
                    RuntimeDependencies.Add(SDKLib);*/
                }
                else if (Target.Platform == UnrealTargetPlatform.Win64)
                {
                    //PublicAdditionalLibraries.Add(SDKDirectory);
                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-c-common.lib"));
                    PublicDelayLoadDLLs.Add("aws-c-common.dll");
                    string CommonLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-c-common.dll");
                    RuntimeDependencies.Add(CommonLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-c-event-stream.lib"));
                    PublicDelayLoadDLLs.Add("aws-c-event-stream.dll");
                    string EventStreamLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-c-event-stream.dll");
                    RuntimeDependencies.Add(EventStreamLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-checksums.lib"));
                    PublicDelayLoadDLLs.Add("aws-checksums.dll");
                    string ChecksumsLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-checksums.dll");
                    RuntimeDependencies.Add(ChecksumsLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-cognito-identity.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-cognito-identity.dll");
                    string CognitoIdentityLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-cognito-identity.dll");
                    RuntimeDependencies.Add(CognitoIdentityLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-cognito-idp.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-cognito-idp.dll");
                    string CognitoIdpLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-cognito-idp.dll");
                    RuntimeDependencies.Add(CognitoIdpLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-core.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-core.dll");
                    string CoreLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-core.dll");
                    RuntimeDependencies.Add(CoreLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-iam.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-iam.dll");
                    string IamLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-iam.dll");
                    RuntimeDependencies.Add(IamLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-kinesis.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-kinesis.dll");
                    string KinesisLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-kinesis.dll");
                    RuntimeDependencies.Add(KinesisLibWindows);

                    PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-lambda.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-lambda.dll");
                    string LambdaLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-lambda.dll");
                    RuntimeDependencies.Add(LambdaLibWindows);
                }
            }
        }
    }
}