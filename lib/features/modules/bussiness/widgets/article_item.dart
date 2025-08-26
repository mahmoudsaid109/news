import 'package:flutter/material.dart';

Widget buildArticleItem(article) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage('${article['urlToImage']}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 20.0),
      Expanded(
        child: SizedBox(
          height: 120.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${article['title']}',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10.0),
              Text('${article['publishedAt']}', style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    ],
  ),
);
