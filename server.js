// ══════════════════════════════════════════════════════
//  Sulmak Locações — Servidor Express + MySQL
// ══════════════════════════════════════════════════════
require('dotenv').config();
const express    = require('express');
const mysql      = require('mysql2/promise');
const cors       = require('cors');
const rateLimit  = require('express-rate-limit');
const path       = require('path');

const app  = express();
const PORT = process.env.PORT || 3000;

// ── Middlewares ──────────────────────────────────────────
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Rate limiting — máx 200 requests/minuto por IP
app.use('/api', rateLimit({
  windowMs: 60 * 1000,
  max: 200,
  message: { ok: false, error: 'Muitas requisições. Aguarde um momento.' }
}));

// Serve o frontend estático (index.html na raiz do projeto)
app.use(express.static(path.join(__dirname, 'public')));

// ── Conexão com o banco ──────────────────────────────────
const pool = mysql.createPool({
  host:               process.env.DB_HOST     || 'localhost',
  port:               parseInt(process.env.DB_PORT || '3306'),
  user:               process.env.DB_USER     || 'root',
  password:           process.env.DB_PASSWORD || '',
  database:           process.env.DB_NAME     || 'sulmak',
  waitForConnections: true,
  connectionLimit:    10,
  charset:            'utf8mb4',
});

// Testa a conexão ao iniciar
pool.getConnection()
  .then(conn => {
    console.log('✅ Conectado ao MySQL com sucesso!');
    conn.release();
  })
  .catch(err => {
    console.error('❌ Erro ao conectar ao MySQL:', err.message);
  });

// ── Helper: converte valores para número ────────────────
function toNum(v)  { const n = parseFloat(v); return isNaN(n) ? 0 : n; }
function toInt(v)  { const n = parseInt(v);   return isNaN(n) ? 0 : n; }
function toStr(v)  { return v == null ? '' : String(v); }
function toBool(v) { return v === true || v === 'true' || v === 1 ? 1 : 0; }
function toDate(v) {
  if (!v || v === '') return null;
  const s = String(v).slice(0, 10);
  return /^\d{4}-\d{2}-\d{2}$/.test(s) ? s : null;
}

// ══════════════════════════════════════════════════════
//  ROTA DE SAÚDE
// ══════════════════════════════════════════════════════
app.get('/api/ping', (req, res) => {
  res.json({ ok: true, message: 'Sulmak API online!', ts: new Date().toISOString() });
});

// ══════════════════════════════════════════════════════
//  GET ALL — Carrega tudo de uma vez (igual ao Sheets)
// ══════════════════════════════════════════════════════
app.get('/api/all', async (req, res) => {
  try {
    const [[funcionarios], [lancamentos], [ferias], [decimoTerceiro]] = await Promise.all([
      pool.query('SELECT * FROM funcionarios ORDER BY nome'),
      pool.query('SELECT * FROM lancamentos  ORDER BY competencia, criadoEm'),
      pool.query('SELECT * FROM ferias       ORDER BY periodoInicio'),
      pool.query('SELECT * FROM decimoTerceiro ORDER BY ano'),
    ]);
    res.json({ ok: true, funcionarios, lancamentos, ferias, decimoTerceiro });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ══════════════════════════════════════════════════════
//  FUNCIONÁRIOS
// ══════════════════════════════════════════════════════

// Salvar (insert ou update)
app.post('/api/funcionarios', async (req, res) => {
  const d = req.body;
  if (!d || !d.id || !d.nome) return res.status(400).json({ ok: false, error: 'Dados inválidos.' });
  try {
    await pool.query(`
      INSERT INTO funcionarios
        (id, nome, cpf, cargo, salario, insalubridade, adicionalSalario, ats,
         salarioFamilia, auxilioCreche, auxilioCombustivel,
         dataAdmissao, dataDemissao, dataNascimento,
         email, telefone, banco, agencia, conta, obs)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ON DUPLICATE KEY UPDATE
        nome=VALUES(nome), cpf=VALUES(cpf), cargo=VALUES(cargo),
        salario=VALUES(salario), insalubridade=VALUES(insalubridade),
        adicionalSalario=VALUES(adicionalSalario), ats=VALUES(ats),
        salarioFamilia=VALUES(salarioFamilia), auxilioCreche=VALUES(auxilioCreche),
        auxilioCombustivel=VALUES(auxilioCombustivel),
        dataAdmissao=VALUES(dataAdmissao), dataDemissao=VALUES(dataDemissao),
        dataNascimento=VALUES(dataNascimento),
        email=VALUES(email), telefone=VALUES(telefone),
        banco=VALUES(banco), agencia=VALUES(agencia), conta=VALUES(conta),
        obs=VALUES(obs), atualizadoEm=NOW()
    `, [
      toStr(d.id), toStr(d.nome), toStr(d.cpf), toStr(d.cargo),
      toNum(d.salario), toNum(d.insalubridade), toNum(d.adicionalSalario), toNum(d.ats),
      toNum(d.salarioFamilia), toNum(d.auxilioCreche), toNum(d.auxilioCombustivel),
      toDate(d.dataAdmissao), toDate(d.dataDemissao), toDate(d.dataNascimento),
      toStr(d.email), toStr(d.telefone), toStr(d.banco), toStr(d.agencia), toStr(d.conta),
      toStr(d.obs)
    ]);
    res.json({ ok: true, id: d.id });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// Excluir
app.delete('/api/funcionarios/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM funcionarios WHERE id = ?', [req.params.id]);
    res.json({ ok: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ══════════════════════════════════════════════════════
//  LANÇAMENTOS
// ══════════════════════════════════════════════════════

// Salvar
app.post('/api/lancamentos', async (req, res) => {
  const d = req.body;
  if (!d || !d.id) return res.status(400).json({ ok: false, error: 'Dados inválidos.' });
  try {
    await pool.query(`
      INSERT INTO lancamentos
        (id, funcionarioId, funcionarioNome, mes, competencia, dataLancamento,
         categoria, tipo, valor, qtdHoras, valorHora, diasVR, valorDiaVR, totalVR,
         totalEmprestimo, totalParcelas, grupoId, parcelaAtual, obs,
         qtdFaltas, baseCalcVT, unidade, justificado, anexoNome, anexoBase64)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ON DUPLICATE KEY UPDATE
        funcionarioId=VALUES(funcionarioId), funcionarioNome=VALUES(funcionarioNome),
        mes=VALUES(mes), competencia=VALUES(competencia), dataLancamento=VALUES(dataLancamento),
        categoria=VALUES(categoria), tipo=VALUES(tipo), valor=VALUES(valor),
        qtdHoras=VALUES(qtdHoras), valorHora=VALUES(valorHora),
        diasVR=VALUES(diasVR), valorDiaVR=VALUES(valorDiaVR), totalVR=VALUES(totalVR),
        totalEmprestimo=VALUES(totalEmprestimo), totalParcelas=VALUES(totalParcelas),
        grupoId=VALUES(grupoId), parcelaAtual=VALUES(parcelaAtual), obs=VALUES(obs),
        qtdFaltas=VALUES(qtdFaltas), baseCalcVT=VALUES(baseCalcVT),
        unidade=VALUES(unidade), justificado=VALUES(justificado),
        anexoNome=VALUES(anexoNome), anexoBase64=VALUES(anexoBase64),
        atualizadoEm=NOW()
    `, [
      toStr(d.id), toStr(d.funcionarioId), toStr(d.funcionarioNome),
      toStr(d.mes || d.competencia), toStr(d.competencia || d.mes),
      toDate(d.dataLancamento),
      toStr(d.categoria), toStr(d.tipo), toNum(d.valor),
      toStr(d.qtdHoras), toNum(d.valorHora),
      toStr(d.diasVR), toNum(d.valorDiaVR), toNum(d.totalVR),
      toNum(d.totalEmprestimo), toStr(d.totalParcelas),
      toStr(d.grupoId), toInt(d.parcelaAtual), toStr(d.obs),
      toStr(d.qtdFaltas), toStr(d.baseCalcVT), toStr(d.unidade),
      toStr(d.justificado), toStr(d.anexoNome), toStr(d.anexoBase64)
    ]);
    res.json({ ok: true, id: d.id });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// Excluir um lançamento
app.delete('/api/lancamentos/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM lancamentos WHERE id = ?', [req.params.id]);
    res.json({ ok: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// Excluir grupo de parcelas (empréstimo parcelado)
app.delete('/api/lancamentos/grupo/:grupoId', async (req, res) => {
  try {
    const [result] = await pool.query(
      'DELETE FROM lancamentos WHERE grupoId = ?',
      [req.params.grupoId]
    );
    res.json({ ok: true, deletados: result.affectedRows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ══════════════════════════════════════════════════════
//  FÉRIAS
// ══════════════════════════════════════════════════════

// Salvar
app.post('/api/ferias', async (req, res) => {
  const d = req.body;
  if (!d || !d.id) return res.status(400).json({ ok: false, error: 'Dados inválidos.' });
  try {
    await pool.query(`
      INSERT INTO ferias
        (id, funcionarioId, funcionarioNome, periodoInicio, periodoFim, dataLancamento,
         diasFeriasGozo, diasAbono, numDependentes,
         salarioFerias, insalubridadeFerias, adicionalFerias, atsFerias, salarioFamiliaFerias,
         comAbono, comDobro, com1Parc13, mesesTrab13, obs)
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
      ON DUPLICATE KEY UPDATE
        funcionarioId=VALUES(funcionarioId), funcionarioNome=VALUES(funcionarioNome),
        periodoInicio=VALUES(periodoInicio), periodoFim=VALUES(periodoFim),
        dataLancamento=VALUES(dataLancamento),
        diasFeriasGozo=VALUES(diasFeriasGozo), diasAbono=VALUES(diasAbono),
        numDependentes=VALUES(numDependentes),
        salarioFerias=VALUES(salarioFerias), insalubridadeFerias=VALUES(insalubridadeFerias),
        adicionalFerias=VALUES(adicionalFerias), atsFerias=VALUES(atsFerias),
        salarioFamiliaFerias=VALUES(salarioFamiliaFerias),
        comAbono=VALUES(comAbono), comDobro=VALUES(comDobro),
        com1Parc13=VALUES(com1Parc13), mesesTrab13=VALUES(mesesTrab13),
        obs=VALUES(obs), atualizadoEm=NOW()
    `, [
      toStr(d.id), toStr(d.funcionarioId), toStr(d.funcionarioNome),
      toDate(d.periodoInicio), toDate(d.periodoFim), toDate(d.dataLancamento),
      toInt(d.diasFeriasGozo), toInt(d.diasAbono), toInt(d.numDependentes),
      toNum(d.salarioFerias), toNum(d.insalubridadeFerias), toNum(d.adicionalFerias),
      toNum(d.atsFerias), toNum(d.salarioFamiliaFerias),
      toBool(d.comAbono), toBool(d.comDobro), toBool(d.com1Parc13), toInt(d.mesesTrab13),
      toStr(d.obs)
    ]);
    res.json({ ok: true, id: d.id });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// Excluir
app.delete('/api/ferias/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM ferias WHERE id = ?', [req.params.id]);
    res.json({ ok: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ ok: false, error: e.message });
  }
});

// ══════════════════════════════════════════════════════
//  FALLBACK — Serve o index.html para qualquer rota
// ══════════════════════════════════════════════════════
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ── Start ────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
});
