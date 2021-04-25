<template>
  <div>
    <p>{{ user_test }}</p>
    <p>{{ ticker }}</p>
  </div>
</template>

<script lant="ts">

export default {
  async asyncData ({ $axios }) {
    const url1 = 'http://docker.for.mac.localhost:3000/users/index'
    const response1 = await $axios.$get(url1)

    const url2 = 'http://docker.for.mac.localhost:3000/ticker/1'
    const response2 = await $axios.$get(url2)
    return {
      user_test: response1,
      ticker: response2
    }
  }
}
</script>

<style lang="scss">
</style>
