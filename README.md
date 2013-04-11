# chatwork-allow-origin-proxy

[chatwork-replace-icon](https://github.com/chocoby/chatwork-replace-icon) で使用するプロキシ

## 使い方

Request:

```
GET http://chatwork-allow-origin-proxy.herokuapp.com/v1/image.json?url=http://path/to/image.jpg
```

Response:

```json
{
  "status": "success",
  "data": "data:image/jpeg;base64,..."
}
```

## 注意点
* サービスが停止する可能性があります。
* Chrome Extension 化したら削除する可能性が高いです。
