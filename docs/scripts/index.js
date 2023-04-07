// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.17.1/firebase-app.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDRZfWpJzdw7hwAlyigiyJOfxzMSHsLuks",
  authDomain: "sangeet-b4b33.firebaseapp.com",
  projectId: "sangeet-b4b33",
  storageBucket: "sangeet-b4b33.appspot.com",
  messagingSenderId: "938273869324",
  appId: "1:938273869324:web:06ff1eec1a73ada317a829"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

(function (c, l, a, r, i, t, y) {
  c[a] = c[a] || function () {
    (c[a].q = c[a].q || []).push(arguments)
  };
  t = l.createElement(r);
  t.async = 1;
  t.src = "https://www.clarity.ms/tag/" + i;
  y = l.getElementsByTagName(r)[0];
  y.parentNode.insertBefore(t, y);
})
  (window, document, "clarity", "script", "fpik2gr3m6");


const repo = 'sumanishere/Sangeet';
const endpoint = `https://api.github.com/repos/${repo}`;
let downloadsCount = 0;

// Smooth scroll for links with hashes
$('a[href*="#"]')
  // Remove links that don't actually link to anything
  .not('[href="#"]')
  .not('[href="#0"]')
  .click(function (event) {
    // On-page links
    if (
      location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') &&
      location.hostname == this.hostname
    ) {
      // Figure out element to scroll to
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      // Does a scroll target exist?
      if (target.length) {
        // Only prevent default if animation is actually gonna happen
        event.preventDefault();
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 1000, function () {
          // Callback after animation
          // Must change focus!
          var $target = $(target);
          $target.focus();
          if ($target.is(":focus")) { // Checking if the target was focused
            return false;
          } else {
            $target.attr('tabindex', '-1'); // Adding tabindex for elements not focusable
            $target.focus(); // Set focus again
          };
        });
      }
    }
  });

class TxtType {
  constructor(el, toRotate, period) {
    this.toRotate = toRotate;
    this.el = el;
    this.loopNum = 0;
    this.period = parseInt(period, 10) || 1500;
    this.txt = '';
    this.tick();
    this.isDeleting = false;
  }
  tick() {
    let i = this.loopNum % this.toRotate.length;
    let fullTxt = this.toRotate[i];

    if (this.isDeleting) {
      this.txt = fullTxt.substring(0, this.txt.length - 1);
    } else {
      this.txt = fullTxt.substring(0, this.txt.length + 1);
    }

    this.el.innerHTML = this.txt;

    let that = this;
    let delta = 200 - Math.random() * 100;

    if (this.isDeleting) { delta /= 2; }

    if (!this.isDeleting && this.txt === fullTxt) {
      delta = this.period;
      this.isDeleting = true;
    } else if (this.isDeleting && this.txt === '') {
      this.isDeleting = false;
      this.loopNum++;
      delta = 500;
    }

    setTimeout(function () {
      that.tick();
    }, delta);
  }
}

let scroll = window.requestAnimationFrame || function (callback) { window.setTimeout(callback, 1000 / 60) };
let elementsToShow = document.querySelectorAll('.show-on-scroll');

function loop() {
  elementsToShow.forEach(function (element) {
    if (isElementInViewport(element)) {
      element.classList.add('is-visible');
      if (element.classList.contains('odometer')) {
        document.getElementById('downloads-count').innerHTML = downloadsCount;
      }
    } else {
      element.classList.remove('is-visible');
    }
  });
  scroll(loop);
}

function updateDownloadCount() {
  fetch(endpoint)
    .then(response => response.json())
    .then(data => {
      if (Array.isArray(data)) {
        let downloadCount = 0;
        data.forEach(release => {
          downloadCount += release.assets.reduce((count, asset) => count + asset.download_count, 0);
        });
        downloadsCount = downloadCount;
      } else {
        console.log(data);
      }
    })
    .catch(error => console.error(error));
}

window.onload = function () {
  try {
    let dt = new Date().getFullYear();
    document.getElementById('current-year').innerHTML = dt;
  } catch (error) {
    console.error(error);
  }
  updateDownloadCount();
  const interval = setInterval(function () {
    updateDownloadCount();
    if (document.getElementById('downloads-count').classList.contains("is-visible")) {
      document.getElementById('downloads-count').innerHTML = downloadsCount;
    }
  }, 5000);
  let elements = document.getElementsByClassName('typewrite');
  for (let i = 0; i < elements.length; i++) {
    let toRotate = elements[i].getAttribute('data-type');
    if (toRotate) {
      new TxtType(elements[i], JSON.parse(toRotate), 1500);
    }
  }
  loop();
};

function isElementInViewport(el) {
  if (typeof jQuery === "function" && el instanceof jQuery) {
    el = el[0];
  }
  var rect = el.getBoundingClientRect();
  return (
    (rect.top <= 0 &&
      rect.bottom >= 0) ||
    (rect.bottom >= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.top <= (window.innerHeight || document.documentElement.clientHeight)) ||
    (rect.top >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight))
  );
}

// const floatingCard = document.querySelector('.floating-card');

// document.addEventListener('scroll', function() {
//   const scrollPosition = window.scrollY;

//   if (floatingCard) {
//     if (scrollPosition > 3000) {
//       floatingCard.classList.add('floating-card-top');
//     } else {
//       floatingCard.classList.remove('floating-card-top');
//     }
//   }
// });

jQuery(document).ready(function () {

  function detect_active() {
    // get active
    var get_active = $("#dp-slider .dp_item:first-child").data("class");
    $("#dp-dots li").removeClass("active");
    $("#dp-dots li[data-class=" + get_active + "]").addClass("active");
  }
  $("#dp-next").click(function () {
    $("#dp-slider .dp_item:first-child").hide().appendTo("#dp-slider").fadeIn();
    $.each($('.dp_item'), function (index, dp_item) {
      $(dp_item).attr('data-position', index + 1);
    });
    detect_active();
  });

  $("#dp-prev").click(function () {
    $("#dp-slider .dp_item:last-child").hide().prependTo("#dp-slider").fadeIn();
    $.each($('.dp_item'), function (index, dp_item) {
      $(dp_item).attr('data-position', index + 1);
    });
    detect_active();
  });

  $("#dp-dots li").click(function () {
    $("#dp-dots li").removeClass("active");
    $(this).addClass("active");
    let get_slide = $(this).attr('data-class');
    console.log(get_slide);
    $("#dp-slider .dp_item[data-class=" + get_slide + "]").hide().prependTo("#dp-slider").fadeIn();
    $.each($('.dp_item'), function (index, dp_item) {
      $(dp_item).attr('data-position', index + 1);
    });
  });


  $("body").on("click", "#dp-slider .dp_item:not(:first-child)", function () {
    var get_slide = $(this).attr('data-class');
    console.log(get_slide);
    $("#dp-slider .dp_item[data-class=" + get_slide + "]").hide().prependTo("#dp-slider").fadeIn();
    $.each($('.dp_item'), function (index, dp_item) {
      $(dp_item).attr('data-position', index + 1);
    });
    detect_active();
  });
});

function closeBanner() {
  document.getElementById('banner').style.display = 'none';
}