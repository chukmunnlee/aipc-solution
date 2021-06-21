# Setup

## Provision a Docker host on DigitalOcean

Use [`docker-machine`](https://github.com/docker/machine/releases) to provision 
a Docker host on DigitalOcean.

Use the following command to provision a Docker host; substitute `**my-token-here**` 
with your [DigitalOcean access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)

```
docker-machine create --driver digitalocean \
	--digitalocean-image ubuntu-20-04-x64 \
	--digitalocean-size s-1vcpu-2gb \
	--digitalocean-region sgp1 \
	--engine-install-url "https://releases.rancher.com/install-docker/19.03.9.sh" \
	--digitalocean-access-token **my-token-here** \
	my-docker
```
