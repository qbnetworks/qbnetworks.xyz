/* @licstart  The following is the entire license notice for the JavaScript code in this page.
 *
 *  QB Networks Web Development Team - modern and mobile-friendly promotional website.
 *  Copyright (C) 2026 QB Networks
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as published
 *  by the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

(function () {
  "use strict";

  var header = document.querySelector(".site-header");
  var menuButton = document.getElementById("menuButton");
  var menu = document.getElementById("mainMenu");
  var revealNodes = document.querySelectorAll(".reveal");
  var statNodes = document.querySelectorAll(".stat-number");
  var form = document.getElementById("contactForm");
  var formResult = document.getElementById("formResult");

  function onScrollHeader() {
    if (window.scrollY > 12) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }
  }

  function toggleMenu() {
    var expanded = menuButton.getAttribute("aria-expanded") === "true";
    menuButton.setAttribute("aria-expanded", String(!expanded));
    menu.classList.toggle("open", !expanded);
  }

  function closeMenuOnOutsideClick(event) {
    var clickedInside = menu.contains(event.target) || menuButton.contains(event.target);
    if (!clickedInside) {
      menu.classList.remove("open");
      menuButton.setAttribute("aria-expanded", "false");
    }
  }

  function setupRevealAnimation() {
    if (!("IntersectionObserver" in window)) {
      revealNodes.forEach(function (node) {
        node.classList.add("visible");
      });
      return;
    }

    var observer = new IntersectionObserver(
      function (entries, obs) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) {
            return;
          }
          entry.target.classList.add("visible");
          obs.unobserve(entry.target);
        });
      },
      { threshold: 0.15 }
    );

    revealNodes.forEach(function (node) {
      observer.observe(node);
    });
  }

  function animateStat(node) {
    var target = Number(node.getAttribute("data-target"));
    var duration = 1000;
    var startTime = null;

    function step(timestamp) {
      if (!startTime) {
        startTime = timestamp;
      }
      var progress = Math.min((timestamp - startTime) / duration, 1);
      var value = Math.round(target * progress);
      node.textContent = String(value);
      if (progress < 1) {
        window.requestAnimationFrame(step);
      }
    }

    window.requestAnimationFrame(step);
  }

  function setupStatsAnimation() {
    if (!("IntersectionObserver" in window)) {
      statNodes.forEach(animateStat);
      return;
    }

    var done = false;
    var statsSection = document.getElementById("stats");
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (done || !entry.isIntersecting) {
            return;
          }
          done = true;
          statNodes.forEach(animateStat);
          observer.disconnect();
        });
      },
      { threshold: 0.45 }
    );

    if (statsSection) {
      observer.observe(statsSection);
    }
  }

  function handleFormSubmit(event) {
    event.preventDefault();

    if (!form.checkValidity()) {
      formResult.textContent = "Please complete all fields correctly.";
      return;
    }

    formResult.textContent = "Message received. We will get back to you shortly.";
    form.reset();
  }

  window.addEventListener("scroll", onScrollHeader);
  menuButton.addEventListener("click", toggleMenu);
  document.addEventListener("click", closeMenuOnOutsideClick);
  form.addEventListener("submit", handleFormSubmit);

  onScrollHeader();
  setupRevealAnimation();
  setupStatsAnimation();
})();

/* @licend  The above is the entire license notice for the JavaScript code in this page. */
