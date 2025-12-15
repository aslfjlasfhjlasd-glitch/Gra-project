<template>
  <div class="w-full overflow-auto">
    <table class="w-full caption-bottom text-sm">
      <thead class="[&_tr]:border-b">
        <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
          <th
            v-for="header in headers"
            :key="header.key"
            class="h-12 px-4 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0"
          >
            {{ header.title }}
          </th>
        </tr>
      </thead>
      <tbody class="[&_tr:last-child]:border-0">
        <tr
          v-for="(item, index) in data"
          :key="index"
          class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted"
        >
          <td
            v-for="header in headers"
            :key="header.key"
            class="p-4 align-middle [&:has([role=checkbox])]:pr-0"
          >
            <slot :name="`cell-${header.key}`" :item="item" :index="index">
              {{ getNestedValue(item, header.key) }}
            </slot>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
const props = defineProps({
  headers: {
    type: Array,
    required: true
  },
  data: {
    type: Array,
    required: true
  }
});

// 获取嵌套对象的值
const getNestedValue = (obj, path) => {
  return path.split('.').reduce((o, i) => o && o[i], obj);
};
</script>