# 🚀 Guia de Migração — Sulmak Locações para MySQL + Railway

## Estrutura do projeto

```
sulmak-backend/
├── public/
│   └── index.html      ← frontend (o sistema que você já usa)
├── server.js           ← backend Node.js + API REST
├── schema.sql          ← cria as tabelas no banco
├── package.json        ← dependências do Node.js
├── .env.example        ← modelo das variáveis de ambiente
└── .gitignore          ← ignora node_modules e .env
```

---

## FASE 1 — Instalar ferramentas no seu computador

### 1.1 — Instalar Node.js
1. Acesse https://nodejs.org
2. Baixe a versão **LTS** (botão verde)
3. Execute o instalador e clique em "Next" em tudo
4. Para verificar, abra o **Prompt de Comando** (Windows) ou **Terminal** (Mac) e digite:
   ```
   node --version
   ```
   Deve aparecer algo como `v20.x.x`

### 1.2 — Instalar Git
1. Acesse https://git-scm.com
2. Baixe e instale com as opções padrão
3. Verifique:
   ```
   git --version
   ```

---

## FASE 2 — Criar o repositório no GitHub

1. Acesse https://github.com e crie uma conta (se não tiver)
2. Clique em **"New repository"** (botão verde)
3. Nome: `sulmak-backend`
4. Marque **Private** (privado — seus dados são sigilosos!)
5. Clique em **"Create repository"**
6. Copie a URL do repositório (ex: `https://github.com/seuusuario/sulmak-backend.git`)

### 2.1 — Enviar os arquivos para o GitHub

Abra o **Prompt de Comando** na pasta onde você vai colocar o projeto:

```bash
# Navegue até onde quer salvar o projeto
cd C:\Users\SeuNome\Documents

# Clone o repositório vazio que você criou
git clone https://github.com/seuusuario/sulmak-backend.git

# Entre na pasta
cd sulmak-backend
```

Agora **copie todos os arquivos** desta pasta (package.json, server.js, schema.sql, .env.example, .gitignore, e a pasta public/) para dentro da pasta `sulmak-backend` que foi criada.

```bash
# Adicione todos os arquivos
git add .

# Faça o primeiro commit
git commit -m "Primeiro commit — Sulmak backend"

# Envie para o GitHub
git push origin main
```

✅ Pronto! Seus arquivos já estão no GitHub.

---

## FASE 3 — Criar o banco de dados no Railway

1. Acesse https://railway.app e crie uma conta (pode usar o GitHub para entrar)
2. Clique em **"New Project"**
3. Escolha **"Provision MySQL"**
4. O Railway vai criar um banco MySQL automaticamente — aguarde ~30 segundos
5. Clique no serviço MySQL que apareceu
6. Vá na aba **"Variables"** e copie os valores de:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
   - `MYSQLDATABASE`

### 3.1 — Criar as tabelas no banco

Você vai precisar de um cliente MySQL para rodar o `schema.sql`.
A opção mais fácil é usar o **TablePlus** (gratuito):

1. Baixe em https://tableplus.com
2. Crie uma nova conexão MySQL com os dados copiados do Railway
3. Conecte e abra o arquivo `schema.sql`
4. Clique em **"Run"** (▶️)
5. Deve aparecer: `Schema criado com sucesso!`

---

## FASE 4 — Deploy do backend no Railway

1. No Railway, clique em **"New"** → **"GitHub Repo"**
2. Autorize o Railway a acessar seu GitHub
3. Selecione o repositório `sulmak-backend`
4. O Railway vai detectar o Node.js automaticamente

### 4.1 — Configurar as variáveis de ambiente

No serviço do seu backend no Railway:
1. Vá na aba **"Variables"**
2. Adicione as seguintes variáveis (uma por vez):

| Variável      | Valor                          |
|---------------|--------------------------------|
| `DB_HOST`     | (valor de MYSQLHOST)           |
| `DB_PORT`     | (valor de MYSQLPORT)           |
| `DB_USER`     | (valor de MYSQLUSER)           |
| `DB_PASSWORD` | (valor de MYSQLPASSWORD)       |
| `DB_NAME`     | (valor de MYSQLDATABASE)       |
| `API_SECRET`  | qualquer string longa e aleatória |

3. Clique em **"Deploy"**
4. Aguarde o deploy terminar (ícone verde = sucesso)

### 4.2 — Pegar a URL do seu sistema

1. No serviço do backend, vá na aba **"Settings"**
2. Na seção **"Networking"**, clique em **"Generate Domain"**
3. Vai aparecer uma URL como `sulmak-backend-production.up.railway.app`
4. Abra essa URL no navegador — seu sistema vai carregar!

---

## FASE 5 — Atualizações futuras

Quando quiser atualizar o sistema:

```bash
# Na pasta do projeto
git add .
git commit -m "Descrição do que mudou"
git push origin main
```

O Railway detecta o push automaticamente e faz o deploy sozinho em ~1 minuto.

---

## Dúvidas comuns

**O sistema carregou mas está vazio?**
→ Normal! É um banco novo. Vá em "Sincronizar" para confirmar a conexão.

**Erro "Cannot connect to MySQL"?**
→ Verifique se as variáveis DB_HOST, DB_USER, DB_PASSWORD estão corretas no Railway.

**Como migrar dados do Google Sheets?**
→ Use a aba Configurações → "Sincronizar" após o deploy. Os dados novos serão salvos direto no MySQL.

**Preciso pagar pelo Railway?**
→ O plano gratuito tem 500 horas/mês. Para uso contínuo, o plano Hobby custa ~$5/mês.
