<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATFLIX - 레시피 작성</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recipe_write_new.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="mf_page">
        <div class="mf_container">
            <div class="mf_header">
                <div class="mf_header_left">
                    <h1 class="mf_title">레시피 작성</h1>
                    <p class="mf_subtitle">나만의 레시피를 MATFLIX에 공유해보세요.</p>
                </div>
<!--                <div class="mf_header_right">-->
<!--                    <div class="mf_badge"><i class="fa-solid fa-fire"></i> WRITE</div>-->
<!--                </div>-->
            </div>

            <form id="recipe_write_form" class="mf_form" action="recipe_write" method="post" enctype="multipart/form-data" autocomplete="off">

                <!-- 맨위에 대표 이미지 넣는 부분 -->
                <section class="mf_section" id="section_thumbnail">
                    <div class="mf_section_title">
                        <h2><i class="fa-regular fa-image"></i> 대표 이미지</h2>
                        <span class="mf_required">*</span>
                    </div>

                    <div class="mf_image_box">
                        <div class="mf_image_preview" id="thumbnail_preview" aria-label="대표 이미지 미리보기">
                            <div class="mf_image_placeholder">
                                <i class="fa-solid fa-camera"></i>
                                <div class="mf_image_placeholder_text">대표 이미지를 업로드해주세요</div>
                                <div class="mf_image_placeholder_hint">JPG / PNG 권장 (최대 5MB)</div>
                            </div>
                        </div>

                        <div class="mf_image_controls">
                            <label class="mf_btn mf_btn_outline" for="thumbnail_file">
                                <i class="fa-solid fa-upload"></i> 이미지 선택
                            </label>
                            <input type="hidden" name="step_no[]" value="0">
                            <input type="hidden" name="image_type[]" value="THUMBNAIL">
                            <input type="file" id="thumbnail_file" name="image_path[]" accept="image/*" class="mf_file_input">

                            <button type="button" class="mf_btn mf_btn_ghost" id="thumbnail_clear_btn">
                                <i class="fa-solid fa-rotate-left"></i> 선택 해제
                            </button>

                            <div class="mf_help">대표 이미지는 목록/상세에서 가장 먼저 보여요.</div>
                        </div>
                    </div>
                </section>

                <!-- 기본 정보: 제목/간단 소개 -->
                <section class="mf_section" id="section_basic">
                    <div class="mf_section_title">
                        <h2><i class="fa-solid fa-circle-info"></i> 기본 정보</h2>
                        <span class="mf_required">*</span>
                    </div>

                    <div class="mf_grid">
                        <div class="mf_field">
                            <label class="mf_label" for="recipe_title">제목</label>
                            <input type="text" id="recipe_title" name="title" class="mf_input" placeholder="예) 자취생 10분 김치볶음밥" maxlength="60" required>
                            <div class="mf_count"><span id="title_count">0</span>/60</div>
                        </div>

                        <div class="mf_field mf_field_full">
                            <label class="mf_label" for="recipe_intro">간단 소개</label>
                            <textarea id="recipe_intro" name="intro" class="mf_textarea mf_textarea_small" placeholder="레시피 한 줄 소개를 짧게 작성해주세요" maxlength="140" required></textarea>
                            <div class="mf_count"><span id="intro_count">0</span>/140</div>
                        </div>
                    </div>
                </section>

                <!-- 음식 양, 시간, 난이도 -->
                <section class="mf_section" id="section_meta">
                    <div class="mf_section_title">
                        <h2><i class="fa-solid fa-sliders"></i> 레시피 정보</h2>
                        <span class="mf_required">*</span>
                    </div>

                    <div class="mf_grid mf_grid_3">
                        <div class="mf_field">
                            <label class="mf_label" for="recipe_servings">몇 인분</label>
                            <select id="recipe_servings" name="servings" class="mf_select" required>
                                <option value="">선택</option>
                                <option value="1">1인분</option>
                                <option value="2">2인분</option>
                                <option value="3">3인분</option>
                                <option value="4">4인분</option>
                                <option value="5">5인분</option>
                                <option value="6">6인분</option>
                                <option value="7">7인분</option>
                                <option value="8">8인분</option>
                                <option value="9">9인분</option>
                                <option value="10">10인분+</option>
                            </select>
                        </div>

                        <div class="mf_field">
                            <label class="mf_label" for="recipe_time">조리 시간(분)</label>
                            <div class="mf_input_unit">
                                <input type="number" id="recipe_time" name="cook_time" class="mf_input" placeholder="예) 15" min="1" max="999" required>
                                <span class="mf_unit">분</span>
                            </div>
                        </div>

                        <div class="mf_field">
                            <label class="mf_label" for="recipe_level">난이도</label>
                            <select id="recipe_level" name="difficulty" class="mf_select" required>
                                <option value="">선택</option>
                                <option value="EASY">쉬움</option>
                                <option value="NORMAL">보통</option>
                                <option value="HARD">어려움</option>
                            </select>
                        </div>
						
				       <div class="mf_field">
				           <label class="mf_label" for="recipe_category">음식 분야</label>
				           <select id="recipe_category" name="category" class="mf_select" required>
				               <option value="">선택</option>
				               <option value="KOREAN">한식</option>
				               <option value="CHINESE">중식</option>
				               <option value="JAPANESE">일식</option>
				               <option value="WESTERN">양식</option>
				               <option value="DESSERT">디저트</option>
				           </select>
				       </div>
                    </div>
                </section>

                <!-- 재료 이름/양 -->
                <section class="mf_section" id="section_ingredients">
                    <div class="mf_section_title">
                        <h2><i class="fa-solid fa-carrot"></i> 재료</h2>
                        <span class="mf_required">*</span>
                    </div>

                    <div class="mf_section_desc">재료명을 입력하고, 필요하면 양/단위를 적어주세요. (예: "양파" / "1/2개")</div>

                    <div class="mf_list" id="ingredient_list">
                        <div class="mf_list_row ingredient_row" data_row="1">
                            <div class="mf_field">
                                <label class="mf_label mf_label_inline">재료명</label>
                                <input type="text" name="ingredient_name[]" class="mf_input" placeholder="예) 양파" required>
                            </div>
                            <div class="mf_field">
                                <label class="mf_label mf_label_inline">양</label>
                                <input type="text" name="ingredient_amount[]" class="mf_input" placeholder="예) 1/2개">
                            </div>
                            <div class="mf_row_actions">
                                <button type="button" class="mf_btn mf_btn_icon mf_btn_danger ingredient_remove_btn" title="삭제">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="mf_actions_inline">
                        <button type="button" class="mf_btn mf_btn_outline" id="ingredient_add_btn">
                            <i class="fa-solid fa-plus"></i> 재료 추가
                        </button>
                    </div>
                </section>

                <!-- 조리순서 + 이미지 -->
                <section class="mf_section" id="section_steps">
                    <div class="mf_section_title">
                        <h2><i class="fa-solid fa-utensils"></i> 조리 순서</h2>
                        <span class="mf_required">*</span>
                    </div>

                    <div class="mf_section_desc">순서대로 적어주세요. 각 과정에 이미지를 추가할 수 있어요.</div>

                    <div class="mf_steps" id="step_list">
                        <div class="mf_step" data_step="1">
                            <div class="mf_step_left">
                                <div class="mf_step_no">1</div>
                            </div>

                            <div class="mf_step_body">
                                <div class="mf_step_text">
									<input type="hidden" name="step_no[]" value="1" class="step_order_input">
                                    <label class="mf_label mf_label_inline">설명</label>
                                    <textarea name="step_content[]" class="mf_textarea" placeholder="예) 양파를 잘게 다져 중불에 2분 볶아주세요" required></textarea>
                                </div>

                                <div class="mf_step_media">
                                    <div class="mf_step_image">
                                        <div class="mf_step_preview" data_preview="1">
                                            <div class="mf_image_placeholder">
                                                <i class="fa-regular fa-images"></i>
                                                <div class="mf_image_placeholder_text">과정 이미지(선택)</div>
                                                <div class="mf_image_placeholder_hint">있으면 더 좋아요</div>
                                            </div>
                                        </div>

                                        <div class="mf_step_controls">
                                            <label class="mf_btn mf_btn_outline" for="step_file_1">
                                                <i class="fa-solid fa-upload"></i> 이미지 선택
                                            </label>
                                            <input type="hidden" name="image_type[]" value="STEP">
                                            <input type="file" id="step_file_1" name="image_path[]" accept="image/*" class="mf_file_input mf_step_file" data_step="1">

                                            <button type="button" class="mf_btn mf_btn_ghost step_clear_btn" data_step="1">
                                                <i class="fa-solid fa-rotate-left"></i> 해제
                                            </button>
                                        </div>
                                    </div>

                                    <div class="mf_step_actions">
                                        <button type="button" class="mf_btn mf_btn_icon mf_btn_danger step_remove_btn" title="삭제">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mf_actions_inline">
                        <button type="button" class="mf_btn mf_btn_outline" id="step_add_btn">
                            <i class="fa-solid fa-plus"></i> 과정 추가
                        </button>
                    </div>
                </section>

                <!-- 팁 -->
                <section class="mf_section" id="section_tip">
                    <div class="mf_section_title">
                        <h2><i class="fa-regular fa-lightbulb"></i> 팁</h2>
                    </div>

                    <div class="mf_field">
                        <label class="mf_label" for="recipe_tip">요리 팁</label>
                        <textarea id="recipe_tip" name="tip" class="mf_textarea" placeholder="예) 마지막에 참기름 한 방울 넣으면 고소함이 확 살아나요"></textarea>
                    </div>
                </section>

                <!-- # 태그 -->
                <section class="mf_section" id="section_tags">
                    <div class="mf_section_title">
                        <h2><i class="fa-solid fa-hashtag"></i> 태그</h2>
                    </div>

                    <div class="mf_section_desc">태그를 추가하면 검색/분류에 도움이 돼요. (엔터 또는 추가 버튼)</div>

                    <div class="mf_tag_box">
                        <div class="mf_tag_input_row">
                            <input type="text" id="tag_input" class="mf_input" placeholder="예) 다이어트">
                            <button type="button" class="mf_btn mf_btn_outline" id="tag_add_btn">
                                <i class="fa-solid fa-plus"></i> 추가
                            </button>
                        </div>

                        <div class="mf_tag_list" id="tag_list"></div>
                        <input type="hidden" name="tags" id="tag_hidden" value="">

                        <div class="mf_help">팁: "#" 없이 입력해도 자동으로 태그로 들어가요.</div>
                    </div>
                </section>

                <!-- 저장/취소 -->
                <div class="mf_footer_actions">
                    <button type="button" class="mf_btn mf_btn_ghost" id="cancel_btn">
                        <i class="fa-solid fa-arrow-left"></i> 취소
                    </button>
                    <button type="submit" class="mf_btn mf_btn_primary" id="submit_btn">
                        <i class="fa-solid fa-check"></i> 등록
                    </button>
                </div>

            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

<script>
(function() {
    "use strict";

    function escape_html(text) {
        return String(text)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function set_count(input_el, count_el_id, max_len) {
        var el = document.getElementById(count_el_id);
        if (!el) {
            return;
        }
        var len = (input_el.value || "").length;
        el.textContent = String(len);
        if (max_len && len > max_len) {
            el.textContent = String(max_len);
        }
    }

    function render_image_preview(file, preview_el) {
        if (!file || !preview_el) {
            return;
        }
        var reader = new FileReader();
        reader.onload = function(e) {
            preview_el.innerHTML = "<img src=\"" + e.target.result + "\" alt=\"preview\">";
            preview_el.classList.add("mf_has_image");
        };
        reader.readAsDataURL(file);
    }

    function clear_image_preview(preview_el) {
        if (!preview_el) {
            return;
        }
        preview_el.innerHTML = "<div class='mf_image_placeholder'>" +
            "<i class='fa-solid fa-camera'></i>" +
            "<div class='mf_image_placeholder_text'>이미지를 업로드해주세요</div>" +
            "<div class='mf_image_placeholder_hint'>JPG / PNG 권장 (최대 5MB)</div>" +
        "</div>";
        preview_el.classList.remove("mf_has_image");
    }

    function clear_final_preview(preview_el) {
        if (!preview_el) {
            return;
        }
        preview_el.innerHTML = "<div class='mf_image_placeholder'>" +
            "<i class='fa-solid fa-camera-retro'></i>" +
            "<div class='mf_image_placeholder_text'>완성 사진을 업로드해주세요</div>" +
            "<div class='mf_image_placeholder_hint'>대표 이미지와 같아도 OK</div>" +
        "</div>";
        preview_el.classList.remove("mf_has_image");
    }

    function clear_step_preview(preview_el) {
        if (!preview_el) {
            return;
        }
        preview_el.innerHTML = "<div class='mf_image_placeholder'>" +
            "<i class='fa-regular fa-images'></i>" +
            "<div class='mf_image_placeholder_text'>과정 이미지(선택)</div>" +
            "<div class='mf_image_placeholder_hint'>있으면 더 좋아요</div>" +
        "</div>";
        preview_el.classList.remove("mf_has_image");
    }

    // 카운트
    var recipe_title = document.getElementById("recipe_title");
    var recipe_subtitle = document.getElementById("recipe_subtitle");
    var recipe_intro = document.getElementById("recipe_intro");

    recipe_title.addEventListener("input", function() {
        set_count(recipe_title, "title_count", 60);
    });
    //recipe_subtitle.addEventListener("input", function() {
      //  set_count(recipe_subtitle, "subtitle_count", 60);
    //});
    recipe_intro.addEventListener("input", function() {
        set_count(recipe_intro, "intro_count", 140);
    });

    set_count(recipe_title, "title_count", 60);
    //set_count(recipe_subtitle, "subtitle_count", 60);
    set_count(recipe_intro, "intro_count", 140);

    // 취소
    document.getElementById("cancel_btn").addEventListener("click", function() {
        history.back();
    });

    // 대표 이미지
    var thumbnail_file = document.getElementById("thumbnail_file");
    var thumbnail_preview = document.getElementById("thumbnail_preview");
    var thumbnail_clear_btn = document.getElementById("thumbnail_clear_btn");

    thumbnail_file.addEventListener("change", function() {
        if (thumbnail_file.files && thumbnail_file.files[0]) {
            render_image_preview(thumbnail_file.files[0], thumbnail_preview);
        }
    });

    thumbnail_clear_btn.addEventListener("click", function() {
        thumbnail_file.value = "";
        clear_image_preview(thumbnail_preview);
    });

    // 완성 사진
    //var final_file = document.getElementById("final_file");
    //var final_preview = document.getElementById("final_preview");
    //var final_clear_btn = document.getElementById("final_clear_btn");

    //final_file.addEventListener("change", function() {
    //    if (final_file.files && final_file.files[0]) {
    //        render_image_preview(final_file.files[0], final_preview);
    //    }
    //});

    //final_clear_btn.addEventListener("click", function() {
    //    final_file.value = "";
    //    clear_final_preview(final_preview);
    //});

    // 재료 추가/삭제
    var ingredient_list = document.getElementById("ingredient_list");
    var ingredient_add_btn = document.getElementById("ingredient_add_btn");

    function bind_ingredient_remove(btn) {
        btn.addEventListener("click", function() {
            var rows = ingredient_list.querySelectorAll(".ingredient_row");
            if (rows.length <= 1) {
                rows[0].querySelector("input[name='ingredient_name[]']").value = "";
                rows[0].querySelector("input[name='ingredient_amount[]']").value = "";
                return;
            }
            var row = btn.closest(".ingredient_row");
            if (row) {
                row.remove();
            }
        });
    }

    ingredient_add_btn.addEventListener("click", function() {
        var row_count = ingredient_list.querySelectorAll(".ingredient_row").length + 1;

        var row = document.createElement("div");
        row.className = "mf_list_row ingredient_row";
        row.setAttribute("data_row", String(row_count));

        row.innerHTML = "" +
            "<div class='mf_field'>" +
                "<label class='mf_label mf_label_inline'>재료명</label>" +
                "<input type='text' name='ingredient_name[]' class='mf_input' placeholder='예) 대파' required>" +
            "</div>" +
            "<div class='mf_field'>" +
                "<label class='mf_label mf_label_inline'>양</label>" +
                "<input type='text' name='ingredient_amount[]' class='mf_input' placeholder='예) 1/2대'>" +
            "</div>" +
            "<div class='mf_row_actions'>" +
                "<button type='button' class='mf_btn mf_btn_icon mf_btn_danger ingredient_remove_btn' title='삭제'>" +
                    "<i class='fa-solid fa-xmark'></i>" +
                "</button>" +
            "</div>";

        ingredient_list.appendChild(row);

        var remove_btn = row.querySelector(".ingredient_remove_btn");
        bind_ingredient_remove(remove_btn);

        row.querySelector("input[name='ingredient_name[]']").focus();
    });

    var ingredient_remove_buttons = ingredient_list.querySelectorAll(".ingredient_remove_btn");
    ingredient_remove_buttons.forEach(function(btn) {
        bind_ingredient_remove(btn);
    });

    // 조리 과정 추가/삭제 + 이미지
    var step_list = document.getElementById("step_list");
    var step_add_btn = document.getElementById("step_add_btn");

    function reindex_steps() {
        var steps = step_list.querySelectorAll(".mf_step");
        steps.forEach(function(step, index) {
            var no = index + 1;
            step.setAttribute("data_step", String(no));

            var no_el = step.querySelector(".mf_step_no");
            if (no_el) {
                no_el.textContent = String(no);
            }
			
			var order_input = step.querySelector("input[name='step_no[]']");
		    if (order_input) {
		        order_input.value = String(no);
		    }

            var file_el = step.querySelector(".mf_step_file");
            if (file_el) {
                file_el.setAttribute("data_step", String(no));
                file_el.id = "step_file_" + String(no);
            }

            var label_el = step.querySelector("label[for^='step_file_']");
            if (label_el) {
                label_el.setAttribute("for", "step_file_" + String(no));
            }

            var preview_el = step.querySelector(".mf_step_preview");
            if (preview_el) {
                preview_el.setAttribute("data_preview", String(no));
            }

            var clear_btn = step.querySelector(".step_clear_btn");
            if (clear_btn) {
                clear_btn.setAttribute("data_step", String(no));
            }
        });
    }

    function bind_step_remove(btn) {
        btn.addEventListener("click", function() {
            var steps = step_list.querySelectorAll(".mf_step");
            if (steps.length <= 1) {
                var first = steps[0];
                first.querySelector("textarea[name='step_content[]']").value = "";
                var file_el = first.querySelector(".mf_step_file");
                var preview_el = first.querySelector(".mf_step_preview");
                if (file_el) {
                    file_el.value = "";
                }
                if (preview_el) {
                    clear_step_preview(preview_el);
                }
                return;
            }

            var step = btn.closest(".mf_step");
            if (step) {
                step.remove();
                reindex_steps();
            }
        });
    }

    function bind_step_file(file_el) {
        file_el.addEventListener("change", function() {
            var step_no = file_el.getAttribute("data_step");
            var preview_el = step_list.querySelector(".mf_step[data_step='" + step_no + "'] .mf_step_preview");
            if (file_el.files && file_el.files[0] && preview_el) {
                render_image_preview(file_el.files[0], preview_el);
            }
        });
    }

    function bind_step_clear(btn) {
        btn.addEventListener("click", function() {
            var step_no = btn.getAttribute("data_step");
            var file_el = step_list.querySelector(".mf_step[data_step='" + step_no + "'] .mf_step_file");
            var preview_el = step_list.querySelector(".mf_step[data_step='" + step_no + "'] .mf_step_preview");
            if (file_el) {
                file_el.value = "";
            }
            if (preview_el) {
                clear_step_preview(preview_el);
            }
        });
    }

    step_add_btn.addEventListener("click", function() {
        var step_count = step_list.querySelectorAll(".mf_step").length + 1;

        var step = document.createElement("div");
        step.className = "mf_step";
        step.setAttribute("data_step", String(step_count));

        step.innerHTML = "" +
            "<div class='mf_step_left'>" +
                "<div class='mf_step_no'>" + String(step_count) + "</div>" +
            "</div>" +
            "<div class='mf_step_body'>" +
                "<div class='mf_step_text'>" +
					"<input type='hidden' name='step_no[]' value='" + String(step_count) + "' class='step_order_input'>" +
                    "<label class='mf_label mf_label_inline'>설명</label>" +
                    "<textarea name='step_content[]' class='mf_textarea' placeholder='예) 팬에 기름을 두르고 계란을 스크램블 해주세요' required></textarea>" +
                "</div>" +
                "<div class='mf_step_media'>" +
                    "<div class='mf_step_image'>" +
                        "<div class='mf_step_preview' data_preview='" + String(step_count) + "'>" +
                            "<div class='mf_image_placeholder'>" +
                                "<i class='fa-regular fa-images'></i>" +
                                "<div class='mf_image_placeholder_text'>과정 이미지(선택)</div>" +
                                "<div class='mf_image_placeholder_hint'>있으면 더 좋아요</div>" +
                            "</div>" +
                        "</div>" +
                        "<div class='mf_step_controls'>" +
                            "<label class='mf_btn mf_btn_outline' for='step_file_" + String(step_count) + "'>" +
                                "<i class='fa-solid fa-upload'></i> 이미지 선택" +
                            "</label>" +
                            "<input type='hidden' name='image_type[]' value='STEP'>" +
                            "<input type='file' id='step_file_" + String(step_count) + "' name='image_path[]' accept='image/*' class='mf_file_input mf_step_file' data_step='" + String(step_count) + "'>" +
                            "<button type='button' class='mf_btn mf_btn_ghost step_clear_btn' data_step='" + String(step_count) + "'>" +
                                "<i class='fa-solid fa-rotate-left'></i> 해제" +
                            "</button>" +
                        "</div>" +
                    "</div>" +
                    "<div class='mf_step_actions'>" +
                        "<button type='button' class='mf_btn mf_btn_icon mf_btn_danger step_remove_btn' title='삭제'>" +
                            "<i class='fa-solid fa-xmark'></i>" +
                        "</button>" +
                    "</div>" +
                "</div>" +
            "</div>";

        step_list.appendChild(step);

        // 바인딩
        bind_step_remove(step.querySelector(".step_remove_btn"));
        bind_step_file(step.querySelector(".mf_step_file"));
        bind_step_clear(step.querySelector(".step_clear_btn"));

        step.querySelector("textarea[name='step_content[]']").focus();
    });

    // 기존 1개 바인딩
    step_list.querySelectorAll(".step_remove_btn").forEach(function(btn) {
        bind_step_remove(btn);
    });

    step_list.querySelectorAll(".mf_step_file").forEach(function(file_el) {
        bind_step_file(file_el);
    });

    step_list.querySelectorAll(".step_clear_btn").forEach(function(btn) {
        bind_step_clear(btn);
    });

    // 태그
    var tag_input = document.getElementById("tag_input");
    var tag_add_btn = document.getElementById("tag_add_btn");
    var tag_list = document.getElementById("tag_list");
    var tag_hidden = document.getElementById("tag_hidden");

    var tags = [];

    function sync_tag_hidden() {
        tag_hidden.value = tags.join(",");
    }

    function render_tags() {
        tag_list.innerHTML = "";
        tags.forEach(function(t) {
            var chip = document.createElement("div");
            chip.className = "mf_tag_chip";
            chip.innerHTML = "" +
                "<span class='mf_tag_text'>#" + escape_html(t) + "</span>" +
                "<button type='button' class='mf_tag_remove' data_tag='" + escape_html(t) + "' title='삭제'>" +
                    "<i class='fa-solid fa-xmark'></i>" +
                "</button>";
            tag_list.appendChild(chip);
        });

        tag_list.querySelectorAll(".mf_tag_remove").forEach(function(btn) {
            btn.addEventListener("click", function() {
                var v = btn.getAttribute("data_tag");
                tags = tags.filter(function(x) { return x !== v; });
                sync_tag_hidden();
                render_tags();
            });
        });
    }

    function add_tag(value) {
        var v = (value || "").trim();
        if (!v) {
            return;
        }
        if (v.startsWith("#")) {
            v = v.substring(1).trim();
        }
        if (!v) {
            return;
        }
        if (v.length > 20) {
            v = v.substring(0, 20);
        }
        if (tags.indexOf(v) >= 0) {
            return;
        }
        if (tags.length >= 15) {
            return;
        }
        tags.push(v);
        sync_tag_hidden();
        render_tags();
    }

    tag_add_btn.addEventListener("click", function() {
        add_tag(tag_input.value);
        tag_input.value = "";
        tag_input.focus();
    });

    tag_input.addEventListener("keydown", function(e) {
        if (e.key === "Enter") {
            e.preventDefault();
            add_tag(tag_input.value);
            tag_input.value = "";
        }
        if (e.key === ",") {
            e.preventDefault();
            add_tag(tag_input.value.replace(/,/g, ""));
            tag_input.value = "";
        }
    });

    // 간단 검증
    document.getElementById("recipe_write_form").addEventListener("submit", function(e) {
        // 대표/완성 이미지 필수 체크
        if (!thumbnail_file.files || !thumbnail_file.files[0]) {
            e.preventDefault();
            alert("대표 이미지를 업로드해주세요.");
            window.scrollTo({ top: document.getElementById("section_thumbnail").offsetTop - 80, behavior: "smooth" });
            return;
        }
        if (!final_file.files || !final_file.files[0]) {
            e.preventDefault();
            alert("완성 사진을 업로드해주세요.");
            window.scrollTo({ top: document.getElementById("section_final").offsetTop - 80, behavior: "smooth" });
            return;
        }

        // 최소 1개 재료명
        var first_ing = ingredient_list.querySelector("input[name='ingredient_name[]']");
        if (!first_ing || !(first_ing.value || "").trim()) {
            e.preventDefault();
            alert("재료를 1개 이상 입력해주세요.");
            window.scrollTo({ top: document.getElementById("section_ingredients").offsetTop - 80, behavior: "smooth" });
            return;
        }

        // 최소 1개 과정
        var first_step = step_list.querySelector("textarea[name='step_content[]']");
        if (!first_step || !(first_step.value || "").trim()) {
            e.preventDefault();
            alert("조리 순서를 1개 이상 입력해주세요.");
            window.scrollTo({ top: document.getElementById("section_steps").offsetTop - 80, behavior: "smooth" });
            return;
        }
    });

})();
</script>

</body>
</html>
