# ops — IcFalcon tooling

All CLI scripts, templates, and docs live here. Root stays clean.

```
ops/
├── falcon                 # global CLI entry (install via install.sh)
├── install.sh          # link falcon to ~/.local/bin
├── falcon.yaml            # moved from root — command config
├── make-feature.sh     # falcon m:f <Name>
├── pkg-add.sh          # falcon add pkg <name>
├── pkg-list.sh         # falcon p:list
├── pkg-installed.sh    # falcon p:ls
├── pkg-push.sh         # falcon p:push <name>
├── scripts/
│   ├── canister-call.sh
│   └── setup-init.sh
├── templates/          # scaffolds (was boilerplate/)
│   ├── feature/        # falcon m:f templates
│   └── command.example.sh
└── docs/
    └── commands.md     # full falcon command reference
```

## Root layout (clean)

```
IcFalcon/
├── backend/            # Motoko canister
├── frontend/           # Next.js app
├── .agents/            # AI skills
├── ops/                # this folder
├── falcon.yaml            # CLI config
├── AGENTS.md
└── README.md
```

`hub/` is gitignored — separate repo at github.com/prasangapokharel/icp-hub
