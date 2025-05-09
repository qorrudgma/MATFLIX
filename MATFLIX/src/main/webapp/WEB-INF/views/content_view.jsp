<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% TeamDTO user = (TeamDTO) session.getAttribute("user"); %>
<% request.setAttribute("user", user); %>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
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
			width: 100px;
		}
	</style>
	<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>

<body>
	<%= user %><br>
	${user.mf_no}
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="boardNo" value="${pageMaker.boardNo}">
			<input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
			<input type="hidden" name="amount" value="${pageMaker.amount}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.boardNo}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit}
				</td>
			</tr>
			<tr>
				<td>이름(닉네임이 나오게 수정하기)</td>
				<td>
					${content_view.boardName}
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle" value="${content_view.boardTitle}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<input type="text" name="boardContent" value="${content_view.boardContent}">
				</td>
			</tr>
			<tr>
				<td>
					${content_view.mf_no}
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<c:if test="${content_view.mf_no == user.mf_no}">
						<input type="submit" value="수정">
					</c:if>
					&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="list">
					<c:if test="${content_view.mf_no == user.mf_no}">
						&nbsp;&nbsp;<input type="submit" value="삭제" formaction="delete">
					</c:if>
				</td>
			</tr>
		</form>
	</table>

	Files
	<!-- 추가 -->
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<!-- 출력 -->
	<div class="bigPicture">
		<div class="bigPic">

		</div>
	</div>

	<div class="uploadResult">
		<ul>

		</ul>
	</div>

	<!-- 댓글 출력 -->
	<div>
		<input type="text" id="commentWriter" placeholder="작성자">
		<input type="text" id="commentContent" placeholder="내용">
		<button onclick="commentWrite()">댓글작성</button>
	</div>

	<div id="comment-list">
		<table border="1">
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
				<th>게시글 번호</th>
				<th>유저 번호</th>
			</tr>
			<c:forEach items="${commentList}" var="comment">
				<tr>
					<td>${comment.commentNo}</td>
					<td>${comment.commentWriter}</td>
					<td>${comment.commentContent}</td>
					<td>${comment.commentCreatedTime}</td>
					<td>${comment.boardNo}</td>
					<td>${comment.userNo}</td>
					<td>
						<c:if test="${comment.userNo == user.mf_no}">
							<button onclick="deleteComment('${comment.commentNo}')">댓글 삭제</button>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>

</body>
<script>
    <% if (user != null) { %>
        var sessionUserNo = <%= user.getMf_no() %>;
    <% } else { %>
        var sessionUserNo = null;
    <% } %>

	const commentWrite = () => {
		console.log("유저 넘 => "+sessionUserNo);
		const writer = document.getElementById("commentWriter").value;
		const content = document.getElementById("commentContent").value;
		const no = "${content_view.boardNo}";

		$.ajax({
			type: "post"
			, data: {
				commentWriter: writer
				, commentContent: content
				, boardNo: no
				, userNo: sessionUserNo
			}
			, url: "/comment/save"
			, success: function (commentList) {
				console.log("작성 성공");
				console.log(commentList);

				let output = "<table border='1'>";
				output += "<tr><th>댓글번호</th>";
				output += "<th>작성자</th>";
				output += "<th>내용</th>";
				output += "<th>작성시간</th>";
				output += "<th>게시글 번호</th>";
				output += "<th>유저 번호</th></tr>";
				for (let i in commentList) {
					output += "<tr>";
					output += "<td>" + commentList[i].commentNo + "</td>";
					output += "<td>" + commentList[i].commentWriter + "</td>";
					output += "<td>" + commentList[i].commentContent + "</td>";
					output += "<td>" + commentList[i].commentCreatedTime + "</td>";
					output += "<td>" + commentList[i].boardNo + "</td>";
					output += "<td>" + commentList[i].userNo + "</td>";

					// 우선 1을 적어둠-------------------------
					if (commentList[i].userNo == sessionUserNo) {
						output += "<td><button onclick='deleteComment(" + commentList[i].commentNo + ")'>댓글 삭제</button></td>";
					} else {
						output += "<td></td>";
					}
					output += "</tr>";
				}
				output += "</table>";
				console.log("@# output=>" + output);

				document.getElementById("comment-list").innerHTML = output;
			}
			, error: function () {
				console.log("실패");
			}
		});//end of ajax
	}//end of script

	function deleteComment(commentNo){
		$.ajax({
			type: "post",
			url: "/comment/delete",
			data: { commentNo: commentNo },
			success: function(response) {
				console.log("댓글 삭제 성공");
				loadComments();
			},
			error: function() {
				console.log("댓글 삭제 실패");
			}
    	});
	}

	function loadComments() {
		const no = "${content_view.boardNo}";

		$.ajax({
			type: "get",
			url: "/comment/list",
			data: { boardNo: no },
			success: function (commentList) {
				let output = "<table border='1'>";
				output += "<tr><th>댓글번호</th><th>작성자</th><th>내용</th><th>작성시간</th><th>게시글 번호</th><th>유저 번호</th></tr>";
				for (let i in commentList) {
					output += "<tr>";
					output += "<td>" + commentList[i].commentNo + "</td>";
					output += "<td>" + commentList[i].commentWriter + "</td>";
					output += "<td>" + commentList[i].commentContent + "</td>";
					output += "<td>" + commentList[i].commentCreatedTime + "</td>";
					output += "<td>" + commentList[i].boardNo + "</td>";
					output += "<td>" + commentList[i].userNo + "</td>";
					if (commentList[i].userNo == sessionUserNo) {
						output += "<td><button onclick='deleteComment(" + commentList[i].commentNo + ")'>댓글 삭제</button></td>";
					} else {
						output += "<td></td>";
					}
					output += "</tr>";
				}
				output += "</table>";
				document.getElementById("comment-list").innerHTML = output;
			},
			error: function () {
				console.log("댓글 목록 불러오기 실패");
			}
		});
	}

</script>
<script>
	// 이미지 보여주기
	$(document).ready(function () {
		(function () {
			console.log("@# document ready");
			var boardNo = "<c:out value='${content_view.boardNo}'/>";
			console.log("@# boardNo=>" + boardNo);

			$.getJSON("/getFileList", { boardNo: boardNo }, function (arr) {
				console.log("@# arr=>" + arr);

				var str = "";

				$(arr).each(function (i, obj) {
					if (obj.image) {
						var fileCallPath = obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName;

						str += "<li data-path='" + obj.uploadPath + "'";
						str += " data-uuid='" + obj.uuid + "'";
						str += " data-filename='" + obj.fileName + "'";
						str += " data-type='" + obj.image + "'";
						str += "><div>";

						str += "<span>" + obj.fileName + "</span>";
						str += "<img src='/display?fileName=" + fileCallPath + "'>";//이미지 출력 처리(컨트롤러단)
						str += "</div></li>";
					} else {
						var fileCallPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;

						str += "<li data-path='" + obj.uploadPath + "'";
						str += " data-uuid='" + obj.uuid + "'";
						str += " data-filename='" + obj.fileName + "'";
						str += " data-type='" + obj.image + "'";
						str += "><div>";

						str += "<span>" + obj.fileName + "</span>";
						str += "<img src='./resources/img/attach.png'>";
						str += "</div></li>";
					}
				});//end of arr each

				console.log("@# str=>"+str);
				$(".uploadResult ul").html(str);
				
			});//end of getJSON

			$(".uploadResult").on("click","li",function (e) {
				console.log("@# uploadResult click");
				
				var liObj = $(this);
				console.log("@# path 01=>", liObj.data("path"));
				console.log("@# uuid=>", liObj.data("uuid"));
				console.log("@# filename=>", liObj.data("filename"));
				console.log("@# type=>", liObj.data("type"));
				
				var path = liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename");
				console.log("@# path 02=>", path);
				
				// 이미지일때
				if (liObj.data("type")) {
					console.log("@# 이미지 확대");
					
					showImage(path);
				// 이미지가 아닐때
				} else {
					console.log("@# 파일 다운로드");
					
					//컨트롤러의 download 호출
					self.location = "/download?fileName="+path;
				}
			});//end of uploadResult click
			
			function showImage(fileCallPath) {
				console.log("@# fileCallPath=>", fileCallPath);
				
				$(".bigPicture").css("display", "flex").show();
				$(".bigPic").html("<img src='/display?fileName="+fileCallPath+"'>")
								  .animate({width: "100%", heigh: "100%"}, 1000);
			}

			$(".bigPicture").on("click", function (e) {
				$(".bigPic").animate({width: "0%", heigh: "0%"}, 1000);
				setTimeout(function () {
					$(".bigPicture").hide();
				}, 1000);
			});

		})();//end of 즉시실행함수
	});//end of document ready
	
	$(document).ready(function (e){
			var formObj = $("form[id='frm']");

			$("button[type='submit']").on("click", function (e) {
				e.preventDefault();
				console.log("submit clicked");

				var str="";

				$(".uploadResult ul li").each(function (i, obj) {
					console.log("@# obj=>"+$(obj));
					console.log("@# data=>"+$(obj).data());
					console.log("@# filename=>"+$(obj).data("filename"));
					
					var jobj = $(obj);
					console.log("===========================");
					console.log("@# filename2=>"+jobj.data("filename"));
					console.log("@# uuid=>"+jobj.data("uuid"));
					console.log("@# path=>"+jobj.data("path"));
					console.log("@# type=>"+jobj.data("type"));

					str +="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].image' value='"+jobj.data("type")+"'>";
				});//end of uploadResult ul li

				console.log("@# uploadResult str=>"+str);
				// return;

				formObj.append(str).submit();

			});//end of button submit

			var regex = new RegExp("(.*?)\.(exe|sh|alz)$");
			var maxSize = 5242880;//5MB

			function checkExtension(fileName, fileSize) {
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				if (regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				return true;
			}

			$("input[type='file']").change(function (e){
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;

				for(var i=0; i<files.length; i++){
					console.log("@# files=>"+files[i].name);

					if (!checkExtension(files[i].name, files[i].size)) {
						return false;
					}

					formData.append("uploadFile",files[i]);
				}

				$.ajax({
					 type: "post"
					,data: formData
					,url: "uploadAjaxAction"
					//processData : 기본은 key/value 를 Query String 으로 전송하는게 true
					//(파일 업로드는 false)
					,processData: false
					//contentType : 기본값 : "application / x-www-form-urlencoded; charset = UTF-8"
					//첨부파일은 false : multipart/form-data로 전송됨
					,contentType: false
					,success: function (result) {
						alert("Uploaded");
						console.log(result);
						//파일정보들을 함수로 보냄
						showUploadResult(result);//업로드 결과 처리 함수
					}
				});//end of ajax

				function showUploadResult(uploadResultArr) {
					if (!uploadResultArr || uploadResultArr.length == 0) {
						return;
					}

					var uploadUL = $(".uploadResult ul");
					var str="";

					$(uploadResultArr).each(function (i, obj) {
						if (obj.image) {
							console.log("@# obj.uploadPath=>"+obj.uploadPath);
							console.log("@# obj.uuid=>"+obj.uuid);
							console.log("@# obj.fileName=>"+obj.fileName);

							var fileCallPath = obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName;

							str += "<li data-path='"+obj.uploadPath+"'";
							str += " data-uuid='"+obj.uuid+"'";
							str += " data-filename='"+obj.fileName+"'";
							str += " data-type='"+obj.image+"'";
							str += "><div>";

							str += "<span>"+obj.fileName+"</span>";
							str += "<img src='/display?fileName="+fileCallPath+"'>";//이미지 출력 처리(컨트롤러단)
							str += "<span data-file=\'"+ fileCallPath +"\'data-type='image'> x </span>";
							str += "</div></li>";
						} else {
							var fileCallPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;

							str += "<li data-path='"+obj.uploadPath+"'";
							str += " data-uuid='"+obj.uuid+"'";
							str += " data-filename='"+obj.fileName+"'";
							str += " data-type='"+obj.image+"'";
							str += "><div>";

							str += "<span>"+obj.fileName+"</span>";
							str += "<img src='./resources/img/attach.png'>";
							str += "<span data-file=\'"+ fileCallPath +"\'data-type='file'> x </span>";
							str += "</div></li>";
						}
					});//end of each
					console.log("@# str=>"+str);

					uploadUL.append(str);

					$(".uploadResult").on("click","span",function () {
						var targetFile = $(this).data("file");
						var type = $(this).data("type");
						var uploadResultItem = $(this).closest("li");

						console.log("@# targetFile=>"+targetFile);
						console.log("@# type=>"+type);
						console.log("@# uploadResultItem=>"+uploadResultItem);

						//컨트롤러 단에서 업로드된 실제파일 삭제
						$.ajax({
							 type:"post"
							,data: {fileName: targetFile, type: type}
							,url: "deleteFile"
							,success: function (result) {
								alert(result);
								//브라우저에서 해당 썸네일이나 첨부파일이미지 제거
								uploadResultItem.remove();
							}
						});//end of ajax
					});//end of click
				}
			});//end of change
		});//end of ready
</script>

</html>