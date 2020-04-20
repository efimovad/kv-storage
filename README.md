## API
- **POST /kv body**: {key: "test", "value": {SOME ARBITRARY JSON}}
- **PUT kv/{id} body: {"value": {SOME ARBITRARY JSON}}
- GET kv/{id}
- DELETE kv/{id}

# kv storage
##### Ссылка на деплой: https://tarantool-kvstorage.herokuapp.com/
### Задача
##### Реализовать kv хранилище, доступное по http  

### Запуск проекта
#### Локально
`$:tarantool main.lua`
#### Docker
`$:docker build -t tarantool_app .` 
`$:docker run -p 8080:8080 --name tarantool_app -t tarantool_app`
### API
#### Получение значения по ключу
##### GET /kv/{id}
#### Добавление значения по ключу
##### POST /kv 
```
{
    "key":"1234",
    "value":{
        "name":"myname"
        "age":"45"
    }
}
```
#### Обновления значения по ключу
##### PUT /kv/{id} 
```
{
    "value":{
        "name":"myname"
        "age":"45"
    }
}
```
#### Удаление значения по ключу
##### DELETE /kv/{id} 


