<!-- 菜单权限 - 添加编辑 -->
<script setup lang="ts">
import {reactive, toRaw, withDefaults,} from "vue";

interface IProps {
  title: string; // 添加编辑
  visible: boolean; // 显示与隐藏
}

const props = withDefaults(defineProps<IProps>(), {
  title: "",
  visible: false,
});
const emits = defineEmits(["onClick"]);

const formState = reactive<any>({
  ruletype: 1,
  menutype: 1,
});

const onVisibleChange = (flag: boolean) => {
};
// 确定
const onClick = () => {
  const _data = toRaw(formState);
  emits("onClick", _data);
};
</script>

<template>
  <i-modal
      :open="props.visible"
      :title="props.title"
      width="1000px"
      :maskClosable="false"
      @confirm="onClick"
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
            v-model:value="formState.region"
            placeholder="please select your zone"
        >
          <a-select-option value="shanghai">Zone one</a-select-option>
          <a-select-option value="beijing">Zone two</a-select-option>
        </a-select>
      </a-form-item>
      <a-form-item label="规则类型" name="password">
        <a-radio-group v-model:value="formState.ruletype">
          <a-radio :value="1">会员中心菜单目录</a-radio>
          <a-radio :value="2">会员中心菜单项</a-radio>
          <a-radio :value="3">页面按钮</a-radio>
          <a-radio :value="4">普通路由</a-radio>
          <a-radio :value="5">顶栏菜单项</a-radio>
        </a-radio-group>
      </a-form-item>
      <a-form-item label="规则标题" name="username">
        <a-input v-model:value="formState.username"/>
      </a-form-item>
      <a-form-item label="规则名称" name="username">
        <a-input v-model:value="formState.username"/>
        <span class="block-help">
          将注册为web端路由名称，同时作为server端API验权使用
        </span>
      </a-form-item>
      <a-form-item label="路由路径" name="username">
        <a-input v-model:value="formState.username"/>
      </a-form-item>
      <template v-if="![3,5].includes(formState.ruletype as number)">
        <a-form-item label="规则图标" name="username">
          <i-icon/>
        </a-form-item>
      </template>
      <template v-if="[2,4,5].includes(formState.ruletype as number)">
        <a-form-item
            label="菜单类型"
            name="username"
            v-if="formState.ruletype !== 4"
        >
          <a-radio-group v-model:value="formState.menutype">
            <a-radio :value="1">选项卡</a-radio>
            <a-radio :value="2">链接(站外)</a-radio>
            <a-radio :value="3">iframe</a-radio>
          </a-radio-group>
        </a-form-item>
        <template
            v-if="(formState.menutype === 1 && [2,5].includes(formState.ruletype as number))
          || formState.ruletype === 4"
        >
          <a-form-item label="组件路径" name="username">
            <a-input v-model:value="formState.username" allow-clear/>
          </a-form-item>
          <a-form-item label="扩展属性" name="username">
            <a-select
                v-model:value="formState.region"
                placeholder="please select your zone"
                allow-clear
            >
              <a-select-option value="shanghai">无</a-select-option>
              <a-select-option value="beijing">只添加为路由</a-select-option>
              <a-select-option value="beijing">只添加为菜单</a-select-option>
            </a-select>
          </a-form-item>
        </template>
        <template v-else>
          <a-form-item label="链接地址" name="username">
            <a-input v-model:value="formState.username" allow-clear/>
          </a-form-item>
        </template>
      </template>
      <template v-if="[3,4,5].includes(formState.ruletype as number)">
        <a-form-item label="游客登录" name="username">
          <a-radio-group v-model:value="formState.type">
            <a-radio :value="0">禁用</a-radio>
            <a-radio :value="1">允许</a-radio>
          </a-radio-group>
        </a-form-item>
      </template>
      <!-- <a-form-item label="链接地址" name="username">
        <a-input v-model:value="formState.username" />
      </a-form-item> -->
      <a-form-item label="规则备注" name="username">
        <a-textarea v-model:value="formState.username"/>
      </a-form-item>
      <a-form-item label="规则权重" name="username">
        <a-input-number
            v-model:value="formState.value"
            :min="0"
            style="width: 100%"
        />
      </a-form-item>
      <a-form-item label="状态" name="username">
        <a-radio-group v-model:value="formState.type">
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
