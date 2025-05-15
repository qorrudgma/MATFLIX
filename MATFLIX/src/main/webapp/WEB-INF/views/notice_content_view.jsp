<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boot.dto.TeamDTO" %>
<%
    TeamDTO user = (TeamDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 공지사항 상세</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 공지사항 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <style>
        .uploadResult {
            width: 100%;
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .uploadResult ul {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            padding: 0;
            margin: 0;
        }

        .uploadResult ul li {
            list-style: none;
            padding: 10px;
            background-color: white;
            border-radius: 4px;
            border: 1px solid #ddd;
            transition: all 0.2s;
        }

        .uploadResult ul li:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
        }

        .uploadResult ul li img {
            width: 100px;
            border-radius: 4px;
        }
        
        /* 공지사항 상세 페이지 스타일 */
        .notice-detail {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-top: 20px;
            animation: fadeIn 0.8s ease-out;
        }
        
        .notice-detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }
        
        .notice-detail-title {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }
        
        .notice-detail-info {
            display: flex;
            gap: 20px;
            color: #666;
            font-size: 14px;
        }
        
        .notice-detail-info span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .notice-detail-content {
            padding: 20px 0;
            min-height: 200px;
            line-height: 1.6;
            color: #333;
            white-space: pre-wrap;
        }
        
        .notice-detail-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .notice-btn {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .notice-btn:hover {
            background-color: #d44637;
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
        }
        
        .notice-btn-secondary {
            background-color: #6c757d;
        }
        
        .notice-btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .notice-btn-danger {
            background-color: #e74c3c;
        }
        
        .notice-btn-danger:hover {
            background-color: #c0392b;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #555;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            transition: all 0.2s;
        }
        
        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.1);
            outline: none;
        }
        
        .form-group textarea {
            min-height: 200px;
            resize: vertical;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="notice-container">
        <!-- 장식 요소 -->
        <div class="notice-decoration notice-decoration-1"></div>
        <div class="notice-decoration notice-decoration-2"></div>
        <div class="notice-decoration notice-decoration-3"></div>
        
        <div class="notice-title">
            <h1>공지사항 상세</h1>
            <p>MATFLIX의 중요 소식과 업데이트를 확인하세요</p>
        </div>
        
        <div class="notice-detail">
            <form id="actionForm" method="post" action="notice_modify">
                <input type="hidden" name="notice_boardNo" value="${pageMaker.notice_boardNo}">
                <input type="hidden" name="notice_pageNum" value="${pageMaker.notice_pageNum}">
                <input type="hidden" name="notice_amount" value="${pageMaker.notice_amount}">
                
                <c:choose>
                    <c:when test="${user != null && user.mf_role == 'ADMIN'}">
                        <!-- 관리자용 편집 폼 -->
                        <div class="form-group">
                            <label for="notice_boardName">작성자</label>
                            <input type="text" id="notice_boardName" name="notice_boardName" value="${content_view.notice_boardName}">
                        </div>
                        
                        <div class="form-group">
                            <label for="notice_boardTitle">제목</label>
                            <input type="text" id="notice_boardTitle" name="notice_boardTitle" value="${content_view.notice_boardTitle}">
                        </div>
                        
                        <div class="form-group">
                            <label for="notice_boardContent">내용</label>
                            <textarea id="notice_boardContent" name="notice_boardContent" rows="10">${content_view.notice_boardContent}</textarea>
                        </div>
                        
                        <div class="notice-detail-info">
                            <span><i class="fas fa-eye"></i> 조회수: ${content_view.notice_boardHit}</span>
                            <span><i class="fas fa-hashtag"></i> 번호: ${content_view.notice_boardNo}</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- 일반 사용자용 보기 폼 -->
                        <div class="notice-detail-header">
                            <div class="notice-detail-title">${content_view.notice_boardTitle}</div>
                            <div class="notice-detail-info">
                                <span><i class="fas fa-user"></i> ${content_view.notice_boardName}</span>
                                <span><i class="fas fa-eye"></i> 조회수: ${content_view.notice_boardHit}</span>
                                <span><i class="fas fa-hashtag"></i> 번호: ${content_view.notice_boardNo}</span>
                            </div>
                        </div>
                        
                        <div class="notice-detail-content">
                            ${content_view.notice_boardContent}
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="notice-detail-actions">
                    <c:if test="${user != null && user.mf_role == 'ADMIN'}">
                        <button type="submit" class="notice-btn">
                            <i class="fas fa-edit"></i> 수정
                        </button>
                        <button type="submit" formaction="notice_delete" class="notice-btn notice-btn-danger">
                            <i class="fas fa-trash-alt"></i> 삭제
                        </button>
                    </c:if>
                    <button type="submit" formaction="notice_list" class="notice-btn notice-btn-secondary">
                        <i class="fas fa-list"></i> 목록보기
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
