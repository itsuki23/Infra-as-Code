# 構成

> **EC2**  
>
> bash設定  
> yum update  
> nginx  
> mysql
>  
> rbenv, ruby, bundler, rails (require パッケージ )

>> **/var/www/**  
>> git clone

>>> **アプリ/**  

>>>> **shared/**  
>>>> .env (link_dest: アプリ/)  
>>>> master.key (link_dest: アプリ/config/)  
>>>> database.yml (link_dest: アプリ/config/) 

<br>

上記がAnsibleで構築した環境。これをテストしていく。

<br><br>

# Flow

* ServerSpecの環境構築

今回はEC2内のvar/workspaceディレクトリを作成し準備していきます。
```
$ bundle init
```
<br>

Gemfileを開き編集
```
gem 'serverspec'
gem 'rake'
```
<br>

今回はEC2内のvar/workspaceディレクトリを作成し準備していきます。
アプリ毎の管理が好みなので--path指定。ServerSpecのファイル作成も。
```
$ bundle install --path vendor/bundle
$ bundle exec serverspec-init
  --------------------
  今回はチェックするサーバー内に構築するのでlocalを選択してEnter
```
<br>


テスト実行！
```
bundle exec rspec spec/localhost/ファイル名.rb
```
<br>
<br>


# 具体的には…

* インストールされたものが入っているかどうか？
* 指定されたバージョンが間違いないか
* 起動状態になっているかどうか
* 通信の疎通は問題ないか

以上を確認していく。
<br>
<br>

# 次の工程
capistranoでのデプロイを検討中。
最終的にはこれら全ての工程をCircleCIでコントロールするのを目標とする。