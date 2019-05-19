/*unfocus element*/

(function() {
  'use strict';
  document.activeElement.blur();
  window.getSelection().empty();
})();
