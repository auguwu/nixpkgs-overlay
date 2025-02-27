{
  pkg-config,
  installShellFiles,
  openssl,
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  version = "4.1.0";
  pname = "ume";

  src = fetchFromGitHub {
    owner = "auguwu";
    repo = "ume";
    rev = version;
    hash = "sha256-wgamzuGILVWjkWhbtbf22JIx2b1cp4VBggQmYpkhPJY=";
  };

  nativeBuildInputs = [pkg-config installShellFiles];
  buildInputs =
    [openssl]
    ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation
      SystemConfiguration
    ]));

  useFetchCargoVendor = true;
  cargoHash = "sha256-R6xiwz/mVkuwMr0qcw9VSYwUj7iOYbSYPKiXHsEpGNE=";

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
