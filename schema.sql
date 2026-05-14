-- ══════════════════════════════════════════════════════
--  Sulmak Locações — Schema do Banco de Dados MySQL
--  Execute este arquivo UMA VEZ para criar as tabelas
-- ══════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS sulmak CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sulmak;

-- ── FUNCIONÁRIOS ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS funcionarios (
  id                  VARCHAR(36)    NOT NULL PRIMARY KEY,
  nome                VARCHAR(150)   NOT NULL,
  cpf                 VARCHAR(20)    DEFAULT '',
  cargo               VARCHAR(100)   DEFAULT '',
  salario             DECIMAL(10,2)  DEFAULT 0,
  insalubridade       DECIMAL(10,2)  DEFAULT 0,
  adicionalSalario    DECIMAL(10,2)  DEFAULT 0,
  ats                 DECIMAL(10,2)  DEFAULT 0,
  salarioFamilia      DECIMAL(10,2)  DEFAULT 0,
  auxilioCreche       DECIMAL(10,2)  DEFAULT 0,
  auxilioCombustivel  DECIMAL(10,2)  DEFAULT 0,
  dataAdmissao        DATE           DEFAULT NULL,
  dataDemissao        DATE           DEFAULT NULL,
  dataNascimento      DATE           DEFAULT NULL,
  email               VARCHAR(150)   DEFAULT '',
  telefone            VARCHAR(30)    DEFAULT '',
  banco               VARCHAR(80)    DEFAULT '',
  agencia             VARCHAR(20)    DEFAULT '',
  conta               VARCHAR(30)    DEFAULT '',
  obs                 TEXT           DEFAULT '',
  criadoEm           DATETIME       DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm       DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ── LANÇAMENTOS ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lancamentos (
  id               VARCHAR(36)   NOT NULL PRIMARY KEY,
  funcionarioId    VARCHAR(36)   NOT NULL,
  funcionarioNome  VARCHAR(150)  DEFAULT '',
  mes              VARCHAR(7)    NOT NULL COMMENT 'Formato YYYY-MM',
  competencia      VARCHAR(7)    NOT NULL COMMENT 'Formato YYYY-MM',
  dataLancamento   DATE          DEFAULT NULL,
  categoria        VARCHAR(20)   DEFAULT '',
  tipo             VARCHAR(60)   NOT NULL,
  valor            DECIMAL(10,2) DEFAULT 0,
  qtdHoras         VARCHAR(10)   DEFAULT '',
  valorHora        DECIMAL(10,2) DEFAULT 0,
  diasVR           VARCHAR(10)   DEFAULT '',
  valorDiaVR       DECIMAL(10,2) DEFAULT 0,
  totalVR          DECIMAL(10,2) DEFAULT 0,
  totalEmprestimo  DECIMAL(10,2) DEFAULT 0,
  totalParcelas    VARCHAR(10)   DEFAULT '',
  grupoId          VARCHAR(36)   DEFAULT '',
  parcelaAtual     INT           DEFAULT 1,
  obs              TEXT          DEFAULT '',
  qtdFaltas        VARCHAR(10)   DEFAULT '',
  baseCalcVT       VARCHAR(20)   DEFAULT '',
  unidade          VARCHAR(5)    DEFAULT '',
  justificado      VARCHAR(10)   DEFAULT '',
  anexoNome        VARCHAR(255)  DEFAULT '',
  anexoBase64      TEXT          DEFAULT '',
  criadoEm        DATETIME      DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_funcionario (funcionarioId),
  INDEX idx_competencia (competencia),
  INDEX idx_grupo (grupoId)
);

-- ── FÉRIAS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ferias (
  id                    VARCHAR(36)   NOT NULL PRIMARY KEY,
  funcionarioId         VARCHAR(36)   NOT NULL,
  funcionarioNome       VARCHAR(150)  DEFAULT '',
  periodoInicio         DATE          DEFAULT NULL,
  periodoFim            DATE          DEFAULT NULL,
  dataLancamento        DATE          DEFAULT NULL,
  diasFeriasGozo        INT           DEFAULT 30,
  diasAbono             INT           DEFAULT 0,
  numDependentes        INT           DEFAULT 0,
  salarioFerias         DECIMAL(10,2) DEFAULT 0,
  insalubridadeFerias   DECIMAL(10,2) DEFAULT 0,
  adicionalFerias       DECIMAL(10,2) DEFAULT 0,
  atsFerias             DECIMAL(10,2) DEFAULT 0,
  salarioFamiliaFerias  DECIMAL(10,2) DEFAULT 0,
  comAbono              TINYINT(1)    DEFAULT 0,
  comDobro              TINYINT(1)    DEFAULT 0,
  com1Parc13            TINYINT(1)    DEFAULT 0,
  mesesTrab13           INT           DEFAULT 0,
  obs                   TEXT          DEFAULT '',
  criadoEm             DATETIME      DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm         DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_funcionario (funcionarioId)
);

-- ── DÉCIMO TERCEIRO ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS decimoTerceiro (
  id             VARCHAR(36)   NOT NULL PRIMARY KEY,
  funcionarioId  VARCHAR(36)   NOT NULL,
  ano            VARCHAR(4)    NOT NULL,
  mesesTrabalhados INT         DEFAULT 12,
  salarioBase    DECIMAL(10,2) DEFAULT 0,
  obs            TEXT          DEFAULT '',
  criadoEm      DATETIME      DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm  DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_funcionario (funcionarioId)
);

SELECT 'Schema criado com sucesso!' AS status;
