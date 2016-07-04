ubuntu16.04 lamp環境
=================

ベースとしたDockefileはこちらにあります。  
https://github.com/tutumcloud/lamp

16.04へベースを変更しphp7とmysql5.7をインストールするように設定
更にmysqlの設定方法を5.7にあわせて変更

使い方
-----

イメージの作成:
カレントに移動して以下を実行

	docker build -t ubuntu-lamp .


LAMP docker image の実行
------------------------------

コンテナの起動:

	docker run -d -p 8888:80 6666:3306 -v ($pwd)/data/app:/app ubuntu-lamp
* httpのポートは``8888``に変更  
* mysqlのポートは``6666``に変更しています  
* /appをhost側の``($pwd)data/app``にマウントしています  

起動の確認:  
windows/macにて docker-machineを使っている場合  

    $docker-machine ip
    $192.168.99.100
上記コマンドでip取得

	curl http://192.168.99.100:8888/

linux環境の場合
    
    curl http://localhost:8888/




コンテナ内からのmysql接続
----------------------------------------------------------------

Container内であればrootのパスワード無しで接続可能です:

	<?php
	$mysql = new mysqli("localhost", "root");
	echo "MySQL Server info: ".$mysql->host_info;
	?>


コンテナ外からのmysql接続
-----------------------------------------------------------------

外部からの接続を許可されたadminユーザをランダムパスワードで接続できる用に初期設定されています:

    docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                        NAMES
    13a03d2d4d4d        xenial-lamp         "/run.sh"           11 hours ago        Up 11 hours         0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp   desperate_shaw

上記のように``docker ps``にてコンテナ起動中であることを確認し

	docker logs desperate_shaw
上記のようにログ出力を確認します。


	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

上記のようにmysqlの接続例がでますのでこれを使って接続します。

You can then connect to MySQL:

	 mysql -uadmin -p47nnf4FweaKu



Adminユーザを任意のパスワードに変更したい
--------------------------------------------------------------

以下のように指定することで任意のパスワードにadminを設定することも可能です

	docker run -d -p 80:80 -p 3306:3306 -e MYSQL_PASS="mypass" tubuntu-lamp


