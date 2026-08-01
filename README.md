# Dotfiles multipiattaforma

Configurazioni personali condivise tra macOS, Linux e Windows.

Il repository mantiene sotto controllo versione le configurazioni di shell, Git,
[Starship](https://starship.rs/) e [WezTerm](https://wezterm.org/). Gli script di
bootstrap salvano eventuali configurazioni esistenti e creano collegamenti
simbolici verso i file del repository: modificare un dotfile attivo equivale
quindi a modificare il file versionato.

## Contenuto

```text
.
├── home/                       # Configurazioni condivise
│   ├── .config/
│   │   ├── starship.toml
│   │   └── wezterm/wezterm.lua
│   ├── .gitconfig
│   ├── .zprofile
│   └── .zshrc
├── packages/
│   └── Brewfile               # Pacchetti e applicazioni macOS
├── platform/
│   ├── linux/.zshrc
│   ├── macos/.zshrc
│   └── windows/Microsoft.PowerShell_profile.ps1
└── scripts/
    ├── bootstrap.sh           # macOS e Linux
    └── bootstrap.ps1          # Windows
```

## Prima dell'installazione

Gli script non eliminano i dotfile esistenti: li spostano in una sottocartella
con data e ora dentro:

```text
~/.dotfiles-backup/
```

Eseguire sempre prima la modalità di anteprima. Il repository non deve contenere
password, token, chiavi SSH, file `.env` o altre credenziali.

## Setup su macOS

### Requisiti

- Git e gli strumenti da riga di comando di Xcode;
- Homebrew;
- una connessione a Internet per installare i pacchetti mancanti.

Su un Mac nuovo, installare gli strumenti Apple:

```bash
xcode-select --install
```

Installare Homebrew, se non è già presente, seguendo le istruzioni del
[sito ufficiale](https://brew.sh/).

### Installazione

Clonare il repository in `~/Projects/dotfiles`:

```bash
mkdir -p ~/Projects
git clone URL_REPOSITORY ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

Installare applicazioni, strumenti e font dichiarati nel `Brewfile`:

```bash
brew bundle check --file=packages/Brewfile || \
  brew bundle install --file=packages/Brewfile
```

Controllare ciò che farà il bootstrap:

```bash
./scripts/bootstrap.sh --dry-run
```

Se l'anteprima è corretta, applicare la configurazione:

```bash
./scripts/bootstrap.sh
exec zsh -l
```

Lo script crea anche `~/.dotfiles`, un collegamento al repository clonato. Le
configurazioni attivate sono:

- `~/.zshrc` e `~/.zprofile`;
- `~/.gitconfig`;
- `~/.config/starship.toml`;
- `~/.config/wezterm`.

La configurazione macOS seleziona Java 21 tramite `/usr/libexec/java_home`. Se
Java 21 non è installato, quella parte viene ignorata senza bloccare la shell.

### Verifica

```bash
brew --version
java -version
echo "$JAVA_HOME"
starship --version
ls -l ~/.zshrc ~/.zprofile ~/.gitconfig ~/.config/starship.toml ~/.config/wezterm
```

## Setup su Linux

### Requisiti

Installare almeno Git, zsh, WezTerm, Starship e JetBrains Mono Nerd Font. Java è
opzionale; quando `javac` è disponibile, la configurazione ricava automaticamente
`JAVA_HOME`.

Esempio per distribuzioni Debian/Ubuntu:

```bash
sudo apt update
sudo apt install git zsh
```

Installare WezTerm, Starship e il font usando le istruzioni ufficiali appropriate
per la propria distribuzione.

### Installazione

```bash
mkdir -p ~/Projects
git clone URL_REPOSITORY ~/Projects/dotfiles
cd ~/Projects/dotfiles
./scripts/bootstrap.sh --dry-run
./scripts/bootstrap.sh
```

Impostare zsh come shell predefinita:

```bash
chsh -s "$(command -v zsh)"
```

Terminare e riaprire la sessione, oppure eseguire:

```bash
exec zsh -l
```

La configurazione Linux aggiunge inoltre `open` come alias di `xdg-open`, quando
quest'ultimo è disponibile.

### Verifica

```bash
echo "$SHELL"
echo "$JAVA_HOME"
starship --version
ls -l ~/.zshrc ~/.zprofile ~/.gitconfig ~/.config/starship.toml ~/.config/wezterm
```

## Setup su Windows

### Requisiti

- Git;
- PowerShell 7 (`pwsh`);
- WezTerm;
- Starship;
- JetBrains Mono Nerd Font.

Abilitare inoltre:

```text
Impostazioni → Sistema → Per sviluppatori → Modalità sviluppatore
```

La Modalità sviluppatore permette allo script di creare collegamenti simbolici
senza avviare PowerShell come amministratore.

### Installazione

Da PowerShell 7:

```powershell
New-Item -ItemType Directory -Path "$HOME\Projects" -Force | Out-Null
git clone URL_REPOSITORY "$HOME\Projects\dotfiles"
Set-Location "$HOME\Projects\dotfiles"
```

Eseguire prima l'anteprima:

```powershell
.\scripts\bootstrap.ps1 -DryRun
```

Poi applicare la configurazione:

```powershell
.\scripts\bootstrap.ps1
```

Chiudere e riaprire WezTerm. Lo script collega:

- `%USERPROFILE%\.gitconfig`;
- `%USERPROFILE%\.config\starship.toml`;
- `%USERPROFILE%\.config\wezterm`;
- il profilo PowerShell dell'utente corrente.

WezTerm usa automaticamente PowerShell 7 con l'opzione `-NoLogo` su Windows.

Se PowerShell impedisce temporaneamente l'esecuzione dello script, avviare una
sola volta il bootstrap con:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1 -DryRun
pwsh -NoProfile -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1
```

### Verifica

```powershell
pwsh --version
starship --version
Get-Item "$HOME\.gitconfig"
Get-Item "$HOME\.config\starship.toml"
Get-Item "$HOME\.config\wezterm"
```

## Uso di WezTerm

La configurazione usa:

- tema **Catppuccin Mocha**;
- font **JetBrains Mono Nerd Font**, dimensione 14;
- sfondo leggermente trasparente;
- barra delle schede nascosta quando esiste una sola scheda;
- PowerShell 7 su Windows e la shell predefinita su macOS/Linux.

### Pannelli e scorciatoie

| Operazione | macOS | Windows/Linux |
|---|---|---|
| Dividere orizzontalmente | `⌘ D` | `Ctrl Shift D` |
| Dividere verticalmente | `⌘ Shift D` | `Ctrl Shift E` |
| Chiudere il pannello attivo | `⌘ W` | `Ctrl Shift W` |

Il nuovo pannello eredita la stessa directory di lavoro e lo stesso dominio del
pannello corrente. La chiusura richiede conferma; se è rimasto un solo pannello,
l'operazione chiude la relativa scheda.

Le normali scorciatoie non ridefinite da questo repository continuano a essere
gestite dalle impostazioni predefinite di WezTerm.

## Comandi della shell

Su macOS e Linux:

| Comando | Effetto |
|---|---|
| `ll` | Elenca anche i file nascosti con dettagli leggibili |
| `gs` | Esegue `git status` |
| `gl` | Mostra il log Git compatto e ad albero |
| `c` | Pulisce il terminale |

Su Windows PowerShell sono disponibili `ll`, `gs` e `gl` con comportamento
equivalente.

## Configurazioni locali e segreti

Su macOS e Linux è possibile aggiungere impostazioni non versionate in:

```text
~/.zshrc.local
~/.zprofile.local
```

Questi file sono caricati automaticamente e ignorati da Git. Sono adatti a
percorsi specifici di una macchina e variabili non condivisibili. I segreti
dovrebbero comunque essere conservati in Bitwarden o in un sistema dedicato,
non in questo repository.

## Aggiornare le configurazioni

I file attivi sono collegamenti simbolici, quindi possono essere modificati sia
dal repository sia dalla loro posizione abituale. Per pubblicare una modifica:

```bash
cd ~/Projects/dotfiles
git status
git add .
git commit -m "Descrizione della modifica"
git push
```

Per aggiornare un altro computer:

```bash
cd ~/Projects/dotfiles
git pull
```

Normalmente non è necessario rilanciare il bootstrap dopo un `git pull`: i
collegamenti puntano già ai file del repository. Va rilanciato quando viene
aggiunto un nuovo file da collegare.

## Ripristinare un file precedente

Ogni esecuzione che incontra file preesistenti li sposta sotto una cartella come:

```text
~/.dotfiles-backup/20260801-120000/
```

Per ripristinare manualmente un file, rimuovere prima il relativo collegamento e
ricopiare il file desiderato dal backup. Controllare sempre il percorso prima di
eseguire questa operazione.
