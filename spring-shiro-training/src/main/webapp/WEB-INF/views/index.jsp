<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/commons/basejs.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>主页</title>
<script type="text/javascript">
	//根据当前登录用户角色查询菜单
	var index_layout;
	var index_tabs;
	var layout_west_tree;
	var layout_west_tree_url = '${path }/resource/tree';

	$(function() {
		//异步请求数据 
		$
				.ajax({
					type : "post",
					url : layout_west_tree_url,
					cache : false,
					async : false,
					dataType : "json",
					success : function(datas) {
						var parentTreeLenth = datas.length;
						var divOuterContent = '';
						for (var i = 0; i < parentTreeLenth; i++) {
							divOuterContent += '<div class="panel" > '
									+ '<div class="panel-header accordion-header ';
									
									divOuterContent += '"> <div class="panel-title" onclick="showItem(this)">'
									+ datas[i].text
									+ '</div>'
									+ '<div class="panel-tool">'
									+ '<a class="accordion-collapse accordion-expand" href="javascript:void(0)" onclick="changeCss(this)" >'
									+ '</a></div></div>'
									+ '<div  class="panel-body accordion-body" style="overflow: auto; display: none;"> ';
							var childTreeData = datas[i].children;
							for (var j = 0; j < childTreeData.length; j++) {
								//alert(childTreeData[j].text);
								var itemName = childTreeData[j].text;
								var itemUrl = "${path }" + childTreeData[j].attributes;
								divOuterContent += '<div class="nav-item"> <a href=javascript:addTab("' + itemName + '","' + itemUrl
										+ '","menu_icon_datadeal")>';
								divOuterContent += '<span class="menu_icon_datadeal"></span> <span>' + itemName + '</span></a></div>';
							}
							divOuterContent += '</div></div>';

						}
						//alert(divOuterContent);
						$('#layout_west_tree').html(divOuterContent);

					}

				});

		index_layout = $('#index_layout').layout({
			fit : true
		});
		index_tabs = $('#index_tabs').tabs({
			fit : true,
			border : false,
			tools : [ {
				iconCls : 'icon-home',
				handler : function() {
					index_tabs.tabs('select', 0);
				}
			}, {
				iconCls : 'icon-refresh',
				handler : function() {
					var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
					index_tabs.tabs('getTab', index).panel('open').panel('refresh');
				}
			}, {
				iconCls : 'icon-del',
				handler : function() {
					var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
					var tab = index_tabs.tabs('getTab', index);
					if (tab.panel('options').closable) {
						index_tabs.tabs('close', index);
					}
				}
			} ]
		});
	});
	
	function showItem(obj){
		changeCss($(obj).next().children());
		
		
	}

	function changeCss(obj) {
	
	    if ($(obj).attr("class") == 'accordion-collapse') {
			$(obj).addClass("accordion-expand");
			$(obj).parent().parent().next().hide();
			
		} else{
			$("[class='accordion-collapse']").each(function() {
				$(this).addClass("accordion-expand");
			});
			$(obj).removeClass("accordion-expand");
			$("[class='panel-body accordion-body']").each(function() {
				$(this).prev().removeClass("accordion-header-selected");
				$(this).hide();
			});
			$(obj).parent().parent().next().show();
			$(obj).parent().parent().addClass("accordion-header-selected");
		}

	}

	function addTab(title, href, icon) {
		var tt = $('#index_tabs');
		icon = icon || 'menu_icon_service';
		if (tt.tabs('exists', title)) {
			tt.tabs('select', title);
			var currTab = tt.tabs('getTab', title);
			tt.tabs('update', {
				tab : currTab,
				options : {
					content : content,
					closable : true
				}
			});
		} else {
			if (href) {
				var content = '<iframe frameborder="0" src="' + href + '" style="border:0;width:100%;height:99.5%;"></iframe>';
			} else {
				var content = '未实现';
			}
			tt.tabs('add', {
				title : title,
				content : content,
				closable : true,
				iconCls : icon
			});
		}
	}

	function logout() {
		$.messager.confirm('提示', '确定要退出?', function(r) {
			if (r) {
				progressLoad();
				$.post('${path }/logout', function(result) {
					if (result.success) {
						progressClose();
						window.location.href = '${path }';
					}
				}, 'json');
			}
		});
	}

	function editUserPwd() {
		parent.$.modalDialog({
			title : '修改密码',
			width : 300,
			height : 250,
			href : '${path }/user/editPwdPage',
			buttons : [ {
				text : '确定',
				handler : function() {
					var f = parent.$.modalDialog.handler.find('#editUserPwdForm');
					f.submit();
				}
			} ]
		});
	}
</script>
</head>
<body>
	<div id="loading"
		style="position: fixed; top: -50%; left: -50%; width: 200%; height: 200%; background: #fff; z-index: 100; overflow: hidden;">
		<img src="${staticPath }/static/style/images/ajax-loader.gif"
			style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; margin: auto;" />
	</div>
	<div id="index_layout">
		<div data-options="region:'north',border:false" style="overflow: hidden;">
			<div>
				<span style="float: right; padding-right: 20px; margin-top: 15px; color: #333">欢迎 <b><shiro:principal></shiro:principal></b>&nbsp;&nbsp;
					<shiro:hasPermission name="/user/editPwdPage">
						<a href="javascript:void(0)" onclick="editUserPwd()" class="easyui-linkbutton" plain="true" icon="icon-edit">修改密码</a>
					</shiro:hasPermission>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="logout()" class="easyui-linkbutton" plain="true" icon="icon-clear">安全退出</a></span> <span
					class="header"></span>
			</div>
		</div>
		<div data-options="region:'west',split:true" title="菜单" style="width: 200px; overflow: hidden; overflow-y: auto; padding: 0px">
			<!-- <div class="easyui-accordion  i_accordion_menu" id="layout_west_tree" fit="true" border="false"></div> -->

			<div class="easyui-accordion  i_accordion_menu accordion accordion-noborder easyui-fluid" style="width: 153px; height: 457px;"
				border="false" fit="true" id="layout_west_tree"></div>

		</div>
		<div data-options="region:'center'" style="overflow: hidden;">
			<div id="index_tabs" style="overflow: hidden;">
				<div title="首页" data-options="border:false" style="overflow: hidden;">
					<h2 style="padding-left: 5px;">欢迎使用</h2>
					<!-- <script src='https://git.oschina.net/wangzhixuan/spring-shiro-training/widget_preview'></script>
                    <style>
                        .pro_name a{color: #4183c4;}
                        .osc_git_title{background-color: #d8e5f1;}
                        .osc_git_box{background-color: #fafafa;}
                        .osc_git_box{border-color: #ddd;}
                        .osc_git_info{color: #666;}
                        .osc_git_main a{color: #4183c4;}
                    </style> -->
				</div>
			</div>
		</div>
		<div data-options="region:'south',border:false"
			style="height: 30px; line-height: 30px; overflow: hidden; text-align: center; background-color: #eee">Copyright © 2016</div>
	</div>

	<!--[if lte IE 7]>
    <div id="ie6-warning"><p>您正在使用 低版本浏览器，在本页面可能会导致部分功能无法使用。建议您升级到 <a href="http://www.microsoft.com/china/windows/internet-explorer/" target="_blank">Internet Explorer 8</a> 或以下浏览器：
    <a href="http://www.mozillaonline.com/" target="_blank">Firefox</a> / <a href="http://www.google.com/chrome/?hl=zh-CN" target="_blank">Chrome</a> / <a href="http://www.apple.com.cn/safari/" target="_blank">Safari</a> / <a href="http://www.operachina.com/" target="_blank">Opera</a></p></div>
    <![endif]-->

	<style>
/*ie6提示*/
#ie6-warning {
	width: 100%;
	position: absolute;
	top: 0;
	left: 0;
	background: #fae692;
	padding: 5px 0;
	font-size: 12px
}

#ie6-warning p {
	width: 960px;
	margin: 0 auto;
}
</style>
</body>
</html>