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
  const betaTimerRef = useRef<number | null>(null);
  const title = "Every room. The right temperature. Automatically.";
  const container = {
    hidden: { opacity: 0, y: 12 },
    show: {
      opacity: 1,
      y: 0,
      transition: { staggerChildren: 0.12, delayChildren: 0.1 },
    },
  };
  const item = {
    hidden: { opacity: 0, y: 12 },
    show: { opacity: 1, y: 0, transition: { duration: 0.6 } },
  };
  const titleContainer = {
    hidden: {},
    show: { transition: { staggerChildren: 0.08 } },
  };
  const word = {
    hidden: { opacity: 0, y: 18 },
    show: { opacity: 1, y: 0, transition: { duration: 0.4 } },
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

  const openBetaModal = () => {
    setIsBetaOpen(true);
    if (betaTimerRef.current) {
      window.clearTimeout(betaTimerRef.current);
      betaTimerRef.current = null;
    }
  };

  const closeBetaModal = () => {
    setIsBetaOpen(false);
    if (betaTimerRef.current) {
      window.clearTimeout(betaTimerRef.current);
      betaTimerRef.current = null;
    }
  };

  useEffect(() => {
    betaTimerRef.current = window.setTimeout(() => {
      openBetaModal();
    }, 1200);

    return () => {
      if (betaTimerRef.current) {
        window.clearTimeout(betaTimerRef.current);
        betaTimerRef.current = null;
      }
    };
  }, []);

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
      <header>
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
          <a href="#control">Control</a>
          {/* <a href="#media">Media</a> */}
          {/* <a href="#reviews">Reviews</a> */}
          <a href="#preorder">Pre-order</a>
        </nav>
        <button className="btn btn-ghost" onClick={openBetaModal}>
          Get early access
        </button>
        <button
          className="mobile-menu-btn"
          onClick={() => setIsMobileMenuOpen(true)}
          aria-label="Open menu"
        >
          <span />
          <span />
          <span />
        </button>
      </header>

      <div className={`mobile-nav ${isMobileMenuOpen ? "open" : ""}`}>
        <button
          className="mobile-nav-close"
          onClick={() => setIsMobileMenuOpen(false)}
          aria-label="Close menu"
        >
          ✕
        </button>
        <a href="#technology" onClick={() => setIsMobileMenuOpen(false)}>
          Technology
        </a>
        <a href="#control" onClick={() => setIsMobileMenuOpen(false)}>
          Control
        </a>
        <a href="#preorder" onClick={() => setIsMobileMenuOpen(false)}>
          Pre-order
        </a>
        <button
          className="btn btn-primary"
          onClick={() => {
            setIsMobileMenuOpen(false);
            openBetaModal();
          }}
        >
          Get early access
        </button>
      </div>

      <section className="hero">
        <div className="hero-bg" aria-hidden="true" />
        <motion.div
          className="hero-copy"
          variants={container}
          initial="hidden"
          animate="show"
        >
          <motion.span className="kicker" variants={item}>
            Comfort reimagined
          </motion.span>
          <motion.h1
            className="hero-title"
            variants={titleContainer}
            initial="hidden"
            animate="show"
            aria-label={title}
          >
            {title.split(" ").map((segment, index) => (
              <motion.span key={`${segment}-${index}`} variants={word}>
                {segment}
              </motion.span>
            ))}
          </motion.h1>
          <motion.p variants={item}>
            Room-by-room temperature control for existing HVAC systems.
            Smart vents, wireless pucks, and app control in one setup.
          </motion.p>
          <motion.div className="hero-chips" variants={item}>
            <span className="chip">Works with existing vents</span>
            <span className="chip">Nest + Ecobee compatible</span>
            <span className="chip">Install with two screws</span>
          </motion.div>
          <motion.div className="hero-actions" variants={item}>
            <button className="btn btn-primary" onClick={openBetaModal}>
              Reserve your system
            </button>
            <button
              className="btn btn-ghost"
              onClick={() => setIsVideoOpen(true)}
            >
              Watch the airflow story
            </button>
          </motion.div>
        </motion.div>
        <motion.div
          className="hero-visual"
          initial={{ opacity: 0, y: 18 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.4 }}
        >
          <div className="orbit one" />
          <div className="orbit two" />
          <div className="glass">
            <span className="tag">How it works</span>
            <h3>Room-by-room balancing</h3>
            <p>
              Each room&apos;s puck reports temperature, then Vynte automatically
              adjusts vent positions to keep comfort consistent across your
              home.
            </p>
          </div>
          <div className="glass">
            <span className="tag">Simple install</span>
            <h3>Swap vents in minutes</h3>
            <p>
              Remove your existing vent with two screws, install Vynte, and
              connect in the app. No major renovation required.
            </p>
          </div>
        </motion.div>
      </section>

      <motion.section
        className="proof-strip reveal"
        initial={{ opacity: 0, y: 16 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.3 }}
        transition={{ duration: 0.5 }}
      >
        <motion.article
          className="proof-card"
          whileHover={{ y: -4, scale: 1.01 }}
          transition={{ type: "spring", stiffness: 260, damping: 18 }}
        >
          <span>Problem</span>
          <strong>87% report uneven room temperatures</strong>
        </motion.article>
        <motion.article
          className="proof-card"
          whileHover={{ y: -4, scale: 1.01 }}
          transition={{ type: "spring", stiffness: 260, damping: 18 }}
        >
          <span>Battery life</span>
          <strong>Up to 2 years per device</strong>
        </motion.article>
        <motion.article
          className="proof-card"
          whileHover={{ y: -4, scale: 1.01 }}
          transition={{ type: "spring", stiffness: 260, damping: 18 }}
        >
          <span>Planned starter price</span>
          <strong>$79.99 for vent + puck</strong>
        </motion.article>
      </motion.section>

      <motion.section
        id="technology"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div>
          <span className="tag">Technology</span>
          <h2>Hardware + software built to balance every room.</h2>
        </div>
        <div className="card-grid stagger">
          <article className="card">
            <h3>Servo-Controlled Vents</h3>
            <p>
              Wi-Fi vents modulate airflow in real time.
            </p>
          </article>
          <article className="card">
            <h3>Temperature Pucks</h3>
            <p>
              Wireless sensors track local room temperature.
            </p>
          </article>
          <article className="card">
            <h3>Nest + Ecobee Sync</h3>
            <p>
              Coordinates HVAC runtime with smart thermostat APIs.
            </p>
          </article>
          <article className="card">
            <h3>Auto Balancing</h3>
            <p>
              Control logic adjusts vent positions automatically.
            </p>
          </article>
        </div>
      </motion.section>

      <motion.section
        id="control"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div className="control-copy">
          <span className="tag">Room control</span>
          <h2>Fast, clear control in the Vynte app.</h2>
        </div>
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
                  sizes="(max-width: 900px) 80vw, 360px"
                />
              </div>
            ))}
          </div>
          <div className="card-grid">
            <div className="card">
              <h3>Create Rooms</h3>
              <p>Group vents and pucks by bedroom, office, or zone.</p>
            </div>
            <div className="card">
              <h3>Set Room Targets</h3>
              <p>Pick a target temperature per room.</p>
            </div>
            <div className="card">
              <h3>Manual Vent Control</h3>
              <p>Override with precise open and close settings anytime.</p>
            </div>
          </div>
        </div>
      </motion.section>

      <motion.section
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div>
          <span className="tag">Why Vynte</span>
          <h2>A simpler path to room-by-room comfort.</h2>
        </div>
        <div className="card-grid">
          <div className="card">
            <h3>Affordable entry point</h3>
            <p>
              Planned starter pricing from $79.99.
            </p>
          </div>
          <div className="card">
            <h3>Quiet operation</h3>
            <p>
              Designed for bedrooms, nurseries, and offices.
            </p>
          </div>
          <div className="card">
            <h3>Simple deployment</h3>
            <p>No ductwork replacement. Expand room by room.</p>
          </div>
        </div>
      </motion.section>

      <motion.section
        id="preorder"
        className="section preorder"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div>
          <span className="tag">Pre-order</span>
          <h2>Be first to bring room-level comfort home.</h2>
          <p>Get launch pricing, timeline updates, and early-access offers.</p>
        </div>
        <form
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
            className="btn btn-primary"
            disabled={preorderPending}
          >
            Join the pre-order list
          </button>
          {preorderStatus ? (
            <span className="form-status">{preorderStatus}</span>
          ) : null}
        </form>
      </motion.section>

      <footer className="footer">
        <div>
          <Image
            src="/solologo.tif.png"
            alt="Vynte logo"
            width={40}
            height={40}
            className="logo"
          />
        </div>
        <span>Smart comfort, room by room.</span>
        <span>Built for precision airflow and quiet operation.</span>
      </footer>

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
              aria-label="Watch the airflow story"
            >
              <div className="modal-header">
                <div>
                  <span className="tag">Video</span>
                  <h3>Watch the airflow story</h3>
                </div>
                <button
                  className="modal-close"
                  type="button"
                  onClick={() => setIsVideoOpen(false)}
                  aria-label="Close"
                >
                  ✕
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

      <AnimatePresence>
        {isBetaOpen ? (
          <motion.div
            className="modal-overlay"
            onClick={closeBetaModal}
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
              transition={{ duration: 0.28 }}
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
                    <span className="tag">Beta access</span>
                    <h3>Join the Vynte beta test</h3>
                  </div>
                  <button
                    className="modal-close"
                    type="button"
                    onClick={closeBetaModal}
                    aria-label="Close"
                  >
                    ✕
                  </button>
                </div>
                <div className="modal-body">
                  <p>
                    We are onboarding a limited group of early homes and
                    smart-home users before full launch.
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
                    Apply for the beta
                  </button>
                  {betaStatus ? (
                    <span className="form-status">{betaStatus}</span>
                  ) : null}
                </form>
                <div className="modal-grid">
                  <div className="modal-card">
                    <strong>What you get</strong>
                    <p>
                      Early hardware access, guided onboarding, and direct
                      support from the team.
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
