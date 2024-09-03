/// <reference types="vite/client" />
interface ImportMetaEnv {
  readonly VITE_NAME: string;
  readonly VITE_BASE_API: string;
  readonly VITE_FILE_VIEW_URL: string;
  readonly VITE_GITHUB_URL: string;
  readonly VITE_GITEE_URL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
