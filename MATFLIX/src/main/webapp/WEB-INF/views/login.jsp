<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 로그인</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 로그인 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script>
        $(document).ready(function() {
            // 비밀번호 표시/숨기기
            $("#togglePassword").on("click", function() {
                const passwordField = document.getElementById("mf_pw");
                const type = passwordField.type === "password" ? "text" : "password";
                passwordField.type = type;
                $(this).toggleClass("fa-eye fa-eye-slash");
            });
        });
		// 로그인 버튼 엔터키도 가능
        $("#user_login").on("keydown", function(event) {
            if (event.key === "Enter") {
                event.preventDefault();
                user_login();
            }
        });
    </script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="content">
        <div class="login_container">
            <div class="login_box">
                <div class="login_header">
                    <h2>로그인</h2>
                    <p><span id="login_MATFLIX">MATFLIX</span> 에 오신 것을 환영합니다</p>
                </div>
                <form id="user_login" class="login_form" action="main_membership" method="post">
                    <div class="form_group">
                        <label for="mf_id"><i class="fas fa-user"></i> 아이디</label>
                        <input type="text" name="mf_id" id="mf_id" required oninvalid="this.setCustomValidity('아이디를 입력해주세요.')" oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_pw"><i class="fas fa-lock"></i> 비밀번호 </label>
                        <div id="box">
                            <div id="box_box">
                                <input type="password" name="mf_pw" id="mf_pw" required oninvalid="this.setCustomValidity('비밀번호를 입력해주세요.')" oninput="this.setCustomValidity('')">
                            </div>
                            <div id="box_i">
                                <i class="fa fa-eye" id="togglePassword"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form_options">
                        <div class="remember_me">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">아이디 저장</label>
                        </div>
                        <div class="forgot_password">
                            <a href="forgot_password.jsp">비밀번호 찾기</a>
                        </div>
                    </div>
                    
                    <div class="form_buttons">
                        <input type="submit" class="login_btn_login" value="로그인">
                    </div>
                </form>
                
                <div class="social_login">
                    <p>소셜 계정으로 로그인</p>
                    <div class="social_buttons">
                        <a href="https://kauth.kakao.com/oauth/authorize?response_type=code
                            &client_id=2920c6e2df9de128fb61e072bc2721aa
                            &redirect_uri=http://localhost:8485/login/oauth2/code/kakao" class="social_button kakao">
                            <i class="fas fa-comment-dots"></i> 카카오 로그인
                        </a>
                        <a href="#" class="social_button naver">
                            <i class="fas fa-n"></i> 네이버 로그인
                        </a>
                        <a href="#" class="social_button google">
                            <i class="fab fa-google"></i> 구글 로그인
                        </a>
                    </div>
                </div>
                
                <div class="register_link">
                    <p>아직 회원이 아니신가요? <a id="login_recruit" href="/recruit">회원가입</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>