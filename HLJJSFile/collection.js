$vc.config({
  props: {
    title: "新娘圈",
    rectEdge: $rectEdge.none,
  },
});

$ui.render({
  views: [
    {
      type: "Collection",
      props: {
        identity: "Collection",
        isAddTopRefresh: true,
        isAddBottomRefresh: true,
        automaticHeight: true,
        flowLayout: {
          type: "CHTCollectionViewWaterfallLayout",
          props: {
            minimumInteritemSpacing: 0,
            minimumColumnSpacing: 0,
            sectionInset: [0, 0, 0, 0],
            columnCount: 2,
            supportSectionColor: false,
          },
        },
      },
      layout: {
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
      },
      events: {
        didSelect: function (tableView, indexPath) {
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
      },
    },
  ],
});

var listObject = $("Collection");

listObject.registerCell({
  identity: "List1",
  views: [
    {
      type: "View",
      layout: {
        marginTop: 16,
        marginLeft: 16,
        marginRight: 16,
        marginBottom: 0,
        flexDirection: "row",
      },
      views: [
        {
          type: "ImageView",
          props: {
            identity: "avatar",
            radius: 10,
            contentMode: $contentMode.scaleAspectFill,
          },
          layout: {
            marginTop: 0,
            marginLeft: 0,
            height: 20,
            width: 20,
          },
        },
        {
          type: "Label",
          props: {
            identity: "name",
            font: $font("default", 12),
            textColor: $color("#999999"),
          },
          layout: {
            marginTop: 0,
            marginLeft: 8,
          },
        },
      ],
    },
    {
      type: "Label",
      props: {
        identity: "title",
        font: $font("bold", 18),
        textColor: $color("#000000"),
      },
      layout: {
        marginLeft: 16,
        marginTop: 10,
        marginRight: 16,
      },
    },
    {
      type: "Label",
      props: {
        identity: "desc",
        font: $font("default", 12),
        textColor: $color("#666666"),
        lines: 2,
      },
      layout: {
        marginLeft: 16,
        marginTop: 10,
        marginRight: 16,
      },
    },
    {
      type: "View",
      layout: {
        marginTop: 16,
        marginLeft: 16,
        marginRight: 16,
        marginBottom: 0,
        flexDirection: "row-reverse",
        alignItems: "center",
      },
      views: [
        {
          type: "Label",
          props: {
            identity: "parise",
            font: $font("default", 12),
            textColor: $color("#666666"),
            lines: 1,
          },
          layout: {
            marginRight: 16,
          },
        },
        {
          type: "ImageView",
          props: {
            source: "button_praise_main_norm_light_36*36",
          },
          layout: {
            marginRight: 5,
            height: 18,
            width: 18,
          },
        },
        {
          type: "Label",
          props: {
            identity: "comment",
            font: $font("default", 12),
            textColor: $color("#666666"),
          },
          layout: {
            marginRight: 16,
          },
        },
        {
          type: "ImageView",
          props: {
            source: "button_reply_lightgray_36*36",
          },
          layout: {
            marginRight: 5,
            height: 18,
            width: 18,
          },
        },
      ],
    },
  ],
});

listObject.registerCell({
  identity: "List2",
  views: [
    {
      type: "View",
      layout: {
        marginTop: 16,
        marginLeft: 16,
        marginRight: 16,
        marginBottom: 0,
        flexDirection: "row",
      },
      views: [
        {
          type: "ImageView",
          props: {
            identity: "avatar",
            radius: 10,
            contentMode: $contentMode.scaleAspectFill,
          },
          layout: {
            marginTop: 0,
            marginLeft: 0,
            height: 20,
            width: 20,
          },
        },
        {
          type: "Label",
          props: {
            identity: "name",
            font: $font("default", 12),
            textColor: $color("#999999"),
          },
          layout: {
            marginTop: 0,
            marginLeft: 8,
          },
        },
      ],
    },
    {
      type: "Label",
      props: {
        identity: "title",
        font: $font("bold", 18),
        textColor: $color("#000000"),
      },
      layout: {
        marginLeft: 16,
        marginTop: 10,
        marginRight: 16,
      },
    },
    {
      type: "Label",
      props: {
        identity: "desc",
        font: $font("default", 12),
        textColor: $color("#666666"),
        lines: 2,
      },
      layout: {
        marginLeft: 16,
        marginTop: 10,
        marginRight: 16,
      },
    },
  ],
});

$ui.loading(true);

function refetch(isRefresh) {
  $http.get({
    url: "http://127.0.0.1:8080/collectionData.json",
    handler: function (resp) {
      renderData(resp, isRefresh);
    },
  });
}

refetch(true);

function renderData(resp, isRefresh) {
  var data = [];
  for (let index = 0; index < resp.data.list.length; index++) {
    var element = resp.data.list[index];
    $console.log(element);
    if (element.entity.user !== undefined) {
      $console.log(element.entity.user);
      data.push({
        identity: "List1",
        selectStyle: $selectStyle.none,
        data: {
          avatar: {
            src: element.entity.user.avatar,
          },
          name: {
            text: element.entity.user.nick,
          },
          title: {
            text: element.entity.title,
          },
          desc: {
            text: element.entity.content,
          },
          parise: {
            text: element.entity.up_count.toString(),
          },
          comment: {
            text: element.entity.post_count.toString(),
          },
        },
      });
    }
  }
  listObject.isRefreshJSValue = isRefresh;
  listObject.dataSource = data;
  $ui.loading(false);
  listObject.endRefresh();
}
