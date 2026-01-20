export interface HealthSection {
  subtitle: string;
  detail: string;
}

export interface HealthArticle {
  id: string;
  title: string;
  category: string;
  keywords: string[];
  sections: HealthSection[];
  summary: string;
}

export const HEALTH_KNOWLEDGE_BASE: HealthArticle[] = [
  {
    id: '1',
    category: '饮水',
    title: '科学饮水指南',
    keywords: ['喝水', '饮水', '水分', '口渴', '补水', '脱水'],
    sections: [
      { subtitle: '维持代谢', detail: '水分参与全身生化反应，帮助营养运输与废物排泄。' },
      { subtitle: '润滑保护', detail: '保护脊髓等敏感组织，并起到润滑关节的作用。' },
      { subtitle: '饮水信号', detail: '不要等口渴再喝水，口渴时身体已处于轻度脱水状态。' }
    ],
    summary: '建议成年人每日分次饮用 1500-2000ml 水，少量多次效果更佳。'
  },
  {
    id: '2',
    category: 'BMI',
    title: '深入理解 BMI 指标',
    keywords: ['BMI', '肥胖', '体重', '体脂', '标准', '身材'],
    sections: [
      { subtitle: '计算公式', detail: 'BMI = 体重(kg) / 身高的平方(m²)。' },
      { subtitle: '中国标准', detail: '18.5-23.9正常，24-27.9超重，28及以上为肥胖。' },
      { subtitle: '局限性', detail: 'BMI无法区分肌肉和脂肪，健身人群需参考体脂率。' }
    ],
    summary: 'BMI 是衡量群体健康风险的简便工具，但不代表绝对体脂水平。'
  },
  {
    id: '3',
    category: '运动',
    title: '有氧与无氧运动组合',
    keywords: ['运动', '跑步', '健身', '力量', '燃脂', '增肌'],
    sections: [
      { subtitle: '有氧运动', detail: '如慢跑、游泳，主要消耗脂肪，提升心肺耐力。' },
      { subtitle: '无氧运动', detail: '如举铁、抗阻训练，旨在增加肌肉量，提高基础代谢。' },
      { subtitle: '运动建议', detail: '建议“有氧+力量”结合，每周至少 150 分钟中等强度运动。' }
    ],
    summary: '肌肉量的增加能让你在睡觉时也消耗更多热量。'
  },
  {
    id: '4',
    category: '饮食',
    title: '限盐控钠小技巧',
    keywords: ['盐', '钠', '高血压', '饮食', '清淡', '重口味'],
    sections: [
      { subtitle: '限量标准', detail: '成年人每天盐摄入量不应超过 5 克（约一平勺）。' },
      { subtitle: '隐藏钠源', detail: '挂面、面包、酱油等调味品中含有大量“隐形盐”。' },
      { subtitle: '口味替代', detail: '利用柠檬汁、醋、葱姜蒜等天然香料替代食盐。' }
    ],
    summary: '控盐是预防高血压最经济有效的健康投资。'
  },
  {
    id: '5',
    category: '睡眠',
    title: '优质睡眠的三个标准',
    keywords: ['睡眠', '熬夜', '失眠', '休息', '作息'],
    sections: [
      { subtitle: '时长充足', detail: '成年人建议保证每天 7-9 小时的睡眠时间。' },
      { subtitle: '入睡高效', detail: '能在 30 分钟内入睡，且夜间醒来次数少。' },
      { subtitle: '醒后状态', detail: '醒后精神焕发，没有明显的疲劳感或昏沉感。' }
    ],
    summary: '规律的作息比偶尔的长睡更重要。'
  }
];