-- =====================================================================
-- Atividade Prática: Escola de Magia de Hogwarts
-- Disciplina: Manipulação de Dados / Banco de Dados II (SIS242M01)
-- Professor: Aguinaldo Neto
--
-- Aluno:Emilly Melissa dos Santos Espindula
-- Matrícula:2532310
--
-- Escreva cada resposta logo abaixo do comentário da questão.
-- Comandos que a atividade pede para FALHAR devem ficar comentados,
-- seguidos do código/mensagem de erro e da sua explicação.
-- =====================================================================

SET SQL_SAFE_UPDATES = 0;

-- =====================================================================
-- 1. PREPARAÇÃO DO AMBIENTE (DDL)
-- =====================================================================
DROP DATABASE IF EXISTS hogwarts;
CREATE DATABASE hogwarts;
USE hogwarts;

-- Tabela casa
CREATE TABLE casa (
    id_casa INT AUTO_INCREMENT PRIMARY KEY,
    nome_casa VARCHAR(30) NOT NULL UNIQUE,
    fundador VARCHAR(60),
    pontos INT DEFAULT 0
);
-- Tabela professor
CREATE TABLE professor (
    id_prof INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) CHECK (salario > 0),
    data_contratacao DATE,
    id_casa INT,
    FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
-- Tabela disciplina
CREATE TABLE disciplina (
    id_disc INT AUTO_INCREMENT PRIMARY KEY,
    nome_disc VARCHAR(60) NOT NULL UNIQUE,
    ano_minimo INT CHECK (ano_minimo BETWEEN 1 AND 7),
    id_prof INT,
    FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
);
-- Tabela aluno
CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ano_escolar INT CHECK (ano_escolar BETWEEN 1 AND 7),
    id_casa INT,
    saldo_galeoes DECIMAL(10,2) DEFAULT 0 CHECK (saldo_galeoes >= 0),
    FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
);
-- Tabela matricula
CREATE TABLE matricula (
    id_aluno INT,
    id_disc INT,
    nota DECIMAL(4,2) CHECK (nota BETWEEN 0 AND 10),
    PRIMARY KEY (id_aluno, id_disc),
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_disc) REFERENCES disciplina(id_disc)
);
-- Tabela registro_pontos
CREATE TABLE registro_pontos (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_prof INT NOT NULL,
    pontos INT NOT NULL,
    motivo VARCHAR(150) NOT NULL,
    data_registro DATE NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
);
-- Tabela produto
CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    loja VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco > 0),
    estoque INT DEFAULT 0 CHECK (estoque >= 0)
);
-- Tabela compra
CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT CHECK (quantidade > 0),
    valor_total DECIMAL(10,2),
    data_compra DATE NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);
-- Tabela log_auditoria
CREATE TABLE log_auditoria (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(30),
    operacao VARCHAR(10),
    descricao VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Pergunta para pensar: por que matricula usa chave primária composta?
-- Resposta: 
Chave primária composta garante que cada aluno se matricule em uma mesma disciplina apenas uma vez. Se fosse usado um ID autoincrementável separado, o banco permitiria cadastrar várias linhas idênticas para o mesmo par aluno-disciplina por descuido, gerando redundância e corrompendo os dados.

-- =====================================================================
-- 1.1 CARGA INICIAL DE DADOS (DML)
-- =====================================================================
-- INSERT casa
INSERT INTO casa (nome_casa, fundador) VALUES
('Grifinória', 'Godric Gryffindor'),
('Sonserina', 'Salazar Slytherin'),
('Corvinal', 'Rowena Ravenclaw'),
('Lufa-Lufa', 'Helga Hufflepuff');
-- INSERT professor
INSERT INTO professor (nome, salario, data_contratacao, id_casa) VALUES
('Minerva McGonagall', 9500.00, '1956-12-01', 1),
('Severo Snape', 8800.00, '1981-09-01', 2),
('Fílio Flitwick', 8200.00, '1974-09-01', 3),
('Pomona Sprout', 7900.00, '1972-09-01', 4),
('Rúbeo Hagrid', 4500.00, '1993-09-01', NULL),
('Remo Lupin', 6200.00, '1993-09-01', NULL),
('Sibila Trelawney', 5100.00, '1980-09-01', NULL),
('Gilderoy Lockhart', 7000.00, '1992-09-01', NULL),
('Horácio Slughorn', 8000.00, '1996-09-01', NULL);
-- INSERT disciplina
INSERT INTO disciplina (nome_disc, ano_minimo, id_prof) VALUES
('Transfiguração', 1, 1),
('Poções', 1, 2),
('Feitiços', 1, 3),
('Herbologia', 1, 4),
('Trato das Criaturas Mágicas', 3, 5),
('Defesa Contra as Artes das Trevas', 1, 6),
('Adivinhação', 3, 7),
('Estudo dos Trouxas', 3, NULL),
('Runas Antigas', 3, NULL);
-- INSERT aluno
INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes) VALUES
('Harry Potter', 5, 1, 120.00),
('Hermione Granger', 5, 1, 85.00),
('Rony Weasley', 5, 1, 12.00),
('Neville Longbottom', 5, 1, 30.00),
('Draco Malfoy', 5, 2, 500.00),
('Pansy Parkinson', 5, 2, 150.00),
('Vicente Crabbe', 5, 2, 40.00),
('Luna Lovegood', 4, 3, 45.00),
('Cho Chang', 6, 3, 200.00),
('Padma Patil', 5, 3, 60.00),
('Cedrico Diggory', 7, 4, 180.00),
('Ana Abbott', 5, 4, 25.00),
('Ernesto Macmillan', 5, 4, 70.00),
('Teddy Lupin', 1, NULL, 0.00);
-- INSERT matricula
INSERT INTO matricula (id_aluno, id_disc, nota) VALUES
(1,1,7.5), (1,2,5.0), (1,6,9.8), (1,5,8.0),
(2,1,10.0), (2,2,9.5), (2,3,10.0), (2,5,9.0), (2,9,9.5),
(3,1,6.0), (3,2,4.5), (3,7,5.5),
(4,2,3.0), (4,4,10.0), (4,6,7.0),
(5,2,9.0), (5,1,7.0), (5,5,4.0),
(6,2,7.5), (6,7,6.5),
(7,2,3.5), (7,6,2.0),
(8,5,8.5), (8,3,8.0), (8,4,9.0),
(9,3,8.5), (9,6,7.5),
(10,3,9.0), (10,7,6.0),
(11,4,8.5), (11,6,9.0), (11,1,8.0),
(12,4,8.0),
(13,4,7.0), (13,3,7.5);
-- INSERT produto
INSERT INTO produto (nome_produto, loja, preco, estoque) VALUES
('Varinha de Azevinho', 'Olivaras', 7.00, 10),
('Vassoura Nimbus 2001', 'Artigos de Quadribol', 300.00, 3),
('Sapo de Chocolate', 'Dedosdemel', 2.00, 200),
('Feijõezinhos de Todos os Sabores', 'Dedosdemel', 1.50, 150),
('Livro Monstruoso dos Monstros', 'Floreios e Borrões', 12.00, 20),
('Caldeirão de Estanho', 'Caldeirões Potage', 9.00, 0),
('Kit de Logros', 'Gemialidades Weasley', 25.00, 40),
('Pena de Repetição Rápida', 'Escribbulus', 15.00, 5)
-- Confira: SELECT COUNT(*) de cada tabela

-- =====================================================================
-- 2. MANUTENÇÃO PÓS-CARGA (ALTER E UPDATE)
-- =====================================================================
-- Questão 1
ALTER TABLE aluno ADD COLUMN email VARCHAR(100);
-- Questão 2
ALTER TABLE matricula ADD COLUMN situacao VARCHAR(20) DEFAULT 'Cursando';
-- Questão 3
ALTER TABLE produto ADD COLUMN ativo CHAR(1) DEFAULT 'S';
-- Questão 4
ALTER TABLE casa MODIFY COLUMN fundador VARCHAR(100);
-- Questão 5
ALTER TABLE professor RENAME COLUMN data_contratacao TO data_admissao;
-- Questão 6
UPDATE aluno 
SET email = CONCAT(LOWER(REPLACE(nome, ' ', '.')), '@hogwarts.edu');
-- Questão 7
ALTER TABLE aluno ADD CONSTRAINT uq_aluno_email UNIQUE (email);
-- Questão 8
UPDATE matricula 
SET nota = LEAST(nota + 0.5, 10.00)
WHERE id_disc IN (
    SELECT id_disc 
    FROM disciplina 
    WHERE id_prof IN (
        SELECT id_prof 
        FROM professor 
        WHERE nome = 'Remo Lupin'
    )
);
-- Questão 9
UPDATE matricula 
SET situacao = CASE 
    WHEN nota >= 6 THEN 'Aprovado' 
    ELSE 'Reprovado' 
END;
-- Questão 10
UPDATE professor 
SET salario = salario * 1.10 
WHERE id_casa IS NOT NULL 
  AND data_admissao < '1980-01-01';
-- Questão 11
UPDATE produto 
SET ativo = 'N' 
WHERE estoque = 0;
-- Questão 12
UPDATE produto 
SET preco = preco * 0.80 
WHERE loja = 'Dedosdemel';

-- =====================================================================
-- 3. REMOÇÃO DE DADOS (DELETE) E TESTES DE RESTRIÇÕES
-- =====================================================================
-- Questão 13
-- Erro:Teste de chave estrangeira (tentar excluir a casa 'Sonserina')
 DELETE FROM casa WHERE nome_casa = 'Sonserina';
-- Explicação:O banco recusa a exclusão (Error Code 1451: Cannot delete or update a parent row: a foreign key constraint fails) 
-- porque existem registros na tabela aluno, professor e disciplinas/matrículas vinculadas a essa casa, violando a integridade referencial das chaves estrangeiras.

-- Questão 14
-- Erro:Teste de CHECK (cadastrar aluno 'Dobby', 8º ano, Grifinória)
 INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes) VALUES ('Dobby', 8, 1, 10.00);
-- Explicação:O comando falha (Error Code 3819: Check constraint 'aluno_chk_1' is violated) 
-- porque a tabela possui uma restrição (CHECK) que limita o ano_escolar entre 1 e 7, e o valor informado foi 8.

-- Questão 15
-- Erro:Teste de UNIQUE (cadastrar aluno com e-mail repetido) e INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes, email) VALUES ('Harry Potter (Polissuco)', 5, 1, 10.00, 'harry.potter@hogwarts.edu');
-- Explicação:O comando falha (Error Code 1062: Duplicate entry for key 'aluno.uq_aluno_email') 
-- porque a coluna email possui a restrição UNIQUE criada na seção anterior, impedindo valores duplicados.

-- Questão 16
-- Erro:Teste de integridade (excluir o professor 'Severo Snape') 
DELETE FROM professor WHERE nome = 'Severo Snape';
-- Explicação:A exclusão é bloqueada (Error Code 1451: Cannot delete or update a parent row) 
-- porque o professor possui referências ativas como chave estrangeira em outras tabelas, como disciplina e registro_pontos.

-- Questão 17
Gilderoy Lockhart perdeu a memória e deixou a escola
DELETE FROM professor WHERE nome = 'Gilderoy Lockhart';

-- Questão 18
DELETE FROM matricula 
WHERE id_aluno IN (SELECT id_aluno FROM aluno WHERE nome = 'Vicente Crabbe');
DELETE FROM aluno 
WHERE nome = 'Vicente Crabbe';
-- Questão 19
Excluir disciplinas sem nenhum aluno matriculado (usando NOT IN com subconsulta)
DELETE FROM disciplina 
WHERE id_disc NOT IN (SELECT id_disc FROM matricula);


-- =====================================================================
-- 4. TRIGGERS
-- =====================================================================
-- Questão 20 - trg_pontos_casa
CREATE TRIGGER trg_pontos_casa
AFTER INSERT ON registro_pontos
FOR EACH ROW
BEGIN
    UPDATE casa 
    SET pontos = pontos + NEW.pontos 
    WHERE id_casa = (SELECT id_casa FROM aluno WHERE id_aluno = NEW.id_aluno);
END$$
-- Questão 21 - trg_valida_compra
CREATE TRIGGER trg_valida_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_saldo DECIMAL(10,2);

    -- Busca estoque e preço do produto
    SELECT estoque, preco INTO v_estoque, v_preco 
    FROM produto 
    WHERE id_produto = NEW.id_produto;

    -- Busca saldo do aluno
    SELECT saldo_galeoes INTO v_saldo 
    FROM aluno 
    WHERE id_aluno = NEW.id_aluno;

    -- Valida estoque
    IF v_estoque < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Estoque insuficiente no Beco Diagonal';
    END IF;

    -- Valida saldo
    IF v_saldo < (v_preco * NEW.quantidade) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Galeões insuficientes no cofre do aluno';
    END IF;

    -- Calcula o valor total da compra
    SET NEW.valor_total = v_preco * NEW.quantidade;
END$$
  
-- Questão 22 - trg_baixa_compra
CREATE TRIGGER trg_baixa_compra
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    -- Diminui o estoque do produto
    UPDATE produto 
    SET estoque = estoque - NEW.quantidade 
    WHERE id_produto = NEW.id_produto;

    -- Desconta o valor total do saldo do aluno
    UPDATE aluno 
    SET saldo_galeoes = saldo_galeoes - NEW.valor_total 
    WHERE id_aluno = NEW.id_aluno;
END$$
  
-- Questão 23 - trg_situacao_nota
CREATE TRIGGER trg_situacao_nota
BEFORE UPDATE ON matricula
FOR EACH ROW
BEGIN
    IF NEW.nota >= 6 THEN
        SET NEW.situacao = 'Aprovado';
    ELSE
        SET NEW.situacao = 'Reprovado';
    END IF;
END$$
  
-- Questão 24 - trg_audita_salario
CREATE TRIGGER trg_audita_salario
AFTER UPDATE ON professor
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO log_auditoria (tabela, operacao, descricao)
        VALUES (
            'professor', 
            'UPDATE', 
            CONCAT(NEW.nome, ': salário de ', OLD.salario, ' para ', NEW.salario)
        );
    END IF;
END$$

DELIMITER ;
-- Pergunta para pensar: por que a validação é BEFORE e a baixa é AFTER?
-- Resposta:A validação precisa ser BEFORE porque atua como um bloqueio preventivo. Se o saldo for insuficiente ou não houver estoque, a operação é cancelada antes de alterar o banco. Já a baixa precisa ser AFTER porque ela depende de que o registro da compra tenha sido inserido com sucesso para só então atualizar os valores na tabela de produtos e alunos[cite: 10].

-- Questão 25 - INSERT registro_pontos
INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES
(2, 3, 20, 'Feitiço de levitação perfeito', '2026-09-10'),
(1, 2, 10, 'Atraso na aula de Poções', '2026-09-12'),
(5, 2, 15, 'Poção do Morto-Vivo impecável', '2026-09-12'),
(8, 5, 10, 'Cuidou de um testrálio ferido', '2026-09-20'),
(11, 4, 25, 'Ajudou os alunos do 1º ano', '2026-09-25'),
(4, 4, 30, 'Identificou uma Mimbulus mimbletonia', '2026-10-02'),
(6, 1, -20, 'Fora da cama após o toque de recolher', '2026-10-05'),
(1, 6, 50, 'Conjurou um Patrono corpóreo', '2026-10-15'),
(9, 3, 15, 'Duelo exemplar no Clube de Duelos', '2026-10-18'),
(5, 1, 30, 'Duelo proibido no corredor', '2026-10-31'),
(10, 7, 5, 'Interpretação da bola de cristal', '2026-11-03'),
(13, 4, 10, 'Colheita de mandrágoras', '2026-11-05'),
(3, 9, 10, 'Identificou um bezoar', '2026-11-06'),
(8, 3, 20, 'Resposta brilhante sobre o Diadema', '2026-11-08'),
(6, 2, 25, 'Antídoto para venenos comuns', '2026-11-09'),
(5, 9, 40, 'Melhor poção do Clube do Slugue', '2026-11-09');

-- Questão 25 - INSERT compra
INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra) VALUES
(5, 2, 1, '2026-09-01'),
(2, 5, 2, '2026-09-02'),
(1, 3, 10, '2026-09-03'),
(3, 4, 5, '2026-09-03'),
(9, 8, 1, '2026-09-15'),
(8, 5, 1, '2026-09-20'),
(11, 1, 1, '2026-10-01'),
(6, 3, 20, '2026-10-10'),
(1, 7, 2, '2026-10-20'),
(13, 4, 10, '2026-11-02');

-- Questão 25 - Rony tenta comprar a Nimbus
INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra) VALUES (3, 2, 1, '2026-11-10');
-- Resultado: A compra é bloqueada com o erro 'Galeões insuficientes no cofre do aluno' 
-- porque Rony possui saldo de 12 galeões e a vassoura custa 300.00.

-- Questão 25 - Hermione tenta comprar o caldeirão
INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra) VALUES (2, 6, 1, '2026-11-10');
-- Resultado: A compra é bloqueada com o erro 'Estoque insuficiente no Beco Diagonal' 
-- porque o estoque do caldeirão está zerado (estoque = 0).

-- Questão 25 - Recuperação do Rony em Poções
 UPDATE matricula 
SET nota = 6.5 
WHERE id_aluno = 3 AND id_disc = 2;
 O trigger trg_situacao_nota atualiza a situação automaticamente para 'Aprovado'.

-- Questão 25 - Salário e data de admissão do Hagrid
   UPDATE professor 
SET salario = 5000.00 
WHERE nome = 'Rúbeo Hagrid';

UPDATE professor 
SET data_admissao = '1993-08-15' 
WHERE nome = 'Rúbeo Hagrid';
-- Linhas em log_auditoria: 1 linha
-- Por que o reajuste da questão 10 não aparece:O reajuste da seção 2 ocorreu antes 
da criação do trigger trg_audita_salario, e a alteração na data de admissão não altera o salário, 
logo o trigger dispara exclusivamente quando OLD.salario <> NEW.salario.


-- =====================================================================
-- 5. CONTROLE DE TRANSAÇÕES (TCL)
-- =====================================================================
-- Questão 26
START TRANSACTION;
UPDATE aluno SET saldo_galeoes = saldo_galeoes - 50.00 WHERE nome = 'Draco Malfoy';
UPDATE aluno SET saldo_galeoes = saldo_galeoes + 50.00 WHERE nome = 'Pansy Parkinson';
COMMIT;

-- Questão 27
START TRANSACTION;
UPDATE casa SET pontos = 0;
SELECT * FROM casa; -- Confere o placar zerado
ROLLBACK;
SELECT * FROM casa; -- O placar voltou ao normal após o ROLLBACK

-- Questão 28
START TRANSACTION;
INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra) VALUES (1, 1, 1, '2026-11-10');
SELECT saldo_galeoes FROM aluno WHERE id_aluno = 1; -- Harry com 47.00
SELECT estoque FROM produto WHERE id_produto = 1;     -- Varinha com estoque 8
ROLLBACK;
SELECT saldo_galeoes FROM aluno WHERE id_aluno = 1; -- Retorna a 54.00
SELECT estoque FROM produto WHERE id_produto = 1;

-- Questão 29
START TRANSACTION;
-- a. Registra 15 pontos para Ana Abbott
INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES (12, 4, 15, 'Cuidou das estufas no feriado', '2026-11-10');
-- b. Cria o savepoint
SAVEPOINT sp_pontos_legitimos;
-- c. Registra 100 pontos para Pansy Parkinson
INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES (6, 2, 100, 'Favoritismo descarado', '2026-11-10');
-- d. Volta ao savepoint e confirma a transação
ROLLBACK TO sp_pontos_legitimos;
COMMIT;

-- Questão 30
SELECT @@autocommit;
-- Resposta do valor retornado: O valor 1 (ON) significa que o autocommit está ativo, ou seja, cada comando SQL é executado e confirmado automaticamente em sua própria transação. Se o valor for 0 (OFF), é necessário executar explicitamente COMMIT para salvar as alterações.
O que acontece com uma transação aberta se você executar um CREATE TABLE no meio dela: Um comando DDL (como CREATE TABLE ou DROP TABLE) executa um commit implícito automático no MySQL, encerrando imediatamente a transação aberta e salvando qualquer alteração pendente.

-- =====================================================================
-- 6. DESAFIOS DE CONSULTA
-- =====================================================================
-- ---------- Nível 1: filtros e operadores especiais ----------

-- 6.1 Faixa salarial (BETWEEN)
SELECT nome, salario FROM professor WHERE salario BETWEEN 6000.00 AND 9000.00 ORDER BY salario DESC;

-- 6.2 Anos selecionados (IN)
SELECT nome, ano_escolar FROM aluno WHERE ano_escolar IN (1, 4, 6, 7) ORDER BY ano_escolar;

-- 6.3 Busca por padrão (LIKE com _)
SELECT nome FROM aluno WHERE nome LIKE '_a%';

-- 6.4 Disciplina órfã (IS NULL)
SELECT * FROM disciplina WHERE id_prof IS NULL;

-- 6.5 Fora da faixa (NOT BETWEEN)
SELECT nome_produto, preco FROM produto WHERE preco NOT BETWEEN 5.00 AND 20.00 ORDER BY preco;

-- 6.6 Lojas do Beco Diagonal (DISTINCT)
SELECT DISTINCT loja FROM produto ORDER BY loja;

-- ---------- Nível 2: JOINs ----------

-- 6.7 Quem é de qual casa (INNER JOIN)
SELECT a.nome AS aluno, c.nome_casa AS casa FROM aluno a INNER JOIN casa c ON a.id_casa = c.id_casa ORDER BY c.nome_casa, a.nome;
-- (Aparecem 12 alunos porque Teddy Lupin possui id_casa NULL, logo o INNER JOIN o exclui).

-- 6.8 Todos os alunos (LEFT JOIN)
SELECT a.nome AS aluno, COALESCE(c.nome_casa, 'Aguardando o Chapéu Seletor') AS casa FROM aluno a LEFT JOIN casa c ON a.id_casa = c.id_casa;

-- 6.9 Professor sem turma (RIGHT JOIN)
SELECT p.nome AS professor FROM disciplina d RIGHT JOIN professor p ON d.id_prof = p.id_prof WHERE d.id_disc IS NULL;

-- 6.10 Boletim da Grifinória (JOIN com 5 tabelas)
SELECT a.nome AS aluno, d.nome_disc AS disciplina, p.nome AS professor, m.nota, m.situacao 
FROM matricula m 
INNER JOIN aluno a ON m.id_aluno = a.id_aluno 
INNER JOIN casa c ON a.id_casa = c.id_casa 
INNER JOIN disciplina d ON m.id_disc = d.id_disc 
LEFT JOIN professor p ON d.id_prof = p.id_prof 
WHERE c.nome_casa = 'Grifinória' 
ORDER BY a.nome, d.nome_disc;

-- 6.11 Extrato do Beco Diagonal (JOIN com 3 tabelas)
SELECT co.id_compra, a.nome AS aluno, pr.nome_produto, pr.loja, co.quantidade, co.valor_total, co.data_compra 
FROM compra co 
INNER JOIN aluno a ON co.id_aluno = a.id_aluno 
INNER JOIN produto pr ON co.id_produto = pr.id_produto 
ORDER BY co.data_compra, co.id_compra;

-- ---------- Nível 3: agrupamento e agregação ----------

-- 6.12 Desempenho por disciplina
SELECT d.nome_disc, COUNT(m.id_aluno) AS qtd_alunos, ROUND(AVG(m.nota), 2) AS media, MAX(m.nota) AS maior_nota, MIN(m.nota) AS menor_nota 
FROM disciplina d 
INNER JOIN matricula m ON d.id_disc = m.id_disc 
GROUP BY d.id_disc, d.nome_disc 
HAVING AVG(m.nota) >= 7 
ORDER BY media DESC;

-- 6.13 Livro-razão da Taça
SELECT c.nome_casa, COUNT(rp.id_registro) AS qtd_registros, 
       SUM(CASE WHEN rp.pontos > 0 THEN rp.pontos ELSE 0 END) AS pontos_ganhos, 
       SUM(CASE WHEN rp.pontos < 0 THEN rp.pontos ELSE 0 END) AS pontos_perdidos, 
       c.pontos AS saldo 
FROM casa c 
LEFT JOIN aluno a ON c.id_casa = a.id_casa 
LEFT JOIN registro_pontos rp ON a.id_aluno = rp.id_aluno 
GROUP BY c.id_casa, c.nome_casa, c.pontos;

-- 6.14 Faturamento por loja
SELECT pr.loja, COUNT(co.id_compra) AS qtd_compras, SUM(co.valor_total) AS faturamento 
FROM produto pr 
INNER JOIN compra co ON pr.id_produto = co.id_produto 
GROUP BY pr.loja 
HAVING SUM(co.valor_total) > 20 
ORDER BY faturamento DESC;

-- 6.15 Pontos por mês
SELECT MONTH(data_registro) AS mes, COUNT(*) AS qtd_registros, SUM(pontos) AS total_pontos 
FROM registro_pontos 
GROUP BY MONTH(data_registro) 
ORDER BY mes;

-- 6.16 Professores mais ativos
SELECT p.nome, COUNT(rp.id_registro) AS qtd_registros, SUM(rp.pontos) AS total_concedido 
FROM professor p 
INNER JOIN registro_pontos rp ON p.id_prof = rp.id_prof 
GROUP BY p.id_prof, p.nome 
HAVING COUNT(rp.id_registro) >= 2 
ORDER BY total_concedido DESC;

-- ---------- Nível 4: subconsultas ----------

-- 6.17 Clientes da Dedosdemel (IN)
SELECT nome FROM aluno WHERE id_aluno IN (
    SELECT id_aluno FROM compra WHERE id_produto IN (
        SELECT id_produto FROM produto WHERE loja = 'Dedosdemel'
    )
);

-- 6.18 Encalhados (NOT IN)
SELECT nome_produto, estoque FROM produto WHERE id_produto NOT IN (SELECT id_produto FROM compra);

-- 6.19 Cofres cheios (subconsulta escalar)
SELECT nome, saldo_galeoes FROM aluno WHERE saldo_galeoes > (SELECT AVG(saldo_galeoes) FROM aluno);

-- 6.20 Acima de todos (ALL)
SELECT nome, salario FROM professor WHERE salario > ALL (SELECT salario FROM professor WHERE id_casa IS NULL);

-- 6.21 Mais rico que algum sonserino (ANY)
SELECT nome, saldo_galeoes FROM aluno WHERE id_casa <> 2 AND saldo_galeoes > ANY (SELECT saldo_galeoes FROM aluno WHERE id_casa = 2);
-- Explicação: O operador > ANY equivale a comparar com o menor valor retornado pela subconsulta (é maior que o menor sonserino).

-- 6.22 Casas com nota máxima (EXISTS)
SELECT * FROM casa c WHERE EXISTS (SELECT 1 FROM aluno a INNER JOIN matricula m ON a.id_aluno = m.id_aluno WHERE a.id_casa = c.id_casa AND m.nota = 10);

-- 6.23 Nunca foram ao Beco (NOT EXISTS)
SELECT * FROM aluno a WHERE NOT EXISTS (SELECT 1 FROM compra c WHERE c.id_aluno = a.id_aluno);

-- 6.24 Média das médias (subconsulta no FROM)
SELECT c.nome_casa, ROUND(AVG(t.media_aluno), 2) AS media_casa 
FROM casa c 
INNER JOIN aluno a ON c.id_casa = a.id_casa 
INNER JOIN (SELECT id_aluno, AVG(nota) AS media_aluno FROM matricula GROUP BY id_aluno) t ON a.id_aluno = t.id_aluno 
GROUP BY c.id_casa, c.nome_casa 
ORDER BY media_casa DESC;

-- ---------- Nível 5: UNION ALL ----------

-- 6.25 Diretório de Hogwarts
SELECT nome, 'Aluno' AS vinculo FROM aluno 
UNION ALL 
SELECT nome, 'Professor' AS vinculo FROM professor 
ORDER BY nome;

-- 6.26 UNION x UNION ALL
SELECT id_aluno FROM compra UNION ALL SELECT id_aluno FROM registro_pontos; -- Retorna 27 linhas (inclui duplicatas)
SELECT id_aluno FROM compra UNION SELECT id_aluno FROM registro_pontos;       -- Retorna 12 linhas (remove duplicatas)

-- 6.27 Painel do Diretor
SELECT 'Total de pontos distribuídos' AS indicador, SUM(pontos) AS valor FROM registro_pontos
UNION ALL
SELECT 'Total de galeões gastos na loja', SUM(valor_total) FROM compra
UNION ALL
SELECT 'Folha salarial dos professores', SUM(salario) FROM professor
UNION ALL
SELECT 'Total de galeões nos cofres dos alunos', SUM(saldo_galeoes) FROM aluno;

-- =====================================================================
-- 7. VIEWS
-- =====================================================================
CREATE VIEW vw_placar_casas AS
SELECT nome_casa, pontos FROM casa ORDER BY pontos DESC;

CREATE VIEW vw_boletim AS
SELECT a.nome AS aluno, COALESCE(c.nome_casa, 'Sem casa') AS casa, d.nome_disc AS disciplina, COALESCE(p.nome, 'Sem professor') AS professor, m.nota, m.situacao 
FROM matricula m 
INNER JOIN aluno a ON m.id_aluno = a.id_aluno 
LEFT JOIN casa c ON a.id_casa = c.id_casa 
INNER JOIN disciplina d ON m.id_disc = d.id_disc 
LEFT JOIN professor p ON d.id_prof = p.id_prof;

CREATE VIEW vw_extrato_loja AS
SELECT a.nome AS aluno, pr.nome_produto, pr.loja, co.quantidade, co.valor_total, co.data_compra 
FROM compra co 
INNER JOIN aluno a ON co.id_aluno = a.id_aluno 
INNER JOIN produto pr ON co.id_produto = pr.id_produto;

CREATE VIEW vw_alunos_destaque AS
SELECT a.nome AS aluno, c.nome_casa AS casa, ROUND(AVG(m.nota), 2) AS media 
FROM aluno a 
INNER JOIN casa c ON a.id_casa = c.id_casa 
INNER JOIN matricula m ON a.id_aluno = m.id_aluno 
GROUP BY a.id_aluno, a.nome, c.nome_casa 
HAVING AVG(m.nota) >= 8;

CREATE VIEW vw_quadro_professores AS
SELECT p.nome AS professor, 
       COALESCE((SELECT c.nome_casa FROM casa c WHERE c.id_casa = p.id_casa), 'Não é diretor') AS casa_dirigida,
       (SELECT COUNT(*) FROM disciplina d WHERE d.id_prof = p.id_prof) AS qtd_disciplinas,
       COALESCE((SELECT SUM(rp.pontos) FROM registro_pontos rp WHERE rp.id_prof = p.id_prof), 0) AS total_pontos_concedidos
FROM professor p;

-- 36. Usando as views:
SELECT * FROM vw_placar_casas;
SELECT * FROM vw_boletim WHERE casa = 'Corvinal';
SELECT loja, SUM(valor_total) AS total_faturado FROM vw_extrato_loja GROUP BY loja;
SELECT * FROM vw_alunos_destaque ORDER BY media DESC;
SELECT * FROM vw_quadro_professores ORDER BY total_pontos_concedidos DESC;

-- 37. A view é "viva"
INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES (11, 1, 20, 'Venceu a primeira tarefa do Torneio', '2026-11-10');
SELECT * FROM vw_placar_casas; 
-- O que mudou: Os pontos da Lufa-Lufa aumentaram automaticamente porque a view consulta diretamente a tabela casa, refletindo as alterações em tempo real.

-- 38. CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW vw_placar_casas AS
SELECT nome_casa, fundador, pontos FROM casa ORDER BY pontos DESC;

-- =====================================================================
-- 8. CONTROLE DE ACESSO (DCL)
-- =====================================================================
-- 39. Criação dos usuários
CREATE USER 'filch'@'localhost' IDENTIFIED BY 'MadameNorra#1';
CREATE USER 'mcgonagall'@'localhost' IDENTIFIED BY 'Animago#Gato1';
CREATE USER 'dumbledore'@'localhost' IDENTIFIED BY 'Fenix#Fawkes1';

-- 40. Permissão para o zelador Filch
GRANT SELECT ON hogwarts.vw_placar_casas TO 'filch'@'localhost';

-- 41. Permissões para a Professora McGonagall
GRANT SELECT, INSERT ON hogwarts.registro_pontos TO 'mcgonagall'@'localhost';
GRANT SELECT ON hogwarts.aluno TO 'mcgonagall'@'localhost';
GRANT SELECT ON hogwarts.vw_boletim TO 'mcgonagall'@'localhost';

-- 42. Privilégios para Dumbledore
GRANT ALL PRIVILEGES ON hogwarts.* TO 'dumbledore'@'localhost' WITH GRANT OPTION;

-- 43. Conferir permissões
SHOW GRANTS FOR 'filch'@'localhost';
SHOW GRANTS FOR 'mcgonagall'@'localhost';

-- 44. Testando como filch (deve falhar na tabela aluno)
-- SELECT * FROM vw_placar_casas; -- Funciona
-- SELECT * FROM aluno; 
-- Erro esperado: Error Code 1142: SELECT command denied to user 'filch'@'localhost' for table 'aluno'

-- 45. Testando como mcgonagall
-- INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES (2, 1, 10, 'Ajudou um colega em Transfiguração', '2026-11-10');
-- UPDATE casa SET pontos = 1000 WHERE id_casa = 1;
-- Explicação de como o trigger atualizou a casa mesmo sem permissão da McGonagall: 
-- Os triggers executam com os privilégios do usuário que definiu o trigger (definiter), permitindo que operações internas ocorram com segurança.

-- 46. Revogar INSERT da McGonagall
REVOKE INSERT ON hogwarts.registro_pontos FROM 'mcgonagall'@'localhost';
SHOW GRANTS FOR 'mcgonagall'@'localhost';

-- 47. Papéis (roles)
CREATE ROLE monitor;
GRANT SELECT ON hogwarts.vw_boletim TO monitor;
GRANT SELECT ON hogwarts.vw_placar_casas TO monitor;

CREATE USER 'percy'@'localhost' IDENTIFIED BY 'Monitor#Chefe1';
GRANT monitor TO 'percy'@'localhost';
SET DEFAULT ROLE monitor FOR 'percy'@'localhost';
-- Vantagem dos papéis: Centralizam a gestão de permissões. Em vez de conceder privilégios individualmente a cada monitor, atribui-se o papel, facilitando alterações futuras.

-- 48. Limpeza final
DROP USER 'filch'@'localhost';
DROP USER 'mcgonagall'@'localhost';
DROP USER 'dumbledore'@'localhost';
DROP USER 'percy'@'localhost';
DROP ROLE monitor;

