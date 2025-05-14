<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 회원가입</title>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <!-- 회원가입 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recruit.css">
    <!-- 폰트어썸 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script>
        // 아이디 중복체크
        $(document).on("click", ".btn_check", function () {
            console.log("btn_check");
            const mf_id = $("#mf_id").val();
            console.log("입력된 ID:", mf_id);  // 아이디 값 확인

            if (!mf_id) {
                alert("아이디를 입력하세요.");
                return;  // 빈값이면 빠져나감
            }

            // 아이디 길이 체크
            if (mf_id.length < 4 || mf_id.length > 20) {
                alert("아이디는 4자 이상 20자 이하이어야 합니다.");
                return;  // 길이 체크 후 빠져나감
            }

            // 정규식 체크
            const idPattern = /^[a-zA-Z0-9]{4,20}$/;
            if (!idPattern.test(mf_id)) {
                alert("아이디는 4~20자의 영문 대/소문자 또는 숫자만 가능합니다.");
                return;  // 정규식 안 맞으면 빠져나감
            }

            console.log("정규식 통과됨");  // 정규식 통과 확인

            console.log("Ajax 요청 시작");  // Ajax 요청이 실행되는지 확인

            $.ajax({
                type: "post",
                url: "/mf_id_check",
                data: { mf_id: mf_id },
                success: function (response) {
                    console.log("서버 응답:", response);  // 응답 확인
                    if (response === "available") {
                        alert("사용 가능한 아이디입니다.");
                        $("#mf_id").prop("readonly", true);
                        $(".btn_check").prop("disabled", true).text("중복체크 완료");
                    } else if (response === "unavailable") {
                        alert("이미 사용 중인 아이디입니다.");
                    } else {
                        alert("확인 중 오류가 발생했습니다.");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Ajax 오류:", status, error);  // 에러 확인
                    alert("서버 요청 중 오류가 발생했습니다.");
                }
            });
        });

        // 이메일 인증 번호 받기
        $(document).on("click", "#email_send_btn", function () {
            console.log("인증번호 받기 버튼 클릭");
            const mf_email = $("#mf_email").val();
            console.log("이메일 => ", mf_email);

            if (!mf_email) {
                alert("이메일을 입력해주세요.");
                return;
            }

            $.ajax({
                type: "post",
                url: "/email_check",
                data: { mf_email: mf_email },
                success: function (code) {
                    console.log("email_chk 응답:", code);
                    if (code !=null) {
                        alert("이메일 인증번호 전송 완료.");
                        $("#email_send_btn").prop("disabled", true).text("전송완료");
                        $("#mf_email").prop("readonly", true);
                    } else {
                        alert("이메일 인증번호 전송 실패.");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Ajax 오류:", status, error);
                    alert("서버 요청 중 오류가 발생했습니다.");
                }
            });
        });

        // 이메일 인증증 확인
        $(document).on("click", "#email_chk_btn", function () {
            console.log("이메일 체크 버튼 클릭");
            const code_chk = $("#code_chk").val();
            console.log("code_chk => ", code_chk);

            if (!code_chk) {
                alert("인증번호를 입력해주세요.");
                return;
            }

            $.ajax({
                type: "post",
                url: "/code_check",
                data: { code_chk: code_chk },
                success: function (result) {
                    console.log("code_check 응답:", result);
                    if (result == "true") {
                        alert("이메일 인증 완료.");
                        $("#email_chk_btn").prop("disabled", true).text("인증완료");
                        $("#code_chk").prop("readonly", true);
                    } else {
                        alert("인증 번호 미일치.");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Ajax 오류:", status, error);  // 에러 확인
                    alert("서버 요청 중 오류가 발생했습니다.");
                }
            });
        });
        
        function fn_submit() {
            console.log("@# fn_submit 실행된다.")
            const form = document.getElementById("frm");

            if(!$("#mf_id").prop("readonly")){
                alert("아이디 중복확인 하세요.");
                return;
            }
            
            // 유효성 검사 실행
            if (!form.checkValidity()) {
                form.reportValidity();  // 브라우저 기본 경고창 띄움
                return;  // 중단
            }

            // 비밀번호 확인 일치 여부 확인
            if (!checkPasswordMatch()) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            // 이메일 인증 확인 여부
            if(!$("#code_chk").prop("readonly")){
                alert("이메일 인증을 해주세요.");
                return;
            }

            const formData = $("#frm").serialize();

            // 로딩 인디케이터 표시
            $("body").append("<div class='loading'>처리 중...</div>");

            $.ajax({
                type: "post",
                data: formData,
                url: "recruit_result_ok",
                success: function(data) {
                    alert("회원가입이 정상적으로 처리되었습니다.");
                    window.location.href = "/login";
                },
                error: function() {
                    alert("fn_submit 여기에서 오류 발생");
                }
            });
        }

        function checkPasswordMatch() {
            const password = document.getElementById("mf_pw").value;
            const confirmPassword = document.getElementById("mf_pw_chk").value;
            if (password !== confirmPassword) {
                document.getElementById("pw_match_msg").innerHTML = "비밀번호가 일치하지 않습니다.";
                document.getElementById("pw_match_msg").style.color = "red";
                return false;
            } else {
                document.getElementById("pw_match_msg").innerHTML = "비밀번호가 일치합니다.";
                document.getElementById("pw_match_msg").style.color = "green";
                return true;
            }
        }

        // 회원가입 취소
        $(document).on("click", ".header_logo, .logo, #home, .btn_cancel", function () {
            $("html, body").animate({ scrollTop: 0 }, 0);
            $(".content").load("${pageContext.request.contextPath}/main", function(response, status, xhr) {
                if (status === "error") {
                    alert("홈 페이지 로딩 중 오류가 발생했습니다: " + xhr.status);
                } else {
                    console.log("홈 페이지 로딩 완료");
                }
            });
        });
        
        // 비밀번호 표시/숨기기 기능
        $(document).ready(function() {
            // 비밀번호 필드 토글
            $("#togglePassword").on("click", function() {
                const passwordField = document.getElementById("mf_pw");
                const type = passwordField.type === "password" ? "text" : "password";
                passwordField.type = type;
                $(this).toggleClass("fa-eye fa-eye-slash");
            });
            
            // 비밀번호 확인 필드 토글
            $("#togglePwChk").on("click", function() {
                const passwordField = document.getElementById("mf_pw_chk");
                const type = passwordField.type === "password" ? "text" : "password";
                passwordField.type = type;
                $(this).toggleClass("fa-eye fa-eye-slash");
            });
        });
    </script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="content">
        <div class="register_container">
            <div class="register_box">
                <div class="register_header">
                    <h2>회원가입</h2>
                    <p><span id="register_MATFLIX">MATFLIX</span> 회원이 되어 다양한 레시피를 만나보세요</p>
                </div>
                <form id="frm" class="register_form" action="recruit_result_ok" method="post">
                    <div class="form_group">
                        <label for="mf_name"><i class="fas fa-user-circle"></i> 이름 <span class="required">*</span></label>
                        <input type="text" id="mf_name" name="mf_name"
                               required maxlength="20"
                               pattern="^[a-z가-힣]+$"
                               title="소문자, 한글만 입력 가능합니다."
                               oninvalid="this.setCustomValidity('올바른 이름 형식이 아닙니다. 소문자/한글만 입력하세요.')"
                               oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_id"><i class="fas fa-user"></i> 아이디 <span class="required">*</span></label>
                        <div class="input_with_button">
                            <input type="text" id="mf_id" name="mf_id" 
                                   required minlength="4" maxlength="12"
                                   pattern="^[a-zA-Z0-9]{4,12}$"
                                   oninvalid="this.setCustomValidity('아이디는 4~12자의 영문 소문자 및 숫자만 입력 가능합니다.')"
                                   oninput="this.setCustomValidity('')">
                            <button type="button" class="btn_check">중복확인</button>
                        </div>
                        <p class="input_hint">영문, 숫자 조합 4-12자리</p>
                    </div>
                    
                    <div class="form_group_pw">
                        <label for="mf_pw"><i class="fas fa-lock"></i> 비밀번호 <span class="required">*</span></label>
                        <div class="password_container">
                            <input type="password" name="mf_pw" id="mf_pw" 
                                  required 
                                   pattern="^[a-zA-Z0-9]{8,16}$"
                                   title="영문, 숫자, 특수문자 조합 8-16자리로 입력해주세요." 
                                   oninvalid="this.setCustomValidity('영문, 숫자 조합 8-16자리로 입력해주세요.')"
                                   oninput="this.setCustomValidity('')">
                            <span class="password_toggle">
                                <i class="fa fa-eye" id="togglePassword"></i>
                            </span>
                        </div>
                        <p class="input_hint">영문, 숫자, 특수문자 조합 8-16자리</p>
                    </div>
                    
                    <div class="form_group_pw">
                        <label for="mf_pw_chk"><i class="fas fa-lock"></i> 비밀번호 확인 <span class="required">*</span></label>
                        <div class="password_container">
                            <input type="password" name="mf_pw_chk" id="mf_pw_chk"
                                   required
                                   placeholder="비밀번호를 다시 입력"
                                   oninput="checkPasswordMatch()">
                            <span class="password_toggle">
                                <i class="fa fa-eye" id="togglePwChk"></i>
                            </span>
                        </div>
                        <div id="pw_match_msg" class="validation_message"></div>
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_email"><i class="fas fa-envelope"></i> 이메일 <span class="required">*</span></label>
                        <div class="input_with_button">
                            <input type="email" name="mf_email" id="mf_email" required>
                            <button type="button" id="email_send_btn">인증번호 받기</button>
                        </div>
                        
                        <div class="input_with_button verification_code">
                            <input type="text" name="code_chk" id="code_chk" placeholder="인증번호 입력">
                            <button type="button" id="email_chk_btn">인증번호 확인</button>
                        </div>
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_phone"><i class="fas fa-phone"></i> 전화번호 <span class="required">*</span></label>
                        <input type="tel" name="mf_phone" id="mf_phone"
                               required
                               placeholder="010-0000-0000"
                               pattern="^010-\d{4}-\d{4}$"
                               oninvalid="this.setCustomValidity('올바른 전화번호 형식(010-0000-0000)으로 입력해주세요.')"
                               oninput="this.setCustomValidity('')">
                    </div>
                    
                    <div class="form_group">
                        <label for="mf_birth"><i class="fas fa-birthday-cake"></i> 생년월일 <span class="required">*</span></label>
                        <input type="text" name="mf_birth" id="mf_birth" required placeholder="주민등록번호 앞자리 6자리">
                    </div>
                    
                    <div class="form_group">
                        <label><i class="fas fa-venus-mars"></i> 성별 <span class="required">*</span></label>
                        <div class="gender_options">
                            <label class="radio_label">
                                <input type="radio" name="mf_gender" value="M" checked> 남
                            </label>
                            <label class="radio_label">
                                <input type="radio" name="mf_gender" value="F"> 여
                            </label>
                        </div>
                    </div>
                    
                    <div class="form_buttons">
                        <button type="button" class="btn_register_recruit" onclick="fn_submit()">가입하기</button>
                        <button type="button" class="btn_cancel">취소</button>
                    </div>
                </form>
                
                <div class="login_link">
                    <p>이미 회원이신가요? <a class="recruit_cancel" href="${pageContext.request.contextPath}/login">로그인</a></p>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>