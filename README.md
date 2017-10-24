# api说明
## 登录验证 /api/login
```
curl -X POST -d "mobile=手机号, password=密码"
200:
code=0 ok
code=1 failed
401: ng
```

## 注销验证 /api/logout
```
curl -X POST -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
200:
code=0 ok
code=1 failed
401: ng
```

## 视频列表 /api/spyder_videos?page=1&per=20&state=xx&name=yy&author=zz
```
curl -X GET -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
-d "page=1, per=20, state=未处理, name=评测, author=作者"
200:
code=0 ok
code=1 failed
{
    "code": 0,
    "message": "获取成功",
    "data": {
        "videos_count": 3796,
        "videos": [
            {
                "id": 12990,
                "src": "https://www.youtube.com/watch?v=6sB3vbQd2Jw",
                "name": "新车评网：10年车龄，本田雅阁和大众帕萨特差距有多大？",
                "author": "Car 汽车社区",
                "pv": "14601",
                "video_duration": "20:39",
                "key_word": "[11, \"底盘\"]",
                "state": "未处理",
                "updated_at": "2017-06-21T15:29:39.229+08:00",
                "upload_time": "2017-06-15T15:29:39.179+08:00",
                "translate_name": null
            },
401: ng
```

## 视频处理 /api/spyder_videos/approved?id=1&translate_name=xx
```
curl -X POST -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
-d "id=1, translate_name=标题"
200:
code=0 ok
code=1 failed
```

## 视频废弃 /api/spyder_videos/disposed?id=1
```
curl -X POST -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
-d "id=1"
200:
code=0 ok
code=1 failed
```

## 视频下载 /api/spyder_videos/ready_to_download?id=1
```
curl -X POST -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
-d "id=1"
200:
code=0 ok
code=1 failed
```

## 视频状态列表 /api/spyder_videos/states
```
curl -X GET -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
200:
code=0 ok
code=1 failed
{
    "code": 0,
    "message": "获取成功",
    "data": {
        "states": [
            {
                "id": null,
                "state": "废弃"
            },
            {
                "id": null,
                "state": "已下载"
            },
            {
                "id": null,
                "state": "未处理"
            },
            {
                "id": null,
                "state": "已匹配标签"
            }
        ]
    }
}
```

## 视频回收 /api/spyder_videos/recovered?id=1
```
curl -X POST -headers "token:6a9cf2eba536229faf0299301a7ff731b535fb5559e1b6813037c5dffadba224, mobile:18018532943"
-d "id=1"
200:
code=0 ok
code=1 failed
```
