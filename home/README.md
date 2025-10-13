## Some quirks to watch out for

- nix treats quoted vs raw paths differently
1. raw paths get included in the nix store and evaluated immediately
2. string paths do not get included in the nix store by default and are not evaluated immediately (you might get file/folder not found error with a super long nix store hash)

- args and extraspecialargs
1. For some damn reason, the extraspecialargs in ~/dotfiles/nix (which passes in all inputs and some user/host info) replaces the default `pkgs` input, therefore you must use `nixpkgs` for everything in ./home (everything else should be unchanged `config` and `lib`)
2. HOWEVER, everything in ./features is imported slightly differently (without the import keyword), so I guess it ignores all the extraspecialargs, uses the base method which does forward `pkgs`
3. You MUST explicity pass in the extraspecialargs, they do not get auto forwarded, no matter how deep (only the special ones `lib`, `pkgs`, `config`, nothing else...). You can do this via `import <file> (args // {extrastuffgoeshere});`, you must also name the inputs at the top of the file via `args@{ ... }:`

**ADD MORE AS YOU LEARN**