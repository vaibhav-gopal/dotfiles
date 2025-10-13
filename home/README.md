## Some quirks to watch out for

- nix treats quoted vs raw paths differently
1. raw paths get included in the nix store and evaluated immediately
2. string paths do not get included in the nix store by default and are not evaluated immediately (you might get file/folder not found error with a super long nix store hash)

- args and extraspecialargs
1. You MUST explicity pass `lib`, `pkgs`, `config` by naming them in the inputs
2. You MUST explicity pass in the extraspecialargs. You can do this via `import <file> (args // {extrastuffgoeshere});`, you must also name the inputs at the top of the file via `args@{ ... }:`

**ADD MORE AS YOU LEARN**