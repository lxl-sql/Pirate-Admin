import {defineConfig} from "vite"
import vue from "@vitejs/plugin-vue"
import {join, resolve} from "path"
import fs from "fs"
import Components from "unplugin-vue-components/vite"
import {AntDesignVueResolver} from "unplugin-vue-components/resolvers"
import mkcert from "vite-plugin-mkcert"
import autoExport from 'vite-plugin-auto-export'
import {theme} from 'ant-design-vue'

const {defaultAlgorithm, defaultSeed} = theme

const mapToken = defaultAlgorithm(defaultSeed)

export default defineConfig({
  plugins: [
    vue(),
    Components({
      dirs: ["src/components"],
      resolvers: [
        AntDesignVueResolver({
          importStyle: 'less', // css in js
        })
      ],
    }),
    mkcert(),
    autoExport({
      files: [
        {
          directory: resolve(process.cwd(), "src", "locales"),
          defaultDir: ['zh', 'en'],
        }
      ],
      keywords: ['default']
    }),
  ],
  resolve: {
    alias: {
      "@": resolve(__dirname, "src"),
      "@types": resolve(__dirname, "src/types"),
      "@utils": resolve(__dirname, "src/utils"),
      "@assets": resolve(__dirname, "src/assets"),
      "@components": resolve(__dirname, "src/components"),
    },
    dedupe: [
      'vue'
    ]
  },
  server: {
    host: true, // 指定服务器应该监听哪个 IP 地址。 如果将此设置为 0.0.0.0 或者 true 将监听所有地址，包括局域网和公网地址。
    open: true, // 在开发服务器启动时自动在浏览器中打开应用程序。
    port: 4000, // 指定开发服务器端口
    hmr: true, // 热更新
    https: {
      // 主要是下面两行的配置文件，不要忘记引入 fs 和 path 两个对象
      cert: fs.readFileSync(join(__dirname, "src/ssl/cert.crt")),
      key: fs.readFileSync(join(__dirname, "src/ssl/cert.key")),
    },
    proxy: {
      "/api": {
        target: "http://localhost:3010",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ""),
      },
    },
  },

  css: {
    preprocessorOptions: {
      less: {
        // modifyVars: mapToken,
        // modifyVars: {hack: 'true; @import "@/assets/styles/less/theme.less"'},
        // modifyVars: {hack: 'true; @import "@/assets/styles/less/variables.less"'},
        modifyVars: {
          hack: 'true; @import "@/assets/styles/less/variables.less"',
        },
        javascriptEnabled: true,
        fileAsync: true,
      },
    },
  },

  build: {
    assetsInlineLimit: 8192, // 小于 8KB 的图片会被转换成 base64 编码的 Data URI 格式
    // assetsDir: "static", // 静态目录
    // rollupOptions: { //解决isCE
    //   external: ["vue"],
    //   output: {
    //     globals: {
    //       vue: 'vue'
    //     }
    //   }
    // },
  },
});
