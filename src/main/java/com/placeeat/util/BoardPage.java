package com.placeeat.util;

public class BoardPage {
	// 페이징 처리 메서드
	// totalCount : 전체 게시물 수
	// pageSize : 한 페이지당 출력할 게시물 수
	// blockPage : 한 블럭당 출력할 페이지 수
	// pageNum : 현재 페이지 번호
    public static String pagingStr(int totalCount, int pageSize, int blockPage,
            int pageNum, String reqUrl) {
        String pagingStr = "";

        // 단계 3 : 전체 페이지 수 계산
        int totalPages = (int) (Math.ceil(((double) totalCount / pageSize)));

        // 단계 4 : '이전 페이지 블록 바로가기' 출력
        int pageTemp = (((pageNum - 1) / blockPage) * blockPage) + 1;
        if (pageTemp != 1) {
            pagingStr += "<a href='" + reqUrl + "?pageNum=1'>[첫 페이지]</a>";
            pagingStr += "&nbsp;";
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + (pageTemp - 1)
                         + "'>[이전 블록]</a>";
        }

        // 단계 5 : 각 페이지 번호 출력
        int blockCount = 1;
        // blockPage 수만큼. 마지막 페이지까지만 출력
        while (blockCount <= blockPage && pageTemp <= totalPages) {
            if (pageTemp == pageNum) {
                // 현재 페이지는 링크를 걸지 않음
                pagingStr += "&nbsp;" + pageTemp + "&nbsp;";
            } else {
                pagingStr += "&nbsp;<a href='" + reqUrl + "?pageNum=" + pageTemp
                              +"'>" + pageTemp + "</a>&nbsp;";
            }
            pageTemp++;
            blockCount++;
        }

        // 단계 6 : '다음 페이지 블록 바로가기' 출력
        if (pageTemp <= totalPages) {
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + pageTemp
                         + "'>[다음 블록]</a>";
            pagingStr += "&nbsp;";
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + totalPages
                         + "'>[마지막 페이지]</a>";
        }

        return pagingStr;
    }
    
    // reply용.오버라이딩
    public static String pagingStr(int totalCount, int pageSize, int blockPage,
    		int pageNum, String reqUrl,int boardId) {
    	String pagingStr = "";
    	
    	// 단계 3 : 전체 페이지 수 계산
    	int totalPages = (int) (Math.ceil(((double) totalCount / pageSize)));
    	
    	// 단계 4 : '이전 페이지 블록 바로가기' 출력
    	int pageTemp = (((pageNum - 1) / blockPage) * blockPage) + 1;
    	if (pageTemp != 1) {
    		pagingStr += "<a href='" + reqUrl + "?pageNum=1'>[첫 페이지]</a>";
    		pagingStr += "&nbsp;";
    		pagingStr += "<a href='" + reqUrl + "?pageNum=" + (pageTemp - 1)
    				+ "'>[이전 블록]</a>";
    	}
    	
    	// 단계 5 : 각 페이지 번호 출력
    	int blockCount = 1;
    	// blockPage 수만큼. 마지막 페이지까지만 출력
    	while (blockCount <= blockPage && pageTemp <= totalPages) {
    		if (pageTemp == pageNum) {
    			// 현재 페이지는 링크를 걸지 않음
    			pagingStr += "&nbsp;" + pageTemp + "&nbsp;";
    		} else {
    			pagingStr += "&nbsp;<a href='" + reqUrl + "?pageNum=" + pageTemp
    					+"&boardId="+boardId +"'>" + pageTemp + "</a>&nbsp;";
    		}
    		pageTemp++;
    		blockCount++;
    	}
    	
    	// 단계 6 : '다음 페이지 블록 바로가기' 출력
    	if (pageTemp <= totalPages) {
    		pagingStr += "<a href='" + reqUrl + "?pageNum=" + pageTemp
    				+ "'>[다음 블록]</a>";
    		pagingStr += "&nbsp;";
    		pagingStr += "<a href='" + reqUrl + "?pageNum=" + totalPages
    				+ "'>[마지막 페이지]</a>";
    	}
    	
    	return pagingStr;
    }
}
