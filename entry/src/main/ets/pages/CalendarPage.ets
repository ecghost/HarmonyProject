import { CalendarComponent } from './Calendar'
import { DailyData } from '../model/information'

interface ChartData {
  date: string
  value: number
}

@Component
export struct CalendarMainPage {
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @StorageLink('healthHistory') historyData: Record<string, DailyData> = {}

  @Builder TabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#666')
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)

      Rect()
        .width(this.currentIndex === index ? 30 : 0)
        .height(3)
        .fill('#007DFF')
        .margin({ top: 6 })
        .borderRadius(2)
        .animation({ duration: 200, curve: Curve.EaseInOut })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        TabContent() {
          CalendarComponent()
        }.tabBar(this.TabBuilder('历史日历', 0))

        TabContent() {
          StatisticsComponent()
        }.tabBar(this.TabBuilder('数据统计', 1))
      }
      .barHeight(56)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .vertical(false)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}

@Component
struct StatisticsComponent {
  @StorageLink('healthHistory') historyData: Record<string, DailyData> = {}

  getWeeklyData(): ChartData[] {
    let list: ChartData[] = []
    for (let i = 6; i >= 0; i--) {
      let d = new Date()
      d.setDate(d.getDate() - i)
      let key = d.toISOString().split('T')[0]
      let val = this.historyData[key]?.actualWater || 0

      list.push({ date: key.substring(5), value: val })
    }
    return list
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Column() {
          Text('近一周饮水趋势 (ml)')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 25 })

          Row() {
            ForEach(this.getWeeklyData(), (item: ChartData) => {
              Column() {
                Stack({ alignContent: Alignment.Bottom }) {
                  Rect()
                    .width(16)
                    .height(150)
                    .fill('#F1F3F5')
                    .borderRadius(8)

                  Rect()
                    .width(16)
                    .height(Math.min((item.value / 2500) * 150, 150))
                    .fill('#007DFF')
                    .borderRadius(8)
                    .animation({ duration: 500, curve: Curve.FastOutSlowIn })
                }

                Text(item.date)
                  .fontSize(10)
                  .fontColor('#999')
                  .margin({ top: 8 })
              }
            }, (item: ChartData) => item.date)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
        }
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .margin({ top: 10 })

        this.summaryCard()
      }
      .padding(16)
    }
    .scrollBar(BarState.Off)
  }

  @Builder
  summaryCard() {
    Column({ space: 12 }) {
      this.statRow('周平均饮水量', `${this.calculateAverage()} ml`)
      Divider()
      this.statRow('本周最高', `${this.calculateMax()} ml`)
    }
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
  }


  calculateAverage(): number {
    const weeklyData = this.getWeeklyData()
    if (weeklyData.length === 0) return 0
    const sum = weeklyData.reduce((s, x) => s + x.value, 0)
    return Math.round(sum / weeklyData.length)
  }

  calculateMax(): number {
    const weeklyData = this.getWeeklyData()
    if (weeklyData.length === 0) return 0
    let max = 0
    weeklyData.forEach(item => {
      if (item.value > max) max = item.value
    })
    return max
  }

  @Builder
  statRow(label: string, value: string) {
    Row() {
      Text(label).fontColor('#666')
      Blank()
      Text(value).fontWeight(FontWeight.Bold).fontColor('#333')
    }
    .width('100%')
  }
}