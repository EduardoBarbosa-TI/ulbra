create table categoria(
    id int auto_increment primary key,
    nome varchar(100) not null
);

create table produtos(
    id_categoria int primary key,
    descricao varchar(200),
    data_cadastro date not null,
    valor_unitario float not null,
    constraint produtos_fk_categoria
    foreign key(id_categoria) references categoria(id)  
    on delete restrict
    on update cascade
);


create table fornecedor(
    id int auto_increment primary key,
    nome varchar(100) not null
);

create table pedidos_produtos_fornecedor(
    id int auto_increment primary key,
    quantidade int not null unique,
    valor_unitario float not null,
    data date not null,

    id_produto int not null,
    id_fornecedor int not null,

    constraint produtos_fk_pedidos_produtos_fornecedor
        foreign key(id_produto) references produtos(id_categoria)
        on delete restrict
        on update cascade,
    constraint fornecedor_fk_pedidos_produtos_fornecedor  
        foreign key(id_fornecedor) references fornecedor(id)  
        on delete restrict
        on update cascade
);

/*3 - Adicionando coluna*/
alter table fornecedor add column data_ultima_compra date not null;

/*4 - Renomeando coluna*/
ALTER TABLE pedidos_produtos_fornecedor RENAME COLUMN data TO data_pedido;

/*5 - Deletando coluna*/
ALTER TABLE produtos DROP COLUMN data_cadastro;

/*6 - Alterando restrições de chave primária*/
ALTER TABLE produtos
        DROP FOREIGN KEY produtos_fk_categoria;

ALTER TABLE produtos
        ADD constraint categoria_fk_produtos
        foreign key(id_categoria) references categoria(id)
        on delete cascade
        on update restrict;

/*7 - Alterando o valor varchar de uma coluna*/
ALTER TABLE fornecedor MODIFY nome varchar(130);

/*8 - Excluindo tabela com restrição de chave estrangeira*/
DROP TABLE fornecedor;
/*
MySqlError { ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails }
O sgbd não autorizou a exclusão da tabela por causa da declaração de restrição na foreign key "on delete restrict".
*/

/*9 - Adicionando nova coluna em tabela*/

alter table pedidos_produtos_fornecedor add column numero_do_pedido varchar(20) not null unique;

/*10 - Populando dados nas tabelas*/

insert into categoria(nome) 
values
('bebidas'),
('doces'),
('limpeza'),
('pets'),
('carnes');

insert into produtos(id_categoria, descricao, valor_unitario) 
values
('1','produto top','7.50'),
('2','produto bom','3.50'),
('3','produto maravilhoso','50.50'),
('4','produto ruim','0.50')

insert into fornecedor(nome, data_ultima_compra) 
values
('André','2022-11-02'),
('Paulo','2022-11-07'),
('Zé','2022-11-22'),
('Jocenir','2022-11-14')

insert into pedidos_produtos_fornecedor(quantidade, valor_unitario, data_pedido,numero_do_pedido, id_produto, id_fornecedor) 
values
('3','3.60','2022-11-02','574','1','4'),
('5','7.90','2022-11-07','467','2','3'),
('7','4.67','2022-11-22','233','3','2'),
('5','3.8','2022-11-14','452','4','1')


/*11 - Deletando uma tupla da tabela*/
 DELETE FROM produtos 
 WHERE 1; 
/*
MySqlError { ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`db272289`.`pedidos_produtos_fornecedor`, CONSTRAINT `produtos_fk_pedidos_produtos_fornecedor` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_categoria`) ON UPDATE CASCADE) }

o sgbd não autoriza pela declaração de restrição da foreign key "on delete restrict"
*/

/*12 - Alterando chave primaria da tupla de uma tabela*/

UPDATE produtos
SET id_categoria = '5'
WHERE id_categoria = 1;

/*
o sgbd aceitou a alteração porém alterou em cascata todos os id_categoria do produto. Pois declaramos na restrição da foreign key "on update cascate"
*/