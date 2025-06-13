import { UserConfig, ConfigEnv, loadEnv } from 'vite'
import path from 'path'
import XEUtils from 'xe-utils'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import { createHtmlPlugin } from 'vite-plugin-html'
import externalGlobals from 'rollup-plugin-external-globals'

// https://vitejs.dev/config/
export default ({ mode }: ConfigEnv): UserConfig => {
  const env = loadEnv(mode, process.cwd(), 'VITE_')
  return {
    base: '/',
    plugins: [
      vue(),
      vueJsx(),
      createHtmlPlugin({
        inject: {
          data: {
            VITE_APP_BUILD_TIME: XEUtils.toDateString(new Date(), 'yyyy-MM-dd HH:mm:ss'),
            ...env
          }
        }
      })
    ],
    resolve: {
      alias: {
        '@': path.join(__dirname, './src')
      },
      extensions: ['.js', '.vue', '.json', '.ts', '.tsx']
    },
    server: {
      port: 8084
    },
    build: {
      outDir: '../api/public/initweb',
      emptyOutDir: true,
      sourcemap: false, // 关闭 sourcemap
      minify: 'terser', // 使用 terser 进行代码压缩
      terserOptions: {
        compress: {
          drop_console: true, // 去掉 console.log 等调试代码
          drop_debugger: true, // 去掉 debugger 语句
          pure_funcs: ['console.log'] // 去掉特定函数调用
        },
        format: {
          comments: false // 移除注释
        },
        mangle: {
          toplevel: true // 混淆顶级作用域变量
        }
      },
      chunkSizeWarningLimit: 500, // 提示超大 chunk 文件（可选）
      rollupOptions: {
        // 不打包依赖
        external: ['echarts'],
        plugins: [
          // 不打包依赖映射的对象
          externalGlobals({
            echarts: 'echarts'
          })
        ]
      },
      target: 'esnext' // 目标环境，选择最新的标准
    }
  }
}
