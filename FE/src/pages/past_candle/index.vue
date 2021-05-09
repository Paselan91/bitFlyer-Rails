<!-- build用(作業中のため、docker-compose build すると落ちることがあるので) -->
<!-- <template>
<div></div>
</template> -->
<template>
  <div>
    <h1>Past Candle</h1>
    <!-- <div>
      <p>choose period</p>
      <v-select
        :items="period"
        label="Period"
        solo
      ></v-select>
    </div> -->
    <div>
      <v-btn @click="fetchPastCandle">Get Data from API</v-btn>
    </div>
    <v-btn depressed color="primary">
      <nuxt-link to="/">back</nuxt-link>
    </v-btn>

    <client-only>
      <div v-if="!isLoading" id="chart">
        <apexchart
          type="candlestick"
          height="350"
          :options="chartOptions"
          :series="series"
        ></apexchart>
      </div>
    </client-only>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "nuxt-property-decorator"
import axios from "axios"

@Component({})
export default class GenericChart extends Vue {
  isLoading: Boolean = false
  duration: string = "minutes" // TODO: hour, minutes, seconds 可変にする
  url: string = "/api/v1/fetch_past_ticker/"
  public series = [
    {
      data: []
    }
  ]

  public chartOptions = {
    chart: {
      type: "candlestick",
      height: 350
    },
    title: {
      text: "CandleStick Chart",
      align: "left"
    },
    xaxis: {
      type: "datetime",
      minHeight: undefined,
      maxHeight: undefined
    },
    yaxis: {
      tooltip: {
        enabled: true
      },
      min: undefined,
      max: undefined
    }
  }

  async fetchPastCandle() {
    this.isLoading = true
    const requestData = { duration: this.duration }
    let data: Array<any>
    await axios
      .get(this.url, { params: requestData })
      .then(res => {
        if (res.status === 200) {
          data = res.data.result["86400"]

          /**
           *  Response
           *  https://docs.cryptowat.ch/rest-api/markets/ohlc
           *
           * [
           *  CloseTime,
           *  OpenPrice,
           *  HighPrice,
           *  LowPrice,
           *  ClosePrice,
           *  Volume,
           *  QuoteVolume
           * ]
           *
           *
           **/
          const chartData: any = data.map(value => ({
            x: new Date(value[0] * 1000),
            y: [value[1], value[2], value[3], value[4]]
          }))

          this.series = [
            {
              data: chartData
            }
          ]

          // this.chartOptions.yaxis.max = Math.max(
          //   ...chartData.map(value => value.y[1])
          // )
          // this.chartOptions.yaxis.min = Math.min(
          //   ...chartData.map(value => value.y[2])
          // )

          // this.chartOptions.xaxis.maxHeight = Math.max(
          //   ...chartData.map(value => value.x)
          // )
          // this.chartOptions.xaxis.minHeight = Math.min(
          //   ...chartData.map(value => value.x)
          // )
        }
      })
      .catch(e => {
        console.error("Apiの取得に失敗しました")
        console.error(e)
        return false
      })
    this.isLoading = false
  }

  @Prop({ required: true, default: "bar" }) type: string
}
</script>
