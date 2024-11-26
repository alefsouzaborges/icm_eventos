const express = require('express');
const app = express();
const port = 3000; // Escolha uma porta de sua preferência

app.use(express.static('build/web'));

app.get('*', (req, res) => {
    res.sendFile('build/web/index.html', { root: __dirname });
});

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});