import os
import psycopg2
from flask import Flask, request, jsonify

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("POSTGRES_HOST", "localhost"),
        database=os.environ.get("POSTGRES_DB", "todos"),
        user=os.environ.get("POSTGRES_USER", "postgres"),
        password=os.environ.get("POSTGRES_PASSWORD", "postgres")
    )
    return conn

@app.route('/todos', methods=['GET'])
def get_todos():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT id, title, completed FROM todos ORDER BY id;')
    todos = [
        {'id': row[0], 'title': row[1], 'completed': row[2]}
        for row in cur.fetchall()
    ]
    cur.close()
    conn.close()
    return jsonify(todos)

@app.route('/todos', methods=['POST'])
def create_todo():
    data = request.get_json()
    title = data.get('title')
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO todos (title, completed) VALUES (%s, %s) RETURNING id;', (title, False))
    todo_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'id': todo_id, 'title': title, 'completed': False}), 201

@app.route('/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    data = request.get_json()
    title = data.get('title')
    completed = data.get('completed')
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('UPDATE todos SET title=%s, completed=%s WHERE id=%s;', (title, completed, todo_id))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'id': todo_id, 'title': title, 'completed': completed})

@app.route('/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('DELETE FROM todos WHERE id=%s;', (todo_id,))
    conn.commit()
    cur.close()
    conn.close()
    return '', 204

# ...existing code (autres routes éventuelles)...
