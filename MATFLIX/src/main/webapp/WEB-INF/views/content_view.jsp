<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			<table width="500" border="1">
				<form method="post" action="modify">
					<!-- <input type="hidden" name="boardNo" value="${content_view.boardNo}"> -->
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
						<td>이름</td>
						<td>
							<%-- ${content_view.boardName} --%>
								<input type="text" name="boardName" value="${content_view.boardName}">
						</td>
					</tr>
					<tr>
						<td>제목</td>
						<td>
							<%-- ${content_view.boardTitle} --%>
								<input type="text" name="boardTitle" value="${content_view.boardTitle}">
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td>
							<%-- ${content_view.boardContent} --%>
								<input type="text" name="boardContent" value="${content_view.boardContent}">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="submit" value="수정">
							<!-- &nbsp;&nbsp;<a href="list">목록보기</a> -->
							 <!-- formaction="list" : name 으로 설정된 값들을 가지고 이동 -->
							&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="list">
							<!-- &nbsp;&nbsp;<a href="delete?boardNo=${content_view.boardNo}">삭제</a> -->
							&nbsp;&nbsp;<input type="submit" value="삭제" formaction="delete">
						</td>
					</tr>
				</form>
			</table>

			<!-- 첨부파일 출력 -->
			Files
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
				<table>
					<tr>
						<th>댓글번호</th>
						<th>작성자</th>
						<th>내용</th>
						<th>작성시간</th>
					</tr>
					<c:forEach items="${commentList}" var="comment">
						<tr>
							<td>${comment.commentNo}</td>
							<td>${comment.commentWriter}</td>
							<td>${comment.commentContent}</td>
							<td>${comment.commentCreatedTime}</td>
						</tr>
					</c:forEach>
				</table>
				<!--
		<table>
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
			</tr>
			<c:forEach items="${commentList}" var="comment">
				<tr>
					<td>${comment.commentNo}</td>
					<td>${comment.commentWriter}</td>
					<td>${comment.commentContent}</td>
					<td>${comment.commentCreatedTime}</td>
				</tr>
			</c:forEach>
		</table>
		-->
			</div>

		</body>
		<script>
			const commentWrite = () => {
				const writer = document.getElementById("commentWriter").value;
				const content = document.getElementById("commentContent").value;
				const no = "${content_view.boardNo}";

				$.ajax({
					type: "post"
					, data: {
						commentWriter: writer
						, commentContent: content
						, boardNo: no
					}
					, url: "/comment/save"
					, success: function (commentList) {
						console.log("작성 성공");
						console.log(commentList);

						let output = "<table>";
						output += "<tr><th>댓글번호</th>";
						output += "<th>작성자</th>";
						output += "<th>내용</th>";
						output += "<th>작성시간</th></tr>";
						for (let i in commentList) {
							output += "<tr>";
							output += "<td>" + commentList[i].commentNo + "</td>";
							output += "<td>" + commentList[i].commentWriter + "</td>";
							output += "<td>" + commentList[i].commentContent + "</td>";
							output += "<td>" + commentList[i].commentCreatedTime + "</td>";
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
		</script>
		<script>
			$(document).ready(function () {
				// 즉시실행함수
				(function () {
					console.log("@# document ready");
					var boardNo = "<c:out value='${content_view.boardNo}'/>";
					console.log("@# boardNo=>" + boardNo);

					$.getJSON("/getFileList", { boardNo: boardNo }, function (arr) {
						console.log("@# arr=>" + arr);

						var str = "";

						$(arr).each(function (i, obj) {
							//image type
							if (obj.image) {
								var fileCallPath = obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName;

								str += "<li data-path='" + obj.uploadPath + "'";
								str += " data-uuid='" + obj.uuid + "'";
								str += " data-filename='" + obj.fileName + "'";
								str += " data-type='" + obj.image + "'";
								str += "><div>";

								str += "<span>" + obj.fileName + "</span>";
								str += "<img src='/display?fileName=" + fileCallPath + "'>";//이미지 출력 처리(컨트롤러단)
								// str += "<span data-file=\'" + fileCallPath + "\'data-type='image'> x </span>";
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
								// str += "<span data-file=\'" + fileCallPath + "\'data-type='file'> x </span>";
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
		</script>

		</html>