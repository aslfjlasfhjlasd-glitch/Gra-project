<template>
  <Teleport to="body">
    <Transition
      enter-active-class="duration-300 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="duration-200 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center">
        <!-- 背景遮罩 -->
        <div class="absolute inset-0 bg-black/80" @click="closeDialog" />
        
        <!-- 对话框内容 -->
        <Transition
          enter-active-class="duration-300 ease-out"
          enter-from-class="opacity-0 scale-95"
          enter-to-class="opacity-100 scale-100"
          leave-active-class="duration-200 ease-in"
          leave-from-class="opacity-100 scale-100"
          leave-to-class="opacity-0 scale-95"
        >
          <div
            v-if="isOpen"
            class="relative z-50 grid w-full max-w-lg gap-4 border bg-background p-6 shadow-lg rounded-lg md:w-full"
          >
            <!-- 标题栏 -->
            <div class="flex flex-col space-y-1.5 text-center sm:text-left">
              <h2 v-if="title" class="text-lg font-semibold leading-none tracking-tight">
                {{ title }}
              </h2>
              <p v-if="description" class="text-sm text-muted-foreground">
                {{ description }}
              </p>
            </div>
            
            <!-- 内容区域 -->
            <div class="flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2">
              <slot />
            </div>
            
            <!-- 关闭按钮 -->
            <button
              class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground"
              @click="closeDialog"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
              <span class="sr-only">Close</span>
            </button>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
  open: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  description: {
    type: String,
    default: ''
  }
});

const emit = defineEmits(['update:open', 'close']);

const isOpen = ref(props.open);

// 监听props.open变化
watch(() => props.open, (newVal) => {
  isOpen.value = newVal;
});

// 监听内部状态变化
watch(isOpen, (newVal) => {
  emit('update:open', newVal);
  if (!newVal) {
    emit('close');
  }
});

const closeDialog = () => {
  isOpen.value = false;
};
</script>