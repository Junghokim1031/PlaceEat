/**
 * List.js - PLACE EAT Board List Page JavaScript
 * Handles: Search form management, location/hashtag tag filtering with hidden inputs
 */

console.log('List.js loaded');

/**
 * Initialize the list page with provided configuration
 * @param {Object} config - Configuration object from JSP containing preselect data
 */
function initializeListPage(config) {
    console.log('Initializing list page with config:', config);
    
    const form = document.getElementById('searchForm');
    const host = document.getElementById('hiddenHost');
    
    if (!form || !host) {
        console.error('Required elements not found (searchForm or hiddenHost)');
        return;
    }
    
    // Initialize tag filtering system
    initializeHashtagFiltering(host);
    initializeLocationFiltering(host);
    
    // Preselect tags based on URL parameters
    preselectTagsFromConfig(config, host);
}

/**
 * Initialize hashtag multi-select filtering
 * @param {HTMLElement} host - Container for hidden inputs
 */
function initializeHashtagFiltering(host) {
    const hashtagRoot = document.getElementById('hashtagTags');
    
    if (!hashtagRoot) {
        console.warn('Hashtag container not found');
        return;
    }
    
    hashtagRoot.addEventListener('click', function (e) {
        const btn = e.target.closest('.hashtagTag');
        if (!btn) return;

        const name = btn.getAttribute('name');
        const value = getButtonValue(btn);

        btn.classList.toggle('active');

        if (btn.classList.contains('active')) {
            addHidden(host, name, value);
        } else {
            removeHidden(host, name, value);
        }
    });
    
    console.log('Hashtag filtering initialized');
}

/**
 * Initialize location single-select filtering
 * @param {HTMLElement} host - Container for hidden inputs
 */
function initializeLocationFiltering(host) {
    const locationRoot = document.getElementById('locationTags');
    
    if (!locationRoot) {
        console.warn('Location container not found');
        return;
    }
    
    locationRoot.addEventListener('click', function (e) {
        const btn = e.target.closest('.locationTag');
        if (!btn) return;

        const name = btn.getAttribute('name');
        const value = getButtonValue(btn);

        // Remove ALL previous location selections
        locationRoot.querySelectorAll('.locationTag.active').forEach(function (el) {
            el.classList.remove('active');
            const prevValue = getButtonValue(el);
            if (prevValue !== '') {
                removeHidden(host, name, prevValue);
            }
        });

        // Set new selection
        btn.classList.add('active');
        
        // Only add hidden input if value is NOT empty (not "전체")
        if (value !== '') {
            addHidden(host, name, value);
        }
    });
    
    console.log('Location filtering initialized');
}

/**
 * Preselect tags based on URL parameters
 * @param {Object} config - Configuration with locationName and hashtags array
 * @param {HTMLElement} host - Container for hidden inputs
 */
function preselectTagsFromConfig(config, host) {
    // Preselect location
    if (config.locationName && config.locationName !== '') {
        const buttons = document.querySelectorAll('.locationTag');
        buttons.forEach(function (btn) {
            const btnValue = getButtonValue(btn);
            if (btnValue === config.locationName) {
                btn.classList.add('active');
                addHidden(host, 'locationName', config.locationName);
            }
        });
        console.log('Preselected location:', config.locationName);
    }
    
    // Preselect hashtags
    if (config.hashtags && config.hashtags.length > 0) {
        const buttons = document.querySelectorAll('.hashtagTag');
        buttons.forEach(function (btn) {
            const val = getButtonValue(btn);
            if (config.hashtags.indexOf(val) !== -1) {
                btn.classList.add('active');
                addHidden(host, 'hashtagName', val);
            }
        });
        console.log('Preselected hashtags:', config.hashtags);
    }
}

/**
 * Add a hidden input to the form
 * @param {HTMLElement} host - Container for hidden inputs
 * @param {string} name - Input name attribute
 * @param {string} value - Input value
 */
function addHidden(host, name, value) {
    const key = name + '::' + value;
    let input = host.querySelector('input[type="hidden"][data-key="' + CSS.escape(key) + '"]');
    
    if (!input) {
        input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        input.dataset.key = key;
        host.appendChild(input);
        console.log('Added hidden input:', name, '=', value);
    }
}

/**
 * Remove a hidden input from the form
 * @param {HTMLElement} host - Container for hidden inputs
 * @param {string} name - Input name attribute
 * @param {string} value - Input value
 */
function removeHidden(host, name, value) {
    const key = name + '::' + value;
    const input = host.querySelector('input[type="hidden"][data-key="' + CSS.escape(key) + '"]');
    if (input) {
        input.remove();
        console.log('Removed hidden input:', name, '=', value);
    }
}

/**
 * Get the value attribute from a button (does NOT fallback to text content)
 * @param {HTMLElement} btn - Button element
 * @returns {string} Button value or empty string
 */
function getButtonValue(btn) {
    const val = btn.getAttribute('value');
    return val !== null ? val : '';
}

// Export functions for potential use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initializeListPage,
        initializeHashtagFiltering,
        initializeLocationFiltering,
        addHidden,
        removeHidden,
        getButtonValue
    };
}
