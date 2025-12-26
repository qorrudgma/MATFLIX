-- 유저테이블
CREATE TABLE matflix (
    mf_no INT AUTO_INCREMENT PRIMARY KEY,
    mf_id VARCHAR(20) NOT NULL,
    mf_pw VARCHAR(20) NOT NULL,
    mf_pw_chk VARCHAR(20),
    mf_name VARCHAR(20) NOT NULL,
    mf_nickname VARCHAR(1000),
    mf_email VARCHAR(50),
    mf_phone VARCHAR(20),
    mf_birth DATE,
    mf_gender CHAR(1) DEFAULT 'M' CHECK (mf_gender IN ('M', 'F')),
    mf_regdate DATETIME DEFAULT CURRENT_TIMESTAMP,
    mf_role VARCHAR(10) DEFAULT 'USER' CHECK (mf_role IN ('USER', 'ADMIN'))
);
select * from matflix;

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
delete f
  from follow f
  join (
		select follow_id
          from follow
		 where follower_id =1
			or following_id =1
	   ) f2 on f.follow_id = f2.follow_id;

-- 알림 테이블
CREATE TABLE notifications (
    notifications_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,          -- 팔로우를 거는 사람 (알림 생성하는 행동하는 사람)
    following_id INT NOT NULL,          -- 팔로우 당하는 사람 (알림 받는 대상)
    boardNo INT NOT NULL,             -- 해당 게시판 고유넘버 (알림 생성하는 게시판)
    post_id INT,                         -- 어떤 알림인지 (게시글(1),댓글(2),팔로우(3),레시피(4))
    is_read int DEFAULT 0,             -- 알림 읽음 여부
    created_at DATETIME DEFAULT NOW()    -- 생성 시간
);

select * from notifications;
DELETE n
  FROM notifications n
  JOIN (
       SELECT notifications_id
         FROM notifications
        WHERE follower_id = 1
		   OR following_id = 1
	   ) t ON n.notifications_id = t.notifications_id;

-- 알림 on/off 테이블
CREATE TABLE notif_setting (
    notif_id INT AUTO_INCREMENT PRIMARY KEY,
    mf_no INT NOT NULL,
    notif_type VARCHAR(30) NOT NULL,
    yn INT NOT NULL DEFAULT 1,
    UNIQUE KEY uk_user_type (mf_no, notif_type)
);

select * from notif_setting;
SELECT YN from notif_setting where mf_no=62 and notif_type = "follow";
-- follow: "팔로우"
-- board: "게시글"
-- comment: "댓글"
-- recipe_comment: "레시피 댓글"

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

-- 게시판 테이블
CREATE TABLE tbl_board (
    boardNo int AUTO_INCREMENT PRIMARY KEY,
    boardName VARCHAR(20),
    boardTitle VARCHAR(100),
    boardContent VARCHAR(300),
    boardDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    boardHit int DEFAULT 0,
    mf_no INT not null
);

-- 게시판 댓글 테이블
CREATE TABLE board_comment (
    commentNo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    commentWriter VARCHAR(20),
    commentContent VARCHAR(300),
    boardNo INT,
    userNo int,
    commentCreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 게시판 파일 테이블
CREATE TABLE board_attach (
    uuid VARCHAR(255) PRIMARY KEY,              -- 파일의 고유 식별자(UUID)
    uploadPath VARCHAR(255) NOT NULL,           -- 파일이 저장된 경로
    fileName VARCHAR(255) NOT NULL,             -- 파일 이름
    image CHAR(1) CHECK (image IN ('Y', 'N')),  -- 이미지 여부 (Y/N)
    boardNo INT NOT NULL                        -- 게시글 번호 (외래키)
);

-- 게시판 추천 테이블
CREATE TABLE tbl_recommend (
    recommend_id INT AUTO_INCREMENT PRIMARY KEY, -- 고유 식별자 (자동 증가)
    boardNo INT NOT NULL,                        -- 게시글 번호 (추천된 게시글)
    mf_no INT NOT NULL,                          -- 사용자 번호 (추천한 사용자)
    UNIQUE KEY unique_recommend (boardNo, mf_no) -- 게시글 번호와 사용자 번호의 조합이 유일하도록 제약
);
select * from tbl_recommend;

-- 레시피 테이블
CREATE TABLE recipe (
    rc_recipe_id     INT PRIMARY KEY AUTO_INCREMENT,
    rc_name          VARCHAR(100) NOT NULL,
    rc_description   TEXT,
    rc_category1_id  VARCHAR(20),
    rc_category2_id  VARCHAR(20) DEFAULT 'a',
    rc_cooking_time  VARCHAR(20),
    rc_difficulty    ENUM('easy', 'medium', 'hard'),
    rc_created_at    DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rc_img           VARCHAR(1000),  -- 요리 메인 사진(1장)
    rc_tip           VARCHAR(1000),
    rc_tag           VARCHAR(1000),
    mf_no        INT,
    star_score DOUBLE default 0
);

-- 레시피 파일
CREATE TABLE rc_attach (
    uuid VARCHAR(100) NOT NULL PRIMARY KEY,     -- 파일 고유 식별자 (UUID)
    uploadPath VARCHAR(200) NOT NULL,          -- 업로드 경로
    fileName VARCHAR(255) NOT NULL,               -- 파일 이름
    image BOOLEAN DEFAULT FALSE,                  -- 이미지 여부 (true: 이미지, false: 일반 파일)
    rc_recipe_id INT NOT NULL                     -- 참조하는 레시피 ID
    );

-- 재료 테이블
CREATE TABLE rc_ingredient (
    rc_recipe_id INT, -- 외래키
    rc_ingredient_id INT AUTO_INCREMENT PRIMARY KEY,    -- 자동 증가 재료 ID
    rc_ingredient_name VARCHAR(1000),                -- 주재료명
    rc_ingredient_amount VARCHAR(1000),               -- 주재료양
    FOREIGN KEY (rc_recipe_id) REFERENCES recipe(rc_recipe_id) ON DELETE CASCADE
);

-- 조리 과정 테이블
CREATE TABLE rc_course (
    rc_recipe_id INT, -- 외래키
    rc_course_id INT AUTO_INCREMENT PRIMARY KEY,       -- 자동 증가 과정 ID
    rc_course_description VARCHAR(1000) DEFAULT '',    -- 조리과정 설명
    rc_course_img VARCHAR(1000),                     -- 조리과정 사진
    FOREIGN KEY (rc_recipe_id) REFERENCES recipe(rc_recipe_id) ON DELETE CASCADE
);

-- 레시피 게시판 테이블
CREATE TABLE rc_board (
    rc_boardNo int AUTO_INCREMENT PRIMARY KEY,
    rc_boardName VARCHAR(20),
    rc_boardTitle VARCHAR(100),
    rc_boardContent VARCHAR(300),
    rc_boardDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rc_boardHit int DEFAULT 0,
    rc_recipe_id INT
);

-- 레시피 댓글
CREATE TABLE rc_board_comment(
   rc_commentNo int primary key auto_increment,
   rc_commentWriter varchar(20),
   rc_commentContent varchar(300),
   rc_boardNo int, 
   rc_commentCreatedTime datetime default current_timestamp,
   user_star_score int default 0,
   mf_no INT NOT NULL
);

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