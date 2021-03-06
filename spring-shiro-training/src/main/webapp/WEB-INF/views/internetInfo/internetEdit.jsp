<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<script type="text/javascript">
	$(function() {
		$('input.easyui-validatebox').validatebox({
			validateOnCreate : false,
			err : function(target, message, action) {
				var opts = $(target).validatebox('options');
				message = message || opts.prompt;
				$.fn.validatebox.defaults.err(target, message, action);
			}
		});
		$("#resperson").select2();

		$.post("${path }/user/queryUsers", function(data) {
			var bToObj = JSON.parse(data);
			for (var i = 0; i < bToObj.length; i++) {
				$("#resperson").append("<option value=" + bToObj[i].key + ">" + bToObj[i].value + "</option>");
			}
			$("#resperson").select2('val', $("#resperson").val());
		});

		var depname_value = $("#resdepart").val();
		$('#resdepart').combotree({
			url : '${path }/organization/tree',
			parentField : 'pid',
			lines : true,
			panelHeight : 'auto',
			value : depname_value
		});
        //devseculevel
        $('#devseculevel').combobox({
            url: '${path}/dictionaryManager/queryLevels',
            valueField: 'key',
            textField: 'value'
        });
        $('#devseculevel').combobox('setValue', $("#devseculevel").val());
		$('#editForm').form({
			url : '${path }/internetInfoManage/dataSave',
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
		<table class="grid">
			<tr>
				<td>地区</td>
				<td><input name="bus_type" type="hidden" value="修改" /><input name="id" type="hidden" value="${InternetInfo.id}" /><input
					name="region" type="text" placeholder="请输入地区" class="easyui-validatebox" data-options="required:true" value="${InternetInfo.region}"></td>
				<td>序号</td>
				<td><input name="number" type="text" placeholder="请输入序号" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.number}"></td>
			</tr>

			<tr>
				<td>所在房间</td>
				<td><input name="roomnum" type="text" placeholder="请输入所在房间" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.roomnum}"></td>
				<td>设备编号</td>
				<td><input name="devno" type="text" placeholder="请输入设备编号" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.devno}"></td>
			</tr>

			<tr>
				<td>新资产号</td>
				<td><input name="newassertsno" type="text" placeholder="请输入新资产号" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.newassertsno}"></td>
				<td>责任部门</td>
				<%-- <td><input name="resdepart" type="text" placeholder="请输入责任部门" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.resdepart}"></td> --%>
				<td><input class="easyui-combotree" id="resdepart" name="resdepart" value="${InternetInfo.resdepart}"
					style="height: 30px; width: 150px" data-options="required:true"></input></td>
			</tr>


			<tr>
				<td>责任人</td>
				<%-- <td><input name="resperson" type="text" placeholder="请输入责任人" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.resperson}"></td> --%>
				<td><select class="js-example-basic-single js-states form-control" id="resperson" name="resperson"
					value="${InternetInfo.resperson}" class="easyui-validatebox" data-options="required:true"></select></td>
				<td>设备品牌</td>
				<td><input name="devbrand" type="text" placeholder="请输入设备品牌" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.devbrand}"></td>
			</tr>


			<tr>
				<td>设备型号</td>
				<td><input name="infodevno" type="text" placeholder="请输入设备型号" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.infodevno}"></td>
				<td>序列号</td>
				<td><input name="serialno" type="text" placeholder="请输入序列号" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.serialno}"></td>
			</tr>


			<tr>
				<td>使用日期</td>
				<td><input name="usedate" type="text" placeholder="请输入使用日期" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"
					readonly="readonly" class="easyui-validatebox" data-options="required:true" value="${InternetInfo.usedate}"></td>
				<td>设备密级</td>
				<%--<td><input name="devseculevel" type="text" placeholder="请输入设备密级" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.devseculevel}"></td>--%>
                <td><input name="devseculevel" id="devseculevel" placeholder="请输入密级" class="easyui-combobox"
                           style="height: 30px;" data-options="required:true" value="${InternetInfo.devseculevel}"></td>
			</tr>

			<tr>
				<td>使用方式</td>
				<td><input name="usemethod" type="text" placeholder="请输入使用方式" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.usemethod}"></td>
				<td>状态</td>
				<td><input name="infostatus" type="text" placeholder="请输入状态" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.infostatus}"></td>
			</tr>
			<tr>
				<td>打印机服务器IP</td>
				<td><input name="printhostip" type="text" placeholder="请输入打印机服务器IP" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.printhostip}"></td>
				<td>打印机MAC</td>
				<td><input name="printmac" type="text" placeholder="请输入打印机MAC" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.printmac}"></td>
			</tr>
			<tr>
				<td>打印机网络端口</td>
				<td><input name="printport" type="text" placeholder="请输入打印机网络端口" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.printport}"></td>
				<td>配线架</td>
				<td><input name="patchpanel" type="text" placeholder="请输入配线架" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.patchpanel}"></td>
			</tr>
			<tr>
				<td>刷卡服务器IP</td>
				<td><input name="payhostip" type="text" placeholder="请输入刷卡服务器IP" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.payhostip}"></td>
				<td>刷卡器MAC</td>
				<td><input name="paymac" type="text" placeholder="请输入刷卡器MAC" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.paymac}"></td>
			</tr>
			<tr>
				<td>刷卡器网络端口</td>
				<td><input name="payport" type="text" placeholder="请输入刷卡器网络端口" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.payport}"></td>
				<td>园区</td>
				<td><input name="park" type="text" placeholder="请输入园区" class="easyui-validatebox" data-options="required:true"
					value="${InternetInfo.park}"></td>
			</tr>
		</table>
	</div>
</div>