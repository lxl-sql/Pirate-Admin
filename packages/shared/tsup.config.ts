import { defineConfig } from 'tsup';

export default defineConfig({
  entry: [
    "src/**/*.ts"
  ],
  format: ['cjs', 'esm'],
  dts: true,
  clean: true,
  sourcemap: true,
  outDir: 'dist',
  treeshake: false,
  splitting: false,
  outExtension({ format }) {
    return {
      js: format === 'cjs' ? '.js' : '.mjs',
    };
  },
  onSuccess: 'echo Build completed successfully!'
});