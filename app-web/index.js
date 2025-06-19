import express from 'express';
import pkg from 'pg';
import cors from 'cors';

const { Pool } = pkg;

const app = express();
app.use(express.json());
app.use(cors());

const pool = new Pool({
    host: process.env.POSTGRES_HOST || 'localhost',
    database: process.env.POSTGRES_DB || 'todos',
    user: process.env.POSTGRES_USER || 'todo_user',
    password: process.env.POSTGRES_PASSWORD || 'todo_super_secret_password',
    port: 5432
});

app.get('/todos', async (req, res) => {
    const { rows } = await pool.query('SELECT id, title, completed FROM todos ORDER BY id');
    res.json(rows);
});

app.post('/todos', async (req, res) => {
    const { title } = req.body;
    const { rows } = await pool.query(
        'INSERT INTO todos (title, completed) VALUES ($1, $2) RETURNING *',
        [title, false]
    );
    res.status(201).json(rows[0]);
});

app.put('/todos/:id', async (req, res) => {
    const id = req.params.id;
    const { title, completed } = req.body;
    const { rows } = await pool.query(
        'UPDATE todos SET title = $1, completed = $2 WHERE id = $3 RETURNING *',
        [title, completed, id]
    );
    res.json(rows[0]);
});

app.delete('/todos/:id', async (req, res) => {
    const id = req.params.id;
    await pool.query('DELETE FROM todos WHERE id = $1', [id]);
    res.status(204).send();
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`API Node.js démarrée sur le port ${port}`);
});
