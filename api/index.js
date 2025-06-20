import express from 'express';
import mysql from 'mysql2/promise';
import cors from 'cors';

const pool = mysql.createPool({
    host: process.env.MYSQL_HOST || 'localhost',
    database: process.env.MYSQL_DB || 'todos',
    user: process.env.MYSQL_USER || 'todo_user',
    password: process.env.MYSQL_PASSWORD || 'todo_super_secret_password',
    port: 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

const app = express();
app.use(express.json());
app.use(cors());

app.get('/todos', async (req, res) => {
    const [rows] = await pool.query('SELECT id, title, completed FROM todos ORDER BY id');
    res.json(rows);
});

app.post('/todos', async (req, res) => {
    const { title } = req.body;
    const [result] = await pool.query(
        'INSERT INTO todos (title, completed) VALUES (?, ?)',
        [title, false]
    );
    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ?', [result.insertId]);
    res.status(201).json(rows[0]);
});

app.put('/todos/:id', async (req, res) => {
    const id = req.params.id;
    const { title, completed } = req.body;
    await pool.query(
        'UPDATE todos SET title = ?, completed = ? WHERE id = ?',
        [title, completed, id]
    );
    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ?', [id]);
    res.json(rows[0]);
});

app.delete('/todos/:id', async (req, res) => {
    const id = req.params.id;
    await pool.query('DELETE FROM todos WHERE id = ?', [id]);
    res.status(204).send();
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`API Node.js démarrée sur le port ${port}`);
});
