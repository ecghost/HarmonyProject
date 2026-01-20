import { DailyData } from '../model/information'
import promptAction from '@ohos.promptAction';

@Component
export struct WaterPage {
  @StorageLink('healthHistory') historyData: Record<string, DailyData> = {}
  @State inputWater: string = ''

  private today: string = new Date().toISOString().split('T')[0]

  getTodayData(): DailyData {
    if (!this.historyData[this.today]) {
      this.historyData[this.today] = {
        height: 175, weight: 65, age: 25, bmi: 0, bmr: 0,
        recommendedWater: 2000,
        actualWater: 0
      }
    }
    return this.historyData[this.today]
  }

  build() {
    Column() {
      Text('饮水追踪')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 30 })

      this.waterProgressCard()

      Text('快捷加水')
        .fontSize(16)
        .fontColor('#666')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 12, left: 10 })

      this.quickActionButtons()

      this.waterInputRow()
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F1F7FF')
  }

  @Builder
  waterProgressCard() {
    Stack() {
      Progress({
        value: this.getTodayData().actualWater,
        total: this.getTodayData().recommendedWater,
        type: ProgressType.Ring
      })
        .width(220)
        .height(220)
        .style({ strokeWidth: 20 })
        .color('#007DFF')

      Column() {
        Image($r('app.media.icon'))
          .width(40).height(40).margin({ bottom: 10 })

        Text(`${this.calculatePercent()}%`)
          .fontSize(40).fontWeight(FontWeight.Bolder).fontColor('#007DFF')

        Text(`${this.getTodayData().actualWater} / ${this.getTodayData().recommendedWater} ml`)
          .fontSize(16).fontColor('#666').margin({ top: 5 })
      }
    }
    .margin({ bottom: 40 })
  }

  calculatePercent(): number {
    const data = this.getTodayData()
    if (data.recommendedWater <= 0) return 0
    return Math.min(Math.floor((data.actualWater / data.recommendedWater) * 100), 100)
  }

  @Builder
  quickActionButtons() {
    Row({ space: 15 }) {
      this.quickBtn(300, '杯')
      this.quickBtn(500, '瓶')
      this.quickBtn(1000, '大瓶')
    }
    .width('100%')
    .margin({ bottom: 30 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  quickBtn(amount: number, label: string) {
    Button() {
      Column() {
        Text(`+${amount}`).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#007DFF')
        Text(label).fontSize(12).fontColor('#666')
      }
    }
    .layoutWeight(1)
    .height(70)
    .backgroundColor(Color.White)
    .borderRadius(15)
    .shadow({ radius: 4, color: '#10000000' })
    .onClick(() => this.addWater(amount))
  }

  @Builder
  waterInputRow() {
    Row({ space: 10 }) {
      TextInput({ placeholder: '手动输入 (ml)', text: this.inputWater })
        .layoutWeight(1)
        .height(50)
        .type(InputType.Number)
        .backgroundColor(Color.White)
        .onChange(v => this.inputWater = v)

      Button('喝水')
        .height(50)
        .width(100)
        .backgroundColor('#007DFF')
        .onClick(() => {
          const val = Number(this.inputWater)
          if (val > 0) {
            this.addWater(val)
            this.inputWater = ''
          }
        })
    }
  }

  addWater(amount: number) {

    let data = this.getTodayData()
    data.actualWater += amount

    this.historyData[this.today] = {
      height: data.height,
      weight: data.weight,
      age: data.age,
      bmi: data.bmi,
      bmr: data.bmr,
      recommendedWater: data.recommendedWater,
      actualWater: data.actualWater
    }

    AppStorage.SetOrCreate('healthHistory', this.historyData)

    try {
      promptAction.showToast({
        message: `已记录饮水 ${amount}ml`,
        duration: 2000
      });
    } catch (error) {
      console.error(`showToast error: ${JSON.stringify(error)}`);
    }
  }
}