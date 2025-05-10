<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="${pageContext.request.contextPath}css/recipe_write.css" rel="stylesheet"><!-- 레시피 작성 -->
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<div class="content">
    <div class="recipe_write_container">
        <div class="recipe_write_header">
            <h2>레시피 작성</h2>
            <p>나만의 특별한 레시피를 공유해보세요!</p>
        </div>
        
        <form id="recipe_form" class="recipe_write_form" action="recipe_write" method="post" enctype="multipart/form-data">
            <!-- 기본 정보 섹션 -->
            <input type="hidden" name="mf_id" value="1">
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-info-circle"></i> 기본 정보</h3>
                
                <div class="form_group">
                    <label for="recipe_title">레시피 제목 <span class="required">*</span></label>
                    <input type="text" id="recipe_title" name="rc_name" required placeholder="레시피 이름을 입력하세요">
                </div>
                
                <div class="form_row">
                    <div class="form_group">
                        <label for="recipe_category">카테고리 <span class="required">*</span></label>
                        <select id="recipe_category" name="rc_category1_id" required>
                            <option value="">카테고리 선택</option>
                            <option value="1">한식</option>
                            <option value="2">양식</option>
                            <option value="3">일식</option>
                            <option value="4">중식</option>
                            <option value="5">디저트</option>
                        </select>
                    </div>
                    
                    <div class="form_group">
                        <label for="cooking_time">조리 시간 <span class="required">*</span></label>
                        <div class="input_with_unit">
                            <input type="number" id="cooking_time" name="rc_cooking_time" required min="1" placeholder="소요 시간">
                            <span class="unit">분</span>
                        </div>
                    </div>
                    
                    <div class="form_group">
                        <label for="difficulty">난이도 <span class="required">*</span></label>
                        <select id="difficulty" name="rc_difficulty" required>
                            <option value="">난이도 선택</option>
                            <option value="easy">초보자</option>
                            <option value="medium">중급자</option>
                            <option value="hard">고급자</option>
                        </select>
                    </div>
                </div>
                
                <div class="form_group">
                    <label for="recipe_description">레시피 소개 <span class="required">*</span></label>
                    <textarea id="recipe_description" name="rc_description" required placeholder="레시피에 대한 간단한 소개를 작성해주세요"></textarea>
                </div>
            </div>
            
            <!-- 대표 이미지 섹션 -->
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-image"></i> 대표 이미지</h3>
                
                <div class="image_upload_container">
                    <div class="image_preview" id="main_image_preview">
                        <i class="fas fa-camera"></i>
                        <p>이미지를 업로드해주세요</p>
                    </div>
                    <div class="image_upload_controls">
                        <label for="main_image" class="upload_btn">
                            <i class="fas fa-upload"></i> 이미지 선택
                        </label>
                        <input type="file" id="main_image" name="rc_img" accept="image/*" style="display: none;">
                        <p class="upload_hint">* JPG, PNG 파일 (최대 5MB)</p>
                    </div>
                </div>
            </div>
            
            <!-- 재료 섹션 -->
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-carrot"></i> 재료</h3>
                
                <div class="ingredients_container" id="ingredients_container">
                    <div class="ingredient_group">
                        <h4>주재료 <button type="button" class="add_group_btn" onclick="addIngredientGroup()"><i class="fas fa-plus"></i> 그룹 추가</button></h4>
                        
                        <div class="ingredient_list" id="main_ingredients">
                            <div class="ingredient_item">
                                <div class="form_row">
                                    <div class="form_group ingredient_name">
                                        <input type="text" name="rc_ingredient_name[]" placeholder="재료명" required>
                                    </div>
                                    <div class="form_group ingredient_amount">
                                        <input type="text" name="rc_ingredient_amount[]" placeholder="양">
                                    </div>
                                    <button type="button" class="remove_btn" onclick="removeIngredient(this)">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <button type="button" class="add_ingredient_btn" onclick="addIngredient('main_ingredients')">
                            <i class="fas fa-plus"></i> 재료 추가
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- 조리 과정 섹션 -->
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-utensils"></i> 조리 과정</h3>
                
                <div class="cooking_steps" id="cooking_steps">
                    <div class="step_item">
                        <div class="step_number">1</div>
                        <div class="step_content">
                            <div class="step_text">
                                <textarea name="rc_course_description[]" placeholder="조리 과정을 설명해주세요" required></textarea>
                            </div>
                            <div class="step_image">
                                <div class="image_preview step_image_preview">
                                    <i class="fas fa-camera"></i>
                                </div>
                                <label for="step_image_1" class="upload_btn step_upload_btn">
                                    <i class="fas fa-upload"></i> 사진 추가
                                </label>
                                <input type="file" id="step_image_1" name="rc_course_img[]" accept="image/*" style="display: none;">
                            </div>
                            <button type="button" class="remove_btn step_remove_btn" onclick="removeStep(this)">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <button type="button" class="add_step_btn" onclick="addStep()">
                    <i class="fas fa-plus"></i> 과정 추가
                </button>
            </div>
            
            <!-- 요리 팁 섹션 -->
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-lightbulb"></i> 요리 팁</h3>
                
                <div class="form_group">
                    <textarea id="cooking_tips" name="rc_tip" placeholder="요리할 때 알아두면 좋은 팁이나 주의사항을 알려주세요"></textarea>
                </div>
            </div>
            
            <!-- 태그 섹션 -->
            <div class="form_section">
                <h3 class="section_title"><i class="fas fa-tags"></i> 태그</h3>
                
                <div class="form_group">
                    <input type="text" id="recipe_tags" name="rc_tag" placeholder="태그를 입력하세요 (쉼표로 구분)">
                    <p class="input_hint">예: 다이어트, 간편요리, 술안주</p>
                </div>
            </div>
            
            <!-- 버튼 섹션 -->
            <div class="form_actions">
                <button type="button" class="cancel_btn" onclick="history.back()">취소</button>
                <button type="submit" class="submit_btn">레시피 등록</button>
            </div>
        </form>
    </div>
</div>
<script>

// 재료 그룹 추가 함수
function addIngredientGroup() {
    const container = document.getElementById('ingredients_container');
    const groupCount = container.querySelectorAll('.ingredient_group').length + 1;
    const groupId = 'ingredient_group_' + groupCount;
    
    const newGroup = document.createElement('div');
    newGroup.className = 'ingredient_group';
    newGroup.innerHTML = `
        <h4>추가 재료 <button type="button" class="remove_btn" onclick="removeIngredientGroup(this)"><i class="fas fa-times"></i></button></h4>
        
        <div class="ingredient_list" id="${groupId}">
            <div class="ingredient_item">
                <div class="form_row">
                    <div class="form_group ingredient_name">
                        <input type="text" name="rc_ingredient_name[]" placeholder="재료명" required>
                    </div>
                    <div class="form_group ingredient_amount">
                        <input type="text" name="rc_ingredient_amount[]" placeholder="양">
                    </div>
                    <button type="button" class="remove_btn" onclick="removeIngredient(this)">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <button type="button" class="add_ingredient_btn" onclick="addIngredient('${groupId}')">
            <i class="fas fa-plus"></i> 재료 추가
        </button>
    `;
    container.appendChild(newGroup);
}

// 재료 그룹 삭제 함수
function removeIngredientGroup(button) {
    const group = button.closest('.ingredient_group');
    group.remove();
}

// 재료 추가 함수
function addIngredient(groupId) {
    const group = document.getElementById(groupId);
    
    const newItem = document.createElement('div');
    newItem.className = 'ingredient_item';
    newItem.innerHTML = `
        <div class="form_row">
            <div class="form_group ingredient_name">
                <input type="text" name="rc_ingredient_name[]" placeholder="재료명" required>
            </div>
            <div class="form_group ingredient_amount">
                <input type="text" name="rc_ingredient_amount[]" placeholder="양">
            </div>
            <button type="button" class="remove_btn" onclick="removeIngredient(this)">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    group.appendChild(newItem);
}

// 재료 삭제 함수
function removeIngredient(button) {
    const item = button.closest('.ingredient_item');
    item.remove();
}

// 조리 과정 추가 함수
function addStep() {
    const container = document.getElementById('cooking_steps');
    const stepCount = container.querySelectorAll('.step_item').length + 1;
    
    const newStep = document.createElement('div');
    newStep.className = 'step_item';
    newStep.innerHTML = `
        <div class="step_number">${stepCount}</div>
        <div class="step_content">
            <div class="step_text">
                <textarea name="rc_course_description[]" placeholder="조리 과정을 설명해주세요" required></textarea>
            </div>
            <div class="step_image">
                <div class="image_preview step_image_preview">
                    <i class="fas fa-camera"></i>
                </div>
                <label for="step_image_${stepCount}" class="upload_btn step_upload_btn">
                    <i class="fas fa-upload"></i> 사진 추가
                </label>
                <input type="file" id="step_image_${stepCount}" name="rc_course_img[]" accept="image/*" style="display: none;" onchange="previewStepImage(this)">
            </div>
            <button type="button" class="remove_btn step_remove_btn" onclick="removeStep(this)">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    container.appendChild(newStep);
    
    // 새로 추가된 단계의 이미지 미리보기 이벤트 설정
    document.getElementById(`step_image_${stepCount}`).addEventListener('change', function() {
        const preview = this.parentElement.previousElementSibling.previousElementSibling;
        previewImage(this, preview);
    });
}

// 조리 과정 삭제 함수
function removeStep(button) {
    const step = button.closest('.step_item');
    step.remove();
    
    // 단계 번호 재정렬
    const steps = document.querySelectorAll('.step_item');
    steps.forEach((step, index) => {
        step.querySelector('.step_number').textContent = index + 1;
    });
}

// 조리 과정 이미지 미리보기 함수
function previewStepImage(input) {
    const preview = input.parentElement.previousElementSibling.querySelector('.step_image_preview');
    previewImage(input, preview);
}
</script>
<script>
    var count = 0;

$("#main_image").on("change", function (e) {
    var file = e.target.files[0];
    var formData = new FormData();
    formData.append("rc_img", file);

    $.ajax({
        url: "/uploadAjaxAction",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        success: function (result) {
            count++;

            // ✅ count ≥ 2면 이전 파일 삭제
            if (count >= 2) {
                var oldFileName = $("#rc_img").val();  // 이전 파일 경로를 저장해놨던 곳
                $.ajax({
                    url: "/deleteFile",
                    data: {
                        fileName: oldFileName,
                        type: "image"
                    },
                    type: "POST",
                    success: function (res) {
                        console.log("이전 파일 삭제됨");
                    }
                });
            }

            // ✅ 새 파일 preview 및 fileName 보관
            var fileCallPath = encodeURIComponent(result[0].uploadPath + "/s_" + result[0].uuid + "_" + result[0].fileName);
            $("#main_image_preview").html(
                "<img src='/display?fileName=" + fileCallPath + "'><input type='hidden' name='rc_img' id='rc_img' value='" + fileCallPath + "'>"
            );
        }
    });
});
</script>