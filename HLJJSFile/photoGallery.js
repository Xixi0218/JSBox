$vc.config({
  props: {
    title: "拍婚纱照",
    rectEdge: $rectEdge.none,
  },
});

var sectionOneHeight = 30;

$ui.render({
  views: [
    {
      type: "View",
      props: {
        identity: "Top",
      },
      layout: {
        position: "absolute",
        left: 0,
        top: 0,
        width: "100%",
        flexDirection: "column",
      },
      views: [
        {
          type: "Collection",
          props: {
            bgColor: $color("#f5f6f7"),
            identity: "tagCollectionOne",
            automaticWidth: true,
            itemSize: [40, sectionOneHeight],
            selectStyle: true,
            flowLayout: {
              type: "UICollectionViewFlowLayout",
              props: {
                minimumLineSpacing: 6,
                minimumInteritemSpacing: 6,
                scrollDirection: $scrollDirection.horizontal,
                sectionInset: [0, 16, 0, 16],
              },
            },
          },
          layout: {
            marginTop: 0,
            height: sectionOneHeight,
          },
          events: {
            didSelect: function (collectionView, section, row) {
              orderSelected = row;
              renderTagData(tagResp);
            },
          },
        },
        {
          type: "Collection",
          props: {
            bgColor: $color("#f5f6f7"),
            identity: "tagCollectionTwo",
            automaticWidth: true,
            itemSize: [40, sectionOneHeight],
            selectStyle: true,
            flowLayout: {
              type: "UICollectionViewFlowLayout",
              props: {
                minimumLineSpacing: 6,
                minimumInteritemSpacing: 6,
                scrollDirection: $scrollDirection.horizontal,
                sectionInset: [0, 16, 0, 16],
              },
            },
          },
          layout: {
            marginTop: 0,
            height: sectionOneHeight,
          },
          events: {
            didSelect: function (collectionView, section, row) {
              firstSelected = row;
              renderTagData(tagResp);
            },
          },
        },
        {
          type: "Collection",
          props: {
            bgColor: $color("#f5f6f7"),
            identity: "tagCollectionThree",
            automaticWidth: true,
            itemSize: [40, sectionOneHeight],
            selectStyle: true,
            flowLayout: {
              type: "UICollectionViewFlowLayout",
              props: {
                minimumLineSpacing: 6,
                minimumInteritemSpacing: 6,
                scrollDirection: $scrollDirection.horizontal,
                sectionInset: [0, 16, 0, 16],
              },
            },
          },
          layout: {
            marginTop: 0,
            height: sectionOneHeight,
          },
          events: {
            didSelect: function (collectionView, section, row) {
              secondSelected = row;
              renderTagData(tagResp);
            },
          },
        },
      ],
    },
    {
      type: "Collection",
      props: {
        bgColor: $color("#f5f6f7"),
        identity: "content",
        addHeaderRefresh: true,
        addFooterRefresh: true,
        automaticHeight: true,
        flowLayout: {
          type: "CHTCollectionViewWaterfallLayout",
          props: {
            minimumInteritemSpacing: 0,
            minimumColumnSpacing: 0,
            sectionInset: [0, 9, 0, 9],
            columnCount: 2,
            supportSectionColor: false,
          },
        },
      },
      layout: {
        flex: 1,
        alignItems: "center",
      },
      events: {
        didSelect: function (collectionView, indexPath) {
          $ui.push({
            url: "http://127.0.0.1:8080/tipcalcuator.js",
          });
        },
        headerRefresh: function (scrollView) {
          refetch(true);
        },
        footerRefresh: function (scrollView) {
          refetch(false);
        },
        scrollViewDidScroll: function (scrollView) {
          if (scrollView.contentOffset.y >= 0) {
            $("suspension").displayHidden = false;
            var isAlive = false;
            for (index in content.parentView.subviews) {
              var element = content.parentView.subviews[index];
              if (element == $("Top")) {
                isAlive = true;
                break;
              }
            }
            if (!isAlive) {
              content.addSubView($("Top"), [0, -90], content.parentView);
            }
          } else {
            $("suspension").displayHidden = true;
            var isAlive = false;
            for (index in content.collectionView.subviews) {
              var element = content.collectionView.subviews[index];
              if (element == $("Top")) {
                isAlive = true;
                break;
              }
            }
            if (!isAlive) {
              content.addSubView($("Top"), [0, -90], content.collectionView);
            }
          }
        },
        scrollViewWillBeginDragging: function (scrollView) {
          if (scrollView.contentOffset.y >= 0) {
            var isAlive = false;
            for (index in content.parentView.subviews) {
              var element = content.parentView.subviews[index];
              if (element == $("Top")) {
                isAlive = true;
                break;
              }
            }
            if (isAlive) {
              var frame = $("Top").frame;
              frame.y = -90;
              $("Top").frame = frame;
            }
          }
        },
      },
    },
    {
      type: "View",
      props: {
        identity: "suspension",
        displayHidden: true,
        bgColor: $color("#999999"),
      },
      layout: {
        position: "absolute",
        left: 0,
        top: 0,
        width: "100%",
        flexDirection: "column",
        alignItems: "center",
      },
      events: {
        tapped: function (tap) {
          var frame = $("Top").frame;
          frame.y = 0;
          $("Top").frame = frame;
        },
      },
      views: [
        {
          type: "Label",
          props: {
            text: "最热*内景*全部",
            align: $align.center,
          },
          layout: {
            width: 200,
            height: 30,
          },
        },
      ],
    },
  ],
});

var content = $("content");
var tagCollectionOne = $("tagCollectionOne");
var tagCollectionTwo = $("tagCollectionTwo");
var tagCollectionThree = $("tagCollectionThree");

//content的cell
content.registerCell({
  identity: "List1",
  views: [
    {
      type: "View",
      props: {
        bgColor: $color("#ffffff"),
        radius: 10,
      },
      layout: {
        marginTop: 10,
        marginLeft: 3,
        marginRight: 3,
        marginBottom: 0,
        flexDirection: "column",
      },
      views: [
        {
          type: "ImageView",
          props: {
            identity: "avatar",
            contentMode: $contentMode.scaleAspectFill,
          },
        },
        {
          type: "View",
          layout: {
            marginTop: 0,
            height: 30,
            marginLeft: 12,
            marginRight: 12,
            flexDirection: "row",
            justifyContent: "space-between",
          },
          views: [
            {
              type: "Label",
              props: {
                identity: "tag",
                font: $font("default", 12),
                textColor: $color("#F83244"),
              },
            },
            {
              type: "Label",
              props: {
                identity: "collect",
                font: $font("default", 12),
                textColor: $color("#F83244"),
              },
            },
          ],
        },
      ],
    },
  ],
});

content.registerCell({
  identity: "List2",
  views: [
    {
      type: "View",
      props: {
        bgColor: $color("#ffffff"),
        radius: 10,
      },
      layout: {
        marginTop: 10,
        marginLeft: 3,
        marginRight: 3,
        marginBottom: 0,
        flexDirection: "column",
      },
      views: [
        {
          type: "ImageView",
          props: {
            identity: "avatar",
            contentMode: $contentMode.scaleAspectFill,
          },
          layout: {
            aspectRatio: 0.75,
          },
          views: [
            {
              type: "CustomRadiusView",
              props: {
                borderTopLeftRadius: 1,
                borderTopRightRadius: 5,
                borderBottomLeftRadius: 5,
                borderBottomRightRadius: 1,
                bgColor: $color("#000000", 0.5),
              },
              layout: {
                position: "absolute",
                left: 15,
                bottom: 6,
                height: 15,
                flexDirection: "row",
              },
              views: [
                {
                  type: "Label",
                  props: {
                    identity: "feedsTag",
                    lines: 2,
                    font: $font("default", 10),
                    textColor: $color("#ffffff"),
                  },
                  layout: {
                    marginRight: 4,
                    marginLeft: 4,
                    alignItems: "center",
                  },
                },
              ],
            },
          ],
        },
        {
          type: "Label",
          props: {
            identity: "title",
            lines: 2,
            font: $font("default", 14),
            textColor: $color("#333333"),
          },
          layout: {
            marginTop: 14,
            marginRight: 12,
            marginLeft: 12,
          },
        },
        {
          type: "View",
          layout: {
            marginTop: 6,
            marginLeft: 12,
            marginRight: 12,
            justifyContent: "space-between",
            flexDirection: "row",
            alignItems: "center",
          },
          views: [
            {
              type: "Label",
              props: {
                identity: "amount",
                lines: 1,
                font: $font("default", 17),
                textColor: $color("#F83244"),
              },
            },
            {
              type: "Label",
              props: {
                identity: "sale",
                lines: 1,
                font: $font("default", 12),
                textColor: $color("#666666"),
              },
            },
          ],
        },
      ],
    },
  ],
});

//tag的cell
tagCell = {
  identity: "Cell",
  normal: {
    bgView: {
      bgColor: $color("#f5f6f7"),
    },
    tag: {
      textColor: $color("#333333"),
    },
  },
  select: {
    bgView: {
      bgColor: $color("#F83244", 0.2),
    },
    tag: {
      textColor: $color("#F83244"),
    },
  },
  views: [
    {
      type: "View",
      layout: {
        flex: 1,
        flexDirection: "column",
        justifyContent: "center",
      },
      views: [
        {
          type: "View",
          props: {
            identity: "bgView",
            bgColor: $color("#f5f6f7"),
            radius: 10,
          },
          layout: {
            height: 20,
          },
          views: [
            {
              type: "Label",
              props: {
                identity: "tag",
                lines: 1,
                font: $font("default", 12),
                textColor: $color("#333333"),
                align: $align.center,
              },
              layout: {
                marginLeft: 8,
                height: 20,
                marginRight: 8,
              },
            },
          ],
        },
      ],
    },
  ],
};

tagCollectionOne.registerCell(tagCell);
tagCollectionTwo.registerCell(tagCell);
tagCollectionThree.registerCell(tagCell);

function fetchTagData() {
  $http.get({
    url: "http://127.0.0.1:8080/photoGalleryTagData.json",
    header: {
      appve: "8.7.2.2",
      appname: "weddingUser",
      cid: "225",
      city: JSON.stringify(city),
      devicekind: "iOS",
      usersource: "phone",
    },
    handler: function (resp) {
      if (resp.status.RetCode != 200 && resp.status.RetCode != 0) {
        $ui.loading(false);
        content.endRefresh();
        return;
      }
      renderTagData(resp);

      content.addSubView($("Top"), [0, -90], content.collectionView);
      content.ignoredScrollViewContentInsetTop = 90;
      content.contentInset = [90, 0, 0, 0];
    },
  });
}

function dealData(element) {
  var tagItem = {
    identity: "Cell",
    data: {
      tag: {
        text: element.name,
      },
    },
  };
  return tagItem;
}

var orderId = 0;
var second_mark = [];
//保存resp
var tagResp = {};
var orderSelected = 0;
var firstSelected = 0;
var secondSelected = 0;
function renderTagData(resp) {
  content.setContentOffset([0, -90], false);
  var order = [];
  var markOne = [];
  var markTwo = [];
  second_mark = [];
  tagResp = resp;
  for (var index = 0; index < resp.data.order.length; index++) {
    const element = resp.data.order[index];
    if (index == orderSelected) {
      orderId = element.id;
    }
    order.push(dealData(element));
  }
  for (var index = 0; index < resp.data.marks.length; index++) {
    var mark = resp.data.marks[index];
    for (var markIndex = 0; markIndex < mark.length; markIndex++) {
      const element = mark[markIndex];
      if (index == 0) {
        if (markIndex == firstSelected) {
          second_mark.push(element.id);
        }
        markOne.push(dealData(element));
      } else if (index == 1) {
        if (markIndex == secondSelected) {
          second_mark.push(element.id);
        }
        markTwo.push(dealData(element));
      }
    }
  }
  tagCollectionOne.dataSource = order;
  tagCollectionTwo.dataSource = markOne;
  tagCollectionThree.dataSource = markTwo;
  tagCollectionOne.selectIndex = orderSelected;
  tagCollectionTwo.selectIndex = firstSelected;
  tagCollectionThree.selectIndex = secondSelected;
  refetch(true);
}

fetchTagData();

$ui.loading(true);

var city = {
  community_cid: 225,
  gps_latitude: 30.28785590277778,
  gps_city: "%E6%9D%AD%E5%B7%9E%E5%B8%82",
  gps_district: "%E8%A5%BF%E6%B9%96%E5%8C%BA",
  expo_cid: 225,
  gps_longitude: 120.1118714735243,
  gps_province: "%E6%B5%99%E6%B1%9F%E7%9C%81",
};

var page = 1;

function refetch(isRefresh) {
  var tempPage = page;
  if (isRefresh) {
    tempPage = 1;
  } else {
    tempPage = tempPage + 1;
  }
  $http.get({
    url:
      "http://127.0.0.1:8080/photoGalleryListData.json?first_mark=16715&order=" +
      orderId +
      "&page=" +
      tempPage +
      "&per_page=20",
    header: {
      appve: "8.7.2.2",
    },
    form: {
      second_mark: second_mark,
    },
    handler: function (resp) {
      if (resp.status.RetCode != 200 && resp.status.RetCode != 0) {
        $ui.loading(false);
        content.endRefresh();
        return;
      }
      page = tempPage;
      renderData(resp, isRefresh);
    },
  });
}

function renderData(resp, isRefresh) {
  var data = [];
  for (var index = 0; index < resp.data.list.length; index++) {
    var element = resp.data.list[index];

    if (element.entity_type == "photo_gallery") {
      var markText = "";
      var ratio = 1;
      if (element.entity_data.marks.length > 0) {
        markText = element.entity_data.marks[0].name;
      }
      if (
        element.entity_data.header_img.height > 0 &&
        element.entity_data.header_img.width > 0
      ) {
        ratio =
          element.entity_data.header_img.width /
          element.entity_data.header_img.height;
      }
      data.push({
        identity: "List1",
        data: {
          avatar: {
            src: element.entity_data.header_img.path,
            layout: {
              aspectRatio: ratio,
            },
          },
          tag: {
            text: markText,
          },
          collect: {
            text: element.entity_data.collected_num.toString(),
          },
        },
      });
    } else if (element.entity_type == "set_meal") {
      var elementData = element.entity_data;
      data.push({
        identity: "List2",
        data: {
          avatar: {
            src: elementData.vertical_image,
          },
          feedsTag: {
            text: elementData.feeds_tag,
          },
          title: {
            text: elementData.title,
          },
          amount: {
            text: elementData.show_price.toString(),
          },
          sale: {
            text: elementData.good_comments_count.toString(),
          },
        },
      });
    }
  }
  content.isFirstPage = isRefresh;
  content.dataSource = data;
  $ui.loading(false);
  content.endRefresh();
}
