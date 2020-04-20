#!/usr/bin/env tarantool

local json = require('json')
local log = require('log')

box.cfg{}

box.once('init', function()
    box.schema.create_space('dict')
    box.space.dict:create_index(
        'primary', {type = 'hash', parts = {1, 'string'}}
    )
    end
)

local function get_method(req)
    local key = req:stash('id')
    local status, data = pcall(
        box.space.dict.get, box.space.dict, key) 

    if status and data then
        log.info('200')
        return {
            status = 200,
            body = json.encode(data[2])
        }
    elseif data == nil then
        log.info('404')
      	return { status = 404 }
    else
        log.info('500')
        return { status = 500 } 
    end
end

local function put_method(req)
    local key = req:stash('id')
    local status, body = pcall(req.json, req)
    local val = body['value'] 
    
    if (status == false) or (type(val) ~= 'table') then
        log.info('200')
        return { status = 400 }
    end
    local status, data = pcall(
        box.space.dict.update, box.space.dict, key, { {'=', 2, val} })

    local result = 404
    
    if data == nil then
        log.info('404')
        return { status = 404 }
    elseif status then
        log.info('200')
        return { status = 200 }
    else
        log.info('500')  
        return { status = 500 }
    end
end

local function post_method(req)
    local status, body = pcall(req.json, req) 
    local key, val = body['key'], body['value']
    
    if not status or
            (type(key) ~= 'string') or
            (type(val) ~= 'table') then
        log.info('400')
        return { status = 400 }
    end

    local status, data = pcall(
        box.space.dict.insert, box.space.dict, {key, val})
    
    if status then
        log.info('200')
        return { status = 200 }
    elseif data.code == 3 then
        log.info('409')
        return { status = 409 }
    else
        log.info('500')
        return { status = 500 }
    end
end

local function delete_method(req)
    local key = req:stash('id')
    local status, data = pcall(
        box.space.dict.delete, box.space.dict, key) 
    
    if status and data then
        log.info('200')
        return {
            status = 200,
            body = json.encode(data[2])
        }
    elseif data == nil then
        log.info('404')
      	return { status = 404 }
    else
        log.info('500')
        return { status = 500 }
    end
end

local server = require('http.server').new(nil, arg[1])
local router = require('http.router').new({charset = "utf8"})

router:route({
    path = '/kv/:id', method = 'GET'}, get_method)

router:route({
    path = '/kv', method = 'POST'}, post_method)

router:route({
    path = '/kv/:id', method = 'PUT'}, put_method)

router:route({
    path = '/kv/:id', method = 'DELETE'}, delete_method)

server:set_router(router)
server:start()
