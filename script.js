/* @licstart  The following is the entire license notice for the JavaScript code in this page.
 *
 *  QB Networks - modern and mobile-friendly promotional website.
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

  function onScrollHeader() {
    if (window.scrollY > 12) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }
  }

  function toggleMenu() {
    if (!menuButton || !menu) {
      return;
    }
    var expanded = menuButton.getAttribute("aria-expanded") === "true";
    menuButton.setAttribute("aria-expanded", String(!expanded));
    menu.classList.toggle("open", !expanded);
  }

  function closeMenuOnOutsideClick(event) {
    if (!menuButton || !menu) {
      return;
    }
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

  window.addEventListener("scroll", onScrollHeader);
  if (menuButton) {
    menuButton.addEventListener("click", toggleMenu);
  }
  document.addEventListener("click", closeMenuOnOutsideClick);

  onScrollHeader();
  setupRevealAnimation();
})();

/* @licend  The above is the entire license notice for the JavaScript code in this page. */
