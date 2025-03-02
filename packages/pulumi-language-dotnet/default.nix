{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  # While `pulumi-language-dotnet`'s .NET version is .NET Core 6 or higher,
  # we should probably test on the latest version of .NET Core.
  dotnet-sdk_9,
}:
buildGo124Module rec {
  pname = "pulumi-language-dotnet";
  version = "3.75.2";

  sourceRoot = "${src.name}/${pname}";
  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-dotnet";
    tag = "v${version}";
    hash = "sha256-rPzYmA7Sq5XDOdH4drgPtJXAMai+RQLEQmEup21NfIg=";
  };

  nativeBuildInputs = [
    # while not required since `pulumi-language-dotnet` doesn't depend on any
    # .NET dependencies (since it is a Go package), it is here so that this
    # can be fixed:
    #
    # pulumi-language-dotnet> /nix/store/7jrcg162q2czbcnfzmpppnz13l9ig60m-dotnet-sdk-wrapped-9.0.200/nix-support/setup-hook: line 95: dotnet: command not found
    # error: builder for '/nix/store/j8014yicd08raf23g7q5wcanfs7r07mp-pulumi-language-dotnet-3.75.2.drv' failed with exit code 127;
    #        last 7 log lines:
    #        > Running phase: unpackPhase
    #        > unpacking source archive /nix/store/xq45qc468ybwjd3907n5jghmh1i0gphp-source
    #        > source root is source/pulumi-language-dotnet
    #        > Running phase: patchPhase
    #        > Running phase: updateAutotoolsGnuConfigScriptsPhase
    #        > Running phase: configureNuget
    #        > /nix/store/7jrcg162q2czbcnfzmpppnz13l9ig60m-dotnet-sdk-wrapped-9.0.200/nix-support/setup-hook: line 95: dotnet: command not found
    dotnet-sdk_9
  ];

  checkInputs = [
    # `dotnet` executable is required for tests
    dotnet-sdk_9
  ];

  checkFlags = [
    # skipping `TestLanguage` requires `pulumi` in source and
    # I don't think it is necessary and other Pulumi language
    # hosts disable it anyway, so it's ok.
    "-skip=TestLanguage"
  ];

  vendorHash = "sha256-8nnliPiQ2bYaWk7ikj6eYkm88lDQZBnxy6GH0IgE/Z4=";
  ldflags = ["-s" "-w" "-X=github.com/pulumi/pulumi-dotnet/pulumi-language-dotnet/version.Version=${version}"];

  meta = with lib; {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/dotnet/";
    description = "Language host for Pulumi programs written in .NET Core";
    licenses = with licenses; [asl20];
    mainProgram = pname;
    maintainers = with maintainers; [auguwu];
  };
}
