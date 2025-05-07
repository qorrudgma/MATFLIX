CREATE TABLE tbl_board (
    boardNo NUMBER PRIMARY KEY,  -- boardNo 필드는 PRIMARY KEY로 설정
    boardName VARCHAR2(20),
    boardTitle VARCHAR2(100),
    boardContent VARCHAR2(300),
    boardDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 게시글 생성 날짜
    boardHit NUMBER DEFAULT 0                        -- 조회수
);

CREATE TABLE board_comment (
    commentNo NUMBER PRIMARY KEY,             -- 댓글 번호 (수동 증가)
    commentWriter VARCHAR2(255) NOT NULL,     -- 댓글 작성자
    commentContent CLOB NOT NULL,             -- 댓글 내용
    boardNo NUMBER NOT NULL,                  -- 게시글 번호 (외래키)
    commentCreatedTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 작성 시간
    CONSTRAINT fk_board_comment_board FOREIGN KEY (boardNo)
        REFERENCES tbl_board(boardNo) ON DELETE CASCADE
);


CREATE TABLE board_attach (
    uuid VARCHAR2(255) PRIMARY KEY,     -- 파일의 고유 식별자(UUID)
    uploadPath VARCHAR2(255) NOT NULL,  -- 파일이 저장된 경로
    fileName VARCHAR2(255) NOT NULL,    -- 파일 이름
    image CHAR(1) CHECK (image IN ('Y', 'N')), -- 이미지 여부 (Y/N)
    boardNo NUMBER NOT NULL,            -- 게시글 번호 (외래키)
    CONSTRAINT fk_boardNo FOREIGN KEY (boardNo) REFERENCES tbl_board(boardNo) -- 외래키 관계 설정
);

SELECT * FROM tbl_board;
SELECT COUNT(*) FROM tbl_board;



SELECT board_no_seq.CURRVAL FROM dual;
SELECT board_no_seq.NEXTVAL FROM dual;
ALTER SEQUENCE board_no_seq RESTART START WITH 11;

GRANT SELECT, ALTER, UPDATE ON board_no_seq TO your_user;

DELETE FROM tbl_board;


-- 300개의 데이터를 삽입하는 INSERT문
BEGIN
  FOR i IN 1..300 LOOP
    INSERT INTO tbl_board (boardNo, boardName, boardTitle, boardContent, boardDate, boardHit)
    VALUES (board_no_seq.NEXTVAL, 
            '자유게시판', 
            '게시글 #' || (i + 10),  -- 10을 더해서 기존 데이터와 겹치지 않도록
            '이 게시글은 자동으로 생성된 게시글 #' || (i + 10) || '입니다.',
            SYSDATE, 
            MOD(i, 10));  -- 조회수는 i값을 이용하여 간단히 주기적으로 증가시킴
  END LOOP;
  COMMIT;
END;
