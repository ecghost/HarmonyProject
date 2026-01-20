import { UserStore, DailyData } from '../model/information';

@Component
export struct CalendarComponent {
  @StorageLink('healthHistory') historyData: Record<string, DailyData> = {}
  @State selectedDate: string = new Date().toISOString().split('T')[0]

  build() {
    Column({ space: 16 }) {
      Text('健康历程').fontSize(22).fontWeight(FontWeight.Bold).margin({ top: 20 })

      CalendarPicker({ selected: new Date(this.selectedDate) })
        .edgeAlign(CalendarAlign.CENTER)
        .onChange((value: Date) => {
          const newDate = `${value.getFullYear()}-${(value.getMonth() + 1).toString().padStart(2, '0')}-${value.getDate().toString().padStart(2, '0')}`
          this.selectedDate = newDate
          this.historyData = AppStorage.get<Record<string, DailyData>>('healthHistory') || {}
        })

      Scroll() {
        Column({ space: 12 }) {
          if (this.selectedDate && this.historyData[this.selectedDate]) {
            Column() {
              this.renderDataCard(this.historyData[this.selectedDate])
            }.id(`card_${this.selectedDate}_${JSON.stringify(this.historyData[this.selectedDate])}`)
          } else {
            this.renderEmptyState()
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#F1F3F5')
  }

  @Builder
  renderDataCard(data: DailyData) {
    Column({ space: 14 }) {
      Row() {
        SymbolGlyph($r('sys.symbol.calendar'))
          .fontSize(20)
          .fontColor(['#007DFF'])
        Text(` ${this.selectedDate} 记录`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
      }.width('100%')

      Divider().opacity(0.4)

      this.DataItem('身高', `${data.height} cm`)
      this.DataItem('体重', `${data.weight} kg`)
      this.DataItem('BMI', data.bmi.toFixed(2))
      this.DataItem('基础代谢', `${data.bmr} kcal`)

      Row() {
        Text('饮水进度').fontColor('#666')
        Blank()
        Text(`${data.actualWater} / ${data.recommendedWater} ml`)
          .fontWeight(FontWeight.Medium)
          .fontColor(data.actualWater >= data.recommendedWater ? '#52C41A' : '#007DFF')
      }.width('100%')

      Progress({
        value: data.actualWater,
        total: data.recommendedWater,
        type: ProgressType.Linear
      })
        .width('100%')
        .color(data.actualWater >= data.recommendedWater ? '#52C41A' : '#007DFF')
        .animation({ duration: 300 }) // 加入动画，数据变化时更顺滑
    }
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .width('100%')
    .shadow({ radius: 15, color: '#15000000' })
  }

  @Builder
  DataItem(label: string, value: string) {
    Row() {
      Text(label).fontColor('#666')
      Blank()
      Text(value).fontWeight(FontWeight.Medium).fontColor('#333')
    }.width('100%')
  }

  @Builder
  renderEmptyState() {
    Column({ space: 10 }) {
      Image($r('app.media.icon'))
        .width(100)
        .height(100)
        .opacity(0.1)
        .grayscale(1)
      Text(`${this.selectedDate}`)
        .fontSize(16)
        .fontColor('#999')
      Text('这一天没有留下健康脚印')
        .fontSize(14)
        .fontColor('#CCC')
    }
    .width('100%')
    .margin({ top: 80 })
  }
}