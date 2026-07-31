# Prismon CLI

Proxy HTTPS local para auditar chamadas de ferramentas LLM (desktop, web e CLIs de terminal) com guardrails e observabilidade centralizados.

## Instalação (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/leozanchett/prismon-cli/main/install.sh | sh
```

- Instala em `~/.local/bin` (override: `PRISMON_INSTALL_DIR`)
- Versão específica: `PRISMON_VERSION=0.1.0 sh install.sh`
- Windows: baixe o `.zip` do [último release](https://github.com/leozanchett/prismon-cli/releases/latest)

## Uso

```bash
prismon   # primeira execução: configura gateway + key, instala a CA local e os aliases de CLIs
```

Depois disso, use as ferramentas normalmente (Claude Desktop, ChatGPT, Gemini, grok, codex, agy...) — o tráfego LLM é interceptado, avaliado pelos guardrails e registrado.

## Comandos

| Comando | Descrição |
|---|---|
| `prismon` | inicia a sessão (proxy local + proxy de sistema no macOS + aliases de CLIs) |
| `prismon config` | altera a URL do gateway e a virtual key salvas |
| `prismon doctor` | diagnóstico do ambiente (sem iniciar sessão) |
| `prismon help` | mostra o uso |

Código-fonte: privado (monorepo). Este repositório contém apenas os binários publicados e o instalador.
