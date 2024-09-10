<p align="center">
  <a href="https://github.com/lxl-sql/Pirate-Vue">
    <img width="160" src="/packages/admin/src/assets/images/logo_piece.png">
  </a>
</p>

<h1 align="center">
  <a href="https://github.com/lxl-sql/Pirate-Vue" target="_blank">Pirate Admin - 最好的 Vue 通用后台管理模版</a>
</h1>
<div align="center">

[![GitHub Repo stars](https://img.shields.io/github/stars/123ten/Pirate-Vue?style=flat&logo=github)](https://github.com/123ten/Pirate-Vue)
[![GitHub forks](https://img.shields.io/github/forks/123ten/Pirate-Vue?style=flat&logo=github)](https://github.com/123ten/Pirate-Vue)
[![star](https://gitee.com/spongebob_dhl/Pirate-Vue/badge/star.svg?theme=dark)](https://gitee.com/spongebob_dhl/Pirate-Vue/stargazers)
[![fork](https://gitee.com/spongebob_dhl/Pirate-Vue/badge/fork.svg?theme=dark)](https://gitee.com/spongebob_dhl/Pirate-Vue/members)
![node version](https://img.shields.io/badge/node-%3E%3D16-green)
![pnpm version](https://img.shields.io/badge/pnpm-%3E%3D7.30-green)
![GitHub package.json version (subfolder of monorepo)](https://img.shields.io/github/package-json/v/123ten/Pirate-Vue)
![GitHub License](https://img.shields.io/github/license/123ten/Pirate-Vue)

</div>

`Pirate Admin` 是一个 通用的后台管理模板，由 `Vue3` + `Ts` + `Vite4` + `Tailwindcss` + `VSCode`(可选 `webstorm`)
实现。它使用了最新的前端技术栈，自适应PC端和移动端。

`Pirate Admin` 内置了 `约定式路由`、`layout布局`、`请求封装`、`请求拦截`、`登录拦截`、`Tailwindcss`、`i18n多语言` 等基础功能。

![](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.png)

<p align="center">
  <a href="https://admin.bqrlm.cn/" target="_blank">📱 在线预览</a>
  <!-- <span style="margin:0 10px;">|</span> -->
  <!-- <a href="https://codercup.github.io/unibest-docs/" target="_blank">📖 阅读文档</a> -->
</p>

> 在运行项目前记得先安装 mysql 以及 redis 环境

#### 初始化依赖

```bash
$ pnpm bootstrap
# 或
$ pnpm install
```

#### 启动项目

```bash
$ pnpm run start # 开发环境 对应 .env.development
# 或
$ pnpm run start:prod # 线上环境 对应 .env.production
```

#### 安装依赖

```bash
# 安装全局依赖
$ pnpm install xxx
# 安装指定package包的依赖，例如
$ pnpm -r --filter=pirate-admin install xxx
$ pnpm -r --filter=pirate-server install xxx --save-dev
```

#### 删除依赖

```bash
# 删除全局依赖
$ pnpm remove xxx
# 删除指定package包的依赖，例如
$ pnpm -r --filter=pirate-admin remove xxx
$ pnpm -r --filter=pirate-server remove xxx
```

## 布局配置

内置四套通用布局配置，以适应大部分应用场景

- 默认布局
  ![img.png](/assets/images/img.png)

- 经典布局
  ![img.png](/assets/images/img_1.png)

- 单栏布局
  ![img.png](/assets/images/img_2.png)

- 双栏布局
  ![img.png](/assets/images/img_3.png)

- 系统内置 `6套` 主题色可供选择，同时支持自定义系统主题色
  ![img.png](/assets/images/img_4.png)

- 支持系统双色切换
  ![img.png](/assets/images/img_5.png)

- 支持多类型附件预览
  ![img.png](/assets/images/img_6.png)
  ![img.png](/assets/images/img_7.png)
  ![img.png](/assets/images/img_8.png)
