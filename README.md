# MATFLIX
<img src="MATFLIX/src/main/resources/static/image/MATFLIX.png" alt="MATFLIX 로고" width="200"/>

**MATFLIX**는 전국의 전기차 충전소 위치 및 실시간 충전 가능 여부를 확인할 수 있는 웹사이트입니다.  
사용자는 지도를 통해 가까운 충전소를 쉽게 찾고, 실시간 상태를 확인하여 효율적으로 충전소를 이용할 수 있습니다.

---

## 🌟 주요 기능(기여도: 상: ⭐/ 중: ★/ 하: ☆)

 ✅*개발 완료*
| 기능명 | 설명 | 기여도 |
|--------|------|--------|
| **전국 전기차 충전소 위치 시각화** | Kakao Map API를 활용해 지도 기반 충전소 위치 제공 | 중 ★ |
| **실시간 충전 가능 여부 표시** | 공공데이터 API로 실시간 충전 상태 시각화 | 상 ⭐ |
| **다양한 검색 기능** <br> (지역 / 현재 지도 / 키워드) | Redis 캐시로 빠른 검색 + Elasticsearch로 정확도 높은 검색 | 상 ⭐ |
| **게시판 및 공지사항 기능** | 커뮤니티 게시판 + 관리자 공지사항 등록/관리 | 중 ★ |
| **사용자 위치 기반 길찾기 기능** | KAKAO API를 활용한 사용자 현재 위치부터 목적지까지의 경로 표시 및 경유지 제공 | 중 ★ |
| **시간대별 충전소 예약 기능** | 해당 충전소 30분 단위 예약기능 CRUD | 중 ★ |
| **실시간 데이터 분석 및 차트 표시** | Spark를 이용한 로지스틱 회귀, 선형회귀를 토대로 해당 충전소 혼잡도 예측 및 시간대별 예약현황 제공 | 중 ★ |

⏳*개발 예정*<br>
| 기능명 | 설명 |
|--------|------|
| **즐겨찾기 기능** | 로그인 사용자 기반의 즐겨찾기 등록 및 <br> 마이페이지에서 관리 기능 제공 |
| **리뷰 및 별점 기능** | 사용자 리뷰 등록/수정/삭제 및 <br> 충전소 별점 평균 표시 |
| **마이페이지 기능** | 내 정보, 즐겨찾기, 내가 쓴 글/리뷰 등 <br> 개인화 정보 제공 |


---

## 🛠 사용 기술 스택

- 🎨 Frontend<br>
<img src="https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black" height="25" /> <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white" height="25" />

- 🔧 Backend<br>
<img src="https://img.shields.io/badge/Java-17-007396?style=flat&logo=java&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/SpringBoot-6DB33F?style=flat&logo=springboot&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/AJAX-0054A6?style=flat&logo=code&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/FETCH-00A9E0?style=flat&logo=javascript&logoColor=white" height="25" />

- 🗃 Database<br>
       <img src="https://img.shields.io/badge/MySQL-005C84?style=flat&logo=mysql&logoColor=white" height="25" />

- 🔍 Data Processing & Search<br>
<img src="https://img.shields.io/badge/Hadoop-66CCFF?style=flat&logo=apachehadoop&logoColor=black" height="25" /> <img src="https://img.shields.io/badge/Spark-FF9900?style=flat&logo=apachespark&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/Elasticsearch-005571?style=flat&logo=elasticsearch&logoColor=white" height="25" />

- ☁️ 실행 환경 (Infra)<br>
<img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/Redis-DC382D?style=flat&logo=redis&logoColor=white" height="25" /><br>
`Elasticsearch / Redis 실행 환경 구성용`

- 🔗 API & 외부 데이터<br>
<img src="https://img.shields.io/badge/Kakao%20Map-FFCD00?style=flat&logo=kakaotalk&logoColor=black" height="25" /> <img src="https://img.shields.io/badge/Public%20Data%20API-0064FF?style=flat&logo=data&logoColor=white" height="25" />

- 🛠 개발 도구 & 빌드<br>
<img src="https://img.shields.io/badge/Gradle-02303A?style=flat&logo=gradle&logoColor=white" height="25" /> <img src="https://img.shields.io/badge/Visual%20C++-00599C?style=flat&logo=visualstudio&logoColor=white" height="25" />


---

## ERD
![image](https://github.com/user-attachments/assets/f5c43908-7c2a-4d65-a080-eb0821ac3b8c)
