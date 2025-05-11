{
  pkg-config,
  installShellFiles,
  openssl,
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  withSystemNotifications ? true, # enables system notifications for `ume screenshot`
  withSystemdSupport ? true, # enables systemd support for `ume server` (Linux only)
}:
rustPlatform.buildRustPackage rec {
  version = "4.2.0";
  pname = "ume";

  src = fetchFromGitHub {
    owner = "auguwu";
    repo = "ume";
    rev = version;
    hash = "sha256-Yf7Y/+OndvphJFvu26aIfS2exsdjAHHs7S4WxkqMz8Y=";
  };

  buildNoDefaultFeatures = true;
  buildFeatures =
    []
    ++ lib.optional withSystemNotifications ["os-notifier"]
    ++ (lib.optional (stdenv.isLinux && withSystemdSupport) ["libsystemd"]);

  nativeBuildInputs = [pkg-config installShellFiles];
  buildInputs =
    [openssl]
    ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks;
      [
        CoreFoundation
        SystemConfiguration
      ]
      ++ lib.optional withSystemNotifications [
        Cocoa
        CoreServices
      ]));

  useFetchCargoVendor = true;
  cargoHash = "sha256-nkxn8iI5Yzi4Zqk7FUHa84FDKIMqdd/ujK5AXb/LwDc=";

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
