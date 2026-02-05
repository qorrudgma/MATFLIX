<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.boot.dto.TeamDTO" %>
<%
    TeamDTO user = (TeamDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <style>
        body { margin:0; font-family: Arial, sans-serif; }
        .header { height:60px; background:#333; color:#fff; display:flex; align-items:center; padding:0 20px; }
        .dashboard { display:flex; height: calc(100vh - 60px); }
        .sidebar { width:200px; background:#f4f4f4; padding:20px; box-sizing:border-box; }
        .sidebar button { width:100%; margin-bottom:10px; padding:10px; cursor:pointer; }
        .content { flex:1; padding:20px; box-sizing:border-box; overflow-y:auto; }
        .active { background:#ddd; }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <div class="header">
        <h2>MATFLIX 관리자</h2>
        <div style="margin-left:auto;">환영합니다, <%= user != null ? user.getMf_nickname() : "관리자" %>님</div>
    </div>

    <!-- 대시보드 -->
    <div class="dashboard">
        <!-- 좌측 메뉴 -->
        <div class="sidebar">
            <button class="menu_btn active" data-target="user_list">로그인한 유저</button>
            <button class="menu_btn" data-target="recipe_list">레시피</button>
            <button class="menu_btn" data-target="board_list">게시글</button>
            <button class="menu_btn" data-target="statistics">통계</button>
        </div>

        <!-- 우측 컨텐츠 -->
        <div class="content" id="content_area">
            <!-- 초기 화면은 유저 목록 -->
            <h3>로그인한 유저 목록</h3>
            <ul id="user_list_area">
                <li>홍길동</li>
                <li>김철수</li>
                <li>이영희</li>
            </ul>
        </div>
    </div>

    <script>
        $(document).ready(function(){
            $(".menu_btn").click(function(){
                // 버튼 active 상태
                $(".menu_btn").removeClass("active");
                $(this).addClass("active");

                let target = $(this).data("target");
                let content = "";

                switch(target){
                    case "user_list":
                        content = "<h3>로그인한 유저 목록</h3><ul>";
                        content += "<li>홍길동</li><li>김철수</li><li>이영희</li>";
                        content += "</ul>";
                        break;
                    case "recipe_list":
                        content = "<h3>최근 등록된 레시피</h3><ul>";
                        content += "<li>김치찌개</li><li>된장찌개</li><li>불고기</li>";
                        content += "</ul>";
                        break;
                    case "board_list":
                        content = "<h3>최근 게시글</h3><ul>";
                        content += "<li>레시피 후기</li><li>질문 게시판</li><li>공지사항</li>";
                        content += "</ul>";
                        break;
                    case "statistics":
                        content = "<h3>통계</h3>";
                        content += "<p>총 회원 수: 123명</p>";
                        content += "<p>오늘 가입한 회원: 5명</p>";
                        content += "<p>오늘 작성된 게시글: 12개</p>";
                        break;
                }

                $("#content_area").html(content);
            });
        });
    </script>
</body>
</html>