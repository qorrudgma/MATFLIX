<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<% 
	TeamDTO user = (TeamDTO) session.getAttribute("user");
	request.setAttribute("user", user); 
%>


<script>
    <% if (user != null) { %>
        var sessionUserNo = <%= user.getMf_no() %>;
        var notification_count = <%= session.getAttribute("notification_count") %>
    <% } else { %>
        var sessionUserNo = null;
    <% } %>
    
    // 알림 버튼 클릭
    $(document).on("click", "#notification_btn", function (e) {
        e.preventDefault();

        var followerId = parseInt(sessionUserNo, 10);
        
        $.ajax({
             type: "POST"
            ,url: "/notification_list"
            ,data: {follower_id: followerId}
            ,dataType: "json"
            ,success: function (notification_list) {
                console.log("notification_list 받아옴");

                let notification_data="";

                console.log(notification_count);
                if (notification_count != 0 && notification_count != null) {
                    notification_data += "<div><h3>알림 갯수"+notification_count+"</h3></div>";
                }
                
                for (let i = 0; i < notification_list.length && 10; i++) {
                    if (notification_list[i].is_read == 1) {
                        notification_data += "<div id='notification_card' class='read_true'>";
                        } else {
                        notification_data += "<div id='notification_card'>";
                    }
                    console.log(notification_list[i].boardNo);
                    notification_data += "<div>읽음 안읽음 "+notification_list[i].is_read+"</div>";
                    notification_data += "<div>시간 "+notification_list[i].created_at+"</div>";
                    notification_data += "<div>누구인지 "+notification_list[i].following_id+"</div>";
                    notification_data += "<div>어디 게시글인지 댓글인지 "+notification_list[i].boardNo+"</div></div>";
                    notification_data += "<div>게시글인지 댓글인지 "+notification_list[i].post_id+"</div></div>";
                    notification_data += '<button type="button" class="move_board" data-board_no="'+notification_list[i].boardNo+'" data-notifications_id="'+notification_list[i].notifications_id+'">보러가기</button>'
                }
                console.log(notification_data);
                document.getElementById("notification_div").innerHTML = notification_data;
				document.getElementById("notification_div").value = "";
            }
            ,error: function () {
                console.log(error);
            }
        });
    });

    // 해당 게시글로 이동
    $(document).on("click", ".move_board", function (e) {
        e.preventDefault();

        console.log("게시글 가는 버튼 클릭 됨");
        var board_no = $(this).data("board_no");
        var notifications_id = $(this).data("notifications_id");
        var h_data = {boardNo: board_no}

        console.log(board_no);
        console.log(notifications_id);
        console.log("is_read_true ajax 시작");
        // 알림 읽음 처리
        $.ajax({
             type: "post"
            ,url: "/is_read_true"
            ,data: {notifications_id:notifications_id}
            ,success: function (params) {
                console.log("해당 알림 읽음 처리됨.");
                window.location.href = "content_view?pageNum=1&amount=10&type=&keyword=&boardNo="+board_no+"&mf_no="+sessionUserNo;
            }
            ,error: function () {
                console.log(error);
            }
        });

        // console.log("content_view ajax 시작");
        // // content_view 로 가게하기
        // $.ajax({
        //      type: "post"
        //     ,url: "/content_view"
        //     ,data: h_data
        //     ,success: function (params) {
        //         console.log(params);
        //         console.log("해당 게시글로 이동 됨");
        //         window.location.href = "content_view?pageNum=1&amount=10&type=&keyword=&boardNo="+board_no+"&mf_no="+sessionUserNo;
        //     }
        //     ,error: function () {
        //         console.log(error);
        //     }
        // });
    });
</script>

<div id="notification_page">
    <div>
        <button type="button" id="notification_btn">알림 버튼</button>
        <div id="notification_div"></div>
        <!-- <div id="notification_card">
            <div>읽음 안읽음 notification_list[i].is_read</div>
            <div>시간 notification_list[i].created_at</div>
            <div>누구인지 notification_list[i].following_id</div>
            <div>어디 게시글인지 댓글인지 notification_list[i].boardNo</div>
        </div> -->
    </div>
</div>