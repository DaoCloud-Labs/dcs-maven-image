# maven-for-dcs
A Maven mirroring and sources with settings.xml configuration files encapsulated for DCS pipeline packaging Java applications.
该项目主要提供了一个用于DCS流水线打包Java应用的Maven镜像。
可通过参考该项目中的配置，用于在DCS流水线的时候将被依赖的项目或Jar包推送到Nexus仓库中。
引用该依赖的项目在DCS流水线的时候拉取依赖，随后打包构建镜像。

## 文件说明
### 1.自定义settings.xml文件
在配置文件中配置有上传jar包权限的账户/密码。如果后续步骤中上传不了，需要在nexus的目标仓库（比如nexus-releases）中开启“Allow Redeploy”。
```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
 <!-- <localRepository>/Users/jiaheng/.m2/repository</localRepository> -->
 ······
    <servers>
    <server>
      <id>nexus-releases</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
    <server>
      <id>nexus-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>
    <!--<server>-->
      <!--<id>nexus-thirdparty</id>-->
      <!--<username>admin</username>-->
      <!--<password>admin123</password>-->
    <!--</server>-->
  </servers>
 ······
</settings> 
```

### 2.Dockerfile文件
基于maven镜像，通过自定义settings.xml文件覆盖默认配置。

```shell
FROM maven:3.5.2-jdk-8-alpine
COPY settings.xml /root/.m2/
```


## 具体使用
举例：auth-service的pon.xml文件中依赖了basic-data。
### 1、在被依赖项目的pom.xml中添加：
如果你需要将maven打包的jar包推送至私有仓库，你需要在项目的pon.xml文件中添加如下配置：

```xml
<distributionManagement>
	<repository>
		<!-- 注意此处需要和settings.xml中配置的id保持一致 -->
		<id>nexus-releases</id>
		<url>http://172.23.0.1:30003/repository/maven-public/</url>
	</repository>
</distributionManagement>
```

同时在dcs的maven打包阶段使用如下命令将jar包发布至nexus仓库中：`mvn clean package deploy`

![deploy](img/script.png)


### 2、在引用依赖的项目中，添加如下内容：
如果你需要在你的项目中引用私有仓库的依赖，你需要在项目的pom.xml文件中添加如下配置：

```xml
<repositories>
	<repository>
		<id>nexus-releases</id>
		<url>http://172.23.0.1:30003/repository/maven-public/</url>
	</repository>
</repositories>
```

此步骤唯一的要求是：能够访问通配置中的nexus仓库。:-D
