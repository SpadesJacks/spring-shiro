<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/commons/basejs.jsp"%>
<meta http-equiv="X-UA-Compatible" content="edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>十三所二三〇厂直连涉密打印设备台帐</title>
<script type="text/javascript">
	var dataGrid;
	$(function() {

		dataGrid = $('#dataGrid')
				.datagrid(
						{
							url : '${path }/secPrintInfoManage/dataGrid',
							fit : true,
							striped : true,
							rownumbers : true,
							pagination : true,
							singleSelect : true,
							idField : 'id',
							pageSize : 20,
							pageList : [ 10, 20, 30, 50 ],
							frozenColumns : [ [  {
								field : 'resperson',
								title : '责任人',
								width : 120
							}, {
								field : 'resdepart',
								title : '责任部门',
								width : 120
							},{
								width : '120',
								title : '设备编号',
								field : 'devno'
							} ] ],
							columns : [ [

									{
										field : 'region',
										title : '地区',
										width : 120
									},
									{
										width : '80',
										title : '所在房间号',
										field : 'roomno'

									},
									{
										width : '120',
										title : '资产号',
										field : 'propertyno'

									},
									{
										width : '120',
										title : '品牌',
										field : 'brand'

									},

									{
										width : '120',
										title : '型号',
										field : 'model'

									},
									{
										width : '80',
										title : '规格',
										field : 'specifications'

									},
									{
										width : '80',
										title : '序列号',
										field : 'serialno'

									},
									{
										width : '120',
										title : '使用日期',
										field : 'usedate'

									},
									{
										width : '80',
										title : '设备密级',
										field : 'devseclevel'

									},
									{
										width : '80',
										title : '用途',
										field : 'purpose'

									},
									{
										width : '80',
										title : '使用方式',
										field : 'usemethod'

									},
									{
										width : '80',
										title : '状态',
										field : 'infostatus'

									},
									{
										width : '120',
										title : '备注',
										field : 'remark'

									},
									{
										width : '140',
										title : '数据状态',
										field : 'status',
										formatter : function(value, row, index) {
											//alert(value);
											value = parseInt(value);
											switch (value) {
											case 0:
												return '已更新';
											case 1:
												return '待更新';
											default:
												return '历史数据';
											}
										}
									},
									{
										field : 'action',
										title : '操作',
										width : 130,
										formatter : function(value, row, index) {
											var str = '';
											<shiro:hasPermission name="/secPrintInfoManage/queryDetail">
											str += $
													.formatString(
															'<a href="javascript:void(0)" class="user-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\');" >编辑</a>',
															row.id);
											</shiro:hasPermission>
											<shiro:hasPermission name="/secPrintInfoManage/delete">
											str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
											str += $
													.formatString(
															'<a href="javascript:void(0)" class="user-easyui-linkbutton-del" data-options="plain:true,iconCls:\'icon-del\'" onclick="deleteFun(\'{0}\');" >删除</a>',
															row.id);
											</shiro:hasPermission>
											return str;
										}
									} ] ],
							onLoadSuccess : function(data) {
								//	$(this).datagrid('freezeRow',0).datagrid('freezeRow',1);
								$('.user-easyui-linkbutton-edit').linkbutton({
									text : '详情',
									plain : true,
									iconCls : 'icon-edit'
								});
								$('.user-easyui-linkbutton-del').linkbutton({
									text : '删除',
									plain : true,
									iconCls : 'icon-del'
								});
							},
							toolbar : '#toolbar'
						});
	});

	function addFun() {
		parent.$.modalDialog({
			title : '添加',
			width : 650,
			height : 600,
			href : '${path }/secPrintInfoManage/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#addForm');
					f.submit();
				}
			} ]
		});
	}
	function fileUpload() {
		parent.$.modalDialog({
			title : '文件上传',
			width : 400,
			height : 300,
			href : '${path }/secPrintInfoManage/fileUpload',
			buttons : [ {
				text : '关闭',
				handler : function() {
					parent.$.modalDialog.handler.dialog('close');
					dataGrid.datagrid('reload');
				}
			} ]
		});

	}

	function deleteFun(id) {
		if (id == undefined) {//点击右键菜单才会触发这个
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {//点击操作里面的删除图标会触发这个
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.messager.confirm('询问', '您是否要删除该条记录？', function(b) {
			if (b) {
				progressLoad();
				$.post('${path }/secPrintInfoManage/delete', {
					id : id
				}, function(result) {
					if (result.success) {
						parent.$.messager.alert('提示', result.msg, 'info');
						dataGrid.datagrid('reload');
					}
					progressClose();
				}, 'JSON');
			}
		});
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		} else {
			dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
		}
		parent.$.modalDialog({
			title : '详情',
			width : 800,
			height : 500,
			href : '${path }/secPrintInfoManage/queryDetail?id=' + id,
			buttons : [ {
				text : '关闭',
				handler : function() {
					 parent.$.modalDialog.handler.dialog('close');
				}
			} ]
		});
	}

	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',border:false" style="height: 30px; overflow: hidden; background-color: #fff">
		<form id="searchForm">
			<table>
				<tr>
					<th>地区 :</th>
					<td><input name="region" placeholder="请输入 地区 " /></td>
					<th>责任部门 :</th>
					<td><input name="resdepart" placeholder="请输入责任部门 " /></td>
					<th>责任人 :</th>
					<td><input name="resperson" placeholder="请输入责任人 " /></td>
					<td><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a><a
						href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="cleanFun();">清空</a></td>
				</tr>
			</table>
		</form>
	</div>
	<div data-options="region:'center',border:true,title:'十三所二三〇厂直连涉密打印设备台帐列表'">
		<table id="dataGrid" data-options="fit:true,border:false"></table>
	</div>
	<div id="toolbar">
		<shiro:hasPermission name="/secPrintInfoManage/fileUpload">
			<a onclick="fileUpload();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">文件上传</a>
		</shiro:hasPermission>
	</div>
</body>
</html>