DROP DATABASE IF EXISTS tpa_e1_pf; CREATE DATABASE IF NOT EXISTS tpa_e1_pf; USE tpa_e1_pf;
CREATE TABLE IF NOT EXISTS eventos ( id INT AUTO_INCREMENT PRIMARY KEY, descricao VARCHAR(255) NOT NULL, data DATE NOT NULL, local VARCHAR(100) NOT NULL );
INSERT INTO eventos (descricao, data, local) VALUES ('Show da banda X', '2025-05-10', 'Estádio Municipal'), ('Palestra sobre tecnologia', '2025-06-15', 'Centro de Convenções'), ('Feira de artesanato', '2025-07-20', 'Parque Central');


desc eventos;
select * from eventos;