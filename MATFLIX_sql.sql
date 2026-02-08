-- 유저테이블
CREATE TABLE matflix (
    mf_no INT AUTO_INCREMENT PRIMARY KEY,
    mf_id VARCHAR(20) NOT NULL,
    mf_pw VARCHAR(255) NOT NULL,
    mf_name VARCHAR(20) NOT NULL,
    mf_nickname VARCHAR(1000),
    mf_email VARCHAR(50),
    mf_phone VARCHAR(20),
    mf_birth DATE,
    mf_gender CHAR(1) DEFAULT 'M' CHECK (mf_gender IN ('M', 'F')),
    mf_regdate DATETIME DEFAULT CURRENT_TIMESTAMP,
    mf_role VARCHAR(10) DEFAULT 'USER' CHECK (mf_role IN ('USER', 'ADMIN')),
    mf_nickname_updatetime DATETIME DEFAULT null,
    last_password_change DATETIME DEFAULT CURRENT_TIMESTAMP,
    status varchar(20) DEFAULT "ACTIVE",
    last_login_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_matflix_id (mf_id) -- 중복 방지
);
alter table matflix add column created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
select *
 from matflix;
SELECT *
FROM matflix
ORDER BY mf_no ASC
LIMIT 5 OFFSET 0;
update matflix
   -- set status = "BANNED"
   set status = "BANNED"
 where mf_no = 74;
SELECT m.mf_no
		  	 , m.mf_id
		  	 , m.mf_pw
		  	 , m.mf_nickname
		  	 , m.mf_name
		  	 , m.mf_email
		 	 , m.mf_phone
		 	 , m.mf_birth
		  	 , m.mf_gender
		  	 , m.mf_regdate
		  	 , m.mf_role
		  	 , m.mf_nickname_updatetime
		  	 , m.status
		  	 , ui.profile_image_path
		  FROM matflix m
		  LEFT JOIN user_image ui
	        ON ui.mf_no = m.mf_no
		 WHERE m.mf_id = "banned";
SELECT *
FROM matflix
WHERE mf_name LIKE CONCAT("", '%')
ORDER BY mf_no DESC
LIMIT 5 OFFSET 0;


         
-- 탈퇴 이유
CREATE TABLE member_withdraw_reason (
    withdraw_id INT AUTO_INCREMENT PRIMARY KEY,
    mf_no INT NOT NULL,
    reason_type VARCHAR(50),
    reason_detail TEXT,
    withdraw_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_withdraw_member
    FOREIGN KEY (mf_no) REFERENCES matflix(mf_no)
    ON DELETE CASCADE
);
select * from member_withdraw_reason;

-- 유저 프로필 사진
CREATE TABLE user_image (
    image_no INT AUTO_INCREMENT PRIMARY KEY,
    mf_no INT NOT NULL,
    profile_image_path VARCHAR(255),

    CONSTRAINT fk_image_user
        FOREIGN KEY (mf_no)
        REFERENCES matflix(mf_no)
        ON DELETE CASCADE
);
select * from user_image;
update user_image set profile_image_path = null where mf_no = 75;


-- 팔로우
CREATE TABLE follow (
    follow_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL, -- 팔로우를 거는 사람 (내 ID)
    following_id INT NOT NULL, -- 팔로우 당하는 사람 (상대 ID)
    follower_email VARCHAR(50), -- 팔로우를 거는 사람 이메일 (email)
    follow_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_follow (follower_id, following_id) -- 중복 방지
);
select * from follow;
select following_id from follow where follower_id = 62;
SELECT r.recipe_id, r.mf_no, r.title, r.intro, r.servings, r.cook_time, r.difficulty, r.category, r.tip, r.star, r.created_at, r.updated_at, m.mf_nickname, ri.image_path
			 , (select count(*) from recipe_review where recipe_id = r.recipe_id) as review_count
		  FROM recipe r
		  JOIN matflix m
			ON r.mf_no = m.mf_no
		  LEFT JOIN recipe_image ri
		    ON r.recipe_id = ri.recipe_id
		   AND ri.image_type ="THUMBNAIL"
		 WHERE r.mf_no IN (SELECT f.following_id
		 					 FROM follow f
		 					WHERE f.follower_id = 62)
		 ORDER BY r.updated_at DESC;
TRUNCATE TABLE follow;
delete f
  from follow f
  join (
		select follow_id
          from follow
		 where follower_id =75
			or following_id =75
	   ) f2 on f.follow_id = f2.follow_id;

-- 알림 테이블
CREATE TABLE notifications (
    notif_id INT AUTO_INCREMENT PRIMARY KEY,
    receiver_id INT NOT NULL,    	 	-- 알림 받는 사람
    sender_id INT,               	 	-- 알림 발생시킨 사람 (시스템 알림이면 NULL)
    notif_type VARCHAR(30) NOT NULL,  	-- 'FOLLOW', 'CREATE', 'COMMENT', 'LIKE', 'REVIEW'
    target_type VARCHAR(30),        	-- 'USER', 'BOARD', 'COMMENT', 'RECIPE'
    target_id INT,              	  	-- board_no / comment_id / recipe_id
    is_read INT DEFAULT 0,         		-- 0: 안읽음, 1: 읽음
    created_at DATETIME DEFAULT NOW()
);
select * from notifications;
    	select n.notif_id
    		 , n.receiver_id
    		 , n.sender_id
    		 , n.notif_type
    		 , n.target_type
    		 , n.target_id
    		 , n.is_read
    		 , n.created_at
    		 , m.mf_nickname as mf_nickname
    	  from notifications n
    	  join matflix m
    	    on n.sender_id = m.mf_no
    	 where receiver_id = 76
    	   and is_read = 0
    	 ORDER BY created_at DESC;

-- 알림 on/off 테이블
CREATE TABLE notif_setting (
    mf_no INT PRIMARY KEY,
    follow_yn TINYINT DEFAULT 1,			-- 팔로우
    board_comment_yn TINYINT DEFAULT 1,		-- 게시글 댓글 알림
    board_reaction_yn TINYINT DEFAULT 1,	-- 게시글 좋아요
    recipe_review_yn TINYINT DEFAULT 1,		-- 레시피 리뷰
    recipe_comment_yn TINYINT DEFAULT 1,	-- 레시피 댓글
    recipe_reaction_yn TINYINT DEFAULT 1,	-- 레시피 좋아요
    recomment_yn TINYINT DEFAULT 1,			-- 댓글의 답글
    comment_reaction_yn TINYINT DEFAULT 1,	-- 댓글의 좋아요
	-- 유저 삭제 시 추천 자동 삭제
	constraint fk_notif_user
		FOREIGN KEY (mf_no)
		REFERENCES matflix (mf_no)
		ON DELETE CASCADE
);

select * from notif_setting;
INSERT INTO notif_setting (mf_no)
SELECT mf_no
FROM matflix
WHERE mf_no NOT IN (
    SELECT mf_no FROM notif_setting
);

-- 게시판 테이블
CREATE TABLE tbl_board (
    boardNo int AUTO_INCREMENT PRIMARY KEY,
    boardName VARCHAR(20),
    boardTitle VARCHAR(100),
    boardContent VARCHAR(300),
    boardDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    boardHit int DEFAULT 0,
    mf_no INT not null,
    recommend_count INT DEFAULT 0,
    recommend_notify_step INT DEFAULT 0
);
select * from tbl_board order by 1 desc;
select b.boardNo
		     , m.mf_nickname as boardName
             , b.boardTitle
             , b.boardContent
             , b.boardDate
             , b.boardHit
             , b.mf_no
             , b.recommend_count
             , b.recommend_notify_step
             , b.comment_count
          from tbl_board b
          LEFT JOIN user_image ui
			ON ui.mf_no = b.mf_no
          LEFT JOIN matflix m
			ON m.mf_no = b.mf_no;


-- 게시판 댓글 테이블
CREATE TABLE board_comment (
    commentNo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    commentWriter VARCHAR(20),
    commentContent VARCHAR(300),
    boardNo INT,
    userNo int,
    commentCreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted int default 0,
    parentCommentNo INT DEFAULT 0,
	updatedTime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    recommend_count INT DEFAULT 0,
    recommend_notify_step INT DEFAULT 0
);
select * FROM board_comment where boardNo = 333 order by 1 desc;
SELECT c.commentNo
	 , c.commentWriter
	 , c.commentContent
	 , c.userNo
	 , c.commentCreatedTime
	 , c.parentCommentNo
	 , c.recommend_count
	 , CASE WHEN cr.mf_no IS NULL THEN 0 ELSE 1 END AS recommended
     , ui.profile_image_path AS profile_image_path
  FROM board_comment c
  LEFT JOIN comment_recommend cr
	ON c.commentNo = cr.commentNo AND cr.mf_no = 61
  LEFT JOIN user_image ui
	ON ui.mf_no = c.userNo
 WHERE c.boardNo = 332 AND c.deleted = 0
 ORDER BY c.commentCreatedTime DESC;


-- 게시판 추천 테이블
CREATE TABLE tbl_recommend (
    recommend_id INT AUTO_INCREMENT PRIMARY KEY, -- 고유 식별자 (자동 증가)
    boardNo INT NOT NULL,                        -- 게시글 번호 (추천된 게시글)
    mf_no INT NOT NULL,                          -- 사용자 번호 (추천한 사용자)
    UNIQUE KEY unique_recommend (boardNo, mf_no) -- 게시글 번호와 사용자 번호의 조합이 유일하도록 제약
);
select * from tbl_recommend order by 1 desc;

-- 게시판 댓글 추천 테이블
CREATE TABLE comment_recommend (
    c_recommend_id INT AUTO_INCREMENT PRIMARY KEY, 	-- 고유 식별자 (자동 증가)
    commentNo INT NOT NULL,                        	-- 댓글 번호 (추천된 댓글)
    mf_no INT NOT NULL,                          	-- 사용자 번호 (추천한 사용자)
    createdTime DATETIME DEFAULT CURRENT_TIMESTAMP,	-- 생성 시간
    updateTime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,	-- 업데이트 시간
    UNIQUE KEY unique_recommend (commentNo, mf_no) 	-- 게시글 번호와 사용자 번호의 조합이 유일하도록 제약
);
select * from comment_recommend order by 1 desc;
insert into comment_recommend(commentNo, mf_no)
		values (308, 61);
   
SELECT c.commentNo
	 , m.mf_nickname as mf_nickname
	 , c.commentContent
     , c.userNo
     , c.commentCreatedTime
	 , c.parentCommentNo
	 , c.recommend_count
     , CASE WHEN cr.mf_no IS NULL THEN 0 ELSE 1 END AS recommended
  FROM board_comment c
  LEFT JOIN comment_recommend cr
    ON c.commentNo = cr.commentNo AND cr.mf_no = 0
		  LEFT JOIN user_image ui
			ON ui.mf_no = c.userNo
		  LEFT JOIN matflix m
			ON m.mf_no = c.userNo
 WHERE c.boardNo = 332 AND c.deleted = 0
 ORDER BY c.commentCreatedTime DESC;


select notifications_id
    		 , follower_id
    		 , following_id
    		 , n.boardNo as boardNo
    		 , post_id
    		 , is_read
    		 , created_at
    		 , m.mf_nickname as nickname
    		 , t.boardTitle as board_title
    	  from notifications n
    	  join matflix m
    	    on n.following_id = m.mf_no
    	  join tbl_board t
    	    on n.boardNo = t.boardNo
    	 where follower_id = 62
    	   and is_read = 0
    	 ORDER BY notifications_id DESC;


-- 게시판 파일 테이블
CREATE TABLE board_attach (
    uuid VARCHAR(255) PRIMARY KEY,              -- 파일의 고유 식별자(UUID)
    uploadPath VARCHAR(255) NOT NULL,           -- 파일이 저장된 경로
    fileName VARCHAR(255) NOT NULL,             -- 파일 이름
    image CHAR(1) CHECK (image IN ('Y', 'N')),  -- 이미지 여부 (Y/N)
    boardNo INT NOT NULL                        -- 게시글 번호 (외래키)
);

-- 즐겨찾기 테이블 생성
CREATE TABLE recipe_favorites (
    favorite_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '즐겨찾기 고유 ID',
    mf_no INT NOT NULL COMMENT '사용자 번호 (matflix 테이블의 mf_no 참조)',
    rc_recipe_id INT NOT NULL COMMENT '레시피 ID (recipe 테이블의 rc_recipe_id 참조)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '즐겨찾기 추가 시간',

    -- 외래 키 설정 (사용자, 레시피 테이블 참조)
    CONSTRAINT fk_favorite_user FOREIGN KEY (mf_no) REFERENCES matflix(mf_no) ON DELETE CASCADE,
    CONSTRAINT fk_favorite_recipe FOREIGN KEY (rc_recipe_id) REFERENCES recipe(rc_recipe_id) ON DELETE CASCADE,

    -- 한 사용자가 같은 레시피를 중복해서 즐겨찾기 할 수 없도록 설정
    UNIQUE KEY uk_user_recipe (mf_no, rc_recipe_id)
);

-- ------------------------------------------------------------------------------------------------
-- 레시피
-- 메인
CREATE TABLE recipe (
    recipe_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    mf_no		  INT NOT NULL,
    title         VARCHAR(200) NOT NULL,
    intro         VARCHAR(500) NOT NULL,
    servings      INT NOT NULL, 	 		  -- 몇인분
    cook_time     INT NOT NULL,      		  -- 분 단위
    difficulty    VARCHAR(20) NOT NULL,       -- EASY / NORMAL / HARD
    category      VARCHAR(50) NOT NULL,       -- KOREAN / CHINESE / JAPANESE / WESTERN / DESSERT
    tip           TEXT,
    star      	  INT DEFAULT NULL, 	 		  -- 리뷰
    recommend     INT DEFAULT 0, 	 		  -- 추천
    recipe_favorite_count INT DEFAULT 0,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from recipe where recipe_id =7;
select * from recipe;
update recipe
		   set star = null
		 where recipe_id = 6;
DELETE FROM recipe
WHERE recipe_id = 1;
alter table recipe add COLUMN recipe_favorite_count INT DEFAULT 0;

select f.favorite_no
	 , r.recipe_id
	 , f.mf_no
	 , r.category
	 , r.title
	 , m.mf_nickname
	 , r.created_at
	 , ri.image_path
  from favorite_recipe f
  left join recipe r
	on f.recipe_id = r.recipe_id
  JOIN matflix m
	ON f.mf_no = m.mf_no
  LEFT JOIN recipe_image ri
	ON f.recipe_id = ri.recipe_id
   AND ri.image_type ="THUMBNAIL"
 where f.mf_no = 61;
 
select r.recipe_id
	 , r.mf_no
     , r.title
     , r.category
     , r.updated_at
     , m.mf_nickname
     , ri.image_path
  from recipe r
  JOIN matflix m
	ON r.mf_no = m.mf_no
  left join follow f
    on r.mf_no = f.following_id
  left join recipe_image ri
	ON r.recipe_id = ri.recipe_id
   AND ri.image_type ="THUMBNAIL"
 where f.follower_id = 62
 order by r.created_at asc;

select * from follow;

-- 재료
CREATE TABLE recipe_ingredient (
    ingredient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id     BIGINT NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    ingredient_amount VARCHAR(50) NOT NULL,

    CONSTRAINT fk_ingredient_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE
);
select * from recipe_ingredient;
DELETE FROM recipe_ingredient
WHERE recipe_id = 1;

-- 순서
CREATE TABLE recipe_step (
    step_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id   BIGINT NOT NULL,
    step_no     INT NOT NULL,
    step_content TEXT NOT NULL,	

    CONSTRAINT fk_step_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE,

    CONSTRAINT uq_recipe_step
        UNIQUE (recipe_id, step_no)
);
select * from recipe_step;
DELETE FROM recipe_step
WHERE recipe_id = 1;

-- 태그
CREATE TABLE recipe_tag (
    tag_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id   BIGINT NOT NULL,
    tag     	VARCHAR(20) NOT NULL,

    CONSTRAINT fk_tag_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE
);
select * from recipe_tag;
DELETE FROM recipe_tag
WHERE recipe_id = 1;

-- 이미지
CREATE TABLE recipe_image (
    image_id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id  BIGINT NOT NULL,
    image_type VARCHAR(20) NOT NULL,		-- THUMBNAIL, STEP
    step_no    INT NOT NULL DEFAULT 0,
    image_path VARCHAR(255),

    CONSTRAINT fk_image_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE
);
select * from recipe_image
WHERE recipe_id = 3;

-- 레시피 추천 테이블
CREATE TABLE recipe_recommend (
    recommend_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id BIGINT NOT NULL,
    mf_no INT NOT NULL,

    UNIQUE KEY unique_recommend (recipe_id, mf_no),
	-- 레시피 삭제 시 삭제
    CONSTRAINT fk_recommend_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipe(recipe_id)
    ON DELETE CASCADE,
	-- 유저 탈퇴 시 삭제
    CONSTRAINT fk_recommend_user
    FOREIGN KEY (mf_no)
    REFERENCES matflix(mf_no)
    ON DELETE CASCADE
);
select * from recipe_recommend order by 1 desc;
delete from recipe_recommend
		 where recipe_id=6
		   and mf_no=62;
           
-- 레시피 즐겨찾기
CREATE TABLE favorite_recipe (
    favorite_no BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id BIGINT NOT NULL,
    mf_no INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_recipe_user (recipe_id, mf_no),
	-- 레시피 삭제 시 삭제
    CONSTRAINT fk_favorite_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipe(recipe_id)
    ON DELETE CASCADE,
	-- 유저 탈퇴 시 삭제
    CONSTRAINT fk_favorite_user
    FOREIGN KEY (mf_no)
    REFERENCES matflix(mf_no)
    ON DELETE CASCADE
);
select * from favorite_recipe;
select count(*)
    	  from favorite_recipe
		 where recipe_id = 7
		   and mf_no = 61;

-- 레시피 댓글 테이블
CREATE TABLE recipe_comment (
    comment_no INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id bigint not null,
    mf_no int not null,
    comment_content VARCHAR(300),
    parentCommentNo INT DEFAULT 0,
    deleted int default 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    recommend_count INT DEFAULT 0,
    recommend_notify_step INT DEFAULT 0,
    
    CONSTRAINT fk_recipe_comment_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_recipe_comment_user
        FOREIGN KEY (mf_no)
        REFERENCES matflix (mf_no)
        ON DELETE CASCADE
);
select * from recipe_comment;
SELECT rc.comment_no
		     , rc.recipe_id
		     , rc.mf_no
		     , rc.comment_content
		     , rc.parentCommentNo
		     , rc.deleted
		     , rc.created_at
		     , rc.recommend_count
		     , m.mf_nickname
		     , ui.profile_image_path AS profile_image_path
             , (select count(*) from recipe_comment_recommend rcr where rcr.mf_no = 61 and comment_no = rc.comment_no) AS recommended
    	  FROM recipe_comment rc
		  LEFT JOIN user_image ui
			ON rc.mf_no = ui.mf_no
          JOIN matflix m
            ON rc.mf_no = m.mf_no
         WHERE rc.recipe_id = 7
           AND rc.deleted = 0
         ORDER BY rc.comment_no ASC;

CREATE TABLE recipe_comment_recommend (
	recipe_comment_recommend_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
    comment_no  int NOT NULL,
    mf_no  		int NOT NULL,
    updateTime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,	-- 업데이트 시간
    UNIQUE KEY unique_recommend (comment_no, mf_no), 	-- 레시피 번호와 사용자 번호의 조합이 유일하도록 제약
    -- 댓글 삭제 시 추천 자동 삭제
	CONSTRAINT fk_recipe_comment_recommend_comment
        FOREIGN KEY (comment_no)
        REFERENCES recipe_comment (comment_no)
        ON DELETE CASCADE,
    -- 유저 삭제 시 추천 자동 삭제
	constraint fk_recipe_comment_recommend_user
		FOREIGN KEY (mf_no)
		REFERENCES matflix (mf_no)
		ON DELETE CASCADE
);
select * from recipe_comment_recommend;
delete from recipe_comment_recommend where comment_no = 3;

-- 리뷰
CREATE TABLE recipe_review (
    review_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipe_id  BIGINT NOT NULL,
    mf_no  	   int NOT NULL,
    rating     INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    content    TEXT,
    deleted	   int DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_recipe_user (recipe_id, mf_no),
    -- 레시피 삭제시 삭제
    CONSTRAINT fk_recipe_review
		FOREIGN KEY (recipe_id)
		REFERENCES recipe(recipe_id)
		ON DELETE CASCADE,
    -- 유저 삭제 시 추천 자동 삭제
	constraint fk_review_user
		FOREIGN KEY (mf_no)
		REFERENCES matflix (mf_no)
		ON DELETE CASCADE
);
select * from recipe_review;
select * from recipe_review_summary;
update recipe_review_summary set review_count = review_count + 1 where recipe_id = 7;
SELECT r.review_id
			 , r.recipe_id
			 , r.mf_no
			 , r.rating
			 , r.deleted
			 , r.content
			 , r.created_at
			 , m.mf_nickname
		  FROM recipe_review r
		  left join matflix m
		    on r.mf_no = m.mf_no
		 WHERE r.review_id = 15
		   AND deleted = 0
		 ORDER BY created_at DESC;
select f.favorite_no
			 , r.recipe_id
			 , f.mf_no
			 , r.category
			 , r.title
			 , m.mf_nickname
			 , r.star
			 , r.created_at
			 , ri.image_path
             , (select count(*) from recipe_review where recipe_id = r.recipe_id) as review_count
		  from favorite_recipe f
		  left join recipe r
			on f.recipe_id = r.recipe_id
		  JOIN matflix m
			ON f.mf_no = m.mf_no
		  LEFT JOIN recipe_image ri
			ON f.recipe_id = ri.recipe_id
		   AND ri.image_type ="THUMBNAIL"
		 where f.mf_no = 61;
         
         SELECT r.review_id
			 , r.recipe_id
			 , r.mf_no
			 , r.rating
			 , r.deleted
			 , r.content
			 , r.created_at
			 , m.mf_nickname
		  FROM recipe_review r
		  left join matflix m
		    on r.mf_no = m.mf_no
		 WHERE r.review_id = 28
		   AND r.deleted = 0
		 ORDER BY created_at DESC;

-- 리뷰 이미지
CREATE TABLE review_image (
    image_id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    review_id  BIGINT NOT NULL,
    image_path VARCHAR(255),

    CONSTRAINT fk_image_review
        FOREIGN KEY (review_id)
        REFERENCES recipe_review(review_id)
        ON DELETE CASCADE
);
select * from review_image;

-- 리뷰 점수
CREATE TABLE recipe_review_summary (
    recipe_id     BIGINT PRIMARY KEY,
    review_count  INT DEFAULT 0,
    rating_sum    INT DEFAULT 0,
    rating_5      INT DEFAULT 0,
    rating_4      INT DEFAULT 0,
    rating_3      INT DEFAULT 0,
    rating_2      INT DEFAULT 0,
    rating_1      INT DEFAULT 0,

    CONSTRAINT fk_summary_recipe
        FOREIGN KEY (recipe_id)
        REFERENCES recipe(recipe_id)
        ON DELETE CASCADE
);
select * from recipe_review_summary;
SELECT * 
  FROM recipe_review_summary
 WHERE recipe_id = 6;
delete from recipe_review_summary where recipe_id = 6;
update recipe_review_summary
   set rating_4 = 1
 WHERE recipe_id = 6;


-- 공지사항
create table notice_board(
	notice_boardNo int primary key auto_increment, 
	notice_boardName varchar(20),
	notice_boardTitle varchar(100),
	notice_boardContent varchar(300),
	notice_boardDate timestamp default current_timestamp,
	notice_boardHit int default 0,
	mf_no int default 0
);

CREATE TABLE user_ranking (
    mf_no INT PRIMARY KEY,
    mf_nickname VARCHAR(100),
    follower_count INT NOT NULL,
    avg_recipe_recommend DECIMAL(6,3) NOT NULL,
    avg_recipe_star DECIMAL(4,2) NOT NULL,
    avg_board_recommend DECIMAL(6,3) NOT NULL,
    ranking_score DECIMAL(10,4) NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT *
  FROM user_ranking
 ORDER BY ranking_score DESC
 LIMIT 100;
 SELECT ur.mf_no
			 , ur.mf_nickname
			 , ur.follower_count
			 , ur.avg_recipe_star
			 , ur.ranking_score
			 , ui.profile_image_path
		  FROM user_ranking ur
		  LEFT JOIN user_image ui
		    ON ur.mf_no = ui.mf_no
		 ORDER BY ranking_score DESC
		 LIMIT 10;

INSERT INTO user_ranking (
    mf_no,
    mf_nickname,
    follower_count,
    avg_recipe_recommend,
    avg_recipe_star,
    avg_board_recommend,
    ranking_score
)
SELECT
    new.mf_no,
    new.mf_nickname,
    new.follower_count,
    new.avg_recipe_recommend,
    new.avg_recipe_star,
    new.avg_board_recommend,
    new.ranking_score
FROM (
    SELECT
        m.mf_no,
        m.mf_nickname,

        IFNULL(f.follower_count, 0) AS follower_count,

        IFNULL(r.avg_recipe_recommend, 0) AS avg_recipe_recommend,
        IFNULL(r.avg_recipe_star, 0) AS avg_recipe_star,
        IFNULL(b.avg_board_recommend, 0) AS avg_board_recommend,

        ROUND(
            IFNULL(f.follower_count, 0) * 0.3 +
            IFNULL(r.avg_recipe_recommend, 0) * 0.3 +
            IFNULL(r.avg_recipe_star, 0) * 0.2 +
            IFNULL(b.avg_board_recommend, 0) * 0.2
        , 4) AS ranking_score

    FROM matflix m

    LEFT JOIN (
        SELECT
            following_id,
            COUNT(*) AS follower_count
        FROM follow
        GROUP BY following_id
    ) f ON m.mf_no = f.following_id

    LEFT JOIN (
        SELECT
            mf_no,
            ROUND(AVG(recommend), 3) AS avg_recipe_recommend,
            ROUND(AVG(star), 2) AS avg_recipe_star
        FROM recipe
        GROUP BY mf_no
    ) r ON m.mf_no = r.mf_no

    LEFT JOIN (
        SELECT
            mf_no,
            ROUND(AVG(recommend_count), 3) AS avg_board_recommend
        FROM tbl_board
        GROUP BY mf_no
    ) b ON m.mf_no = b.mf_no
) AS new
ON DUPLICATE KEY UPDATE
    mf_nickname = new.mf_nickname,
    follower_count = new.follower_count,
    avg_recipe_recommend = new.avg_recipe_recommend,
    avg_recipe_star = new.avg_recipe_star,
    avg_board_recommend = new.avg_board_recommend,
    ranking_score = new.ranking_score;
-- 신고 기능 ------------------------------------------------------------------------------------------------

-- 신고 테이블
CREATE TABLE report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_mf_no INT NOT NULL,                 		-- 신고자 mf_no
    target_type VARCHAR(20) NOT NULL,            		-- "USER" / "BOARD" / "COMMENT" / "RECIPE"
    target_id INT NOT NULL,                   		-- 대상 PK
    target_owner_mf_no INT DEFAULT NULL,         		-- 대상 작성자 mf_no (유저 신고면 신고당한 유저)
    report_title VARCHAR(120) NOT NULL,         		-- 관리자 빠른 파악용 제목
    report_reason VARCHAR(30) NOT NULL,          		-- "성적" / "욕설" / "비하" / "차별" / "스팸" ...
    report_detail TEXT,                          		-- 상세 설명
    status VARCHAR(20) NOT NULL DEFAULT "PENDING",		-- "PENDING"(미처리) / "DONE"(처리완료) / "REJECTED"(반려)  <- 원하는 만큼만 쓰면 됨
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_report_target (target_type, target_id),
    INDEX idx_report_status_created (status, created_at),
    INDEX idx_report_reporter_created (reporter_mf_no, created_at)
);
select * from report;


-- 신고 이미지 테이블
CREATE TABLE report_image (
    report_image_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    original_name VARCHAR(255) DEFAULT NULL,
    sort_no INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_report_image_report (report_id, sort_no),
    CONSTRAINT fk_report_image_report
        FOREIGN KEY (report_id) REFERENCES report(report_id) ON DELETE CASCADE
);
select * from report_image;


-- 신고 관리자 테이블
CREATE TABLE report_admin_action (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    admin_mf_no INT NOT NULL,                    -- 관리자 mf_no
    action_type VARCHAR(30) NOT NULL,            -- "REVIEW" 검토중 / "DONE" 저리 완료 / "REJECT" 반려
    action_code VARCHAR(30) DEFAULT NULL,        -- "WARN" 경고 / "SUSPEND" 이용정지(일정기간) / "BAN" 영구정지 / "DELETE_CONTENT" 해당 콘텐츠 삭제 / "NO_ACTION" 초지 없음 등(선택)
    action_detail TEXT,                          -- 관리자 메모/처리 사유/내부 기록
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_report_action_report (report_id, created_at),
    INDEX idx_report_action_admin (admin_mf_no, created_at),
    CONSTRAINT fk_report_action_report
        FOREIGN KEY (report_id) REFERENCES report(report_id) ON DELETE CASCADE
);
select * from report_admin_action;







-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------