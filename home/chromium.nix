{
  pkgs,
  inputs,
  ...
}: {
  # programs.chromium = {
  #   enable = true;
  #   # Use brave
  #   package = pkgs.brave;
  # };
  # This option isn't in the manual but it exists I guess?
  programs.brave = {
    enable = true;
    extensions = [
      "kcgedkeajhbfkackhppmenimpfpnopje" # 600% Volume
      "ammjkodgmmoknidbanneddgankgfejfh" # 7TV
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
      "ponfpcnoihfmfllpaingbgckeeldkhle" # Enhancer for YouTube
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "ghnomdcacenbmilgjigehppbamfndblo" # The Camelizer
      "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "likgccmbimhjbgkjambclfkhldnlhbnn" # Yomitan
      "nlkaejimjacpillmajjnopmpbkbnocid" # YouTube NonStop
    ];
  };
}
