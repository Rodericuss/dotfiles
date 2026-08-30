# Rodrigo's Arch / Hyprland dotfiles

Configuração portátil do meu desktop Arch Linux + Hyprland. O conteúdo foi
portado da instalação atual, mas referências ao usuário `/home/amitis`, aos
monitores atuais e a estado de sessão foram removidas.

## Instalação

```bash
git clone <URL-DESTE-REPO> ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

O instalador:

- atualiza o sistema e instala os pacotes oficiais de `packages/arch.txt`;
- instala `vial-appimage` se `yay` ou `paru` estiver disponível;
- faz backup de cada arquivo que será substituído em
  `~/.local/state/dotfiles-backups/`;
- copia as configurações e scripts para os caminhos usados pelo Hyprland;
- instala dois wallpapers em `~/.local/share/wallpapers`;
- configura o áudio do PipeWire quando já existe uma sessão de usuário.

Para apenas instalar as configurações em uma máquina que já tem os pacotes:

```bash
./install.sh --no-packages
```

## Componentes

- `config/hypr`: Hyprland, Hyprpaper, modo normal/foco e controle de volume;
- `config/waybar`: barra, módulos, scripts de brilho e player;
- `config/rofi`: launcher, clipboard, power menu, screenshot e wallpapers;
- `config/kitty`: terminal e tema CYBR;
- `config/nvim`: configuração completa e `lazy-lock.json`;
- Firefox/Sidebery: mantidos separadamente no repositório original `cybr-firefox`;
- `config/herdr.toml`: somente preferências do Herdr, sem sessão ou logs;
- `fonts/GeistMono`: quatro faces Nerd Font usadas pelo tema;
- `bin`: clipboard, screenshot, scratchpad, gravação e troca de wallpaper;
- `keyboard`: export do layout Vial e overlay do firmware customizado do Lily58.

## Pós-instalação

1. Entre novamente na sessão Hyprland ou execute `hyprctl reload`.
2. Confira os nomes dos monitores com `hyprctl monitors`; a configuração usa um
   fallback portátil. Se quiser posições fixas, adicione regras em `hyprland.conf`.
3. Instale e configure o Firefox/Sidebery usando o repositório original
   `cybr-firefox`.
4. Abra o Vial e importe `~/Documents/Keyboard/layout.vil`. O overlay do firmware
   não é aplicado automaticamente: veja `keyboard/README.md`.
5. O Neovim instala/atualiza plugins na primeira abertura; execute `:checkhealth`
   depois.

## Decisões de portabilidade

O wallpaper inicial é escolhido por `dotfiles-wallpaper-init` depois que os
monitores reais são descobertos. O atalho F7 alterna arquivos copiados em
`~/.config/hypr`, portanto não consegue sobrescrever este repositório. O
Hyprpanel não foi incluído: a sessão usa o Waybar solicitado.

## Ainda não versionado de propósito

Cookies, perfis completos do Firefox, histórico do clipboard, tokens do GitHub,
sessões do Herdr, binários de aplicativos, caches, serviços pessoais, Android
SDK, credenciais e o acervo inteiro de wallpapers ficaram fora. Se quiser
adicionar outro wallpaper, coloque-o em `wallpapers/` e rode o instalador novamente.
