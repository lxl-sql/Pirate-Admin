<!-- 菜单权限 - 添加编辑 -->
<script setup lang="ts">
import {reactive, toRaw, withDefaults,} from "vue";
import {IFormState} from "./index";

interface IProps {
  title: string; // 添加编辑
  visible: boolean; // 显示与隐藏
}

const props = withDefaults(defineProps<IProps>(), {
  title: "",
  visible: false,
});
const emits = defineEmits(["onClick"]);

const formState = reactive<IFormState>({
  ruletype: 1,
  menutype: 1,
});

// 确定
const onClick = () => {
  const _data = toRaw(formState);
  emits("onClick", _data);
};
</script>

<template>
  <i-modal
      v-model:open="props.visible"
      :title="props.title"
      @confirm="onClick"
      width="1000px"
      :maskClosable="false"
  >
    <a-form
        :model="formState"
        name="basic"
        :label-col="{ span: 4 }"
        :wrapper-col="{ span: 18 }"
        autocomplete="off"
    >
      <a-form-item label="上级菜单规则" name="username">
        <a-select
            v-model:value="formState.menutype"
            placeholder="please select your zone"
        >
          <a-select-option value="shanghai">Zone one</a-select-option>
          <a-select-option value="beijing">Zone two</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="规则类型" name="password">
        <a-radio-group v-model:value="formState.ruletype">
          <a-radio :value="1">菜单目录</a-radio>
          <a-radio :value="2">菜单项</a-radio>
          <a-radio :value="3">页面按钮</a-radio>
        </a-radio-group>
      </a-form-item>
      <a-form-item label="规则标题" name="username">
        <a-input v-model:value="formState.menutype"/>
      </a-form-item>
      <a-form-item label="规则名称" name="username">
        <a-input v-model:value="formState.menutype"/>
      </a-form-item>
      <template v-if="formState.ruletype !== 3">
        <a-form-item label="路由路径" name="username">
          <a-input v-model:value="formState.menutype"/>
        </a-form-item>
        <a-form-item label="规则图标" name="username">
          <i-icon/>
        </a-form-item>
      </template>
      <template v-if="formState.ruletype === 2">
        <a-form-item label="菜单类型" name="username">
          <a-radio-group v-model:value="formState.menutype">
            <a-radio :value="1">选项卡</a-radio>
            <a-radio :value="2">链接(站外)</a-radio>
            <a-radio :value="3">iframe</a-radio>
          </a-radio-group>
        </a-form-item>
        <template v-if="formState.menutype === 1">
          <a-form-item label="组件路径" name="username">
            <a-input v-model:value="formState.menutype"/>
          </a-form-item>
          <a-form-item label="扩展属性" name="username">
            <a-select
                v-model:value="formState.menutype"
                placeholder="please select your zone"
            >
              <a-select-option value="shanghai">无</a-select-option>
              <a-select-option value="beijing">只添加为路由</a-select-option>
              <a-select-option value="beijing">只添加为菜单</a-select-option>
            </a-select>
          </a-form-item>
        </template>
        <template v-else>
          <a-form-item label="链接地址" name="username">
            <a-input v-model:value="formState.menutype"/>
          </a-form-item>
        </template>
      </template>
      <!-- <a-form-item label="链接地址" name="username">
        <a-input v-model:value="formState.username" />
      </a-form-item> -->
      <a-form-item label="规则备注" name="username">
        <a-textarea v-model:value="formState.menutype"/>
      </a-form-item>
      <a-form-item label="规则权重" name="username">
        <a-input-number
            v-model:value="formState.menutype"
            :min="0"
            style="width: 100%"
        />
      </a-form-item>
      <a-form-item label="缓存" name="username">
        <a-radio-group v-model:value="formState.menutype">
          <a-radio :value="0">禁用</a-radio>
          <a-radio :value="1">启用</a-radio>
        </a-radio-group>
      </a-form-item>
      <a-form-item label="状态" name="username">
        <a-radio-group v-model:value="formState.menutype">
          <a-radio :value="0">禁用</a-radio>
          <a-radio :value="1">启用</a-radio>
        </a-radio-group>
      </a-form-item>
    </a-form>
  </i-modal>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
