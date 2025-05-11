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
    <% } else { %>
        var sessionUserNo = null;
    <% } %>

    $(document).on("click", function (e) {
        e.preventDefault();

        $.ajax({
             type: "POST"
            ,url: "/notification_list"
            ,data: {follower_id: sessionUserNo}
            ,success: function (list) {
                
            }
            ,error: function () {
                console.log(error);
            }
        });
    });
</script>

<div id="notification_page">
    <div id="">
        
    </div>
</div>