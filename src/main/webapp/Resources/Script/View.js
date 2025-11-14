/**
 * View.js - PLACE EAT Board View Page JavaScript
 * Handles: Kakao Map initialization, Like button AJAX, and other view page interactions
 * Version: 1.2 (Pill-like button, red on like, optimistic UI, better error handling)
 */

console.log('View.js loaded');

/* =========================================================
 * Public initializer
 * ========================================================= */
function initializeViewPage(config) {
  console.log('initializeViewPage()', config);

  if (!config) {
    console.error('No config provided to initializeViewPage');
    return;
  }

  // Map
  if (config.latitude && config.longitude && config.latitude !== 0 && config.longitude !== 0) {
    initializeKakaoMap(config.latitude, config.longitude);
  } else {
    console.warn('Skipping map initialization: invalid coords', config.latitude, config.longitude);
  }

  // Like button
  initializeLikeButton(config);
}

/* =========================================================
 * Kakao Static Map
 * ========================================================= */
function initializeKakaoMap(latitude, longitude) {
  try {
    if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
      console.error('Kakao Maps API not loaded');
      return;
    }

    var markerPosition = new kakao.maps.LatLng(latitude, longitude);
    var marker = { position: markerPosition };
    var container = document.getElementById('staticMap');

    if (!container) {
      console.error('#staticMap not found');
      return;
    }

    var opts = {
      center: new kakao.maps.LatLng(latitude, longitude),
      level: 3,
      marker: marker
    };

    new kakao.maps.StaticMap(container, opts);
    console.log('Map initialized at', latitude, longitude);
  } catch (err) {
    console.error('Error initializing Kakao map:', err);
  }
}

/* =========================================================
 * Like Button (pill) - red when liked
 * ========================================================= */
function initializeLikeButton(config) {
  var btn = document.getElementById('likeBtn');
  if (!btn) {
    console.warn('#likeBtn not present');
    return;
  }

  // Initial visual from data-liked
  var liked = String(btn.getAttribute('data-liked')) === 'true';
  syncLikeVisual(btn, liked);

  // Single handler
  btn.addEventListener('click', function () {
    const userId = btn.dataset.userId;
    const boardId = btn.dataset.boardId;
    const contextPath = btn.dataset.contextPath || (config && config.contextPath) || '';
    if (!userId || !boardId) return;

    const currentlyLiked = btn.getAttribute('data-liked') === 'true';
    const wantLike = !currentlyLiked;

    // 1) Optimistic immediate UI
    optimisticToggle(btn, wantLike);

    // 2) Server call
	sendLikeRequest(boardId, userId, contextPath, wantLike)
	  .then(function (data) {
	    // Reflect actual server state (liked)
	    if (typeof data.liked === 'boolean') {
	      btn.setAttribute('data-liked', String(data.liked));
	      syncLikeVisual(btn, data.liked);
	    }
        if (typeof data.likeCount === 'number') {
          const cntEl = document.getElementById('likeCount');
          if (cntEl) cntEl.textContent = String(data.likeCount);
        }
      })
      .catch(function () {
        // 3) Roll back to the previous state on error
        optimisticToggle(btn, currentlyLiked);
        alert('좋아요 처리 중 오류가 발생했습니다.');
      });
  });

}

/* AJAX - returns Promise<{ liked:boolean, likeCount:number }> */
function sendLikeRequest(boardId, userId, contextPath, wantLike) {
  var url = (contextPath || '') + '/likeToggle.do';

  return new Promise(function (resolve, reject) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function () {
      if (xhr.readyState !== 4) return;
      if (xhr.status === 200) {
        try {
          var data = JSON.parse(xhr.responseText);
          // Controller returns: { success:boolean, newLikeCount:number }
		  var likedFromServer = (data && typeof data.liked === 'boolean') ? data.liked : undefined;
		            resolve({
		              liked: (likedFromServer !== undefined) ? likedFromServer : Boolean(wantLike),
		              likeCount: (data && typeof data.newLikeCount === 'number') ? data.newLikeCount : undefined
		            });
        } catch (e) {
          reject({ message: '응답 파싱 오류가 발생했습니다.' });
        }
      } else {
        reject({ message: '서버 통신 오류: ' + xhr.status });
      }
    };

    xhr.onerror = function () { reject({ message: '네트워크 오류가 발생했습니다.' }); };

    // Your server takes userId from session, but sending boardId is required
    var body = new URLSearchParams({
      boardId: String(boardId)
      // userId not required since controller reads session
    }).toString();

    xhr.send(body);
  });
}


/* Optional utility */
function smoothScrollTo(id) {
  var el = document.getElementById(id);
  if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

/* Exports (CommonJS) */
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    initializeViewPage: initializeViewPage,
    initializeKakaoMap: initializeKakaoMap,
    initializeLikeButton: initializeLikeButton
  };
}

function syncLikeVisual(btn, liked) {
  btn.classList.toggle('active', liked); // red when true, gray when false
}


function optimisticToggle(btn, wantLike) {
  const wasLiked = btn.getAttribute('data-liked') === 'true';
  if (wasLiked === wantLike) return;
  btn.setAttribute('data-liked', String(wantLike));
  syncLikeVisual(btn, wantLike);

  const cntEl = document.getElementById('likeCount');
  if (cntEl) {
    const prev = parseInt(cntEl.textContent || '0', 10);
    cntEl.textContent = String(Math.max(0, prev + (wantLike ? 1 : -1)));
  }
}

console.log('View.js ready');
