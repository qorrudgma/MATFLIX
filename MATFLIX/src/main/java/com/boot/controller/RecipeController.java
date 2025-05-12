/*==========================================================
* 파일명     : RecipeController.java
* 작성자     : 임진우
* 작성일자   : 2025-05-07
* 설명       : recipe 등록, 수정, 삭제, 조회, 관리에 관한 컨트롤러입니다.

* 수정 이력 :
* 날짜         수정자       내용
* --------   ----------   ------------------------- 
* 2025-05-07   임진우       최초 생성
* 2025-05-07   임진우       Spring Lagacy에서 Boot로 이동
* 2025-05-07   임진우       이미지 파일 업로드 완료
* 2025-05-08   임진우       main : 이미지 나타내기 로직 구현 => 카테로리별 리스트
* 2025-05-08   임진우       요리 게시판 리스트 및 해당 요리 뷰 작성
* 2025-05-12   임진우       테이블에 유저넘버 추가
* 2025-05-12   임진우       내 레시피 생성
* 2025-05-12   임진우       레시피 보드에 작성자 이름 및 정보 삽입
============================================================*/

package com.boot.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.RcCourseDTO;
import com.boot.dto.RcIngredientDTO;
import com.boot.dto.RecipeAttachDTO;
import com.boot.dto.RecipeBoardDTO;
import com.boot.dto.RecipeCommentDTO;
import com.boot.dto.RecipeCriteria;
import com.boot.dto.RecipeDTO;
import com.boot.dto.RecipePageDTO;
import com.boot.dto.TeamDTO;
import com.boot.service.RecipeBoardService;
import com.boot.service.RecipeCommentService;
import com.boot.service.RecipePageService;
import com.boot.service.RecipeService;
import com.boot.service.RecipeUploadService;
import com.boot.service.TeamService;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Slf4j
public class RecipeController {
	@Autowired
	private RecipeService service;

	@Autowired
	private RecipeUploadService service_attach;

	@Autowired
	private RecipeBoardService service_board;

	@Autowired
	private RecipeCommentService service_comment;

	@Autowired
	private RecipePageService service_page;

	@Autowired
	private TeamService service_member;

	@RequestMapping("/main")
	public String main(Model model, HttpServletRequest request) {

//		카테고리 별 레시피id 모음
		int[] korean_food = service.get_food(1);
		int[] american_food = service.get_food(2);
		int[] japanese_food = service.get_food(3);
		int[] chinese_food = service.get_food(4);
		int[] dessert = service.get_food(5);

		List<RecipeAttachDTO> korean_food_list = new ArrayList<>();
		List<RecipeAttachDTO> american_food_list = new ArrayList<>();
		List<RecipeAttachDTO> japanese_food_list = new ArrayList<>();
		List<RecipeAttachDTO> chinese_food_list = new ArrayList<>();
		List<RecipeAttachDTO> dessert_list = new ArrayList<>();

		for (int i = 0; i < korean_food.length; i++) { // 한식 파일 리스트
			korean_food_list.add(service_attach.get_upload_by_id(korean_food[i]));
		}
		for (int i = 0; i < american_food.length; i++) { // 양식 파일 리스트
			american_food_list.add(service_attach.get_upload_by_id(american_food[i]));
		}
		for (int i = 0; i < japanese_food.length; i++) { // 일식 파일 리스트
			japanese_food_list.add(service_attach.get_upload_by_id(japanese_food[i]));
		}
		for (int i = 0; i < chinese_food.length; i++) { // 중식 파일 리스트
			chinese_food_list.add(service_attach.get_upload_by_id(chinese_food[i]));
		}
		for (int i = 0; i < dessert.length; i++) { // 디저트 파일 리스트
			dessert_list.add(service_attach.get_upload_by_id(dessert[i]));
		}

		HttpSession session = request.getSession();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		log.info("@# main : user =>" + user);

		model.addAttribute("korean_food_list", korean_food_list);
		model.addAttribute("american_food_list", american_food_list);
		model.addAttribute("japanese_food_list", japanese_food_list);
		model.addAttribute("chinese_food_list", chinese_food_list);
		model.addAttribute("dessert_list", dessert_list);

		return "main";
	}

//	@RequestMapping("/profile")
//	public String profile() {
//		return "profile";
//	}

	@RequestMapping("/insert_recipe")
	public String insert_recipe() {
		return "insert_recipe";
	}

	@RequestMapping("/recipe_write")
	public String insertRecipe(@RequestParam HashMap<String, String> params,
			@RequestParam("rc_ingredient_name[]") List<String> rc_ingredient_name,
			@RequestParam("rc_ingredient_amount[]") List<String> rc_ingredient_amount,
			@RequestParam("rc_course_description[]") List<String> rc_course_description,
			@RequestParam("rc_img") MultipartFile[] multipartFile, @RequestParam("mf_id") String mf_id, Model model,
			HttpServletRequest request) {

		HttpSession session = request.getSession();
		TeamDTO user = (TeamDTO) session.getAttribute("user");

		log.info("@#user => " + user);

		int mf_no = user.getMf_no();

		// 레시피 정보 저장 (Map으로 구성)
		HashMap<String, String> recipeData = new HashMap<>();
		recipeData.put("rc_name", params.get("rc_name"));
		recipeData.put("rc_description", params.get("rc_description"));
		recipeData.put("rc_category1_id", params.get("rc_category1_id"));
		recipeData.put("rc_cooking_time", params.get("rc_cooking_time"));
		recipeData.put("rc_difficulty", params.get("rc_difficulty"));
		recipeData.put("rc_tip", params.get("rc_tip"));
		recipeData.put("rc_tag", params.get("rc_tag"));
		recipeData.put("rc_tag", params.get("rc_tag"));
		recipeData.put("mf_no", Integer.toString(mf_no));

		log.info("@# recipeData => " + recipeData);
		// insert 및 생성된 ID 추출
		service.insert_recipe(recipeData);

		for (int i = 0; i < rc_course_description.size(); i++) {
			service.insert_rc_course(rc_course_description.get(i));
		}

		for (int i = 0; i < rc_ingredient_name.size(); i++) {
			service.insert_rc_ingredient(rc_ingredient_name.get(i), rc_ingredient_amount.get(i));
		}

		ResponseEntity<List<RecipeAttachDTO>> resList = new RecipeController().uploadAjaxPost(multipartFile);
		List<RecipeAttachDTO> imgList = resList.getBody();
		RecipeAttachDTO resultDTO = imgList.get(0);

		log.info("@# insertRecipe : multipartFile =>" + multipartFile[0]);

		int rc_recipe_id = service_attach.getMaxId();
		log.info("현재 테이블상 최대 id값 =>" + rc_recipe_id);
		resultDTO.setRc_recipe_id(rc_recipe_id);
		service_attach.insertFile(resultDTO);
		service_board.insert_rc_board(params, rc_recipe_id);

		model.addAttribute("mf_id", mf_id);
		return "redirect:/main";
	}

	// 레시피 이미지 업로드
	// ========================================================================================================================
	@PostMapping("/uploadAjaxAction")
	public ResponseEntity<List<RecipeAttachDTO>> uploadAjaxPost(@RequestParam("rc_img") MultipartFile[] mainImage) {
		// 이미지 파일 업로드 및 미리보기 보여주기
		List<RecipeAttachDTO> list = new ArrayList<RecipeAttachDTO>();
		String uploadFolder = "C:\\develop\\upload";
//		날짜별 폴더 생성
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("@# uploadPath=>" + uploadPath);

		if (uploadPath.exists() == false) {
			// make yyyy/MM/dd folder
			uploadPath.mkdirs();
		}

		for (MultipartFile multipartFile : mainImage) {
			String uploadFileName = multipartFile.getOriginalFilename();

			UUID uuid = UUID.randomUUID();
			RecipeAttachDTO recipeAttachDTO = new RecipeAttachDTO();
			recipeAttachDTO.setFileName(uploadFileName);
			recipeAttachDTO.setUuid(uuid.toString());
			recipeAttachDTO.setUploadPath(uploadFolderPath);

			uploadFileName = uuid.toString() + "_" + uploadFileName;

			File saveFile = new File(uploadPath, uploadFileName);
			FileInputStream fis = null;

			try {
//						transferTo : saveFile 내용을 저장
				multipartFile.transferTo(saveFile);

//						참이면 이미지 파일
				if (checkImageType(saveFile)) {
					recipeAttachDTO.setImage(true);
					log.info("@# boardAttachDTO 02=>" + recipeAttachDTO);

					fis = new FileInputStream(saveFile);

//							썸네일 파일은 s_ 를 앞에 추가
					FileOutputStream thumnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));

//							썸네일 파일 형식을 100/100 크기로 생성
					Thumbnailator.createThumbnail(fis, thumnail, 1600, 1600);

					log.info("@# 저장완료");
					thumnail.close();
				}

				list.add(recipeAttachDTO);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (fis != null) {
						fis.close();
					}
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
		} // end of for

//				파일정보들을 list 객체에 담고, http 상태값은 정상으로 리턴

		log.info("@#listlistlistlistlistlistlistlistlist =>" + list);
		return new ResponseEntity<List<RecipeAttachDTO>>(list, HttpStatus.OK);
	}

	// 이미지 생성시 필요한 메소드
	// ========================================================================================================================
//	날짜별 폴더 생성
	public String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);

		log.info("@# str=>" + str);

		return str;
	}

//	이미지 여부 체크
	public boolean checkImageType(File file) {
		try {
//			이미지파일인지 체크하기 위한 타입(probeContentType)
			String contentType = Files.probeContentType(file.toPath());
			log.info("@# contentType=>" + contentType);

//			startsWith : 파일종류 판단
//			return contentType.startsWith("images");//참이면 이미지파일
			return contentType.startsWith("image");// 참이면 이미지파일
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false; // 거짓이면 이미지파일이 아님
	}

//	이미지파일을 받아서 화면에 출력(byte 배열타입)
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("@# display fileName=>" + fileName);

//		File file = new File("C:\\develop\\upload"+fileName);
		File file = new File("C:\\develop\\upload\\" + fileName);
		log.info("@# file=>" + file);

		ResponseEntity<byte[]> result = null;
		HttpHeaders headers = new HttpHeaders();

		try {
//			파일타입을 헤더에 추가
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
//			파일정보를 byte 배열로 복사+헤더정보+http상태 정상을 결과에 저장
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("@# deleteFile fileName=>" + fileName);
		File file;

		try {
//			URLDecoder.decode : 서버에 올라간 파일을 삭제하기 위해서 디코딩
			file = new File("C:\\develop\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			log.info("@# file=>" + file);
			file.delete();

//			이미지 파일이면 썸네일도 삭제
			if (type.equals("image")) {
//				getAbsolutePath : 절대경로(full path)
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("@# largeFileName=>" + largeFileName);

				file = new File(largeFileName);
				file.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
//			예외 오류 발생시 not found 처리
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}

//		deleted : success 의 result 로 전송
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}

	@GetMapping("/download")
	public ResponseEntity<Resource> download(String fileName) {
		log.info("@# download fileName=>" + fileName);

		// 파일을 리소스(자원)로 변경. 파일을 비트값으로 전환
		Resource resource = new FileSystemResource("C:\\develop\\upload\\" + fileName);
		log.info("@# resource=>" + resource);

//		리소스에서 파일명을 찾아서 변수에 저장
		String resourceName = resource.getFilename();

//		uuid 를 제외한 파일명
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		HttpHeaders headers = new HttpHeaders();

		try {
//			헤더에 파일다운로드 정보 추가
			headers.add("Content-Disposition",
					"attachment; filename=" + new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1"));
		} catch (Exception e) {
			e.printStackTrace();
		}

//		윈도우 다운로드시 필요한 정보(리소스, 헤더, 상태OK)
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}

	// 요리 게시판
	// ===================================================================================
	@RequestMapping("/recipe_board")
	public String recipe_board(RecipeCriteria cri, Model model, HashMap<String, String> param) {
		List<RecipeAttachDTO> paging_file_list = new ArrayList<>();
		List<RecipeDTO> paging_recipe_list = new ArrayList<>();
		int[] rc_recipe_id_list = service_page.listWithPaging(cri);

		log.info("@# recipe_board RecipeCriteria ==>" + cri);

		for (int i = 0; i < rc_recipe_id_list.length; i++) {
			log.info("@# recipe_board rc_recipe_id_list ==>" + rc_recipe_id_list[i]);
			paging_recipe_list.add(service.paging_recipe_list(rc_recipe_id_list[i]));
			paging_file_list.add(service_attach.get_upload_by_id(rc_recipe_id_list[i]));
		}

		List<TeamDTO> mem_list = service_member.list();

		model.addAttribute("pageMaker", new RecipePageDTO(service_page.totalList(cri), cri));
		model.addAttribute("recipe_list_all", paging_recipe_list);
		model.addAttribute("file_list_all", paging_file_list);
		model.addAttribute("mem_list", mem_list);

		System.out.println("cri => " + cri);
		System.out.println("model => " + model);
		System.out.println("param => " + param);

		return "recipe_board";
	}

	@RequestMapping("/recipe_content_view")
	public String recipe_content_view(@RequestParam("rc_recipe_id") int rc_recipe_id, Model model) {
		log.info("rc_recipe_id" + rc_recipe_id);

//		해당 아이디로 정보 가져오기
		RecipeDTO dto = service.get_recipe_by_id(rc_recipe_id);
		List<RcIngredientDTO> ing_list = service.get_recipe_ingredient_by_id(rc_recipe_id);
		List<RcCourseDTO> course_list = service.get_recipe_course_by_id(rc_recipe_id);
		RecipeAttachDTO img_list = service_attach.get_upload_by_id(rc_recipe_id);
		RecipeBoardDTO rc_board = service_board.get_board_by_id(rc_recipe_id);
		int rc_boardNo = rc_board.getRc_boardNo();
		ArrayList<RecipeCommentDTO> commentList = service_comment.findAll(rc_boardNo);
		int mf_no = service.get_mf_no_by_id(rc_recipe_id);

		TeamDTO mem_dto = service_member.find_user_by_no(mf_no);

		// 요리 별점 업데이트
		// ---------------------------------------------------------------
		int total_score = 0;
		for (int i = 0; i < commentList.size(); i++) {
			total_score += commentList.get(i).getUser_star_score();
			log.info("commentList.get(i).getUser_star_score() =>" + commentList.get(i).getUser_star_score());
		}
		double average_score = (double) total_score / commentList.size();
		double result_score = (double) Math.round(average_score * 10) / 10;
		service.update_star_score(result_score, rc_recipe_id);
		// ---------------------------------------------------------------

		log.info("@# average_score =>" + result_score);

		model.addAttribute("dto", dto);
		model.addAttribute("ing_list", ing_list);
		model.addAttribute("course_list", course_list);
		model.addAttribute("img_list", img_list);
		model.addAttribute("rc_board", rc_board);
		model.addAttribute("commentList", commentList);

		model.addAttribute("mem_dto", mem_dto);
		log.info("model" + model);

		return "recipe_content_view";
	}

	// 마이페이지 내 내레시피
	// ===================================================================================

	@RequestMapping("/my_recipe")
	public String my_recipe(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		TeamDTO user = (TeamDTO) session.getAttribute("user");
		String mf_no = Integer.toString(user.getMf_no());

		List<RecipeAttachDTO> my_recipe_attach = new ArrayList<>();
		List<RecipeDTO> my_recipe = service.get_recipe_by_user_id(mf_no);

		for (int i = 0; i < my_recipe.size(); i++) {
			my_recipe_attach.add(service_attach.get_upload_by_id(my_recipe.get(i).getRc_recipe_id()));
		}
		log.info("@# my_recipe_attach =>" + my_recipe_attach);

		model.addAttribute("my_recipe", my_recipe);
		model.addAttribute("my_recipe_attach", my_recipe_attach);

		return "my_recipe";
	}
}
