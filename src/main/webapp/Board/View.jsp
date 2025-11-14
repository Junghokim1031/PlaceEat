<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${board.title}</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/Footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Resources/CSS/View.css">

<!-- jQuery (must load before View.js) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Kakao Maps API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=54ad5c72f0aaa1f9d3ac1211aad9a839&libraries=services"></script>

<!-- ✅ FIXED: Correct path to View.js -->
<script src="${pageContext.request.contextPath}/Resources/Script/View.js"></script>

</head>
<body class="container-fluid p-0 m-0">
<jsp:include page="/Resources/Header.jsp" />

<!-- 게시글 데이터 확인 -->
<c:if test="${empty board or board.boardId eq 0}">
    <div class="alert alert-warning text-center">
        해당 게시글을 찾을 수 없습니다.
    </div>
</c:if>

<!-- 게시글 데이터 있을 때 -->
<c:if test="${not empty board and board.boardId ne 0}">
    <div class="content-wrapper">
        <!-- Decorative Top Border -->
        <div class="border-decoration-top"></div>
        
        <!-- Title Section -->
        <table id="title" class="w-100 mb-1">
            <tr>
                <td>
                    <h1>${board.title}</h1>
                </td>
            </tr>
        </table>
        
        <!-- Meta Information -->
        <table class="w-100 meta-info">
            <tr>
                <td class="text-center"><b>작성자:</b> ${board.userId}</td>
                <td class="text-center"><b>작성일:</b> ${board.createdAt}</td>
                <td class="text-center"><b>조회수:</b> ${board.viewCount}</td>
            </tr>
        </table>

        <!-- Navigation Shortcuts -->
        <table id="shortCut">
            <tr>
                <td><a href="#title">사진 보기</a></td>
                <td><a href="#staticMap">지도 보기</a></td>
                <td><a href="#content">상세정보</a></td>
                <td><a href="#replyTable">댓글 보기</a></td>
            </tr>
        </table>

        <!-- Featured Image -->
        <c:choose>
            <c:when test="${not empty board.imgSfilename}">
                <img src="${pageContext.request.contextPath}/Uploads/${board.imgSfilename}" 
                     class="centered-img" alt="${board.title}"/>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted mb-3">등록된 이미지가 없습니다.</div>
            </c:otherwise>
        </c:choose>

        <!-- Main Content Section -->
        <div id="content">
            <h3>상세정보</h3>
            <div id="main-content">${board.content}</div>
            
            <!-- Map -->
            <div id="staticMap"></div>
            
            <!-- Additional Details -->
            <c:choose>              
                <c:when test="${not empty board.details}">
                    <div class="detail">
                        <b>부가정보:</b><br>
                        ${board.details}
                    </div>
                </c:when>
            </c:choose>

            <!-- Location & Hashtags -->
            <div class="detail">
                <b>위치:</b> ${board.locationName}<br>
                <c:if test="${not empty board.hashtagName}">
                    <b>해시태그:</b> #${board.hashtagName}
                </c:if>
            </div>
            
            <!-- ✅ FIXED: Like Button with correct session attribute -->
            <div class="d-flex align-items-center justify-content-between py-3 px-2 border rounded bg-white my-3">
				  <!-- Left: exact text -->
				  <div class="pe-like-copy">
				    <div class="fw-bold mb-1">해당 여행지가 마음에 드시나요?</div>
				    <div class="text-muted small">평가를 해주시면 개인화 추천 시 활용하여 최적의 여행지를 추천해 드리겠습니다.</div>
				  </div>
				
				  <!-- Right: large pill button -->
				  <c:choose>
				    <c:when test="${not empty sessionScope.loginUser}">
				      <button id="likeBtn" type="button"
						        class="pe-like btn border-0 px-4 py-3 ms-3"
						        data-user-id="${sessionScope.loginUser.userid}"
						        data-board-id="${board.boardId}"
						        data-liked="${userLiked ? 'true' : 'false'}"
						        data-context-path="${pageContext.request.contextPath}">
						  <span class="pe-like-face me-2" aria-hidden="true">😆</span>
						  <span class="pe-like-text">좋아요!</span>
						  <span class="badge ms-2" id="likeCount">${likeCount}</span>
						</button>
				    </c:when>
				    <c:otherwise>
				      <button type="button"
				              class="pe-like btn border-0 px-4 py-3 ms-3"
				              onclick="alert('로그인이 필요합니다.');">
				        <span class="pe-like-face me-2" aria-hidden="true">😆</span>
				        <span class="pe-like-text">좋아요!</span>
				        <span class="badge ms-2" id="likeCount">${likeCount}</span>
				      </button>
				    </c:otherwise>
				  </c:choose>
				</div>

            
            <!-- ✅ FIXED: Action Buttons with correct session check -->
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/Board/List.do" class="btn btn-secondary">목록으로</a>
                <c:if test="${not empty sessionScope.loginUser and board.userId eq sessionScope.loginUser.userid}">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/Board/Edit.do?mode=edit&boardId=${board.boardId}';"
                            class="btn btn-warning ms-2"> 수정하기 </button>
                    
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/Board/Edit.do" style="display:inline;">
					    <input type="hidden" name="mode" value="delete">
					    <input type="hidden" name="boardId" value="${board.boardId}">
					    <button type="button" class="btn btn-danger ms-2"
					            onclick="if(confirm('정말 삭제하시겠습니까?')) document.getElementById('deleteForm').submit();">
					        삭제하기
					    </button>
					</form>
                </c:if>
            </div>
        </div>

        <!-- Restaurants Section -->
        <div class="info-box mt-4">
            <h4>🍽️ 추천 맛집</h4>
        
            <c:if test="${empty restaurants}">
                <p class="text-muted">등록된 맛집이 없습니다.</p>
            </c:if>
        
            <c:forEach var="r" items="${restaurants}">
                <div class="border rounded p-2 mb-2 d-flex justify-content-between align-items-center">
                    <span><b>${r.restName}</b></span>
                    <span>
                        <a href="${r.restAddress}" target="_blank" class="text-decoration-none">
                            바로가기
                        </a>
                    </span>
                    <span class="text-muted">${r.createdAt}</span>
                </div>
            </c:forEach>
        </div>

        <!-- Comments Section -->
        <table id="replyTable" class="w-100 mt-5">
            <tr>
                <td colspan="3">
                    <h3>💬 댓글</h3>
                </td>
            </tr>
            <c:choose>
                <c:when test="${empty comments}">
                    <tr>
                        <td class="text-muted text-center py-3">아직 댓글이 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="cmt" items="${comments}">
                        <tr>
                            <td>
                                <b>${cmt.userId}</b> <span class="text-muted">(${cmt.createdAt})</span>
                                <br>
                                ${cmt.content}
                                
                                
                                <c:if test="${not empty sessionScope.loginUser and cmt.userId eq sessionScope.loginUser.userid}">
                                    <form action="${pageContext.request.contextPath}/Board/Delete.do" 
                                          method="post" style="display:inline;" class="float-end">
                                        <input type="hidden" name="commentId" value="${cmt.commentId}">
                                        <input type="hidden" name="boardId" value="${board.boardId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('댓글을 삭제하시겠습니까?');">삭제</button>
                                    </form>
                                </c:if>
                                <hr>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </table>

        <table style="width:100%; margin:0 auto;">
            <c:if test="${not empty map.pagingImg}">
                <tr>
                    <td align="center">${map.pagingImg}</td>
                </tr>
            </c:if>
        </table>

        
        <!-- Comment Form - Only for logged-in users -->
		<c:choose>
		    <c:when test="${not empty sessionScope.loginUser}">
		        <!-- Logged-in users: Show comment form -->
		        <form id="replyForm" method="post" action="${pageContext.request.contextPath}/Board/Insert.do">
		            <input type="hidden" name="boardId" value="${board.boardId}">
		            <textarea id="replyContent" name="replyContent" rows="4" 
		                      class="form-control" placeholder="댓글을 입력하세요" required></textarea>
		            <button type="submit" class="btn float-end mt-3">댓글등록</button>
		        </form>
		    </c:when>
		    <c:otherwise>
		        <!-- Guests: Show login prompt -->
		        <div class="alert alert-info text-center">
		            <p>댓글을 작성하려면 로그인이 필요합니다.</p>
		            <a href="${pageContext.request.contextPath}/Member/Login.jsp" class="btn btn-primary">
		                로그인하기
		            </a>
		        </div>
		    </c:otherwise>
		</c:choose>


        <!-- Decorative Bottom Border -->
        <div class="border-decoration-bottom"></div>
    </div>
</c:if>

<!-- ✅ FIXED: Initialize View Page with correct session attribute -->
<script>
    var viewPageConfig = {
        <c:choose>
            <c:when test="${not empty board and board.boardId ne 0}">
                latitude: ${board.latitude != null ? board.latitude : 0},
                longitude: ${board.longitude != null ? board.longitude : 0},
                boardId: ${board.boardId},
                userLiked: ${userLiked != null ? userLiked : false},
                likeCount: ${likeCount != null ? likeCount : 0},
                contextPath: '${pageContext.request.contextPath}'
            </c:when>
            <c:otherwise>
                latitude: 0,
                longitude: 0,
                boardId: 0,
                userId: '',
                userLiked: false,
                likeCount: 0,
                contextPath: '${pageContext.request.contextPath}'
            </c:otherwise>
        </c:choose>
    };
    
    console.log('viewPageConfig created:', viewPageConfig);
    
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded - initializing view page...');
        
        if (typeof initializeViewPage === 'function') {
            initializeViewPage(viewPageConfig);
            console.log("✅ View.jsp initialized successfully");
        } else {
            console.error("❌ ERROR: initializeViewPage function not found in View.js");
            console.error("Check if View.js is loaded at: Resources/Script/View.js");
        }
    });
</script>

<jsp:include page="/Resources/Footer.jsp" />

</body>
</html>
