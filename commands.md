# 그룹 추가하기

```js
db.getCollection('groups').insertOne({groupId:"home",displayName:"집"})
```

# 기기 추가하기

```js
db.getCollection('devices').insertOne({allowedIps:["115.138.195.111"],deviceId:"qwreeywindows",displayName:"쿼리 윈도우",groupId:"home"})
```
