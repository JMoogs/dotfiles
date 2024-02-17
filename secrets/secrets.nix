let
  jeremy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMYJuGhbTfmZe3VMk7Lbqiw8E46Q+8MxWi/7IQNfbBB";
in
{
  "openai_key.age".publicKeys = [ jeremy ];
}
