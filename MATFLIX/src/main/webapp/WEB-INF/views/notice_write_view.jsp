<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 공지사항 작성</title>
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
        
        /* 공지사항 작성 페이지 스타일 */
        .notice-write {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-top: 20px;
            animation: fadeIn 0.8s ease-out;
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
        
        .form-actions {
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
            padding: 10px 20px;
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
        
        .file-upload-container {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            border: 1px dashed #ddd;
        }
        
        .file-upload-btn {
            display: inline-block;
            background-color: #f0f0f0;
            color: #555;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid #ddd;
        }
        
        .file-upload-btn:hover {
            background-color: #e0e0e0;
        }
        
        .file-upload-btn i {
            margin-right: 5px;
        }
        
        .file-upload-input {
            display: none;
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
            <h1>공지사항 작성</h1>
            <p>MATFLIX 사용자들에게 중요한 소식을 알려주세요</p>
        </div>
        
        <div class="notice-write">
            <form id="frm" method="post" action="notice_write">
                <div class="form-group">
                    <label for="notice_boardName">
                        <i class="fas fa-user"></i> 작성자
                    </label>
                    <input type="text" id="notice_boardName" name="notice_boardName" placeholder="작성자 이름을 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="notice_boardTitle">
                        <i class="fas fa-heading"></i> 제목
                    </label>
                    <input type="text" id="notice_boardTitle" name="notice_boardTitle" placeholder="공지사항 제목을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label for="notice_boardContent">
                        <i class="fas fa-align-left"></i> 내용
                    </label>
                    <textarea id="notice_boardContent" name="notice_boardContent" placeholder="공지사항 내용을 입력하세요"></textarea>
                </div>
                
                <div class="file-upload-container">
                    <label for="uploadFile" class="file-upload-btn">
                        <i class="fas fa-upload"></i> 파일 첨부하기
                    </label>
                    <input type="file" id="uploadFile" name="uploadFile" class="file-upload-input" multiple>
                    <p class="file-upload-info">최대 5MB, exe/sh/alz 파일은 업로드할 수 없습니다.</p>
                </div>
                
                <div class="uploadResult">
                    <ul>
                        <!-- 업로드된 파일이 여기에 표시됩니다 -->
                    </ul>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="notice-btn">
                        <i class="fas fa-paper-plane"></i> 등록
                    </button>
                    <a href="${pageContext.request.contextPath}/notice_list" class="notice-btn notice-btn-secondary">
                        <i class="fas fa-list"></i> 목록보기
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />

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
            str += "<span data-file='" + fileCallPath + "' data-type='" + (obj.notice_image ? "image" : "file") + "' class='file-delete-btn'> x </span>";
            str += "</div></li>";
        });

        uploadUL.append(str);
    }

    $(".uploadResult").on("click", ".file-delete-btn", function () {
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
    
    // 파일 업로드 버튼 클릭 시 파일 선택 창 열기
    $(".file-upload-btn").on("click", function() {
        $("#uploadFile").click();
    });
});
</script>
</body>
</html>
