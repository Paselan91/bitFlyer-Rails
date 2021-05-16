<!-- buildで落ちる時用 -->
<!-- <template>
<div></div>
</template> -->
<template>
  <div>
    <v-container class="grey lighten-5 text-center">
      <h1>Past Candle</h1>
      <v-row :align="align" no-gutters>
        <v-col :cols="5">
          <v-container>
            <h3 class="text-center">Choose Period</h3>
            <v-select
              v-model="selectedPeriod"
              :items="period"
              label="Period"
              item-text="label"
              item-value="value"
              solo
              return-object
              width="100px"
            ></v-select>
          </v-container>
        </v-col>
        <v-spacer></v-spacer>
        <v-col :cols="7">
          <h3 class="text-center">Choose Date</h3>
          <v-row>
            <v-col cols="5">
              <v-container fluid>
                <v-radio-group v-model="beforeAfter" mandatory col>
                  <v-radio label="After" value="after"></v-radio>
                  <v-radio label="Before" value="before"></v-radio>
                </v-radio-group>
              </v-container>
            </v-col>
            <v-col cols="7">
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
                          persistent-hint
                          prepend-icon="mdi-calendar"
                          v-bind="attrs"
                          @blur="date = parseDate(dateFormatted)"
                          v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker v-model="date" no-title></v-date-picker>
                    </v-menu>
                  </v-col>
                </v-row>
              </v-container>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="3" offset="6">
          <h3>You selected</h3>
          <p>
            {{ this.selectedPeriod.label }} {{ this.beforeAfter }}
            {{ this.date }}
          </p>
        </v-col>
        <v-col cols="2">
          <v-btn class="my-3" @click="fetchPastCandle">Get Data</v-btn>
        </v-col>
      </v-row>
    </v-container>
    <v-container>
      <client-only>
        <div v-if="isLoading" class="text-center">
          <v-progress-circular :size="50" indeterminate></v-progress-circular>
        </div>
        <div v-else id="chart">
          <apexchart
            type="candlestick"
            height="350"
            :options="chartOptions"
            :series="series"
          ></apexchart>
        </div>
      </client-only>
    </v-container>

    <v-container class="my-5">
      <v-row justify="center">
        <v-btn to="/" nuxt elevation="3" width="10%">
          Back
        </v-btn>
      </v-row>
    </v-container>

    <v-container>
      <v-btn class="my-3 text-center" @click="checkParamerters"
        >Check Qeury Parameters</v-btn
      >
    </v-container>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue, Watch } from "nuxt-property-decorator"
import axios from "axios"

@Component({})
export default class GenericChart extends Vue {
  isLoading: Boolean = false
  url: string = "/api/v1/fetch_past_ticker/"
  beforeAfter: string = "after"

  // periodに関する処理
  period: Array<object> = [
    { label: "1m", value: 60 },
    { label: "3m", value: 180 },
    { label: "5m", value: 300 },
    { label: "15m", value: 900 },
    { label: "30m", value: 1800 },
    { label: "1h", value: 3600 },
    { label: "2h", value: 7200 },
    { label: "4h", value: 14400 },
    { label: "6h", value: 21600 },
    { label: "12h", value: 43200 },
    { label: "1d", value: 86400 },
    { label: "3d", value: 259200 },
    { label: "1w", value: 604800 }
  ]

  selectedPeriod = { label: "15m", value: 900 }

  today = new Date()
  date = new Date().toISOString().substr(0, 10)
  dateFormatted = this.formatDate(new Date().toISOString().substr(0, 10))
  get computedDateFormatted() {
    return this.formatDate(this.date)
  }

  // TODO: デバッグ用
  checkParamerters() {
    console.log("checkParamerters")
    console.log("selected period ")
    console.log(this.selectedPeriod.value)
    console.log("beforeAfter " + this.beforeAfter)
    console.log("date " + this.date)
    const unixtimestamp = Math.floor(Date.parse(this.date) / 1000)
    console.log("unixtimestamp " + unixtimestamp)

    const requestData = {
      period: this.selectedPeriod.value,
      [this.beforeAfter]: unixtimestamp
    }
    console.log("requestData")
    console.log(requestData)
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

  mounted() {
    const yesterday = new Date(this.today)
    yesterday.setDate(yesterday.getDate() - 1)
    this.date = yesterday.toISOString().substr(0, 10)
    this.fetchPastCandle()
  }

  async fetchPastCandle() {
    this.isLoading = true

    // FIXME: 変数名かえたい
    const unixtimestamp = Math.floor(Date.parse(this.date) / 1000)
    const requestData = {
      period: this.selectedPeriod.value,
      [this.beforeAfter]: unixtimestamp
    }
    // FIXME: anyに型をつける
    let data: Array<any>

    await axios
      .get(this.url, { params: requestData })
      .then(res => {
        if (res.status === 200) {
          console.log(res.data)
          data = res.data.result[this.selectedPeriod.value]

          /**
           *  Response
           *  https://docs.cryptowat.ch/rest-api/markets/ohlc
           *
           *  [
           *      CloseTime,
           *      OpenPrice,
           *      HighPrice,
           *      LowPrice,
           *      ClosePrice,
           *      Volume,
           *      QuoteVolume
           *  ]
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

          this.chartOptions.yaxis.max = Math.max(
            ...chartData.map(value => value.y[1])
          )
          this.chartOptions.yaxis.min = Math.min(
            ...chartData.map(value => value.y[2])
          )

          this.chartOptions.xaxis.maxHeight = Math.max(
            ...chartData.map(value => value.x)
          )
          this.chartOptions.xaxis.minHeight = Math.min(
            ...chartData.map(value => value.x)
          )
        }
      })
      .catch(e => {
        alert("Apiの取得に失敗しました")
        console.error(e)
        return false
      })
    this.isLoading = false
  }

  @Prop({ required: true, default: "bar" }) type: string
}
</script>
