# QB Networks Web Development Team

A modern, mobile-first promotional website built with Bootstrap layout utilities and plain JavaScript (no frontend framework).

## Project Summary

QB Networks Web Development Team is a single-page website focused on a bold yellow, purple, gray, and white visual identity. It is designed to be lightweight, responsive, and easy to maintain.

This project intentionally avoids frontend frameworks and uses:
- HTML5 for structure
- CSS3 for custom styling and visual effects
- Bootstrap 5 (CDN) for responsive grid/utilities
- Vanilla JavaScript for interactions and animations

## Core Features

- Responsive layout for mobile, tablet, and desktop
- Sticky header with scroll-based visual state
- Mobile menu toggle for small screens
- Section reveal animations with IntersectionObserver
- Animated statistics counters
- Client-side contact form validation and feedback
- LibreJS-compatible JavaScript license notice pattern
- AGPLv3-or-later licensing notice added to source files

## Tech Stack

- HTML: index.html
- CSS: styles.css
- JavaScript: script.js
- UI Utilities: Bootstrap 5.3.3 (CDN)

## Project Structure

- index.html: Main page markup, sections, and license table for LibreJS
- styles.css: Color system, layout refinements, responsive rules, and component styling
- script.js: Menu behavior, scroll/reveal effects, counter animation, and form logic
- LICENSE: Full GNU Affero General Public License v3 text

## Color and Design Direction

The interface is built around:
- Yellow for emphasis and calls to action
- Purple for brand depth and hierarchy
- Gray for text balance and neutral support
- White for contrast and readability

Visual style choices include soft gradients, blurred background shapes, elevated cards, and rounded controls for a modern landing-page look.

## Accessibility and UX Notes

- Semantic sections and labels are used in forms and navigation
- Status text uses aria-live for form feedback
- Motion-sensitive users are respected via prefers-reduced-motion CSS rules
- The layout remains readable and touch-friendly on small devices

## Local Development

You can run this project with any static HTTP server.

Example with Python:

```bash
cd /home/hwpplayer1/Public/demo/webdemos/zerodemo
python -m http.server 5500
```

Then open:

- http://localhost:5500
- http://127.0.0.1:5500

## Production Notes

- Bootstrap is currently loaded from CDN. For stricter deployment control, pin and self-host static dependencies.
- The project is static and does not require a backend to render.
- The contact form currently provides client-side feedback only (no server submission).

## License

QB Networks Web Development Team - modern and mobile-friendly promotional website.
Copyright (C) 2026 QB Networks

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

## Maintenance Checklist

- Keep license headers present in all source files
- Keep LICENSE file unchanged unless legally reviewed
- Re-test responsive behavior after UI updates
- Re-check JS behavior if section IDs or class names change
