# Prismon CLI

Proxy HTTPS local para auditar chamadas de ferramentas LLM (desktop, web e CLIs de terminal) com guardrails e observabilidade centralizados.

## Instalação

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/leozanchett/prismon-cli/main/install.sh | sh
```

- Valida o sha256 do release antes de instalar
- Instala em `~/.local/bin` (override: `PRISMON_INSTALL_DIR`)
- Versão específica: `PRISMON_VERSION=0.4.0 sh install.sh`

É o mesmo layout que o auto-update usa, então o CLI passa a se manter atualizado sozinho.

### Windows (Path A — CLIs no terminal)

No PowerShell:

```powershell
irm https://raw.githubusercontent.com/leozanchett/prismon-cli/main/install.ps1 | iex
```

- Valida o sha256 do release antes de instalar
- Instala em `%LOCALAPPDATA%\prismon` e adiciona esse diretório ao PATH do usuário
- Versão específica: `$env:PRISMON_VERSION='0.4.0'; irm ... | iex`

Depois rode `prismon` nesse terminal: ele pede gateway e virtual key, instala a CA no store do usuário (confirme o diálogo do Windows), sobe o proxy como serviço de login e liga o proxy de sistema (WinINET) para desktop e navegador que respeitam o proxy do Windows. Não precisa deixar o terminal aberto. Use `claude`, `codex`, `grok`, `agy` ou `gemini` em qualquer terminal novo. Apps com certificate pinning ou que ignoram o proxy do SO continuam fora.

### Já instalou por Homebrew?

O tap `leozanchett/prismon` foi descontinuado e está congelado numa versão antiga: `brew upgrade prismon` não traz mais atualizações. Instalação por brew também não participa do auto-update — o binário fica no Cellar, que o `prismon update` não substitui, e o CLI recusa a atualização em vez de deixar o terminal numa versão e o serviço em outra.

Para migrar:

```bash
brew uninstall prismon
curl -fsSL https://raw.githubusercontent.com/leozanchett/prismon-cli/main/install.sh | sh
prismon
```

## Uso

```bash
prismon   # primeira execução: configura gateway + key, instala a CA local e os aliases de CLIs
```

No macOS e no Windows o proxy passa a rodar como serviço de login — sobe sozinho a cada login, sem terminal aberto — e o auto-update é ativado. No Windows os CLIs entram pelos wrappers e o desktop/web entra pelo proxy de sistema (WinINET/WinHTTP), quando o app respeita o proxy do SO.

Depois disso, use as ferramentas normalmente (Claude Desktop e navegadores no macOS; Claude Code, grok, codex, agy e gemini no terminal) — o tráfego LLM é interceptado, avaliado pelos guardrails e registrado.

## Comandos

| Comando | Descrição |
|---|---|
| `prismon` | configura o CLI e ativa o serviço em segundo plano e o auto-update |
| `prismon status` | snapshot da sessão ativa (status, capturas, uptime, totais) |
| `prismon matrix` | lista os apps e CLIs de IA homologados |
| `prismon stop` | para o serviço (ele volta no próximo login) |
| `prismon doctor` | diagnóstico do ambiente, com auto-correção de estados degradados |
| `prismon config` | altera a URL do gateway e a virtual key salvas |
| `prismon update` | atualiza para a última versão agora (`--check` apenas verifica) |
| `prismon updater` | controla o auto-update de hora em hora (`install`/`status`/`uninstall`) |
| `prismon service` | controla o serviço em segundo plano (`install`/`start`/`stop`/`status`/`uninstall`) |
| `prismon version` | mostra a versão instalada |
| `prismon help` | mostra o uso |

Código-fonte: privado (monorepo). Este repositório contém apenas os binários publicados e o instalador.
