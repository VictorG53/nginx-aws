document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('todo-form');
    const input = document.getElementById('todo-input');
    const list = document.getElementById('todo-list');

    function createTodoItem(text) {
        const li = document.createElement('li');
        li.className = 'todo-item';

        const label = document.createElement('label');
        label.textContent = text;

        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.addEventListener('change', () => {
            li.classList.toggle('completed', checkbox.checked);
        });

        const deleteBtn = document.createElement('button');
        deleteBtn.textContent = 'Supprimer';
        deleteBtn.addEventListener('click', () => {
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

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        const text = input.value.trim();
        if (text) {
            const item = createTodoItem(text);
            list.appendChild(item);
            input.value = '';
        }
    });
});