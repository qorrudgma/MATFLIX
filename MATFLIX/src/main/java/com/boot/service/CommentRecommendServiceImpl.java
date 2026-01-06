package com.boot.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.CommentDAO;
import com.boot.dao.CommentRecommendDAO;
import com.boot.dao.NotifSettingDAO;
import com.boot.dao.NotificationDAO;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service("CommentRecommendService")
public class CommentRecommendServiceImpl implements CommentRecommendService {

	private final NotificationServiceImpl NotificationService;
	@Autowired
	private SqlSession sqlSession;

	CommentRecommendServiceImpl(NotificationServiceImpl NotificationService) {
		this.NotificationService = NotificationService;
	}

	@Override
	public void add_comment_recommend(int commentNo, int mf_no) {
		log.info("여기는 오나?");
		CommentRecommendDAO CRdao = sqlSession.getMapper(CommentRecommendDAO.class);
		CommentDAO Cdao = sqlSession.getMapper(CommentDAO.class);
		NotifSettingDAO NSdao = sqlSession.getMapper(NotifSettingDAO.class);
		NotificationDAO Ndao = sqlSession.getMapper(NotificationDAO.class);
		CRdao.add_comment_recommend(commentNo, mf_no);
		Cdao.add_comment_count(commentNo);
		log.info("추천 된거지?");
		int recommend_count = Cdao.recommend_count(commentNo);

		if (recommend_count % 50 == 0) {
			int recommend_notify_step = Cdao.recommend_notify_step(commentNo);
			if (recommend_count != recommend_notify_step) {
				Cdao.update_recommend_notify_step(commentNo);
				int yn = NSdao.check_notif_setting(mf_no, "recommend");
				if (yn == 1) {
					log.info("알림이 가야하는데");
					// 보내는 사람/받는사람/어디서/어떤거
					int boardNo = Cdao.commentNo_boardNo(commentNo);
					Ndao.add_notification(mf_no, mf_no, boardNo, 5);
				}
			}
		}
	}

	@Override
	public void minus_comment_recommend(int commentNo, int mf_no) {
		CommentRecommendDAO CRdao = sqlSession.getMapper(CommentRecommendDAO.class);
		CommentDAO Cdao = sqlSession.getMapper(CommentDAO.class);
		CRdao.minus_comment_recommend(commentNo, mf_no);
		Cdao.minus_comment_count(commentNo);
	}

	@Override
	public void delete_comment(int commentNo) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		dao.delete_comment(commentNo);
	}

	@Override
	public int comment_yn(int commentNo, int mf_no) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		int yn = dao.comment_yn(commentNo, mf_no);
		return yn;
	}

	@Override
	public void delete_board_comment(int boardNo) {
		CommentRecommendDAO dao = sqlSession.getMapper(CommentRecommendDAO.class);
		dao.delete_board_comment(boardNo);
	}
}