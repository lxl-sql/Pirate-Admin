<!-- 代码片段 -->
<script setup lang="ts">
// 引入 highlightJS
import hlJSVuePlugin from '@highlightjs/vue-plugin'
import 'highlight.js/styles/atom-one-light.min.css'
// import 'highlight.js/styles/atom-one-dark.min.css'
import hlJS from 'highlight.js/lib/core';
import javascript from 'highlight.js/lib/languages/javascript';
import json from "highlight.js/lib/languages/json";
import {js_beautify} from 'js-beautify';
import {ref, watchEffect} from "vue";
import {setTimeoutPromise,} from "@/utils/common";
import {throttle} from 'lodash-es'
import {useClipboard} from "@vueuse/core";

const highlightjs = hlJSVuePlugin.component

hlJS.registerLanguage('javascript', javascript);
hlJS.registerLanguage('json', json);

interface CodeSegmentProps {
  text?: string
}

const props = withDefaults(defineProps<CodeSegmentProps>(), {
  text: ''
})
const {copy} = useClipboard()

const codeFormat = ref<string>(props.text || '')
const hasCopy = ref<boolean>(false)

watchEffect(() => {
  if (props.text) {
    codeFormat.value = js_beautify(props.text, {
      indent_size: 2,
      space_in_empty_paren: true,
    });
  }
});

// 复制
const handleCopy = throttle(async () => {
  hasCopy.value = true;
  copy(codeFormat.value)
  await setTimeoutPromise(4500)
  hasCopy.value = false
}, 5000)

defineOptions({
  name: "CodeSegment",
})
</script>

<template>
  <div class="group relative">
    <i-button
      type="success"
      size="small"
      class="hidden group-hover:inline-block absolute top-2 right-2 z-1 !text-xs"
      @click="handleCopy"
    >
      {{ hasCopy ? $t('other.copied') : $t('other.copy') }}
    </i-button>
    <highlightjs
      language="json"
      :autodetect="false"
      :code="codeFormat"
    />
    <small
      class="bg-black/30 text-white/80 absolute bottom-0 right-0 uppercase font-bold text-xs rounded-tl-md box-border px-2 py-1 z-0 scale-75 origin-bottom-right"
    >
      json
    </small>
  </div>
</template>
