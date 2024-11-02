resource "hcloud_ssh_key" "mykey" {
  name       = "hetzner_key"
  public_key = file("/root/.ssh/id_rsa.pub")
}