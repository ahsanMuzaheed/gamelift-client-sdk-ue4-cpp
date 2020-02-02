using UnrealBuildTool;

public class GameLiftClientSDK : ModuleRules
{
    public GameLiftClientSDK(ReadOnlyTargetRules Target) : base(Target)
    {
        PublicIncludePaths.Add(System.IO.Path.Combine(ModuleDirectory, "Public"));
        PrivateIncludePaths.Add(System.IO.Path.Combine(ModuleDirectory, "Private"));

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
                    /*PublicAdditionalLibraries.Add(System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-gamelift-server.lib"));
                    PublicDelayLoadDLLs.Add("aws-cpp-sdk-gamelift-server.dll");
                    string SDKLibWindows = System.IO.Path.Combine(SDKDirectory, "aws-cpp-sdk-gamelift-server.dll");
                    RuntimeDependencies.Add(SDKLibWindows);*/
                }
            }
        }
    }
}