terraformからの続き  
https://github.com/itsuki23/infra-as-a-code/tree/master/terraform

# Todo

### EC2内の環境構築

* bashの設定
* yumのアップデート
* nginx
* rubyに必要なパッケージ群
* ruby, rails
* mysql
* アプリのgit clone
* capistrano用ファイルの配置

<br>



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



# 作成手順

### ansibleの確認用サンドボックスを作る
* terraformで作成したEC2のAMIを作成  
* 作成したAMIイメージからEC2を立ち上げる  
>※今回はコンソール画面から操作したが、なるべくCLIから操作したいので要調査。

<br>

### テスト実行
host情報や変数などを確認後、ローカル環境からテスト
```
$ ansible-playbook -i hosts provisioning.yml --check
```

<br>

問題がなければ実行
```
$ ansible-playbook -i hosts provisioning.yml
```

<br>

実行結果（例）↓

```
PLAY RECAP ****************************************************
ec2: ok=37    changed=36    unreachable=0  
     failed=0    skipped=0    rescued=0    ignored=0
```

<br>

問題がなければ、この時点でのAMIも作成。  
テスト実行したEC2は停止し、terraformで作成されたEC2のhost情報をansibleに記載。

### 本番用のEC2にて実行

<br>

### Why Sandbox?
今回sandboxを作ったのには理由がある
* ansibleで実行したことによる、予期しないトラブルがあった時に対処しやすい
* capistrano等、後続の実行手順でのテスト環境にもなる
* AMIの料金は安いので存分に利用！ここが一番
>※料金に関してはAMI自体は無料、EBSスナップショットのS3領域の使用量分のみ（圧縮済）

<br>

# 次の工程
### capistrano
現在勉強中...

<br>

# 参考資料
### 公式Document
https://docs.ansible.com  
何はともあれドキュメント。個人的にはとても解りにくい構成。

<br>

### Ansible徹底入門  
https://www.shoeisha.co.jp/book/detail/9784798149943  
うーん、これもvagrant前提なので解りにくかった。

Ansibleはやり始めるととっつきやすい反面、
いい資料などが見つからず、最初の敷居は高いと感じた。  

<br>

Ansibleに限っては、ドキュメントよりもQiita、githubなどの実資料を参考にディレクトリ構成やモジュールの使い方を学んだ方がいいと感じた。


