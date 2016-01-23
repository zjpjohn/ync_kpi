<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html>
<head>
<script src="${ctx }/static/My97/WdatePicker.js"></script>
<!-- 时间控件 css  -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/My97/skin/WdatePicker.css" />
<!-- 时间控件js  -->
<script type="text/javascript" src="${ctx}/static/My97/WdatePicker.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="queryForm" class="form-inline">
		<table>
			<tr>
				<td><label class="control-label">所在项目</label></td>
				<td><input type="text" id="projectName" name="projectName"></td>
				<td><label class="control-label">评价者</label></td>
				<td><input type="text" id="evaluatedName" name="evaluatedName"></td>
				<td><label class="control-label">评分</label></td>
				<td><input type="text" id="score" name="score"></td>
			</tr>
			<tr>
				<td><label class="control-label">被评者</label></td>
				<td><input type="text" id="beEvaluatedName"
					name="beEvaluatedName"></td>
				<td><label class="control-label">时间</label></td>
				<td><input class="Wdate" onFocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM '})"
					type="text" id="evaluatedTime" name="evaluatedTime"/></td>
				<td></td>
				<td></td>
			</tr>
		</table>
		<button class="btn" id="btnSearch" type="submit">搜索</button>
		<button class="btn" id="btnSearch" type="reset">重置</button>
	</form>
	<div id="pager"></div>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<td>序号</td>
				<td>所在项目</td>
				<td>评价者</td>
				<td>被评者</td>
				<td>时间</td>
				<td>评分</td>
				<td>评语</td>
				<td>操作</td>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
	<script type="text/x-jquery-tmpl" id="tmplList">
		{{each(i,p) data.content}}
				<tr>
				<td>@{i+1}</td>
				<td>@{p.projectName}</td>
				<td>@{p.evaluatedName}</td>
				<td>@{p.beEvaluatedName}</td>
				<td>@{formatDate(p.evaluatedTime)}</td>
				<td>@{p.score}</td>
				<td>@{p.comment}</td>
				<td><a href="view/@{p.id}">查看</a></td>
				</tr>
		{{/each}}
	</script>
	<script type="text/javascript">
	function formatDate(times) {
		var date = new Date(times);
		var fm = date.format('yyyy-MM-dd');
		return fm;
	}
		var pageSize = 10;
		$(function() {
			 validate();
			$("#queryForm").submit();

		})
		function getData(pageIndex) {
			var queryData = $("#queryForm").serialize();
			pageIndex = pageIndex - 1;
			queryData = queryData + "&pageIndex=" + pageIndex + "&pageSize="
					+ pageSize;
			var sort = "totalScore";
			$.ajax({
				type : "POST",
				url : "${ctx}/admin/satisfaction/search",
				data : queryData,
				success : function(data) {
					if (data == null || data.records == 0) {
						$("#tbody").html("暂无记录");
					} else {
						$("#tbody").html($("#tmplList").tpl({
							data : data
						}));
					}
					//分页控件
					var pager = new pagination(function() {
						getData($(this).attr("data-index"));
					});
					pager.pageIndex = data.number + 1;//当前页码
					pager.pageSize = data.size;//页大小
					pager.totalCount = data.totalElements;//总条数
					pager.totalPage = data.totalPages;//总页数
					$("#pager").html(pager.creat());
				}
			});
		};
	</script>
	<script type="text/javascript">
		function validate() {
			$("#queryForm").validate({
				rules : {
					id : {
						digits : true
					},
				//createTime:{date:true}
				},
				messages : {
					leaderAssessmentScore : {
						number : "必须是数字"
					},
					efficiencyScore : {
						number : "必须是数字"
					},
					specialtyScore : {
						number : "必须是数字"
					},
					satisfactionScore : {
						number : "必须是数字"
					},
					totalScore : {
						number : "必须是数字"
					}
				},
				submitHandler : function(form) {
					//alert("submitHandler:function");
					getData(1);
				}
			});
		}
	</script>
</body>

</html>