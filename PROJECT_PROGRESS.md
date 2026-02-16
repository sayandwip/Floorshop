# Bloom & Petal — Seasonal Flower Shop Website

## Project Summary

A modern, fast, single-page seasonal flower shop website built with vanilla HTML, CSS, and JavaScript. Deployed live on GitHub Pages with Razorpay payment gateway integration.

**Live URL:** https://sayandwip.github.io/Floorshop/  
**Repository:** https://github.com/sayandwip/Floorshop

---

## Tech Stack

- **HTML5** — Semantic markup, accessible structure
- **CSS3** — Custom properties, grid/flexbox, animations, fully responsive
- **Vanilla JavaScript** — Zero dependencies for maximum speed
- **Razorpay** — Payment gateway (UPI, Cards, Net Banking, Wallets)
- **GitHub Pages** — Free hosting with auto-deploy via GitHub Actions
- **Unsplash** — Real flower-only images

---

## Features Built

### 1. Website Structure
- **Navbar** — Fixed, transparent-to-solid on scroll, mobile hamburger menu
- **Hero Section** — Gradient background, stats (12K+ customers, 200+ varieties, 4.9 rating), CTA buttons
- **Shop by Season** — Interactive season cards (Spring, Summer, Autumn, Winter) that filter products
- **Product Grid** — 12 flower products with images, prices, sale badges, and filter bar
- **Features Section** — Free delivery, sustainably grown, freshness guarantee, gift wrapping
- **Testimonials** — 3 customer reviews with star ratings
- **About Us** — Brand story with image and highlights (50+ partner farms, 100% eco packaging, 24hr farm to door)
- **Newsletter** — Email signup for 15% off first order
- **Contact Section** — Address, phone, email, hours + contact form
- **Footer** — Full footer with quick links, support, company info, social media icons

### 2. Shopping Cart
- Slide-out sidebar cart
- Add/remove items, quantity controls (+/−)
- Persistent storage via localStorage
- Real-time cart count badge on navbar
- Cart total in Indian Rupees (₹) with `en-IN` locale formatting

### 3. Checkout Flow (3 Steps)
- **Step 1: Shipping Information** — All mandatory fields with validation:
  - First Name, Last Name
  - Email Address (format validated)
  - Phone Number (10-digit Indian number validation, digits-only input)
  - Street Address
  - City, State (dropdown with all 29 Indian states)
  - PIN Code (6-digit validation, digits-only input)
  - Delivery Notes (optional)
- **Step 2: Review & Pay** — Order summary with:
  - Shipping details review
  - Item list with quantities and prices
  - Subtotal, delivery charge (free over ₹200), total
  - Razorpay secure payment badge
  - Supported methods strip (UPI, Cards, Net Banking, Wallets)
- **Step 3: Success** — Order confirmation with Order ID and Razorpay Payment ID

### 4. Razorpay Payment Gateway
- Integrated Razorpay Checkout.js SDK
- Supports: UPI (GPay, PhonePe, Paytm), Credit/Debit Cards (Visa, Mastercard, RuPay), Net Banking, Wallets
- Test mode key: `rzp_test_1DP5mmOlF5G5ag`
- Pre-fills customer name, email, phone from shipping form
- Handles payment success, failure, and cancellation
- Branded with Bloom & Petal theme color (#d4577b)

### 5. UI/UX Features
- Smooth scroll animations (Intersection Observer)
- Product card hover effects (image zoom, card lift)
- Toast notifications for all actions
- Season filtering (click season card or filter button)
- Responsive design (mobile, tablet, desktop)
- Custom scrollbar styling
- Floating decorative gradient elements on hero
- CSS transitions and cubic-bezier easing throughout

### 6. Deployment
- GitHub repository: `sayandwip/Floorshop` (public)
- GitHub Pages with custom Actions workflow
- Auto-deploys on every push to `main` branch
- HTTPS enabled

---

## Shop Details

| Field | Value |
|-------|-------|
| **Shop Name** | Bloom & Petal |
| **Address** | Sobha Dream Acres Phase 2, Balagere, Varthur 560087 |
| **Phone** | 080-26026787 |
| **Email** | sayandwip@bloomandpetal.com |
| **Hours** | Mon-Sat: 8am - 7pm, Sun: 9am - 5pm |
| **Free Delivery** | Orders over ₹200 |

---

## Product Catalog (12 Items)

| # | Name | Season | Price | Sale Price | Image |
|---|------|--------|-------|------------|-------|
| 1 | Jasmine Malli Bunch | Spring | ₹289 | — | White jasmine flowers |
| 2 | Pink Lotus Blooms | Spring | ₹239 | — | Pink lotus flower |
| 3 | Crossandra Orange | Spring | ₹199 | ~~₹269~~ | Orange tropical flower |
| 4 | Sunflower Radiance | Summer | ₹329 | — | Golden sunflower |
| 5 | Red Rose Bouquet | Summer | ₹189 | — | Red roses close-up |
| 6 | Pink Rose Garden Mix | Summer | ₹369 | ~~₹449~~ | Pink/peach roses |
| 7 | Dahlia Collection | Autumn | ₹299 | — | Colourful dahlia bloom |
| 8 | Golden Marigold Bunch | Autumn | ₹159 | — | Orange marigold flowers |
| 9 | Chrysanthemum Elegance | Autumn | ₹269 | ~~₹329~~ | Chrysanthemum close-up |
| 10 | Red Hibiscus Bunch | Winter | ₹249 | — | Red hibiscus flower |
| 11 | White Lily Bouquet | Winter | ₹319 | — | White lily flowers |
| 12 | Tuberose Rajnigandha | Winter | ₹219 | ~~₹289~~ | White tuberose flowers |

---

## File Structure

```
Floorshop/
├── index.html          # Main HTML (navbar, hero, sections, checkout modal, cart sidebar)
├── style.css           # Complete CSS (variables, layout, animations, responsive, checkout modal)
├── app.js              # All JavaScript (products, cart, filtering, checkout, Razorpay, validation)
├── .github/
│   └── workflows/
│       └── deploy.yml  # GitHub Actions workflow for GitHub Pages deployment
└── PROJECT_PROGRESS.md # This file
```

---

## Change Log

### Session 1 — Initial Build
1. **Created website** — Full HTML/CSS/JS seasonal flower shop with hero, seasons, shop, features, testimonials, about, newsletter, contact, footer
2. **Currency to Rupees** — Changed all prices from USD ($) to INR (₹) with realistic Indian pricing and `en-IN` locale formatting
3. **Price reduction** — Reduced all prices by 10x (e.g., ₹2,899 → ₹289)
4. **Shop details updated** — Address: Sobha Dream Acres Phase 2, Balagere, Varthur 560087; Phone: 080-26026787
5. **Email updated** — Changed to sayandwip@bloomandpetal.com
6. **Checkout system** — Built complete multi-step checkout with mandatory shipping fields, payment options, order review, and success confirmation
7. **Deployed to internet** — GitHub repo created, GitHub Pages enabled with Actions workflow, live at https://sayandwip.github.io/Floorshop/
8. **Razorpay integration** — Replaced manual payment fields with Razorpay Checkout SDK supporting UPI, Cards, Net Banking, Wallets
9. **Checkout bug fix** — Fixed checkout not opening: switched to event delegation, added timing delay between cart close and modal open, localStorage cleanup, safe element selection
10. **Real flower images** — Replaced all product images with verified real flower-only photos from Unsplash (jasmine, lotus, crossandra, sunflower, rose, dahlia, marigold, chrysanthemum, hibiscus, lily, tuberose)
11. **Image verification** — Double-checked and replaced problematic images (Pink Lotus, Pink Rose Garden Mix) that showed non-flower content; all 12 products + about section now show flowers only

---

## How to Update the Website

```bash
# Make changes to files locally, then:
cd /Users/sayandwips/Desktop/Cursor/Floorshop
git add -A
git commit -m "your change description"
git push
# Site auto-deploys in ~30 seconds
```

---

## Going Live with Real Payments

To accept real payments:

1. Sign up at [razorpay.com](https://razorpay.com)
2. Complete KYC verification
3. Get your **Live API Key** from Dashboard → Settings → API Keys
4. In `app.js`, replace the test key:
   ```js
   const RAZORPAY_KEY = "rzp_live_YOUR_LIVE_KEY_HERE";
   ```
5. Commit and push — payments will be real

### Test Mode Card for Testing
- Card: `4111 1111 1111 1111`
- Expiry: Any future date
- CVV: Any 3 digits
