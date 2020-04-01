# 構成
> **AWS**

>> **ap-northeast-1**: VPC {app} <br>
>>> **ap-northeast-1a**: <br>
>>> __Public subnet 1a: <br>
>>> ____EC2 1a {web}<br> 
>>> ____RDS master {DB}<br><br>
>>> **ap-northeast-1c**: <br>
>>> __Public subnet 1c: <br>
>>> ____EC2 1c {web} <br>
>>> ____RDS slave {DB} <br>

>> ELB: ALB for EC2 {web} <br>

>> IAM for S3 

> route53 { url: climb-match.work }

<br>

# 作成手順
変数などを確認、バイナリファイルをインストール
```
$ terraform init
```

<br>

dry-run、問題がなければ yes で実行
```
$ terraform apply
```

<br>

実行結果（例）↓

```
Apply complete! Resources: 36 added, 0 changed, 0 destroyed.

Outputs:

ALB_dns_name = climb-alb-1218765740.ap-northeast-1.elb.amazonaws.com
EC2_1a_public_IP = 54.249.56.245
EC2_1c_public_IP = 54.238.46.188
RDS_end_point = climb-rds.chtyvyhdfwvq.ap-northeast-1.rds.amazonaws.com:3306
domain_name = climb-match.work
```

<br>

curlで疎通確認

```
$ curl { url or IP }
```

<br>




# 次の工程
## Ansible
terraformではAWSのリソース作成を自動化した。  
次はansibleにてEC2内のプロビジョニングを自動化する。

<br>

先程のoutputの値は後々の工程でも使用するので控えておく
* **ALB_dns_name**: ansible(nginx.conf.j2) にて使用
* **EC2_public_IP**: ansible(hosts, nginx.conf.j2) にて使用
* **RDS_end_point**: Rails_app(.env) にて使用
* **dmain_name**: ansible(nginx.conf.j2), Rails_app(config/deploy/production.rb) にて使用

※ nginx.conf.j2に関しては都度、各疎通確認・各表示確認をしたいため、全てのip・end_point・urlを記載することにした。

<br><br><br>

節約の為、各リソースを停止にしておくこともあるかもしれないが、EC2に関してはパブリックIPの値が代わってしまう為、必要であればコマンドで確認する。コンソールにログインするよりは早いと判断。例)Tag → Name: app
```
$ aws ec2 describe-instances \
--filter 'Name=tag:Name,Values=*app*' \
--query 'Reservations[].Instances[].[PublicIpAddress, Tags[?Key==`Name`].Value]' \
--output table
```

追記）もっと簡単に出力できました！
```
$ terraform output <output時に指定した名前>　
```

<br><br>

公開鍵・秘密鍵で毎度調べなくてもよくしよう！とも考えたが以下の理由により今回は却下。
* EC2が2台以上の構成の場合に鍵を分ける、もしくはssh/configの設定を変える等の手間が増える
* なるべくssh/configをきれいに保ちたい
* pem keyでの管理ができるならそうしたい  

この辺は変更の余地あり。

<br><br>

# 参考資料
### 公式Document
https://www.terraform.io  
何はともあれドキュメント。個人的にはとてもわかりやすい構成。

<br>

### 実践terraform  
https://www.amazon.co.jp/実践Terraform-AWSにおけるシステム設計とベストプラクティス-技術の泉シリーズ（NextPublishing）-野村-友規/dp/4844378139

<br>
素晴らしい良書。わかりやすい！応用も乗ってる！どんどん楽しくなってくる！  
著者のtwitterにて続編が出るとか出ないとか…待ち遠しい！


