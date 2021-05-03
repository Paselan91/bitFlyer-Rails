<script lang="ts">
import { Component, Prop, mixins } from "nuxt-property-decorator";
import Chart from "chart.js";
import VueChart from "vue-chartjs";
// 棒グラフの場合は、Barを使う
const Bar = VueChart.Bar;
const reactiveProp = VueChart.mixins.reactiveProp;

@Component
// mixinsもBarに変更
export default class ChartBar extends mixins(Bar, reactiveProp) {
  @Prop({ default: {} }) chartData: Chart.ChartData;
  @Prop({ default: {} }) options: Chart.ChartOptions;

  mounted() {
    this.renderChart(this.chartData, this.options);
  }
}
</script>
