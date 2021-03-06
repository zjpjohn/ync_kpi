<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
	$(function(){
		validate();
		limitAssessmentTime();
	})
	//计算总分
	function countResult() {
		var score1 = $("#score1").val();
		var score2 = $("#score2").val();
		var score3 = $("#score3").val();
		var score4 = $("#score4").val();
		var score5 = $("#score5").val();
		
		var scoresNum;
		var scores = "${score}";
		if(scores) {
			scoresNum = scores/5;
			if (score1 && score1 > scoresNum) {
				score1 = scoresNum;
				$("#score1").val(score1);
			}
			if (score2 && score2 > scoresNum) {
				score2 = scoresNum;
				$("#score2").val(score2);
			}
			if (score3 && score3 > scoresNum) {
				score3 = scoresNum;
				$("#score3").val(score3);
			}
			if (score4 && score4 > scoresNum) {
				score4 = scoresNum;
				$("#score4").val(score4);
			}
			if (score5 && score5 > scoresNum) {
				score5 = scoresNum;
				$("#score5").val(score5);
			}
		}
		
		var count = parseInt(score1) + parseInt(score2) + parseInt(score3) + parseInt(score4) + parseInt(score5);
		$("#count").html(count);
		$("#totalScore").val(count);
	}
	
	function validate() {
		$("#queryForm").validate({
			rules:{
				action1_Score:{
					number:true
				},
				action2_Score:{
					number:true
				},
				action3_Score:{
					number:true
				},
				action4_Score:{
					number:true
				},
				action5_Score:{
					number:true
				}				
			},
			messages:{
				action1_Score: {
					number:"必须是数字"
				},
				action2_Score: {
					number:"必须是数字"
				},
				action3_Score: {
					number:"必须是数字"
				},
				action4_Score: {
					number:"必须是数字"
				},
				action5_Score: {
					number:"必须是数字"
				},
			},
		});
	}

	//限制评论时间，超过每月的3号不可以进行评价，超过当月不可以进行评论
	//后台传到前台的历史日期比当前月多一个月，如当前时间为2015-12，后台传过来则是2016-1
	function limitAssessmentTime() {
		var historyDate = "${date}";
		var historyYear = historyDate.substring(0, 4);
		var historyMonth = historyDate.substring(5, 7);
		
		var date = new Date("${serverDate}");		//获取服务器传到前台的时间
		
		//不同年份的比较方式，如2016年的1月可以评2015年的12月
		if ((historyYear - date.getFullYear())==1) {
			var currentMonth = date.getMonth() + 2;
			if (currentMonth == 13) {
				currentMonth = 1;
			}
			if ((currentMonth - historyMonth)==1) {
				if (date.getDate() > 3) {
					$("input[type='text']").attr("readonly", "readonly");
					$("textarea").attr("readonly", "readonly");
				}
			} else if ((currentMonth - historyMonth)!=1){
				$("input[type='text']").attr("readonly", "readonly");
				$("textarea").attr("readonly", "readonly");
			}
			
		} else if (historyYear == date.getFullYear()) {	//如果在同一年，当前月1-3号可以评论上个月的评价
			var currentMonth = date.getMonth() + 2;
			if (currentMonth == 13) {
				currentMonth = 1;
			}
			if ((currentMonth - historyMonth)==1) {
				if (date.getDate() > 3) {
					$("input[type='text']").attr("readonly", "readonly");
					$("textarea").attr("readonly", "readonly");
				}
			} else if ((currentMonth - historyMonth)!=1){
				$("input[type='text']").attr("readonly", "readonly");
				$("textarea").attr("readonly", "readonly");
			}
		}
	}

</script>
<title>编辑评价</title>
<style>
	td{
		text-align:center;
	}
</style>
</head>
<body>
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span2">
			<ul class="nav nav-tabs nav-stacked">
					<li class="nav-header"><h4>历史列表</h4></li>
					<c:forEach items="${pe.getContent()}" var="pc">
						<li><a
							href="${ctx }/leaderAssessment/depList?date=<fmt:formatDate value="${pc.createTime}" pattern="yyyy-MM"/>">${pc.peDateDepartment.replace('_','') }</a></li>
					</c:forEach>
				</ul>
			</div>
			<div class="span10">
				<h4>
					上级评价ID:${assessment.id }&nbsp;&nbsp;&nbsp;&nbsp;
					被评价者:${assessment.beEvaluatedName }&nbsp;&nbsp;&nbsp;&nbsp;
					部门:${assessment.departmentName }&nbsp;&nbsp;&nbsp;&nbsp;
					评价者：${assessment.mt }<br />
					评价时间:<fmt:formatDate value="${assessment.evaluatedTime }" pattern="yyyy-MM-dd"/>
					</h4>
					<form action="${ctx}/leaderAssessment/edit" method="post" id="queryForm">
						<input name="id" type="hidden" value="${assessment.id }" />
						<input name="departmentId" type="hidden" value="${assessment.departmentId }" />
						<input name="departmentName" type="hidden" value="${assessment.departmentName }" />
						<input name="mt" type="hidden" value="${assessment.mt }" />
						<input name="beEvaluatedId" type="hidden" value="${assessment.beEvaluatedId }" />
						<input name="beEvaluatedName" type="hidden" value="${assessment.beEvaluatedName }" />
						<input name="createTime" type="hidden" value="${assessment.createTime }" />
						<input name="date" type="hidden" value="${date }" />
						
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td>行为要项</td>
								<td>行为藐视</td>
								<td>分值</td>
								<td>上级评分</td>
							</tr>
							<tr>
								<td>主动承担</td>
								<td>职责范围之内的工作，主动计划，高效推进；职责边界模糊的工作，主动推进积极协作，确保结果落实</td>
								<td>${score/5 }</td>
								<td><input id="score1" name="action1_Score" type="text" value="${assessment.action1_Score }" onblur="countResult();"/></td>
							</tr>
							<tr>
								<td>快速高效</td>
								<td>接到任务马上执行，不推诿，不迟疑，并想法设法高效完成</td>
								<td>${score/5 }</td>
								<td><input id="score2" name="action2_Score" type="text" value="${assessment.action2_Score }" onblur="countResult();" /></td>
							</tr>
							<tr>
								<td>结果意识</td>
								<td>以价值为根本，始终保持对目标的关注，通过不断地监控和排除各种困难，高效率地实施计划，取得高质量的成果</td>
								<td>${score/5 }</td>
								<td><input id="score3" name="action3_Score" type="text" value="${assessment.action3_Score }" onblur="countResult();" /></td>
							</tr>
							<tr>
								<td>沟通协作</td>
								<td>以积极的行动，谦和的态度主动沟通，并与工作上下游良好协作，支持团队总体目标的达成</td>
								<td>${score/5 }</td>
								<td><input id="score4" name="action4_Score" type="text" value="${assessment.action4_Score }" onblur="countResult();" /></td>
							</tr>
							<tr>
								<td>坚韧耐挫</td>
								<td>困难面前不低头，压力面前不弯腰、挑战面前不后退；愈挫愈勇、百折不挠、坚韧不拔、持之以恒</td>
								<td>${score/5 }</td>
								<td><input id="score5" name="action5_Score" type="text" value="${assessment.action5_Score }" onblur="countResult();" /></td>
							</tr>
						</table>
					<div>
						<input id="totalScore" type="hidden" name="totalScore" value="${assessment.totalScore }"/>
						<h4>总分: <span id="count">${assessment.totalScore }分</span></h4>
						<h4>评价: </h4>
						<textarea name="comment" rows="5" style="width: 400px;">${assessment.comment }</textarea>
					</div>
					<div align="right">
						<button class="btn">保存</button>
						<button class="btn" onclick="window.history.go(-1)">取消</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>