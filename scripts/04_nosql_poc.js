// Exemplo de inclusão no MongoDB Atlas via VS Code / MongoDB Playground
use('omnichannel_nosql');

db.createCollection('logs_navegacao');

db.getCollection('logs_navegacao'). insertMany([
    {
        cliente_id: 101,
        data_hora: new Date(),
        pagina_visitada: '/produto/smartphone-galaxy',
        dispositivo: 'Mobile',
        evento: 'vizualizacao_produto'
    },
    {
        cliente_id: 102,
        data_hora: new Date(),
        pagina_visitada: '/carrinho',
        dispositivo: 'Desktop',
        evento: 'acesso_carrinho'
    },
    {
        cliente_id: 103,
        data_hora: new Date(),
        pagina_visitada: '/busca',
        dispositivo: 'Mobile',
        evento: 'pesquisa_produto'
    }
]);

db.getCollection('logs_navegacao').find({},);