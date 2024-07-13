import {
  FileType, HttpRequestHeader,
  ItemRender,
  ShowUploadListInterface, UploadChangeParam,
  UploadFile,
  UploadListProgressProps,
  UploadListType, UploadLocale, UploadType
} from "ant-design-vue/es/upload/interface";
import type {VueNode} from "ant-design-vue/es/_util/type";
import type {UploadRequestOption as RcCustomRequestOptions} from "ant-design-vue/es/vc-upload/interface";

export interface IUploadProps<T = any> {
  /**
   * upload 占位内容
   * @default 上传
   */
  placeholder?: string;
  /**
   * 上传文件大小
   */
  size?: number;
  /**
   * 手机设备如何选择相册或文件夹
   *
   * 你可以设置 :capture="null"
   */
  capture: {
    type: import("vue").PropType<boolean | "user" | "environment">;
    default: boolean | "user" | "environment";
  };
  type: {
    type: import("vue").PropType<UploadType>;
    default: UploadType;
  };
  /**
   * 	发到后台的文件参数名
   */
  name: StringConstructor;
  /**
   * 	已经上传的文件列表（受控）
   */
  fileList: {
    type: import("vue").PropType<UploadFile<T>[]>;
    default: UploadFile<T>[];
  };
  /**
   * 	上传的地址
   */
  action: {
    type: import("vue").PropType<string | ((file: FileType) => string) | ((file: FileType) => PromiseLike<string>)>;
    default: string | ((file: FileType) => string) | ((file: FileType) => PromiseLike<string>);
  };
  /**
   * 支持上传文件夹（[caniuse](https://caniuse.com/#feat=input-file-directory)）
   */
  directory: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 上传所需参数或返回上传参数的方法
   */
  data: {
    type: import("vue").PropType<Record<string, unknown> | ((file: UploadFile<T>) => Record<string, unknown> | Promise<Record<string, unknown>>)>;
    default: Record<string, unknown> | ((file: UploadFile<T>) => Record<string, unknown> | Promise<Record<string, unknown>>);
  };
  /**
   * 	上传请求的 http method
   */
  method: {
    type: import("vue").PropType<"post" | "POST" | "PUT" | "PATCH" | "put" | "patch">;
    default: "post" | "POST" | "PUT" | "PATCH" | "put" | "patch";
  };
  /**
   * 	设置上传的请求头部，IE10 以上有效
   */
  headers: {
    type: import("vue").PropType<HttpRequestHeader>;
    default: HttpRequestHeader;
  };
  /**
   * 是否展示 uploadList, 可设为一个对象，用于单独设定 `showPreviewIcon`, `showRemoveIcon` 和 `showDownloadIcon`
   */
  showUploadList: {
    type: import("vue").PropType<boolean | ShowUploadListInterface>;
    default: boolean | ShowUploadListInterface;
  };
  /**
   * 	是否支持多选文件，`ie10+` 支持。开启后按住 ctrl 可选择多个文件。
   */
  multiple: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 接受上传的文件类型, 详见 [input accept Attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept)
   */
  accept: StringConstructor;
  /**
   * 	上传文件之前的钩子，参数为上传的文件，若返回 `false` 则停止上传。支持返回一个 Promise 对象，Promise 对象 reject 时则停止上传，resolve 时开始上传（ resolve 传入 `File` 或 `Blob` 对象则上传 resolve 传入对象）。
   */
  beforeUpload: {
    type: import("vue").PropType<(file: FileType, FileList: FileType[]) => BeforeUploadValueType | Promise<BeforeUploadValueType>>;
    default: (file: FileType, FileList: FileType[]) => BeforeUploadValueType | Promise<BeforeUploadValueType>;
  };
  /**
   * 	上传列表的内建样式，支持三种基本样式 `text`, `picture` 和 `picture-card`
   */
  listType: {
    type: import("vue").PropType<UploadListType>;
    default: UploadListType;
  };
  /**
   * 服务端渲染时需要打开这个
   */
  supportServerRender: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 是否禁用
   */
  disabled: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 通过覆盖默认的上传行为，可以自定义自己的上传实现
   */
  customRequest: {
    type: import("vue").PropType<(options: RcCustomRequestOptions) => void>;
    default: (options: RcCustomRequestOptions) => void;
  };
  /**
   * 	上传请求时是否携带 cookie
   */
  withCredentials: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 	点击打开文件对话框
   */
  openFileDialogOnClick: {
    type: BooleanConstructor;
    default: boolean;
  };
  /**
   * 自定义文件预览逻辑
   */
  previewFile: {
    type: import("vue").PropType<PreviewFileHandler>;
    default: PreviewFileHandler;
  };
  /**
   * 自定义显示 icon
   * @param opt
   */
  iconRender: {
    type: import("vue").PropType<(opt: {
      file: UploadFile<T>;
      listType?: UploadListType;
    }) => VueNode>;
    default: (opt: {
      file: UploadFile<T>;
      listType?: UploadListType;
    }) => VueNode;
  };
  /**
   * 自定义缩略图是否使用 <img /> 标签进行显示
   */
  isImageUrl: {
    type: import("vue").PropType<(file: UploadFile) => boolean>;
    default: (file: UploadFile) => boolean;
  };
  /**
   * 自定义进度条样式
   */
  progress: {
    type: import("vue").PropType<UploadListProgressProps>;
    default: UploadListProgressProps;
  };
  /**
   * 自定义上传列表项
   */
  itemRender: {
    type: import("vue").PropType<ItemRender<T>>;
    default: ItemRender<T>;
  };
  /**
   * 配置 `fileList` 的最大数量。当 `maxCount` 为 1 时将替换当前文件
   */
  maxCount: NumberConstructor;
  /**
   * 自定义删除 icon
   * @param opt {UploadFile}
   */
  removeIcon: {
    type: import("vue").PropType<(opt: {
      file: UploadFile;
    }) => VueNode>;
    default: (opt: {
      file: UploadFile;
    }) => VueNode;
  };
  /**
   * 	自定义下载 icon
   */
  downloadIcon: {
    type: import("vue").PropType<(opt: {
      file: UploadFile;
    }) => VueNode>;
    default: (opt: {
      file: UploadFile;
    }) => VueNode;
  };
  /**
   * 	自定义预览 icon
   */
  previewIcon: {
    type: import("vue").PropType<(opt: {
      file: UploadFile;
    }) => VueNode>;
    default: (opt: {
      file: UploadFile;
    }) => VueNode;
  };
}
