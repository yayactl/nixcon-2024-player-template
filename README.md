# NixCon 2024 - NixOS on garnix: Production-grade hosting as a game

This is a template repo for participating in the game. To play you need to:

- Fork this repo on github.
- Get a garnix account [here](https://garnix.io).
- Enable garnix for the forked repo [here](https://github.com/apps/garnix-ci).
- Push a commit to the `main` branch to trigger a deployment.

## Your game objective

Your mission (if you choose to accept it) is to implement a server that conforms to [this API spec](./spec.md).
Once you deploy a server from this template, it should automatically register as a player server with our game-server.
Our game-server will regularly run checks against all registered servers.
You can see the check results -- including error messages -- [here](https://game-server.main.nixcon-2024-game-server.garnix-io.garnix.me/).
This site also lists every players current score and a leaderboard.

(Hint: You get points every time the server runs a successful check against your player server. And these points accumulate. Choose your strategy accordingly.)

Our game-server: https://game-server.main.nixcon-2024-game-server.garnix-io.garnix.me/

## Viewing your server requests and responses in logs

To ensure your server is responding correctly, you can monitor its logs.

First, you'll need SSH access to the server. To enable this, define your SSH public key using the `playerConfig` module with the `sshKey` option.

After committing changes to the main branch, the Garnix app will automatically trigger a deployment.
You can track the deployment status by visiting [the servers page in Garnix](https://garnix.io/servers).
Your server's domain, as well as both its IPv4 and IPv6 addresses, will be displayed in the deployment logs.

Once you have sshed into the server, you can check incoming requests and responses by running the following command:

```sh
tail /var/log/nginx/access.log
```
