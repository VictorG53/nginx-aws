document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('todo-form');
    const input = document.getElementById('todo-input');
    const list = document.getElementById('todo-list');
    const API_URL = '/todos';

    // Charger les todos depuis l'API
    async function fetchTodos() {
        const res = await fetch(API_URL);
        const todos = await res.json();
        list.innerHTML = '';
        todos.forEach(todo => {
            const item = createTodoItem(todo);
            list.appendChild(item);
        });
    }

    // Créer un élément todo à partir d'un objet
    function createTodoItem(todo) {
        const li = document.createElement('li');
        li.className = 'todo-item';
        if (todo.completed) li.classList.add('completed');

        const label = document.createElement('label');
        label.textContent = todo.title;

        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.checked = todo.completed;
        checkbox.addEventListener('change', async () => {
            await updateTodo(todo.id, { title: todo.title, completed: checkbox.checked });
            li.classList.toggle('completed', checkbox.checked);
        });

        const deleteBtn = document.createElement('button');
        deleteBtn.textContent = 'Supprimer';
        deleteBtn.addEventListener('click', async () => {
            await deleteTodo(todo.id);
            list.removeChild(li);
        });

        const actions = document.createElement('div');
        actions.className = 'todo-actions';
        actions.appendChild(checkbox);
        actions.appendChild(deleteBtn);

        li.appendChild(label);
        li.appendChild(actions);

        return li;
    }

    // Ajouter une todo via l'API
    async function addTodo(title) {
        const res = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title })
        });
        return await res.json();
    }

    // Mettre à jour une todo via l'API
    async function updateTodo(id, data) {
        const res = await fetch(`${API_URL}/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        return await res.json();
    }

    // Supprimer une todo via l'API
    async function deleteTodo(id) {
        await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
    }

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const text = input.value.trim();
        if (text) {
            const todo = await addTodo(text);
            const item = createTodoItem(todo);
            list.appendChild(item);
            input.value = '';
        }
    });

    fetchTodos();
});