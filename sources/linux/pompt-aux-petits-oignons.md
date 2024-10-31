# Un prompt aux petits oignons

## Installation

Installation de [Oh My Zsh](https://ohmyz.sh), [Powerlevel10k](https://github.com/romkatv/powerlevel10k), et de quelques plugins :

```{literalinclude} snippets/pompt-aux-petits-oignons.sh
:lines: 2-
:language: shell
```

## Configuration

Ajouter ces lignes au fichier `$HOME/.zshrc` :

```{code-block} shell
:caption: ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME='powerlevel10k/powerlevel10k'
CASE_SENSITIVE='true'
zstyle ':omz:update' mode disabled
ENABLE_CORRECTION='true'
COMPLETION_WAITING_DOTS='true'
DISABLE_UNTRACKED_FILES_DIRTY='true'
HIST_STAMPS='yyyy-mm-dd'
plugins=( git zsh-syntax-highlighting zsh-autosuggestions )

source $ZSH/oh-my-zsh.sh
source $HOME/.profile
```

Télécharger et installer les 4 polices d’écriture : [MesloLGS NF](https://github.com/romkatv/powerlevel10k#manual-font-installation).
Penser à configurer le terminal pour utiliser cette fonte.

Relancer le shell :

```{code-block} shell
exec $SHELL
```

Le configurateur de Powerlevel10k devrait se lancer, ensuite, c’est terminé.

Pour information, le contenu final du fichier `$HOME/.zshrc` serait quelque chose comme :

```{code-block} shell
:caption: ~/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME='powerlevel10k/powerlevel10k'
CASE_SENSITIVE='true'
zstyle ':omz:update' mode disabled
ENABLE_CORRECTION='true'
COMPLETION_WAITING_DOTS='true'
DISABLE_UNTRACKED_FILES_DIRTY='true'
HIST_STAMPS='yyyy-mm-dd'
plugins=( git zsh-syntax-highlighting zsh-autosuggestions )

source $ZSH/oh-my-zsh.sh
source $HOME/.profile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

Dernières touches, j’ai modifié ces options dans `$HOME/.p10k.zsh` :

```{code-block} shell
:caption: ~/.p10k.zsh

# Python - pyenv
typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=true

# Python - virtualenv
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=true
typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🐍'
```

## Aperçu

```{figure} images/zsh-omz-powerlevel10k.png
:align: center
```

---

## 📜 Historique

2024-01-27
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2023/11/26/11/00/16-un-prompt-aux-petits-oignons).

2023-11-26
: Premier jet.
