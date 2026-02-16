/* ============================================
   BLOOM & PETAL — Seasonal Flower Shop
   Main Application JavaScript
   ============================================ */

// ===== PRODUCT DATA =====
const products = [
  {
    id: 1,
    name: "Spring Tulip Bouquet",
    desc: "Vibrant mix of pink, yellow & white tulips",
    price: 289,
    originalPrice: null,
    season: "spring",
    image: "https://images.unsplash.com/photo-1524386416438-98b9b2d4b433?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 2,
    name: "Cherry Blossom Branch",
    desc: "Elegant pink cherry blossom stems",
    price: 239,
    originalPrice: null,
    season: "spring",
    image: "https://images.unsplash.com/photo-1522748906645-95d8adfd52c7?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 3,
    name: "Daffodil Sunshine",
    desc: "Bright golden daffodils in a rustic wrap",
    price: 199,
    originalPrice: 269,
    season: "spring",
    image: "https://images.unsplash.com/photo-1457089328109-e5d9bd499191?w=400&h=500&fit=crop",
    badge: "sale"
  },
  {
    id: 4,
    name: "Sunflower Radiance",
    desc: "Bold sunflowers that light up any room",
    price: 329,
    originalPrice: null,
    season: "summer",
    image: "https://images.unsplash.com/photo-1551731409-43eb3e517a1a?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 5,
    name: "Lavender Dreams",
    desc: "Fragrant dried lavender bundle",
    price: 189,
    originalPrice: null,
    season: "summer",
    image: "https://images.unsplash.com/photo-1468327768560-75b778cbb551?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 6,
    name: "Rose Garden Mix",
    desc: "Classic red, pink & peach roses",
    price: 369,
    originalPrice: 449,
    season: "summer",
    image: "https://images.unsplash.com/photo-1490750967868-88aa4f44baee?w=400&h=500&fit=crop",
    badge: "sale"
  },
  {
    id: 7,
    name: "Autumn Dahlia Collection",
    desc: "Rich burgundy & orange dahlias",
    price: 299,
    originalPrice: null,
    season: "autumn",
    image: "https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 8,
    name: "Golden Marigold Bunch",
    desc: "Warm golden marigolds for the season",
    price: 159,
    originalPrice: null,
    season: "autumn",
    image: "https://images.unsplash.com/photo-1603217040830-34473db521e8?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 9,
    name: "Chrysanthemum Elegance",
    desc: "Lush mums in autumn tones",
    price: 269,
    originalPrice: 329,
    season: "autumn",
    image: "https://images.unsplash.com/photo-1510552776732-03d9729e0a46?w=400&h=500&fit=crop",
    badge: "sale"
  },
  {
    id: 10,
    name: "Poinsettia Classic",
    desc: "Festive red poinsettia in a gold pot",
    price: 249,
    originalPrice: null,
    season: "winter",
    image: "https://images.unsplash.com/photo-1545696563-9f5e9e5e5e5e?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 11,
    name: "White Amaryllis",
    desc: "Stunning white amaryllis in bloom",
    price: 319,
    originalPrice: null,
    season: "winter",
    image: "https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400&h=500&fit=crop",
    badge: null
  },
  {
    id: 12,
    name: "Winter Hellebore Mix",
    desc: "Delicate hellebores in soft pastels",
    price: 219,
    originalPrice: 289,
    season: "winter",
    image: "https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400&h=500&fit=crop",
    badge: "sale"
  }
];

// ===== STATE =====
let cart = JSON.parse(localStorage.getItem("bloom_cart")) || [];
let currentFilter = "all";

// ===== DOM ELEMENTS =====
const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

const navbar = $("#navbar");
const hamburger = $("#hamburger");
const navLinks = $("#navLinks");
const productGrid = $("#productGrid");
const cartBtn = $("#cartBtn");
const cartSidebar = $("#cartSidebar");
const cartOverlay = $("#cartOverlay");
const cartClose = $("#cartClose");
const cartItems = $("#cartItems");
const cartFooter = $("#cartFooter");
const cartCount = $("#cartCount");
const cartTotal = $("#cartTotal");
const cartShopBtn = $("#cartShopBtn");
const toast = $("#toast");

// ===== INIT =====
document.addEventListener("DOMContentLoaded", () => {
  renderProducts();
  updateCart();
  setupEventListeners();
  setupScrollAnimations();
});

// ===== RENDER PRODUCTS =====
function renderProducts(filter = "all") {
  const filtered = filter === "all" ? products : products.filter(p => p.season === filter);

  productGrid.innerHTML = filtered.map((p, i) => `
    <div class="product-card" style="animation-delay: ${i * 0.08}s" data-season="${p.season}">
      <div class="product-image">
        <img src="${p.image}" alt="${p.name}" loading="lazy" />
        <span class="product-badge badge-${p.season}">${capitalize(p.season)}</span>
        ${p.badge === "sale" ? '<span class="product-badge badge-sale">Sale</span>' : ''}
      </div>
      <div class="product-info">
        <h3>${p.name}</h3>
        <p class="product-desc">${p.desc}</p>
        <div class="product-footer">
          <div class="product-price">
            ₹${p.price}
            ${p.originalPrice ? `<span class="original">₹${p.originalPrice}</span>` : ''}
          </div>
          <button class="add-to-cart" onclick="addToCart(${p.id})" aria-label="Add ${p.name} to cart">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          </button>
        </div>
      </div>
    </div>
  `).join("");
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

// ===== CART FUNCTIONS =====
function addToCart(productId) {
  const product = products.find(p => p.id === productId);
  if (!product) return;

  const existing = cart.find(item => item.id === productId);
  if (existing) {
    existing.qty += 1;
  } else {
    cart.push({ ...product, qty: 1 });
  }

  saveCart();
  updateCart();
  showToast(`${product.name} added to cart`);
}

function removeFromCart(productId) {
  cart = cart.filter(item => item.id !== productId);
  saveCart();
  updateCart();
}

function updateQty(productId, delta) {
  const item = cart.find(i => i.id === productId);
  if (!item) return;

  item.qty += delta;
  if (item.qty <= 0) {
    removeFromCart(productId);
    return;
  }

  saveCart();
  updateCart();
}

function saveCart() {
  localStorage.setItem("bloom_cart", JSON.stringify(cart));
}

function updateCart() {
  const totalItems = cart.reduce((sum, item) => sum + item.qty, 0);
  const totalPrice = cart.reduce((sum, item) => sum + item.price * item.qty, 0);

  cartCount.textContent = totalItems;
  cartCount.classList.toggle("show", totalItems > 0);
  cartTotal.textContent = `₹${totalPrice.toLocaleString("en-IN")}`;

  if (cart.length === 0) {
    cartItems.innerHTML = `
      <div class="cart-empty">
        <span>🌸</span>
        <p>Your cart is empty</p>
        <a href="#shop" class="btn btn-primary" onclick="closeCart()">Start Shopping</a>
      </div>
    `;
    cartFooter.style.display = "none";
  } else {
    cartItems.innerHTML = cart.map(item => `
      <div class="cart-item">
        <div class="cart-item-image">
          <img src="${item.image}" alt="${item.name}" />
        </div>
        <div class="cart-item-info">
          <h4>${item.name}</h4>
          <span class="cart-item-price">₹${(item.price * item.qty).toLocaleString("en-IN")}</span>
          <div class="cart-item-actions">
            <button class="qty-btn" onclick="updateQty(${item.id}, -1)">−</button>
            <span class="cart-item-qty">${item.qty}</span>
            <button class="qty-btn" onclick="updateQty(${item.id}, 1)">+</button>
            <button class="remove-item" onclick="removeFromCart(${item.id})">Remove</button>
          </div>
        </div>
      </div>
    `).join("");
    cartFooter.style.display = "block";
  }
}

// ===== CART SIDEBAR TOGGLE =====
function openCart() {
  cartSidebar.classList.add("open");
  cartOverlay.classList.add("open");
  document.body.style.overflow = "hidden";
}

function closeCart() {
  cartSidebar.classList.remove("open");
  cartOverlay.classList.remove("open");
  document.body.style.overflow = "";
}

// ===== TOAST =====
function showToast(message) {
  toast.textContent = message;
  toast.classList.add("show");
  setTimeout(() => toast.classList.remove("show"), 2500);
}

// ===== EVENT LISTENERS =====
function setupEventListeners() {
  // Navbar scroll
  window.addEventListener("scroll", () => {
    navbar.classList.toggle("scrolled", window.scrollY > 50);
  });

  // Hamburger menu
  hamburger.addEventListener("click", () => {
    hamburger.classList.toggle("open");
    navLinks.classList.toggle("open");
  });

  // Close mobile menu on link click
  navLinks.querySelectorAll("a").forEach(link => {
    link.addEventListener("click", () => {
      hamburger.classList.remove("open");
      navLinks.classList.remove("open");
    });
  });

  // Cart
  cartBtn.addEventListener("click", openCart);
  cartClose.addEventListener("click", closeCart);
  cartOverlay.addEventListener("click", closeCart);

  // Filter buttons
  $$(".filter-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      $$(".filter-btn").forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
      currentFilter = btn.dataset.filter;
      renderProducts(currentFilter);
    });
  });

  // Season cards
  $$(".season-card").forEach(card => {
    card.addEventListener("click", () => {
      $$(".season-card").forEach(c => c.classList.remove("active"));
      card.classList.add("active");

      const season = card.dataset.season;
      currentFilter = season;

      $$(".filter-btn").forEach(b => {
        b.classList.toggle("active", b.dataset.filter === season);
      });

      renderProducts(season);

      document.getElementById("shop").scrollIntoView({ behavior: "smooth" });
    });
  });

  // Newsletter form
  $("#newsletterForm").addEventListener("submit", (e) => {
    e.preventDefault();
    showToast("Thanks for subscribing! Check your email for 15% off.");
    e.target.reset();
  });

  // Contact form
  $("#contactForm").addEventListener("submit", (e) => {
    e.preventDefault();
    showToast("Message sent! We'll get back to you soon.");
    e.target.reset();
  });

  // Checkout button — open modal
  $("#checkoutBtn").addEventListener("click", () => {
    openCheckout();
  });

  // Checkout modal setup
  setupCheckout();
}

// ===== SCROLL REVEAL ANIMATIONS =====
function setupScrollAnimations() {
  const revealElements = [
    ...$$(".season-card"),
    ...$$(".feature-card"),
    ...$$(".testimonial-card"),
    $(".about-grid"),
    $(".newsletter-inner"),
    $(".contact-grid")
  ].filter(Boolean);

  revealElements.forEach(el => el.classList.add("reveal"));

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
      }
    });
  }, { threshold: 0.1, rootMargin: "0px 0px -50px 0px" });

  revealElements.forEach(el => observer.observe(el));
}

// ===== RAZORPAY CONFIG =====
// Using Razorpay TEST mode key — replace with your live key for production
const RAZORPAY_KEY = "rzp_test_1DP5mmOlF5G5ag";

// ===== CHECKOUT SYSTEM =====
let currentStep = 1;

function openCheckout() {
  if (cart.length === 0) {
    showToast("Your cart is empty!");
    return;
  }
  closeCart();
  currentStep = 1;
  updateCheckoutSteps();
  $("#checkoutOverlay").classList.add("open");
  $("#checkoutModal").classList.add("open");
  document.body.style.overflow = "hidden";
}

function closeCheckout() {
  $("#checkoutOverlay").classList.remove("open");
  $("#checkoutModal").classList.remove("open");
  document.body.style.overflow = "";
}

function updateCheckoutSteps() {
  const steps = $$(".checkout-steps .step");
  const lines = $$(".checkout-steps .step-line");
  const panels = $$(".checkout-step-panel");

  steps.forEach((s, i) => {
    const stepNum = i + 1;
    s.classList.remove("active", "completed");
    if (stepNum < currentStep) s.classList.add("completed");
    else if (stepNum === currentStep) s.classList.add("active");
  });

  lines.forEach((l, i) => {
    l.classList.remove("active", "completed");
    if (i + 1 < currentStep) l.classList.add("completed");
    else if (i + 1 === currentStep) l.classList.add("active");
  });

  panels.forEach(p => p.classList.remove("active"));
  if (currentStep === 1) $("#stepShipping").classList.add("active");
  else if (currentStep === 2) $("#stepReview").classList.add("active");
  else if (currentStep === 3) {
    $(".checkout-steps").style.display = "none";
    $("#stepSuccess").classList.add("active");
  }

  if (currentStep < 3) {
    $(".checkout-steps").style.display = "flex";
  }
}

function getOrderTotals() {
  const subtotal = cart.reduce((sum, item) => sum + item.price * item.qty, 0);
  const delivery = subtotal >= 200 ? 0 : 49;
  const total = subtotal + delivery;
  return { subtotal, delivery, total };
}

function populateOrderSummary() {
  const { subtotal, delivery, total } = getOrderTotals();

  const itemsHtml = cart.map(item => `
    <div class="order-item-row">
      <span>${item.name} x${item.qty}</span>
      <span>₹${(item.price * item.qty).toLocaleString("en-IN")}</span>
    </div>
  `).join("");

  const orderItemsEl = $("#orderItems");
  if (orderItemsEl) orderItemsEl.innerHTML = itemsHtml;

  const subEl = $("#orderSubtotal");
  if (subEl) subEl.textContent = `₹${subtotal.toLocaleString("en-IN")}`;

  const delEl = $("#orderDelivery");
  if (delEl) delEl.textContent = delivery === 0 ? "Free" : `₹${delivery}`;

  const totEl = $("#orderTotal");
  if (totEl) totEl.textContent = `₹${total.toLocaleString("en-IN")}`;
}

function populateReview() {
  const firstName = $("#coFirstName").value.trim();
  const lastName = $("#coLastName").value.trim();
  const email = $("#coEmail").value.trim();
  const phone = $("#coPhone").value.trim();
  const address = $("#coAddress").value.trim();
  const city = $("#coCity").value.trim();
  const state = $("#coState").value;
  const pincode = $("#coPincode").value.trim();
  const notes = $("#coNotes").value.trim();

  let shippingHtml = `
    <strong>${firstName} ${lastName}</strong><br/>
    ${address}<br/>
    ${city}, ${state} — ${pincode}<br/>
    📞 ${phone} &nbsp; ✉️ ${email}
  `;
  if (notes) shippingHtml += `<br/><em>Note: ${notes}</em>`;
  $("#confirmShipping").innerHTML = shippingHtml;
}

// ===== RAZORPAY PAYMENT =====
function initiateRazorpayPayment() {
  const { total } = getOrderTotals();
  const firstName = $("#coFirstName").value.trim();
  const lastName = $("#coLastName").value.trim();
  const email = $("#coEmail").value.trim();
  const phone = $("#coPhone").value.trim();

  const itemNames = cart.map(item => `${item.name} x${item.qty}`).join(", ");

  const options = {
    key: RAZORPAY_KEY,
    amount: total * 100,
    currency: "INR",
    name: "Bloom & Petal",
    description: itemNames.length > 200 ? itemNames.substring(0, 197) + "..." : itemNames,
    image: "https://em-content.zobj.net/source/apple/391/cherry-blossom_1f338.png",
    prefill: {
      name: `${firstName} ${lastName}`,
      email: email,
      contact: phone
    },
    theme: {
      color: "#d4577b"
    },
    modal: {
      ondismiss: function () {
        showToast("Payment cancelled. You can try again.");
      }
    },
    handler: function (response) {
      onPaymentSuccess(response);
    }
  };

  const rzp = new Razorpay(options);

  rzp.on("payment.failed", function (response) {
    showToast("Payment failed: " + response.error.description);
  });

  rzp.open();
}

function onPaymentSuccess(response) {
  const orderId = "BP" + Date.now().toString(36).toUpperCase();
  $("#orderId").textContent = `Order ID: ${orderId}`;
  $("#paymentId").textContent = `Payment ID: ${response.razorpay_payment_id}`;

  currentStep = 3;
  updateCheckoutSteps();

  cart = [];
  saveCart();
  updateCart();

  showToast("Payment successful! Order placed.");
}

// ===== VALIDATION =====
function validateField(input, rules) {
  const val = input.value.trim();
  const errorEl = input.parentElement.querySelector(".form-error");
  let msg = "";

  if (rules.required && !val) {
    msg = "This field is required";
  } else if (rules.email && val && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
    msg = "Enter a valid email address";
  } else if (rules.phone && val && !/^[6-9]\d{9}$/.test(val)) {
    msg = "Enter a valid 10-digit phone number";
  } else if (rules.pincode && val && !/^\d{6}$/.test(val)) {
    msg = "Enter a valid 6-digit PIN code";
  } else if (rules.minLength && val.length < rules.minLength) {
    msg = `Minimum ${rules.minLength} characters required`;
  }

  if (msg) {
    input.classList.add("error");
    if (errorEl) errorEl.textContent = msg;
    return false;
  } else {
    input.classList.remove("error");
    if (errorEl) errorEl.textContent = "";
    return true;
  }
}

function validateShipping() {
  const fields = [
    { el: $("#coFirstName"), rules: { required: true, minLength: 2 } },
    { el: $("#coLastName"), rules: { required: true, minLength: 1 } },
    { el: $("#coEmail"), rules: { required: true, email: true } },
    { el: $("#coPhone"), rules: { required: true, phone: true } },
    { el: $("#coAddress"), rules: { required: true, minLength: 5 } },
    { el: $("#coCity"), rules: { required: true, minLength: 2 } },
    { el: $("#coState"), rules: { required: true } },
    { el: $("#coPincode"), rules: { required: true, pincode: true } }
  ];

  let valid = true;
  fields.forEach(f => {
    if (!validateField(f.el, f.rules)) valid = false;
  });
  return valid;
}

// ===== CHECKOUT EVENT SETUP =====
function setupCheckout() {
  $("#checkoutOverlay").addEventListener("click", closeCheckout);
  $("#checkoutClose").addEventListener("click", closeCheckout);
  $("#checkoutCancelBtn").addEventListener("click", closeCheckout);

  // Step 1 → 2 (Shipping → Review)
  $("#toReviewBtn").addEventListener("click", () => {
    if (!validateShipping()) return;
    currentStep = 2;
    updateCheckoutSteps();
    populateOrderSummary();
    populateReview();
  });

  // Step 2 → 1 (Review → Shipping)
  $("#backToShippingBtn").addEventListener("click", () => {
    currentStep = 1;
    updateCheckoutSteps();
  });

  // Pay Now — open Razorpay
  $("#payNowBtn").addEventListener("click", () => {
    initiateRazorpayPayment();
  });

  // Continue shopping after success
  $("#continueShopping").addEventListener("click", () => {
    closeCheckout();
    currentStep = 1;
    updateCheckoutSteps();
  });

  // Phone number — digits only
  const phoneInput = $("#coPhone");
  if (phoneInput) {
    phoneInput.addEventListener("input", (e) => {
      e.target.value = e.target.value.replace(/\D/g, "").substring(0, 10);
    });
  }

  // Pincode — digits only
  const pinInput = $("#coPincode");
  if (pinInput) {
    pinInput.addEventListener("input", (e) => {
      e.target.value = e.target.value.replace(/\D/g, "").substring(0, 6);
    });
  }
}
