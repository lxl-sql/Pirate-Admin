import {FormInstance} from "ant-design-vue";
import {FormExpose} from "ant-design-vue/lib/form/Form";
import {Ref, ref} from "vue";

export default function useFormInstance() {
  const formRef = ref<FormInstance>()
  return [
    formRef as Ref<FormInstance | undefined>,
    {
      clearValidate(...args) {
        formRef.value?.clearValidate(...args)
      },
      getFieldsValue(...args) {
        formRef.value?.getFieldsValue(...args)
      },
      resetFields(...args) {
        formRef.value?.resetFields(...args)
      },
      scrollToField(...args) {
        formRef.value?.scrollToField(...args)
      },
      validate(...args) {
        formRef.value?.validate(...args)
      },
      validateFields(...args) {
        formRef.value?.validateFields(...args)
      },
    } as FormExpose
  ] as [Ref<FormInstance | undefined>, FormExpose]
}
