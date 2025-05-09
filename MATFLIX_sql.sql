SELECT * FROM matflix;
SELECT * FROM tbl_board;
SELECT * FROM board_comment;
SELECT * FROM board_attach;
select * from tbl_recommend;

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
    mf_gender CHAR(1) DEFAULT 'm' CHECK (mf_gender IN ('m', 'f')),
    mf_regdate DATETIME DEFAULT CURRENT_TIMESTAMP,
    mf_role VARCHAR(10) DEFAULT 'USER' CHECK (mf_role IN ('USER', 'ADMIN'))
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

-- 게시판 조회수 테이블
CREATE TABLE tbl_recommend (
    recommend_id INT AUTO_INCREMENT PRIMARY KEY, -- 고유 식별자 (자동 증가)
    boardNo INT NOT NULL,                        -- 게시글 번호 (추천된 게시글)
    mf_no INT NOT NULL,                          -- 사용자 번호 (추천한 사용자)
    UNIQUE KEY unique_recommend (boardNo, mf_no) -- 게시글 번호와 사용자 번호의 조합이 유일하도록 제약
);


