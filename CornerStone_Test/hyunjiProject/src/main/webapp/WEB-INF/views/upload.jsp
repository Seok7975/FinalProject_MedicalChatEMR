<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org">
<head>
<meta charset="UTF-8">
<title>Multi File Upload</title>
</head>
<body>
    <h2>다중 파일 업로드</h2>
    <form method="POST" action="/upload-multiple" enctype="multipart/form-data">
        <label for="files">파일 선택:</label>
        <input type="file" id="files" name="files" multiple>
        <br><br>
        <button type="submit">업로드</button>
    </form>
</body>
</html>