"use client";

import Image from "next/image";
import { motion, AnimatePresence } from "framer-motion";
import { useEffect, useRef, useState, type FormEvent } from "react";

export default function Home() {
  const [isVideoOpen, setIsVideoOpen] = useState(false);
  const [isBetaOpen, setIsBetaOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [preorderStatus, setPreorderStatus] = useState("");
  const [betaStatus, setBetaStatus] = useState("");
  const [preorderPending, setPreorderPending] = useState(false);
  const [betaPending, setBetaPending] = useState(false);

  const title = "Every room. The right temperature. Automatically.";

  const fadeUp = {
    hidden: { opacity: 0, y: 20 },
    show: { opacity: 1, y: 0, transition: { duration: 0.6 } },
  };

  const stagger = {
    hidden: {},
    show: { transition: { staggerChildren: 0.1, delayChildren: 0.1 } },
  };

  const titleContainer = {
    hidden: {},
    show: { transition: { staggerChildren: 0.06 } },
  };

  const wordVariant = {
    hidden: { opacity: 0, y: 16 },
    show: { opacity: 1, y: 0, transition: { duration: 0.35 } },
  };

  const submitLead = async (
    event: FormEvent<HTMLFormElement>,
    type: "preorder" | "beta",
    setStatus: (value: string) => void,
    setPending: (value: boolean) => void
  ) => {
    event.preventDefault();
    if (
      (type === "preorder" && preorderPending) ||
      (type === "beta" && betaPending)
    ) {
      return;
    }
    setPending(true);
    setStatus("Sending...");
    const formData = new FormData(event.currentTarget);
    const payload = {
      type,
      name: String(formData.get("name") || "").trim(),
      email: String(formData.get("email") || "").trim(),
      zip: String(formData.get("zip") || "").trim(),
    };

    try {
      const response = await fetch("/api/lead", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const data = await response.json().catch(() => ({}));
      if (!response.ok) {
        throw new Error(data.error || "Request failed");
      }
      setStatus("Thanks! We'll be in touch soon.");
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Something went wrong.";
      setStatus(message);
    } finally {
      setPending(false);
    }
  };

  const appScreens = [
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max) (1).png",
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max).png",
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max) (2).png",
  ];

  useEffect(() => {
    if (!isBetaOpen && !isVideoOpen && !isMobileMenuOpen) return;
    const scrollBarWidth =
      window.innerWidth - document.documentElement.clientWidth;
    const originalOverflow = document.body.style.overflow;
    const originalPadding = document.body.style.paddingRight;
    document.body.style.overflow = "hidden";
    document.body.style.paddingRight = scrollBarWidth
      ? `${scrollBarWidth}px`
      : originalPadding;
    return () => {
      document.body.style.overflow = originalOverflow;
      document.body.style.paddingRight = originalPadding;
    };
  }, [isBetaOpen, isVideoOpen, isMobileMenuOpen]);

  return (
    <main>
      {/* ── Header ──────────────────────────────────────── */}
      <header>
        <div className="header-inner">
          <Image
            src="/compound_logo.png"
            alt="Vynte"
            width={140}
            height={40}
            className="logo"
            priority
          />
          <nav>
            <a href="#technology">Technology</a>
            <a href="#how-it-works">How It Works</a>
            <a href="#product">Product</a>
            <a href="#control">App</a>
            <a href="#preorder">Pre-order</a>
          </nav>
          <div className="header-actions">
            <button
              className="btn btn-ghost"
              onClick={() => setIsVideoOpen(true)}
            >
              Watch demo
            </button>
            <button
              className="btn btn-primary"
              onClick={() => setIsBetaOpen(true)}
            >
              Get early access
            </button>
          </div>
          <button
            className="mobile-menu-btn"
            onClick={() => setIsMobileMenuOpen(true)}
            aria-label="Open menu"
          >
            <span />
            <span />
            <span />
          </button>
        </div>
      </header>

      {/* ── Mobile Nav ──────────────────────────────────── */}
      <div className={`mobile-nav ${isMobileMenuOpen ? "open" : ""}`}>
        <button
          className="mobile-nav-close"
          onClick={() => setIsMobileMenuOpen(false)}
          aria-label="Close menu"
        >
          &#x2715;
        </button>
        <a href="#technology" onClick={() => setIsMobileMenuOpen(false)}>
          Technology
        </a>
        <a href="#how-it-works" onClick={() => setIsMobileMenuOpen(false)}>
          How It Works
        </a>
        <a href="#product" onClick={() => setIsMobileMenuOpen(false)}>
          Product
        </a>
        <a href="#control" onClick={() => setIsMobileMenuOpen(false)}>
          App
        </a>
        <a href="#preorder" onClick={() => setIsMobileMenuOpen(false)}>
          Pre-order
        </a>
        <button
          className="btn btn-primary"
          onClick={() => {
            setIsMobileMenuOpen(false);
            setIsBetaOpen(true);
          }}
        >
          Get early access
        </button>
      </div>

      {/* ── Hero ────────────────────────────────────────── */}
      <section className="hero">
        <motion.div
          className="hero-inner"
          variants={stagger}
          initial="hidden"
          animate="show"
        >
          <motion.div className="hero-copy" variants={stagger}>
            <motion.span className="tag" variants={fadeUp}>
              Smart Home Ventilation
            </motion.span>
            <motion.h1
              className="hero-title"
              variants={titleContainer}
              initial="hidden"
              animate="show"
              aria-label={title}
            >
              {title.split(" ").map((segment, index) => (
                <motion.span key={`${segment}-${index}`} variants={wordVariant}>
                  {segment}
                </motion.span>
              ))}
            </motion.h1>
            <motion.p className="hero-subtitle" variants={fadeUp}>
              Room-by-room temperature control for existing HVAC systems.
              Smart vents, wireless pucks, and app control&#8212;installed in minutes.
            </motion.p>
            <motion.div className="hero-badges" variants={fadeUp}>
              <span className="hero-badge">
                <span className="hero-badge-icon">&#10003;</span>
                Works with existing vents
              </span>
              <span className="hero-badge">
                <span className="hero-badge-icon">&#10003;</span>
                Nest + Ecobee compatible
              </span>
              <span className="hero-badge">
                <span className="hero-badge-icon">&#10003;</span>
                Two-screw installation
              </span>
            </motion.div>
            <motion.div className="hero-actions" variants={fadeUp}>
              <button
                className="btn btn-primary btn-lg"
                onClick={() => setIsBetaOpen(true)}
              >
                Reserve your system
              </button>
              <button
                className="btn btn-secondary btn-lg"
                onClick={() => setIsVideoOpen(true)}
              >
                Watch the demo
              </button>
            </motion.div>
          </motion.div>
          <motion.div
            className="hero-visual"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8, delay: 0.3 }}
          >
            <div className="hero-product">
              <Image
                src="/front.png"
                alt="Vynte smart vent front view"
                width={768}
                height={512}
                className="hero-product-img"
                priority
              />
            </div>
          </motion.div>
        </motion.div>
      </section>

      {/* ── Proof Strip ─────────────────────────────────── */}
      <motion.section
        className="proof-strip"
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true, amount: 0.3 }}
        transition={{ duration: 0.5 }}
      >
        <div className="proof-strip-inner">
          <div className="proof-card">
            <div className="proof-card-value">
              <span className="accent">87%</span>
            </div>
            <div className="proof-card-label">
              of homeowners report uneven room temperatures
            </div>
          </div>
          <div className="proof-card">
            <div className="proof-card-value">2 Years</div>
            <div className="proof-card-label">battery life per device</div>
          </div>
          <div className="proof-card">
            <div className="proof-card-value">
              <span className="accent">$79.99</span>
            </div>
            <div className="proof-card-label">
              planned starter price per vent + puck
            </div>
          </div>
        </div>
      </motion.section>

      {/* ── Technology ──────────────────────────────────── */}
      <motion.section
        id="technology"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.15 }}
        transition={{ duration: 0.6 }}
      >
        <div className="section-header">
          <span className="tag">Technology</span>
          <h2>Hardware + software designed to balance every room</h2>
          <p>
            Vynte combines precision hardware with intelligent software to
            deliver consistent comfort throughout your entire home.
          </p>
        </div>
        <div className="tech-grid">
          <article className="tech-card">
            <div className="tech-card-icon">&#9881;</div>
            <h3>Servo-Controlled Vents</h3>
            <p>
              Wi-Fi connected vents modulate airflow in real time, responding
              to temperature changes across your home.
            </p>
          </article>
          <article className="tech-card">
            <div className="tech-card-icon">&#9832;</div>
            <h3>Temperature Pucks</h3>
            <p>
              Compact wireless sensors track temperature in each room,
              providing the data needed for precise control.
            </p>
          </article>
          <article className="tech-card">
            <div className="tech-card-icon">&#8644;</div>
            <h3>Thermostat Integration</h3>
            <p>
              Coordinates HVAC runtime with Nest and Ecobee APIs for
              seamless whole-home optimization.
            </p>
          </article>
          <article className="tech-card">
            <div className="tech-card-icon">&#9733;</div>
            <h3>Auto Balancing</h3>
            <p>
              Intelligent control logic automatically adjusts vent positions
              to maintain target temperatures in every room.
            </p>
          </article>
        </div>
      </motion.section>

      {/* ── How It Works ────────────────────────────────── */}
      <motion.section
        id="how-it-works"
        className="section section-alt"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.15 }}
        transition={{ duration: 0.6 }}
      >
        <div className="section-header">
          <span className="tag tag-accent">How It Works</span>
          <h2>Up and running in three simple steps</h2>
          <p>
            No contractors. No ductwork changes. Install Vynte yourself in minutes
            and start controlling airflow room by room.
          </p>
        </div>
        <div className="steps-grid">
          <div className="step">
            <div className="step-number">1</div>
            <h3>Swap your vents</h3>
            <p>
              Remove your existing register with two screws and drop in a Vynte
              smart vent. Standard sizes fit most homes.
            </p>
          </div>
          <div className="step">
            <div className="step-number">2</div>
            <h3>Place the pucks</h3>
            <p>
              Set a wireless temperature puck in each room you want to
              control. They connect automatically.
            </p>
          </div>
          <div className="step">
            <div className="step-number">3</div>
            <h3>Set your targets</h3>
            <p>
              Open the Vynte app, assign rooms, set your desired temperatures,
              and let the system handle the rest.
            </p>
          </div>
        </div>
      </motion.section>

      {/* ── Product Showcase ─────────────────────────────── */}
      <motion.section
        id="product"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.15 }}
        transition={{ duration: 0.6 }}
      >
        <div className="product-showcase">
          <div className="product-image-wrap">
            <Image
              src="/back.png"
              alt="Vynte smart vent back view"
              width={612}
              height={408}
            />
          </div>
          <div className="product-copy">
            <span className="tag">The Product</span>
            <h2>Engineered for precision airflow and quiet operation</h2>
            <p>
              The Vynte smart vent replaces your existing floor or ceiling
              register. Servo-driven louvers open and close on demand,
              directing conditioned air exactly where it&apos;s needed.
            </p>
            <div className="product-features">
              <div className="product-feature">
                <span className="product-feature-icon">&#10003;</span>
                <div className="product-feature-text">
                  <h4>Whisper-quiet servo motors</h4>
                  <p>Designed for bedrooms, nurseries, and home offices.</p>
                </div>
              </div>
              <div className="product-feature">
                <span className="product-feature-icon">&#10003;</span>
                <div className="product-feature-text">
                  <h4>Standard vent sizing</h4>
                  <p>Fits common register openings with no modifications.</p>
                </div>
              </div>
              <div className="product-feature">
                <span className="product-feature-icon">&#10003;</span>
                <div className="product-feature-text">
                  <h4>2-year battery life</h4>
                  <p>Low-power design means minimal maintenance.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </motion.section>

      {/* ── App Control ──────────────────────────────────── */}
      <motion.section
        id="control"
        className="section section-alt"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.15 }}
        transition={{ duration: 0.6 }}
      >
        <div className="control-layout">
          <div className="phone-stack">
            {appScreens.map((src, index) => (
              <div className="phone-frame" key={src}>
                <Image
                  src={src}
                  alt={`Vynte app screen ${index + 1}`}
                  width={420}
                  height={900}
                  className="phone-image"
                  sizes="(max-width: 768px) 80vw, 320px"
                />
              </div>
            ))}
          </div>
          <div className="control-features">
            <span className="tag">The App</span>
            <h2>Clear, intuitive room-by-room control</h2>
            <p>
              The Vynte app puts full control of your home&apos;s airflow in your
              pocket. Set up in minutes, then monitor and adjust from anywhere.
            </p>
            <div className="control-card">
              <span className="control-card-num">1</span>
              <div>
                <h3>Create rooms</h3>
                <p>Group vents and pucks by bedroom, office, or zone.</p>
              </div>
            </div>
            <div className="control-card">
              <span className="control-card-num">2</span>
              <div>
                <h3>Set room targets</h3>
                <p>Pick a target temperature for each room independently.</p>
              </div>
            </div>
            <div className="control-card">
              <span className="control-card-num">3</span>
              <div>
                <h3>Manual overrides</h3>
                <p>
                  Fine-tune individual vent positions anytime with precise
                  open/close controls.
                </p>
              </div>
            </div>
          </div>
        </div>
      </motion.section>

      {/* ── Why Vynte ────────────────────────────────────── */}
      <motion.section
        className="section section-dark"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.15 }}
        transition={{ duration: 0.6 }}
      >
        <div className="section-header">
          <span className="tag">Why Vynte</span>
          <h2>A smarter path to whole-home comfort</h2>
          <p>
            Zone control without the cost and complexity of a full HVAC
            overhaul. Vynte works with what you already have.
          </p>
        </div>
        <div className="benefits-grid">
          <article className="benefit-card">
            <div className="benefit-icon">&#36;</div>
            <h3>Affordable entry point</h3>
            <p>
              Starting at $79.99 per vent + puck. Scale your system room by
              room as your budget allows.
            </p>
          </article>
          <article className="benefit-card">
            <div className="benefit-icon">&#128264;</div>
            <h3>Quiet operation</h3>
            <p>
              Servo motors engineered for near-silent movement. Comfortable
              in bedrooms, nurseries, and offices.
            </p>
          </article>
          <article className="benefit-card">
            <div className="benefit-icon">&#9889;</div>
            <h3>Simple deployment</h3>
            <p>
              No ductwork replacement. No contractor visits. Expand coverage
              one room at a time.
            </p>
          </article>
        </div>
      </motion.section>

      {/* ── Pre-order CTA ────────────────────────────────── */}
      <motion.section
        id="preorder"
        className="cta-section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.6 }}
      >
        <div className="cta-inner">
          <span className="tag tag-accent">Pre-order</span>
          <h2>Be first to bring room-level comfort home</h2>
          <p>
            Join the pre-order list for launch pricing, timeline updates,
            and early-access offers.
          </p>
          <form
            className="cta-form"
            onSubmit={(event) =>
              submitLead(event, "preorder", setPreorderStatus, setPreorderPending)
            }
          >
            <input
              type="text"
              name="name"
              placeholder="Full name"
              aria-label="Full name"
              required
            />
            <input
              type="email"
              name="email"
              placeholder="Email address"
              aria-label="Email"
              required
            />
            <input
              type="text"
              name="zip"
              placeholder="Zip code"
              aria-label="Zip code"
              required
            />
            <button
              type="submit"
              className="btn btn-primary btn-lg"
              disabled={preorderPending}
            >
              Join waitlist
            </button>
            {preorderStatus ? (
              <span className="form-status">{preorderStatus}</span>
            ) : null}
          </form>
        </div>
      </motion.section>

      {/* ── Footer ──────────────────────────────────────── */}
      <footer className="footer">
        <div className="footer-inner">
          <div className="footer-top">
            <div className="footer-brand">
              <Image
                src="/compound_logo.png"
                alt="Vynte"
                width={140}
                height={40}
                className="logo"
              />
              <p>
                Smart ventilation that works with your existing HVAC system.
                Room-by-room comfort, simplified.
              </p>
            </div>
            <div className="footer-col">
              <h4>Product</h4>
              <a href="#technology">Technology</a>
              <a href="#product">Smart Vent</a>
              <a href="#control">Vynte App</a>
              <a href="#how-it-works">How It Works</a>
            </div>
            <div className="footer-col">
              <h4>Company</h4>
              <a href="#preorder">Pre-order</a>
              <a href="#" onClick={() => setIsBetaOpen(true)}>
                Beta Program
              </a>
            </div>
            <div className="footer-col">
              <h4>Support</h4>
              <a href="mailto:support@vynte.com">Contact Us</a>
            </div>
          </div>
          <div className="footer-bottom">
            <span>&copy; {new Date().getFullYear()} Vynte. All rights reserved.</span>
            <span>Built for precision airflow and quiet operation.</span>
          </div>
        </div>
      </footer>

      {/* ── Video Modal ──────────────────────────────────── */}
      <AnimatePresence>
        {isVideoOpen ? (
          <motion.div
            className="modal-overlay"
            onClick={() => setIsVideoOpen(false)}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <motion.div
              className="modal"
              onClick={(event) => event.stopPropagation()}
              initial={{ opacity: 0, y: 20, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 20, scale: 0.98 }}
              transition={{ duration: 0.25 }}
              role="dialog"
              aria-modal="true"
              aria-label="Watch the demo"
            >
              <div className="modal-header">
                <div>
                  <span className="tag">Demo</span>
                  <h3>See Vynte in action</h3>
                </div>
                <button
                  className="modal-close"
                  type="button"
                  onClick={() => setIsVideoOpen(false)}
                  aria-label="Close"
                >
                  &#x2715;
                </button>
              </div>
              <div className="modal-body">
                <div className="video-frame">
                  <video controls playsInline preload="metadata">
                    <source src="/Video.mp4" type="video/mp4" />
                  </video>
                </div>
                <p>
                  Watch Vynte balance airflow across rooms in real time.
                </p>
              </div>
            </motion.div>
          </motion.div>
        ) : null}
      </AnimatePresence>

      {/* ── Beta Modal ───────────────────────────────────── */}
      <AnimatePresence>
        {isBetaOpen ? (
          <motion.div
            className="modal-overlay"
            onClick={() => setIsBetaOpen(false)}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          >
            <motion.div
              className="modal beta-modal"
              onClick={(event) => event.stopPropagation()}
              initial={{ opacity: 0, y: 20, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 20, scale: 0.98 }}
              transition={{ duration: 0.25 }}
              role="dialog"
              aria-modal="true"
              aria-label="Join the beta test"
            >
              <div className="beta-companion">
                <span className="tag">Why Vynte</span>
                <h3>Every room. The right temperature. Automatically.</h3>
                <p>
                  Smart vents and wireless pucks coordinate airflow room by room
                  using your existing HVAC setup.
                </p>
                <ul className="beta-points">
                  <li>Nest + Ecobee compatible</li>
                  <li>Two-screw installation</li>
                  <li>Room-by-room control in the app</li>
                  <li>2-year battery life per device</li>
                </ul>
                <div className="video-frame video-frame-dark">
                  <video controls playsInline preload="metadata">
                    <source src="/Video.mp4" type="video/mp4" />
                  </video>
                </div>
              </div>

              <div className="beta-form-panel">
                <div className="modal-header">
                  <div>
                    <span className="tag">Beta Access</span>
                    <h3>Join the Vynte beta program</h3>
                  </div>
                  <button
                    className="modal-close"
                    type="button"
                    onClick={() => setIsBetaOpen(false)}
                    aria-label="Close"
                  >
                    &#x2715;
                  </button>
                </div>
                <div className="modal-body">
                  <p>
                    We&apos;re onboarding a limited group of early homes before
                    full launch. Apply for early hardware access.
                  </p>
                </div>
                <form
                  className="modal-form"
                  onSubmit={(event) =>
                    submitLead(event, "beta", setBetaStatus, setBetaPending)
                  }
                >
                  <input
                    type="text"
                    name="name"
                    placeholder="Full name"
                    aria-label="Full name"
                    required
                  />
                  <input
                    type="email"
                    name="email"
                    placeholder="Email address"
                    aria-label="Email"
                    required
                  />
                  <input
                    type="text"
                    name="zip"
                    placeholder="Zip code"
                    aria-label="Zip code"
                    required
                  />
                  <button
                    className="btn btn-primary"
                    type="submit"
                    disabled={betaPending}
                  >
                    Apply for beta access
                  </button>
                  {betaStatus ? (
                    <span className="form-status">{betaStatus}</span>
                  ) : null}
                </form>
                <div className="modal-grid">
                  <div className="modal-card">
                    <strong>What you get</strong>
                    <p>
                      Early hardware, guided onboarding, and direct support from
                      the engineering team.
                    </p>
                  </div>
                  <div className="modal-card">
                    <strong>What we need</strong>
                    <p>
                      Room comfort feedback, app usage insights, and install
                      notes from real homes.
                    </p>
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        ) : null}
      </AnimatePresence>
    </main>
  );
}
