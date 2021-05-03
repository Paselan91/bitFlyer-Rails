<template>
  <div>
    <nuxt-link to="candle_sample">
      candle stick test
    </nuxt-link>
    <client-only>
      <div>
        <Apexchart
          width="500"
          :type="type"
          :options="chartOptions"
          :series="series"
        ></Apexchart>
      </div>
    </client-only>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "nuxt-property-decorator";

@Component
export default class GenericChart extends Vue {
  @Prop({ required: true, default: "bar" }) type: string;
  public chartOptions = {
    chart: {
      id: "vuechart-example"
    },
    xaxis: {
      categories: [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998]
    }
  };

  public series = [
    {
      name: "series-1",
      data: [30, 40, 35, 50, 49, 60, 70, 91]
    }
  ];
}
</script>
