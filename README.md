# サーバ監視

サーバにpingを送り、到達できなかったIPをLINEに通知する。

## prerequisites

1. fping in PATH

    https://github.com/dexit/fping-windows

2. LINE account

## preparations

1. IPリストを作成する

    監視したいIPをリストアップする。
    リストは`watch_server.ps1`と同じディレクトリに`servers.txt`として保存する。

    ```txt:servers.txt
    xxx.xxx.xxx.xxx
    xxx.xxx.xxx.xxx
    ```

2. LINE Notifyのトークンを生成する。

    https://notify-bot.line.me/ja/

    1. 上のリンクにアクセスする。
    2. Access Tokenを生成する。
    3. トークンを`watch_server.ps1`と同じディレクトリに`token`として保存する。

3. Windows Task Schedulerで定期実行タスクを作成する。

    1. 「基本タスクの作成」
    2. 名前を指定する。
    3. トリガーを「毎日」に設定する。

        これは一時的なもので、後ほど変更可能。
        一日に複数回実行したい、などの場合は、作成後に編集する。
    
    4. 「プログラムの開始」を選択する。

        - プログラム: Powershell実行ファイルの絶対パス
        - 引数の追加: `-File "{watch_server.ps1の絶対パス}"`

    5. 設定を確認し、「完了」する。
    6. プロパティを開き、追加の設定を行う。

        1. 「ユーザーがログオンしているかどうかにかかわらず実行する」
        2. 新規トリガーを指定する（毎時で監視したい場合など）。
        3. 「タスクを実行するためにスリープを解除する」
        4. 「既存のインスタンスの停止」

## notes

1. 設定直後は発火することを確認するために、存在しないIPをリストに含めておくのがおススメ。
2. 実行するPCは通電時に起動する設定にしておくのがおススメ。

    停電後などにサーバが復活しているか確認するため。
    BIOSの設定が必要。
