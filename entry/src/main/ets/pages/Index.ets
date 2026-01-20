import { Main } from './MainPage'
import { WaterPage } from './WaterPage'
import { CalendarMainPage } from './CalendarPage'
import { MeditationPage } from './meditationPage'
import { KnowledgePage } from './healthConsult'
import { ConsultPage, MyInformation } from './empty'

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0

  build() {
    Tabs({ index: this.currentIndex }) {

      TabContent() {
        Main()
      }
      .tabBar(this.tabItem('首页'))

      TabContent() {
        WaterPage()
      }
      .tabBar(this.tabItem('今日'))

      TabContent() {
        CalendarMainPage()
      }
      .tabBar(this.tabItem('日历'))

      TabContent() {
        MeditationPage()
      }
      .tabBar(this.tabItem('冥想'))

      TabContent() {
        KnowledgePage()
      }
      .tabBar(this.tabItem('咨询'))

      TabContent() {
        MyInformation()
      }
      .tabBar(this.tabItem('我的'))

    }
    .barPosition(BarPosition.End)
  }

  @Builder
  tabItem(title: string) {
    Column() {
      Text(title)
        .fontSize(14)
    }
    .justifyContent(FlexAlign.Center)
  }
}
