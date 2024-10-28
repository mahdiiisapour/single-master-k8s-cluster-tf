resource "hcloud_ssh_key" "mykey" {
  name       = "hetzner_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}