{
  pkg-config,
  installShellFiles,
  openssl,
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}: let
  outputHashes = {
    "azalia-0.1.0" = "sha256-9VE79T2Yry5QhYqD3BoHsq5//4V05CEih1aK2MCXJo0=";
  };
in
  rustPlatform.buildRustPackage rec {
    version = "4.0.5";
    pname = "ume";

    src = fetchFromGitHub {
      owner = "auguwu";
      repo = "ume";
      rev = version;
      hash = "sha256-+D0Th1ysAZeoktpnRFtAvGXHxt5YnGW1Ydr7K5h2hpQ=";
    };

    nativeBuildInputs = [pkg-config installShellFiles];
    buildInputs =
      [openssl]
      ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        CoreFoundation
        SystemConfiguration
      ]));

    cargoLock = {
      inherit outputHashes;
      lockFile = ./Cargo.lock;
    };

    postInstall = ''
      installShellCompletion --cmd ume \
        --bash <($out/bin/ume completions bash) \
        --fish <($out/bin/ume completions fish) \
        --zsh  <($out/bin/ume completions zsh)
    '';

    meta = with lib; {
      description = "Easy, self-hostable, and flexible image host made in Rust";
      homepage = "https://floofy.dev/oss/ume";
      license = with licenses; [asl20];
      maintainers = with maintainers; [auguwu];
      mainProgram = "ume";
      changelog = "https://github.com/auguwu/ume/releases/v${version}";
    };
  }
