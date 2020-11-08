(() => {
  // Only for youtube.
  let host = window.location.host;
  if (!host.endsWith("youtube.com")) {
    return;
  }

  // Auxiliary functions.
  function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  let getVideo = () => document.querySelectorAll("video")[0];

  // Close overlay ad.
  let overlayAdFound = false;
  let closeOverlayAd = () => {
    const overlayAdClose = document.querySelector(
      ".ytp-ad-overlay-close-container .ytp-ad-overlay-close-button"
    );

    if (overlayAdClose && !overlayAdFound) {
      setTimeout(() => {
        overlayAdClose.click();
        overlayAdFound = false;
      }, 5000);
      overlayAdFound = true;
    }
  };
  setInterval(closeOverlayAd, 500);

  // Save playback rate.
  let savedPlaybackRate = null;
  let savePlaybackRate = () => {
    const addMessageContainer = document.querySelector(
      ".ytp-ad-message-container .ytp-ad-message-text"
    );
    if (addMessageContainer) {
      savedPlaybackRate = getVideo().playbackRate;
    }
  };
  setInterval(savePlaybackRate, 500);

  // Close video ad.
  let closeVideoAd = async () => {
    const videoAdClose = () =>
      document.querySelector(
        ".ytp-ad-skip-button-container .ytp-ad-skip-button"
      );

    if (videoAdClose()) {
      // Unblock close button.
      getVideo().currentTime += 7;

      // Close ad.
      await sleep(40);
      if (videoAdClose()) {
        videoAdClose().click();
      }

      // Restore playback rate.
      await sleep(40);
      if (savedPlaybackRate) {
        getVideo().playbackRate = savedPlaybackRate;
        savedPlaybackRate = null;
      }
    }
  };
  setInterval(closeVideoAd, 500);
})();
