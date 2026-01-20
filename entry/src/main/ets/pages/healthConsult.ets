import { HEALTH_KNOWLEDGE_BASE, HealthArticle, HealthSection } from '../model/health_data';

@Component
export struct KnowledgePage {
  @State searchText: string = '';
  @State searchResult: HealthArticle[] = [];

  handleSearch(query: string) {
    this.searchText = query;
    if (!query.trim()) {
      this.searchResult = [];
      return;
    }

    this.searchResult = HEALTH_KNOWLEDGE_BASE.filter(item =>
    item.title.includes(query) ||
    item.keywords.some(k => k.includes(query.toLowerCase()))
    );
  }

  build() {
    Column() {
      Column() {
        Text('健康百科查询')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30, bottom: 20 })

        Search({ value: this.searchText, placeholder: '搜索：饮水、运动、BMI...' })
          .width('100%')
          .height(45)
          .onChange((v) => this.handleSearch(v))
      }
      .padding(16)
      .backgroundColor(Color.White)

      Scroll() {
        Column({ space: 15 }) {
          if (this.searchText.trim() === '') {
            this.renderSuggestions()
          } else if (this.searchResult.length > 0) {
            ForEach(this.searchResult, (item: HealthArticle) => {
              this.ArticleCard(item)
            }, (item: HealthArticle) => item.id)
          } else {
            this.renderEmptyState()
          }
        }
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder
  renderSuggestions() {
    Column({ space: 15 }) {
      Row() {
        Text('热门建议')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')

        Text(' 点击快速查询')
          .fontSize(12)
          .fontColor('#999')
          .margin({ left: 8 })
      }
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(['肥胖', '饮水', '体脂', '运动', '高血压'], (tag: string) => {
          Text(tag)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .margin({ right: 10, bottom: 10 })
            .backgroundColor('#F0F7FF')
            .fontColor('#007DFF')
            .borderRadius(15)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .onClick(() => this.handleSearch(tag))
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .margin({ bottom: 20 })
  }

  @Builder
  ArticleCard(item: HealthArticle) {
    Column({ space: 14 }) {
      Row() {
        Text(item.category)
          .fontSize(10)
          .fontColor('#007DFF')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor('#E6F7FF')
          .borderRadius(4)

        Text(item.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ left: 8 })
      }.width('100%')

      Divider().opacity(0.3)

      Column({ space: 16 }) {
        ForEach(item.sections, (sec: HealthSection) => {
          Column({ space: 4 }) {
            Row() {
              Circle({ width: 4, height: 4 }).fill('#007DFF')
                .margin({ right: 6 })
              Text(sec.subtitle)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333')
            }
            .width('100%')

            Text(sec.detail)
              .fontSize(14)
              .fontColor('#666')
              .lineHeight(22)
              .width('100%')
          }
          .alignItems(HorizontalAlign.Start)
        })
      }
      .width('100%')
      Row() {
        Rect().width(3).height(32).fill('#007DFF').borderRadius(1.5)

        Text(item.summary)
          .fontSize(14)
          .fontColor('#0056B3')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .margin({ left: 10 })
          .lineHeight(20)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#F0F7FF')
      .borderRadius(8)
    }
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .width('100%')
    .shadow({ radius: 10, color: '#0A000000', offsetY: 4 })
  }

  @Builder
  renderEmptyState() {
    Column() {
      Image($r('app.media.icon')).width(60).opacity(0.2)
      Text('未找到相关健康知识').fontColor('#999').margin({ top: 10 })
    }
    .width('100%')
    .margin({ top: 100 })
  }
}