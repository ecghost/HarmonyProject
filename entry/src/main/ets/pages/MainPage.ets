import { DailyData, UserStore } from '../model/information'

@Component
export struct Main {
  @State userHeight: number = 175
  @State userWeight: number = 65
  @State userAge: number = 25
  @State isMale: boolean = true

  @StorageLink('healthHistory') historyData: Record<string, DailyData> = {}

  saveDailyRecord() {
    const today = new Date().toISOString().split('T')[0]
    const data: DailyData = {
      height: this.userHeight,
      weight: this.userWeight,
      age: this.userAge,
      bmi: this.calculateBMI(),
      bmr: this.calculateBMR(),
      recommendedWater: this.calculateWater(),
      actualWater: 0 // 初始实际饮水为0
    }

    this.historyData[today] = data
    AppStorage.SetOrCreate('healthHistory', this.historyData)

    AlertDialog.show({ message: '今日健康数据已保存至日历' })
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('个人健康概览')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 10, bottom: 10 })

        this.bodyInputCard()

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          this.statCard('BMI', `${this.calculateBMI()}`, this.getBMIStatus(), this.getBMIColor(), '#F6FFED')
          this.statCard('基础代谢', `${this.calculateBMR()}`, 'kcal/天', '#1890FF', '#E6F7FF')
          this.statCard('建议饮水', `${this.calculateWater()}`, 'ml/天', '#13C2C2', '#E6FFF1')
        }
        .width('100%')

        Button('保存今日健康记录')
          .width('100%')
          .height(50)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#007DFF')
          .margin({ top: 20 })
          .onClick(() => this.saveDailyRecord())
      }
      .padding(16)
    }
    .backgroundColor('#F1F3F5')
  }

  @Builder
  bodyInputCard() {
    Column({ space: 12 }) {
      Row() {
        Text('性别').fontSize(16).fontWeight(FontWeight.Medium)
        Blank()
        Row() {
          Text('男').fontColor(this.isMale ? Color.White : '#666')
            .backgroundColor(this.isMale ? '#007DFF' : Color.Transparent)
            .padding({ left: 15, right: 15, top: 5, bottom: 5 }).borderRadius(6)
            .onClick(() => this.isMale = true)
          Text('女').fontColor(!this.isMale ? Color.White : '#666')
            .backgroundColor(!this.isMale ? '#FF4D4F' : Color.Transparent)
            .padding({ left: 15, right: 15, top: 5, bottom: 5 }).borderRadius(6)
            .onClick(() => this.isMale = false)
        }.backgroundColor('#E9E9E9').borderRadius(8).padding(2)
      }.width('100%')

      Divider().opacity(0.5)

      this.inputRow('身高', 'cm', this.userHeight, (v) => this.userHeight = v)
      this.inputRow('体重', 'kg', this.userWeight, (v) => {
        this.userWeight = v;
        UserStore.updateTodayTarget(v);
      })
      this.inputRow('年龄', '岁', this.userAge, (v) => this.userAge = v)
    }
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  @Builder
  inputRow(label: string, unit: string, value: number, callback: (v: number) => void) {
    Row() {
      Text(label).fontSize(16)
      Blank()
      TextInput({ text: value.toString() })
        .type(InputType.Number)
        .width(80)
        .textAlign(TextAlign.End)
        .fontColor('#007DFF')
        .fontWeight(FontWeight.Bold)
        .onChange((v) => callback(Number(v)))
      Text(unit).fontSize(14).fontColor('#999').margin({ left: 4 })
    }.width('100%')
  }

  @Builder
  statCard(title: string, value: string, subText: string, color: string, bgColor: string) {
    Column({ space: 4 }) {
      Text(title).fontSize(14).fontColor('#666')
      Text(value).fontSize(20).fontWeight(FontWeight.Bold).fontColor(color)
      Text(subText).fontSize(12).fontColor(color).opacity(0.8)
    }
    .width('31%')
    .padding(12)
    .backgroundColor(bgColor)
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
  }


  calculateBMI(): number {
    if (this.userHeight <= 0) return 0
    const h = this.userHeight / 100
    const bmi = this.userWeight / (h * h)
    return parseFloat(bmi.toFixed(1))
  }

  calculateBMR(): number {
    if (this.isMale) {
      return Math.round(10 * this.userWeight + 6.25 * this.userHeight - 5 * this.userAge + 5)
    }
    return Math.round(10 * this.userWeight + 6.25 * this.userHeight - 5 * this.userAge - 161)
  }

  calculateWater(): number {
    return Math.round(this.userWeight * 35)
  }

  getBMIStatus(): string {
    const bmi = this.calculateBMI()
    if (bmi === 0 || isNaN(bmi)) return '—'
    if (bmi < 18.5) return '偏瘦'
    if (bmi < 24) return '标准'
    if (bmi < 28) return '超重'
    return '肥胖'
  }

  getBMIColor(): string {
    const status = this.getBMIStatus()
    const colorMap: Record<string, string> = { '偏瘦': '#1890FF', '标准': '#52C41A', '超重': '#FAAD14', '肥胖': '#FF4D4F' }
    return colorMap[status] || '#999'
  }
}