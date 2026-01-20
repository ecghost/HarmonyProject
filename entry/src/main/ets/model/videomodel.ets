export interface VideoItem {
  id: string;
  title: string;
  source: Resource;
}

export const VIDEO_DATA: VideoItem[] = [
  { id: '1', title: '健康操演示', source: $rawfile('test1.mp4') },
  { id: '2', title: '饮水重要性', source: $rawfile('test2.mp4') },
  { id: '3', title: 'BMI 计算教程', source: $rawfile('test3.mp4') }
];