/**
 * View.js - PLACE EAT Board View Page JavaScript
 * Handles: Kakao Map initialization, Like button AJAX, and other view page interactions
 * Version: 1.1 (Enhanced with better error handling)
 */

console.log('View.js loaded successfully');

/**
 * Initialize the view page with provided configuration
 * @param {Object} config - Configuration object from JSP
 */
function initializeViewPage(config) {
    console.log('=== initializeViewPage called ===');
    console.log('Config received:', config);
    
    // Validate config
    if (!config) {
        console.error('ERROR: No configuration provided to initializeViewPage');
        return;
    }
    
    // Initialize Kakao Map
    if (config.latitude && config.longitude && config.latitude !== 0 && config.longitude !== 0) {
        console.log('Attempting to initialize map...');
        initializeKakaoMap(config.latitude, config.longitude);
    } else {
        console.warn('Skipping map initialization - invalid coordinates:', config.latitude, config.longitude);
    }
    
    // Initialize Like Button
    console.log('Attempting to initialize like button...');
    initializeLikeButton(config);
    
    console.log('=== initializeViewPage completed ===');
}

/**
 * Initialize Kakao Static Map
 * @param {number} latitude - Location latitude
 * @param {number} longitude - Location longitude
 */
function initializeKakaoMap(latitude, longitude) {
    console.log('initializeKakaoMap called with:', latitude, longitude);
    
    try {
        // Check if Kakao Maps API is loaded
        if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
            console.error('ERROR: Kakao Maps API not loaded! Check script tag.');
            return;
        }
        
        const markerPosition = new kakao.maps.LatLng(latitude, longitude);
        
        const marker = {
            position: markerPosition
        };

        const staticMapContainer = document.getElementById('staticMap');
        
        if (!staticMapContainer) {
            console.error('ERROR: Map container element #staticMap not found in DOM');
            return;
        }
        
        const staticMapOption = { 
            center: new kakao.maps.LatLng(latitude, longitude),
            level: 3,
            marker: marker
        };    

        const staticMap = new kakao.maps.StaticMap(staticMapContainer, staticMapOption);
        
        console.log('✅ Kakao map initialized successfully at:', latitude, longitude);
    } catch (error) {
        console.error('❌ Error initializing Kakao map:', error);
        console.error('Error stack:', error.stack);
    }
}

/**
 * Initialize Like Button with AJAX functionality
 * @param {Object} config - Configuration object containing user and board info
 */
function initializeLikeButton(config) {
    console.log('initializeLikeButton called');
    
    const likeBtn = document.getElementById('likeBtn');
    
    if (!likeBtn) {
        console.warn('⚠️ Like button (#likeBtn) not found in DOM - may not be visible for this user');
        return;
    }
    
    console.log('Like button found:', likeBtn);
    console.log('Button attributes:', {
        userId: likeBtn.getAttribute('data-user-id'),
        boardId: likeBtn.getAttribute('data-board-id'),
        liked: likeBtn.getAttribute('data-liked')
    });
    
    likeBtn.addEventListener('click', function() {
        console.log('👆 Like button clicked!');
        handleLikeButtonClick(this, config.contextPath);
    });
    
    console.log('✅ Like button event listener attached');
}

/**
 * Handle like button click event
 * @param {HTMLElement} btn - The like button element
 * @param {string} contextPath - Application context path
 */
function handleLikeButtonClick(btn, contextPath) {
    console.log('handleLikeButtonClick called');
    
    const boardId = btn.getAttribute('data-board-id');
    const userId = btn.getAttribute('data-user-id');

    console.log('Extracted from button - boardId:', boardId, 'userId:', userId);
    console.log('contextPath:', contextPath);

    // Validate user is logged in
    if (!userId || userId === 'null' || userId === '' || userId === 'undefined') {
        console.warn('⚠️ User not logged in - userId is:', userId);
        alert("로그인 후 이용 가능합니다.");
        return;
    }
    
    // Validate boardId
    if (!boardId || boardId === 'null' || boardId === '0') {
        console.error('❌ Invalid boardId:', boardId);
        alert("게시글 정보를 찾을 수 없습니다.");
        return;
    }

    console.log('✅ Validation passed - sending AJAX request...');

    // Send AJAX request
    sendLikeRequest(boardId, userId, contextPath, function(success, response) {
        console.log('AJAX callback - success:', success, 'response:', response);
        if (success) {
            updateLikeButton(btn, response);
        } else {
            alert(response.message || "좋아요 처리 중 오류가 발생했습니다.");
        }
    });
}

/**
 * Send AJAX request to toggle like status
 * @param {string} boardId - Board ID
 * @param {string} userId - User ID
 * @param {string} contextPath - Application context path
 * @param {Function} callback - Callback function(success, response)
 */
function sendLikeRequest(boardId, userId, contextPath, callback) {
    console.log('sendLikeRequest called');
    
    const url = contextPath + '/likeToggle.do';
    console.log('AJAX URL:', url);
    console.log('Sending data - boardId:', boardId, 'userId:', userId);
    
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true); 
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function() {
        console.log('XHR state changed - readyState:', xhr.readyState, 'status:', xhr.status);
        
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                console.log('✅ Server responded successfully');
                console.log('Response text:', xhr.responseText);
                
                try {
                    const response = JSON.parse(xhr.responseText);
                    console.log('Parsed response:', response);
                    callback(response.success, response);
                } catch (e) {
                    console.error("❌ JSON parsing error:", e);
                    console.error("Raw response:", xhr.responseText);
                    callback(false, { message: "응답 처리 중 오류가 발생했습니다." });
                }
            } else {
                console.error("❌ Server error - HTTP status:", xhr.status);
                console.error("Response text:", xhr.responseText);
                callback(false, { 
                    message: "서버 통신 오류가 발생했습니다. 상태 코드: " + xhr.status 
                });
            }
        }
    };
    
    xhr.onerror = function() {
        console.error('❌ Network error occurred');
        callback(false, { message: "네트워크 오류가 발생했습니다." });
    };

    const postData = 'boardId=' + encodeURIComponent(boardId) + '&userId=' + encodeURIComponent(userId);
    console.log('Sending POST data:', postData);
    xhr.send(postData);
}

/**
 * Update like button UI after successful AJAX response
 * @param {HTMLElement} btn - The like button element
 * @param {Object} response - Response from server
 */
function updateLikeButton(btn, response) {
    console.log('updateLikeButton called with response:', response);
    
    // Update like count
    const likeCountElement = document.getElementById('likeCount');
    if (likeCountElement) {
        console.log('Updating like count from', likeCountElement.innerText, 'to', response.newLikeCount);
        likeCountElement.innerText = response.newLikeCount;
    } else {
        console.warn('⚠️ Like count element (#likeCount) not found');
    }

    // Toggle button state
    const isCurrentlyLiked = btn.getAttribute('data-liked') === 'true';
    const newLikedStatus = !isCurrentlyLiked;
    
    console.log('Toggling button state from', isCurrentlyLiked, 'to', newLikedStatus);
    
    btn.setAttribute('data-liked', newLikedStatus);
    btn.classList.toggle('btn-danger', newLikedStatus);
    btn.classList.toggle('btn-outline-danger', !newLikedStatus);
    
    console.log('✅ Like button updated successfully. New status:', newLikedStatus);
}

/**
 * Utility function: Smooth scroll to element
 * @param {string} elementId - Target element ID
 */
function smoothScrollTo(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

// Export functions for potential use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initializeViewPage,
        initializeKakaoMap,
        initializeLikeButton
    };
}

console.log('View.js file parsing completed - all functions defined');
