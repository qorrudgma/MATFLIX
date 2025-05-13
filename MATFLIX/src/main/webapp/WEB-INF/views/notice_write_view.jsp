<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}
.uploadResult ul {
	display: flex;
	flex-flow: row;
}
.uploadResult ul li {
	list-style: none;
	padding: 10px;
}
.uploadResult ul li img {
	width: 20px;
}
</style>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<form id="frm" method="post" action="notice_write">
		<table width="500" border="1">
			<tr>
				<td>이름</td>
				<td><input type="text" name="notice_boardName" size="50"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" name="notice_boardTitle" size="50" required></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea rows="10" name="notice_boardContent"></textarea></td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">입력</button>
					&nbsp;&nbsp;
					<a href="${pageContext.request.contextPath}/notice_list">목록보기</a>
				</td>
			</tr>
		</table>

		<!-- 파일 업로드 -->
		<div class="uploadDiv">
			<input type="file" name="uploadFile" multiple>
		</div>
		<div class="uploadResult">
			<ul></ul>
		</div>
	</form>
</body>

<script>
$(document).ready(function () {
	var formObj = $("form[id='frm']");

	$("button[type='submit']").on("click", function (e) {
		e.preventDefault();

		var str = "";
		$(".uploadResult ul li").each(function (i, obj) {
			var jobj = $(obj);

			str += "<input type='hidden' name='notice_attachList[" + i + "].notice_fileName' value='" + jobj.data("filename") + "'>";
			str += "<input type='hidden' name='notice_attachList[" + i + "].notice_uuid' value='" + jobj.data("uuid") + "'>";
			str += "<input type='hidden' name='notice_attachList[" + i + "].notice_uploadPath' value='" + jobj.data("path") + "'>";
			str += "<input type='hidden' name='notice_attachList[" + i + "].notice_image' value='" + jobj.data("type") + "'>";
		});

		formObj.append(str).submit();
	});

	var regex = new RegExp("(.*?)\\.(exe|sh|alz)$");
	var maxSize = 5242880;

	function checkExtension(fileName, fileSize) {
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}

	$("input[type='file']").change(function () {
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;

		for (var i = 0; i < files.length; i++) {
			if (!checkExtension(files[i].name, files[i].size)) return false;
			formData.append("uploadFile", files[i]);
		}

		$.ajax({
			type: "post",
			url: "${pageContext.request.contextPath}/notice_uploadAjaxAction",
			data: formData,
			processData: false,
			contentType: false,
			success: function (result) {
				showUploadResult(result);
			}
		});
	});

	function showUploadResult(uploadResultArr) {
		if (!uploadResultArr || uploadResultArr.length === 0) return;

		var uploadUL = $(".uploadResult ul");
		var str = "";

		$(uploadResultArr).each(function (i, obj) {
			let fileCallPath = obj.notice_image
				? obj.notice_uploadPath + "/s_" + obj.notice_uuid + "_" + obj.notice_fileName
				: obj.notice_uploadPath + "/" + obj.notice_uuid + "_" + obj.notice_fileName;

			str += "<li data-path='" + obj.notice_uploadPath + "'";
			str += " data-uuid='" + obj.notice_uuid + "'";
			str += " data-filename='" + obj.notice_fileName + "'";
			str += " data-type='" + obj.notice_image + "'>";
			str += "<div><span>" + obj.notice_fileName + "</span>";

			if (obj.notice_image) {
				str += "<img src='${pageContext.request.contextPath}/notice_display?notice_fileName=" + fileCallPath + "'>";
			} else {
				str += "<img src='${pageContext.request.contextPath}/resources/img/attach.png'>";
			}
			str += "<span data-file='" + fileCallPath + "' data-type='" + (obj.notice_image ? "image" : "file") + "'> x </span>";
			str += "</div></li>";
		});

		uploadUL.append(str);
	}

	$(".uploadResult").on("click", "span", function () {
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		var uploadResultItem = $(this).closest("li");

		$.ajax({
			type: "post",
			url: "${pageContext.request.contextPath}/notice_deleteFile",
			data: { fileName: targetFile, type: type },
			success: function (result) {
				alert(result);
				uploadResultItem.remove();
			}
		});
	});
});
</script>
</html>
