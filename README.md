# MLC
喜欢的功能和应用

<br/>

***
<br/>

## 终端挂代理
&emsp; 当使用CocoaPod下载非常慢时，我们可以在终端挂代理，加快下载速度。
- 查看代理：
`git config --global --get http.proxy`
`git config --global --get https.proxy`
代理为：`http://127.0.0.1:7890`

- 设置代理
`git config --global https.proxy http://127.0.0.1:7890`
`git config --global https.proxy http://127.0.0.1:7890`
或者
`export http_proxy=socks5://127.0.0.1:1080`
`export https_proxy=socks5://127.0.0.1:1080`

- 取消
`git config --global --unset http.proxy`
`git config --global --unset https.proxy`
