# learn_infrastucture

Infrastructure-as-Code for **DigitalOcean (DO)** infrastructure, using **OpenTofu** + **Terragrunt**. This repo targets DO only — no other provider (AWS/GCP/Azure...) is supported.

## Stack

- **OpenTofu** (`tofu`) — Terraform runtime
- **Terragrunt** — manages multiple environments/modules, remote state, and dependencies between units
- **Provider**: `digitalocean/digitalocean`
- **Remote state**: DigitalOcean Spaces (S3-compatible), default bucket `learn-infrastructure-dev`, region `sgp1`

## Requirements

- [`tofu`](https://opentofu.org) (tested with v1.12.x)
- [`terragrunt`](https://terragrunt.gruntwork.io) (tested with v1.1.x)
- A DigitalOcean account with:
  - **DO API token** (`DO_TOKEN`) — used to create the provider and manage resources
  - **Spaces access key/secret** (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) — used for the remote state backend (Spaces is S3-compatible)
  - An SSH key already imported into DO, matching `SSH_KEY_NAME`

## Directory structure

```
.
├── terragrunt.hcl              # root config: DO provider + remote state (Spaces)
├── environments/
│   ├── development/
│   │   ├── env.hcl             # per-env variables: region, size...
│   │   ├── vpc/
│   │   └── droplet/
│   └── production/
│       ├── env.hcl
│       ├── vpc/
│       ├── droplet/
│       ├── postgres/
│       ├── valkey/
│       └── volume/
├── modules/                    # reusable OpenTofu modules
│   ├── vpc/                    # digitalocean_vpc
│   ├── droplet/                # digitalocean_droplet + firewall (22/80/8080)
│   ├── postgres/               # digitalocean_database_cluster (engine pg)
│   ├── valkey/                 # digitalocean_database_cluster (engine valkey)
│   └── volume/                 # digitalocean_volume + volume_attachment
├── terraform_example/          # standalone OpenTofu example (not managed via Makefile/Terragrunt)
├── .env.dev / .env.prod        # local secrets, NOT committed (already in .gitignore)
├── .env.dev.example
├── .env.prod.example
└── Makefile                    # wrapper around terragrunt commands
```

Each environment (`development`, `production`) is a set of independent Terragrunt units. Dependencies between units are declared via `dependency` blocks (e.g. `droplet` depends on `vpc`, `volume` depends on `droplet`).

## Available modules

| Module     | Main DO resource                              | Notes |
|------------|------------------------------------------------|-------|
| `vpc`      | `digitalocean_vpc`                              | Private network, default `ip_range` `10.10.0.0/16` |
| `droplet`  | `digitalocean_droplet` + `digitalocean_firewall` | Ubuntu 22.04, opens inbound ports 22/80/8080 |
| `postgres` | `digitalocean_database_cluster` (engine `pg`)   | Managed Postgres, firewall rule scoped to `gitops` tag |
| `valkey`   | `digitalocean_database_cluster` (engine `valkey`) | Managed Valkey (Redis-compatible) |
| `volume`   | `digitalocean_volume` + `digitalocean_volume_attachment` | Block storage attached to a droplet |

## Setup

1. Copy the example env files and fill in real values:
   ```bash
   cp .env.dev.example .env.dev
   cp .env.prod.example .env.prod
   ```
2. Fill in the required variables in `.env.dev` / `.env.prod`:
   ```
   DO_TOKEN=<DigitalOcean API token>
   SSH_KEY_NAME=<name of the SSH key already imported into DO>
   ```
3. Make sure `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (Spaces access key) are set in the environment or env file — used by the remote state backend.
4. Never commit `.env.dev` / `.env.prod` — they are already gitignored; use the `.example` files as templates only.

## Usage (via Makefile)

```bash
make help          # show all available targets
```

### Development

```bash
make dev-init             # init all modules under environments/development
make dev-plan
make dev-apply
make dev-destroy          # requires typing "yes" to confirm
make dev-apply-vpc        # apply the vpc unit only
make dev-apply-droplet    # apply the droplet unit only
```

### Production

```bash
make prod-init
make prod-plan
make prod-apply            # requires typing "yes" to confirm
make prod-destroy          # requires typing "yes" to confirm
make prod-apply-vpc
make prod-apply-droplet
make prod-apply-postgres
make prod-apply-valkey
make prod-apply-volume
```

### Utilities

```bash
make clean          # remove .terragrunt-cache
make fmt            # tofu fmt -recursive
```

> The whole-environment `*-apply`/`*-destroy` targets (as opposed to `-vpc`/`-droplet`/...) run `terragrunt --all`, meaning they apply/destroy **every** unit in that environment at once.

## Remote state

State is stored on DigitalOcean Spaces (S3-compatible), configured in the root `terragrunt.hcl`:

- Endpoint: `https://sgp1.digitaloceanspaces.com`
- Bucket: `STORAGE_BUCKET` env var (default `learn-infrastructure-dev`)
- Key: `<stack>/terraform.tfstate` (stack = unit directory name, e.g. `vpc`, `droplet`)
- Region: `DO_REGION` env var (default `sgp1`)

Change region/bucket by setting `DO_REGION` / `STORAGE_BUCKET` in the relevant `.env.*` file before running any command.

## Safety notes

- `prod-apply`, `prod-destroy`, and `dev-destroy` require manual confirmation (`yes`) — don't bypass this with automated scripts unless you're certain.
- Don't edit state on Spaces directly; always go through `terragrunt`/the Makefile.
- `terraform_example/` is a standalone learning/reference sandbox, **not** part of the main Terragrunt flow and does not share state with `environments/`.
