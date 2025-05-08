SELECT * FROM tbl_board;
SELECT * FROM board_attach;
SELECT * FROM board_comment;

delete from board_comment
 where userNo="";
 
SELECT * FROM tbl_board where boardNo = 303;
SELECT * FROM board_attach where boardNo = 303;
SELECT * FROM board_comment where userNo = 1;

drop table board_comment;

CREATE TABLE board_comment (
    commentNo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    commentWriter VARCHAR(20),
    commentContent VARCHAR(300),
    boardNo INT,
    userNo int DEFAULT 1,
    commentCreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_board (
    boardNo int AUTO_INCREMENT PRIMARY KEY,
    boardName VARCHAR(20),
    boardTitle VARCHAR(100),
    boardContent VARCHAR(300),
    boardDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    boardHit int DEFAULT 0 
);

CREATE TABLE board_attach (
    uuid VARCHAR(255) PRIMARY KEY,              -- 파일의 고유 식별자(UUID)
    uploadPath VARCHAR(255) NOT NULL,           -- 파일이 저장된 경로
    fileName VARCHAR(255) NOT NULL,             -- 파일 이름
    image CHAR(1) CHECK (image IN ('Y', 'N')),  -- 이미지 여부 (Y/N)
    boardNo INT NOT NULL                        -- 게시글 번호 (외래키)
);

SELECT * FROM tbl_board;
SELECT COUNT(*) FROM tbl_board;
