<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>아이디 중복 확인</title>
</head>
<body>
    <h3>아이디 중복 확인</h3>
    <form>
        <label for="mf_id">아이디:</label>
        <input type="text" id="mf_id" name="mf_id">
        <button type="button" onclick="checkId()">중복확인</button>
    </form>

    <script>
        function checkId() {
            var id = document.getElementById("mf_id").value;

            // Controller로 AJAX 요청
            fetch("/member/mf_id_check?mf_id=" + id)
                .then(response => response.text())
                .then(result => {
                    if (result === "unavailable") {
                        alert("이미 사용 중인 아이디입니다.");
                    } else {
                        alert("사용 가능한 아이디입니다.");
                        document.getElementById("mf_id").readOnly = true;
                    }
                })
                .catch(error => console.error("에러 발생:", error));
        }
    </script>
</body>
</html>
