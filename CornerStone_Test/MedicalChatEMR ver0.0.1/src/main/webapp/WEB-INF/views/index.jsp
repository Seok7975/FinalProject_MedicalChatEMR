<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>File Upload</title>
    <c:set var="contextPath" value="${pageContext.request.contextPath}" />
</head>
<body>
    <h1>File Upload</h1>
    <form method="post" action="${contextPath}/upload" enctype="multipart/form-data">
        <input type="file" name="file"/>
        <button type="submit">Upload</button>
    </form>
</body>
</html>
