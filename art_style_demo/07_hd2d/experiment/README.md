# 像素标准实验

测量与两条生产线的输出。标准正文：[`../../../docs/tech/pixel-art-standard.md`](../../../docs/tech/pixel-art-standard.md)。

```bash
python3 art_style_demo/07_hd2d/tools/pipeline_a_convert.py
python3 art_style_demo/07_hd2d/tools/pipeline_b_draw.py
python3 art_style_demo/07_hd2d/tools/measure_sprites.py
python3 art_style_demo/07_hd2d/tools/make_contact_sheet.py
```

`out/pipeline_a/` 依赖 Demo A 参考图；锤子/铁砧隔离图若本地没有 GenerateImage 缓存，对应条目会 skip。
