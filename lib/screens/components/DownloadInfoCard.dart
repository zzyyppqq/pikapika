import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pikapika/basic/Cross.dart';
import 'package:pikapika/basic/Entities.dart';
import 'package:pikapika/screens/components/Images.dart';

import '../../basic/config/CopyFullName.dart';
import 'ComicInfoCard.dart';

// 下载项
class DownloadInfoCard extends StatelessWidget {
  final DownloadComic task;
  final bool downloading;
  final bool linkItem;

  const DownloadInfoCard({
    Key? key,
    required this.task,
    this.downloading = false,
    this.linkItem = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textColor = theme.textTheme.bodyLarge!.color!;
    var textColorAlpha = textColor.withAlpha(0x33);
    var textColorSummary = textColor.withAlpha(0xCC);
    var titleStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
    );
    var categoriesStyle = TextStyle(
      fontSize: 13,
      color: textColorSummary,
    );
    var authorStyle = TextStyle(
      fontSize: 13,
      color: Colors.pink.shade300,
    );
    var iconColor = Colors.pink.shade300;
    var iconLabelStyle = TextStyle(
      fontSize: 13,
      color: iconColor,
    );
    List<dynamic> categories = json.decode(task.categories);
    var categoriesString = categories.map((e) => "$e").join(" ");
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: task.thumbLocalPath == ""
                ? RemoteImage(
                    fileServer: task.thumbFileServer,
                    path: task.thumbPath,
                    width: imageWidth,
                    height: imageHeight,
                  )
                : DownloadImage(
                    path: task.thumbLocalPath,
                    width: imageWidth,
                    height: imageHeight,
                  ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      linkItem
                          ? GestureDetector(
                              onLongPress: () {
                                if (copyFullName()) {
                                  confirmCopy(
                                      context, "${task.title} ${task.author}");
                                } else {
                                  confirmCopy(context, task.title);
                                }
                              },
                              child: Text(task.title, style: titleStyle),
                            )
                          : Text(task.title, style: titleStyle),
                      Container(height: 5),
                      linkItem
                          ? GestureDetector(
                              onLongPress: () {
                                confirmCopy(context, task.author);
                              },
                              child: Text(task.author, style: authorStyle),
                            )
                          : Text(task.author, style: authorStyle),
                      Container(height: 5),
                      Text(
                        "分类: $categoriesString",
                        style: categoriesStyle,
                      ),
                      Container(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: iconSize,
                            color: iconColor,
                          ),
                          Container(width: 5),
                          Text(
                            '下载 ${task.downloadPictureCount} / ${task.selectedPictureCount}',
                            style: iconLabelStyle,
                          ),
                          Container(width: 20),
                          task.deleting
                              ? Text('删除中',
                                  style: TextStyle(
                                      color: Color.alphaBlend(
                                          textColor.withAlpha(0x33),
                                          Colors.red.shade500)))
                              : task.downloadFailed
                                  ? Text('下载失败',
                                      style: TextStyle(
                                          color: Color.alphaBlend(
                                              textColor.withAlpha(0x33),
                                              Colors.red.shade500)))
                                  : task.downloadFinished
                                      ? Text('下载完成',
                                          style: TextStyle(
                                              color: Color.alphaBlend(
                                                  textColorAlpha,
                                                  Colors.green.shade500)))
                                      : downloading // downloader.downloadingTask() == task.id
                                          ? Text('下载中',
                                              style: TextStyle(
                                                  color: Color.alphaBlend(
                                                      textColorAlpha,
                                                      Colors
                                                          .blue.shade500)))
                                          : Text('队列中',
                                              style: TextStyle(
                                                  color: Color.alphaBlend(
                                                      textColorAlpha,
                                                      Colors.lightBlue
                                                          .shade500))),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  height: imageHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFinished(task.finished),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double imageWidth = 210 / 3.15;
double imageHeight = 315 / 3.15;
double iconSize = 15;
