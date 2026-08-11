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

### Windows

Baixe o `.zip` do [último release](https://github.com/leozanchett/prismon-cli/releases/latest).

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

No macOS o proxy passa a rodar como serviço de login — sobe sozinho a cada login, sem terminal aberto — e o auto-update é ativado: o CLI verifica se há versão nova a cada hora e se atualiza, com rollback automático se a versão nova não subir.

Depois disso, use as ferramentas normalmente (Claude Desktop, Claude Code, ChatGPT, Gemini, grok, codex, agy...) — o tráfego LLM é interceptado, avaliado pelos guardrails e registrado.

## Comandos

| Comando | Descrição |
|---|---|
| `prismon` | configura o CLI e ativa o serviço em segundo plano e o auto-update |
| `prismon status` | snapshot da sessão ativa (status, capturas, uptime, totais) |
| `prismon matrix` | lista os apps e CLIs de IA homologados |
| `prismon stop` | para o serviço (ele volta no próximo login) |
| `prismon doctor` | diagnóstico do ambiente |
| `prismon config` | altera a URL do gateway e a virtual key salvas |
| `prismon update` | atualiza para a última versão agora (`--check` apenas verifica) |
| `prismon updater` | controla o auto-update de hora em hora (`install`/`status`/`uninstall`) |
| `prismon service` | controla o serviço em segundo plano (`install`/`start`/`stop`/`status`/`uninstall`) |
| `prismon version` | mostra a versão instalada |
| `prismon help` | mostra o uso |

Código-fonte: privado (monorepo). Este repositório contém apenas os binários publicados e o instalador.
