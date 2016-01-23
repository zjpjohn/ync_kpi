<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    response.setStatus(200);
%>

<!DOCTYPE html>
<html>
<head>
<title>401 - 访问被拒绝</title>
</head>

<body>
	<div class="container">
		<h2>401 - 访问被拒绝.</h2>
		<p>
			<a href="<c:url value="/logout"/>">退出重新登录</a>
		</p>
		<p>
			<a href="<c:url value="/login/success"/>">返回首页</a>
		</p>
	</div>
</body>
</html>