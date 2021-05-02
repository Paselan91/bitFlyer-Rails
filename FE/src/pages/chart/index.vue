<template>
  <div>
    <h1>チャート BitFlyer</h1>
    <p>ticker {{ ticker }}</p>
    <p>chart {{ chart }}</p>

    <nuxt-link to="/chart/chart_js_test">
      chart.jsのテストページ
    </nuxt-link>
  </div>
</template>

<script lant="ts">

export default {
  async asyncData ({ $axios }) {
    const url2 = 'http://docker.for.mac.localhost:3000/ticker/1'
    const response = await $axios.$get(url2)
    let tmp = response[0]
    console.log('tmp ')
    console.log(tmp)
    tmp = {
      open: tmp.Open
    }
    console.log('tmp.open ')
    console.log(tmp)
    return {
      ticker: response,
      chart: tmp
    }
  }
}
</script>

<style lang="scss">
</style>
