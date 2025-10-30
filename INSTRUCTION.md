## Інструкції з Валідації Django ToDo App у Kubernetes

### Підготовка: Отримання Змінних

Виконайте ці команди, щоб отримати динамічні значення для подальших перевірок:

1.  **Отримайте ім'я Pod'а:**
    ```bash
    export TODO_POD_NAME=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')
    echo "Pod Name: $TODO_POD_NAME"
    ```

2.  **Отримайте IP-адресу Вузла (Node IP) та Порт Service:**
    ```bash
    export NODE_IP=$(kubectl get nodes -o wide --no-headers | awk '{print $6}' | head -n 1)
    export NODE_PORT=$(kubectl get svc todoapp-service -n todoapp -o jsonpath='{.spec.ports[0].nodePort}')
    echo "Application URL: http://$NODE_IP:$NODE_PORT"
    ```

---

### 1. Валідація: Застосунок Запущено

1.  **Перевірте статус Pod'а:**
    ```bash
    kubectl get pods -n todoapp -l app=todoapp
    ```
    **Очікуваний результат:** `READY 1/1` та `STATUS Running`.

2.  **Перевірка журналів (Logs):**
    ```bash
    kubectl logs -n todoapp $TODO_POD_NAME
    ```
    (Журнал має показати успішну міграцію та запуск Django сервера).

3.  **Валідація через браузер (UI):**
    Відкрийте у браузері адресу, отриману на кроці "Підготовка": `http://$NODE_IP:$NODE_PORT`.

---

### 2. Валідація: Монтування PersistentVolume (PVC)

Перевірте, що сховище змонтовано у `/app/data` і доступне для запису:

1.  **Перевірте mounted directory та запис:**
    ```bash
    kubectl exec -it -n todoapp $TODO_POD_NAME -- /bin/bash -c "ls -l /app/data"
    kubectl exec -it -n todoapp $TODO_POD_NAME -- /bin/bash -c "touch /app/data/pv_test.txt && ls /app/data"
    ```

---

### 3. Валідація: Монтування ConfigMap та Secret (Read-only)

1.  **Перевірка ConfigMap (`/app/configs`):**
    ```bash
    kubectl exec -it -n todoapp $TODO_POD_NAME -- ls -l /app/configs
    kubectl exec -it -n todoapp $TODO_POD_NAME -- cat /app/configs/PYTHONUNBUFFERED
    kubectl exec -it -n todoapp $TODO_POD_NAME -- touch /app/configs/test.txt
    ```
    **Очікується:** `Read-only file system`

2.  **Перевірка Secret (`/app/secrets`):**
    ```bash
    kubectl exec -it -n todoapp $TODO_POD_NAME -- ls -l /app/secrets
    kubectl exec -it -n todoapp $TODO_POD_NAME -- cat /app/secrets/SECRET_KEY
    kubectl exec -it -n todoapp $TODO_POD_NAME -- touch /app/secrets/test.txt
    ```
    **Очікується:** `Read-only file system`