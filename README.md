# nix-palworld
Palworld server for NixOS.

## Installation
1. Add `nix-palworld` to your `flake.nix`:
   ```nix
   {
     inputs.nix-palworld = {
       inputs.nixpkgs.follows = "nixpkgs";
       url = "github.com:jackwilsdon/nix-palworld";
     };
   }
   ```
2. Add the `nix-palworld` NixOS module to your configuration:
   ```nix
   {
     outputs = { nix-palworld, ... }: {
       nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
         modules = [
           nix-palworld.nixosModules.default
         ];
       };
     };
   }
   ```
3. Enable the `palworld-server` service:
   ```nix
   {
     services.palworld-server = {
       enable = true;
       dataDir = "/path/to/data";
     };
   }
   ```

## Configuration
The following options are exposed under `services.palworld-server`:

### `enable` (boolean)
Whether to enable the Palworld server. Default `false`.

### `package` (package)
The package to use.

### `dataDir` (string)
The directory to store Palworld data in.

### `port` (integer)
Port to listen on. Default `8211`.

### `openFirewall` (boolean)
Open the configured port in the firewall. Default `false`.

### `user` (string)
User to run Palworld under. Default `palworld`.

### `group` (string)
Group to run Palworld under. Default `palworld`.
