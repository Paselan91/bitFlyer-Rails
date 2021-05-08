# bitFlyer-Rails

#### トラブルシューティング
docker-compose up に失敗する場合は下記コマンドを実行し、再度 docker-compose up
```bash
$ rm tmp/pids/server.pid
```
Ctl + cでdockerを強制終了したことにより、pidファイルが残っているため（らしい）
