<template>
  <div class="chart-container">
    <ChartLine :chartData="chartData" :options="chartOption" :styles="chartStyles" />
    
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "nuxt-property-decorator";
import { ChartData, ChartOptions } from "chart.js";
import ChartLine from "~/components/ChartLine.vue";
import ChartBar from "~/components/ChartBar.vue";

@Component({ components: { ChartLine, ChartBar } })
export default class ChartPage extends Vue {
  // チャートのデータ
  private chartData: ChartData = {
    // 横軸のラベル
    labels: ["A", "B", "C", "D", "E"],
    // データのリスト
    datasets: [
      {
        label: "Data One", // データのラベル
        data: [1, 5, 3, 4, 3] // データの値。labelsと同じサイズ
      },
      {
        label: "Data Two",
        data: [10, 50, 30, 40, 30]
      }
    ]
  };

  // チャートのオプション
  private chartOption: ChartOptions = {
    // アスペクト比を固定しないように変更
    maintainAspectRatio: false
  };

  // チャートのスタイル: <canvas>のstyle属性として設定
  private chartStyles = {
    height: "100%",
    width: "100%"
  };
}
</script>

<style lang="scss">
.chart-container {
  /**
   * vue-chartjsで生成する<canvas>がabsoluteのため、
   * relateveを設定
   */
  position: relative;

  /**
   * chartStylesを設定しているので、
   * height/wightが有効になる
   */
  height: 40vh;
  width: 80vw;
  margin: 0 auto;
}
</style>
