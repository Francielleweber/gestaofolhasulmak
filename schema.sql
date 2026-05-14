-- ══════════════════════════════════════════════════════════════════
--  Sulmak Locações — Schema Completo do Banco de Dados MySQL
--  Execute este arquivo UMA VEZ para criar todas as tabelas
--  Compatível com Railway MySQL 8.x
-- ══════════════════════════════════════════════════════════════════

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ── FUNCIONÁRIOS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS funcionarios (
  id                    VARCHAR(36)    NOT NULL PRIMARY KEY,
  nome                  VARCHAR(150)   NOT NULL,
  cpf                   VARCHAR(20)    DEFAULT '',
  dataNascimento        DATE           DEFAULT NULL,
  endereco              VARCHAR(400)   DEFAULT '' COMMENT 'rua|num|bairro|cep|cidade|estado',
  telefone              VARCHAR(30)    DEFAULT '',
  email                 VARCHAR(150)   DEFAULT '',
  cargo                 VARCHAR(100)   DEFAULT '',
  cbo                   VARCHAR(20)    DEFAULT '',
  dataAdmissao          DATE           DEFAULT NULL,
  dataDemissao          DATE           DEFAULT NULL,
  pis                   VARCHAR(30)    DEFAULT '',
  ctps                  VARCHAR(60)    DEFAULT '',
  salario               DECIMAL(10,2)  DEFAULT 0.00,
  insalubridade         DECIMAL(10,2)  DEFAULT 0.00,
  adicionalSalario      DECIMAL(10,2)  DEFAULT 0.00,
  ats                   DECIMAL(10,2)  DEFAULT 0.00,
  salarioFamilia        DECIMAL(10,2)  DEFAULT 0.00,
  auxilioCreche         DECIMAL(10,2)  DEFAULT 0.00,
  auxilioCombustivel    DECIMAL(10,2)  DEFAULT 0.00,
  planoSaudeFuncionario DECIMAL(10,2)  DEFAULT 0.00,
  planoSaudeDependentes DECIMAL(10,2)  DEFAULT 0.00,
  banco                 VARCHAR(80)    DEFAULT '',
  agencia               VARCHAR(20)    DEFAULT '',
  conta                 VARCHAR(30)    DEFAULT '',
  tipoConta             VARCHAR(20)    DEFAULT 'corrente',
  pix                   VARCHAR(150)   DEFAULT '',
  obs                   TEXT           DEFAULT NULL,
  criadoEm             DATETIME       DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm         DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── LANÇAMENTOS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lancamentos (
  id                VARCHAR(36)    NOT NULL PRIMARY KEY,
  funcionarioId     VARCHAR(36)    NOT NULL,
  funcionarioNome   VARCHAR(150)   DEFAULT '',
  mes               VARCHAR(7)     NOT NULL   COMMENT 'YYYY-MM',
  competencia       VARCHAR(7)     NOT NULL   COMMENT 'YYYY-MM',
  dataLancamento    DATE           DEFAULT NULL,
  categoria         VARCHAR(20)    DEFAULT '',
  tipo              VARCHAR(60)    NOT NULL,
  valor             DECIMAL(10,2)  DEFAULT 0.00,
  qtdHoras          VARCHAR(10)    DEFAULT '',
  valorHora         DECIMAL(10,2)  DEFAULT 0.00,
  diasVR            VARCHAR(10)    DEFAULT '',
  valorDiaVR        DECIMAL(10,2)  DEFAULT 0.00,
  totalVR           DECIMAL(10,2)  DEFAULT 0.00,
  totalEmprestimo   DECIMAL(10,2)  DEFAULT 0.00,
  totalParcelas     VARCHAR(10)    DEFAULT '',
  grupoId           VARCHAR(36)    DEFAULT '',
  parcelaAtual      INT            DEFAULT 1,
  qtdFaltas         VARCHAR(10)    DEFAULT '',
  baseCalcVT        VARCHAR(20)    DEFAULT '',
  unidade           VARCHAR(5)     DEFAULT '',
  justificado       VARCHAR(10)    DEFAULT '',
  obs               TEXT           DEFAULT NULL,
  anexoNome         VARCHAR(255)   DEFAULT '',
  anexoBase64       MEDIUMTEXT     DEFAULT NULL,
  criadoEm         DATETIME       DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm     DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_lanc_funcionario (funcionarioId),
  INDEX idx_lanc_competencia (competencia),
  INDEX idx_lanc_mes         (mes),
  INDEX idx_lanc_grupo       (grupoId),
  INDEX idx_lanc_tipo        (tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── FÉRIAS ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ferias (
  id                      VARCHAR(36)    NOT NULL PRIMARY KEY,
  funcionarioId           VARCHAR(36)    NOT NULL,
  funcionarioNome         VARCHAR(150)   DEFAULT '',
  periodoAquisitivoIni    DATE           DEFAULT NULL,
  periodoAquisitivoFim    DATE           DEFAULT NULL,
  periodoInicio           DATE           DEFAULT NULL,
  periodoFim              DATE           DEFAULT NULL,
  competencia             VARCHAR(7)     DEFAULT '',
  dataPagamento           DATE           DEFAULT NULL,
  dataLancamento          DATE           DEFAULT NULL,
  diasFeriasGozo          INT            DEFAULT 30,
  numDependentes          INT            DEFAULT 0,
  salarioFerias           DECIMAL(10,2)  DEFAULT 0.00,
  insalubridadeFerias     DECIMAL(10,2)  DEFAULT 0.00,
  adicionalFerias         DECIMAL(10,2)  DEFAULT 0.00,
  atsFerias               DECIMAL(10,2)  DEFAULT 0.00,
  salarioFamiliaFerias    DECIMAL(10,2)  DEFAULT 0.00,
  comAbono                TINYINT(1)     DEFAULT 0,
  diasAbono               INT            DEFAULT 0,
  comDobro                TINYINT(1)     DEFAULT 0,
  com1Parc13              TINYINT(1)     DEFAULT 0,
  mesesTrab13             INT            DEFAULT 0,
  descontoINSS            DECIMAL(10,2)  DEFAULT 0.00,
  descontoIR              DECIMAL(10,2)  DEFAULT 0.00,
  outrosDescontos         DECIMAL(10,2)  DEFAULT 0.00,
  outrosDescontosLabel    VARCHAR(100)   DEFAULT '',
  propDescontoINSS        DECIMAL(10,2)  DEFAULT 0.00,
  propDescontoIR          DECIMAL(10,2)  DEFAULT 0.00,
  obs                     TEXT           DEFAULT NULL,
  criadoEm               DATETIME       DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm           DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_ferias_funcionario (funcionarioId),
  INDEX idx_ferias_periodo     (periodoInicio, periodoFim)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── DÉCIMO TERCEIRO ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS decimoTerceiro (
  id                    VARCHAR(36)    NOT NULL PRIMARY KEY,
  funcionarioId         VARCHAR(36)    NOT NULL,
  funcionarioNome       VARCHAR(150)   DEFAULT '',
  ano                   VARCHAR(4)     NOT NULL,
  mesesTrabalhados      INT            DEFAULT 12,
  numDependentes        INT            DEFAULT 0,
  dataPagamento1        DATE           DEFAULT NULL,
  dataPagamento2        DATE           DEFAULT NULL,
  dataLancamento        DATE           DEFAULT NULL,
  salarioBase           DECIMAL(10,2)  DEFAULT 0.00,
  insalubridade         DECIMAL(10,2)  DEFAULT 0.00,
  adicionalSalario      DECIMAL(10,2)  DEFAULT 0.00,
  ats                   DECIMAL(10,2)  DEFAULT 0.00,
  descontoINSS          DECIMAL(10,2)  DEFAULT 0.00,
  descontoIR            DECIMAL(10,2)  DEFAULT 0.00,
  outrosDescontos       DECIMAL(10,2)  DEFAULT 0.00,
  outrosDescontosLabel  VARCHAR(100)   DEFAULT '',
  obs                   TEXT           DEFAULT NULL,
  criadoEm             DATETIME       DEFAULT CURRENT_TIMESTAMP,
  atualizadoEm         DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_d13_funcionario (funcionarioId),
  INDEX idx_d13_ano         (ano)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ══════════════════════════════════════════════════════════════════
SELECT TABLE_NAME AS tabela, CREATE_TIME AS criada_em
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;
