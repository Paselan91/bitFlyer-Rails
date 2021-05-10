<!-- build用(作業中のため、docker-compose build すると落ちることがあるので) -->
<!-- <template>
<div></div>
</template> -->
<template>
  <div>
    <h1>Past Candle</h1>
    <div>
      <h3>Choose period</h3>
      <v-select
        v-model="select"
        :items="period"
        label="Period"
        item-text="label"
        item-value="value"
        solo
        return-object
      ></v-select>
    </div>
    <div>
      <h3>Choose date</h3>
      <v-container fluid>
        <p>{{ isBefore }}</p>
        <v-radio-group v-model="isBefore" mandatory>
          <v-radio label="Before" value="true"></v-radio>
          <v-radio label="After" value="false"></v-radio>
        </v-radio-group>
      </v-container>

      <v-container>
        <v-row>
          <v-col cols="12" lg="6">
            <v-menu
              :close-on-content-click="false"
              transition="scale-transition"
              offset-y
              max-width="290px"
              min-width="auto"
            >
              <template #activator="{ on, attrs }">
                <v-text-field
                  v-model="computedDateFormatted"
                  label="Date"
                  hint="MM/DD/YYYY format"
                  persistent-hint
                  prepend-icon="mdi-calendar"
                  v-bind="attrs"
                  @blur="date = parseDate(dateFormatted)"
                  v-on="on"
                ></v-text-field>
              </template>
              <v-date-picker v-model="date" no-title></v-date-picker>
            </v-menu>
            <p>
              Date in ISO format: <strong>{{ date }}</strong>
            </p>
          </v-col>
        </v-row>
      </v-container>
    </div>
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
import { Component, Prop, Vue, Watch } from "nuxt-property-decorator"
import axios from "axios"

@Component({})
export default class GenericChart extends Vue {
  isLoading: Boolean = false
  duration: string = "minutes" // TODO: hour, minutes, seconds 可変にする
  url: string = "/api/v1/fetch_past_ticker/"

  // periodに関する処理
  period: Array<object> = [
    { label: "1m", value: 60 },
    { label: "3m", value: 180 },
    { label: "5m", value: 300 },
    { label: "5m", value: 900 },
    { label: "15m", value: 1800 },
    { label: "30m", value: 3600 },
    { label: "1h", value: 7200 },
    { label: "2h", value: 14400 },
    { label: "4h", value: 21600 },
    { label: "6h", value: 43200 },
    { label: "12h", value: 86400 },
    { label: "1d", value: 259200 },
    { label: "3d", value: 604800 }
  ]

  select = { label: "1m", value: 60 }

  isBefore: Boolean = true

  date = new Date().toISOString().substr(0, 10)
  dateFormatted = this.formatDate(new Date().toISOString().substr(0, 10))
  get computedDateFormatted() {
    return this.formatDate(this.date)
  }

  formatDate(date) {
    if (!date) return null

    const [year, month, day] = date.split("-")
    return `${month}/${day}/${year}`
  }

  parseDate(date) {
    if (!date) return null

    const [month, day, year] = date.split("/")
    return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`
  }

  @Watch("data")
  watchDate() {
    this.dateFormatted = this.formatDate(this.date)
  }

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
