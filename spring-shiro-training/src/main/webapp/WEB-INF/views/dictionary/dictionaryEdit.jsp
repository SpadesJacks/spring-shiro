<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<script type="text/javascript">
	$(function() {
		$('#editForm').form({
			url : '${path }/attendanceInfoManage/edit',
			onSubmit : function() {
				progressLoad();
				var isValid = $(this).form('validate');
				if (!isValid) {
					progressClose();
				}
				return isValid;
			},
			success : function(result) {
				progressClose();
				result = $.parseJSON(result);
				if (result.success) {
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden; padding: 3px;">
		<form id="editForm" method="post">

			<table class="grid">

				<tr>
					<td>名称</td>
					<td><input name="id" type="hidden" value="${Dictionary.id}" />
					<input name="name" type="text" placeholder="请输入名称" class="easyui-validatebox" data-options="required:true" value="${Dictionary.name}"></td>
					<td>参数值</td>
					<td><input name="keys_" type="text" placeholder="请输入参数值" class="easyui-validatebox" data-options="required:true" value="${Dictionary.keys_}"></td>
				</tr>

				<tr>
					<td>URL</td>
					<td><input name="url" type="text" placeholder="请输入URL" class="easyui-validatebox" data-options="required:true" value="${Dictionary.url}"></td>
					<td>描述</td>
					<td><input name="description" type="text" placeholder="请输入描述" class="easyui-validatebox" data-options="required:true"
						value="${Dictionary.description}"></td>
				</tr>


			</table>
		</form>
	</div>
</div>