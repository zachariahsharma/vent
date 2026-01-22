"use client";

import Image from "next/image";
import { motion, AnimatePresence } from "framer-motion";
import { useEffect, useMemo, useRef, useState, type FormEvent } from "react";

export default function Home() {
  const [isVideoOpen, setIsVideoOpen] = useState(false);
  const [isBetaOpen, setIsBetaOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [preorderStatus, setPreorderStatus] = useState("");
  const [betaStatus, setBetaStatus] = useState("");
  const [preorderPending, setPreorderPending] = useState(false);
  const [betaPending, setBetaPending] = useState(false);
  const [sheetRows, setSheetRows] = useState<
    Array<{
      section: string;
      title: string;
      subtitle?: string;
      value?: string;
    }>
  >([]);
  const betaSeenKey = "vynte_beta_modal_seen";
  const betaTimerRef = useRef<number | null>(null);
  const sheetUrl = process.env.NEXT_PUBLIC_VYNTE_SHEETS_CSV_URL;
  const title = "Cold-air precision for every room, without wasting energy.";
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

  const parseCsv = (csvText: string) => {
    const lines = csvText.trim().split("\n");
    if (lines.length < 2) return [];
    const headers = lines[0].split(",").map((value) => value.trim());
    return lines.slice(1).map((line) => {
      const values = line.split(",").map((value) => value.trim());
      return headers.reduce<Record<string, string>>((acc, header, index) => {
        acc[header] = values[index] || "";
        return acc;
      }, {});
    });
  };

  const statsData = useMemo(() => {
    const rows = sheetRows.filter((row) => row.section === "stats");
    if (rows.length) {
      return rows.map((row) => ({
        title: row.value || row.title,
        subtitle: row.subtitle || "",
      }));
    }
    return [
      { title: "Up to 28%", subtitle: "Projected energy savings" },
      { title: "Room-level AI", subtitle: "Smart balancing per vent" },
      { title: "Quiet airflow", subtitle: "Servo motion under 30 dB" },
    ];
  }, [sheetRows]);

  const appScreens = [
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max) (1).png",
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max).png",
    "/MobileUIScreenshots/localhost_63048_(iPhone 14 Pro Max) (2).png",
  ];

  const mediaData = useMemo(() => {
    const rows = sheetRows.filter((row) => row.section === "media");
    if (rows.length) {
      return rows.map((row) => row.title);
    }
    return [
      "Hero Video Placeholder",
      "Lifestyle Image",
      "Vent Close-up",
      "App Demo Clip",
      "Temperature Puck Macro",
      "Installation Timelapse",
    ];
  }, [sheetRows]);

  useEffect(() => {
    if (!sheetUrl) return;
    const controller = new AbortController();
    fetch(sheetUrl, { signal: controller.signal })
      .then((response) => response.text())
      .then((text) => {
        const parsed = parseCsv(text);
        const normalized = parsed.map((row) => ({
          section: (row.section || "").toLowerCase(),
          title: row.title || "",
          subtitle: row.subtitle || "",
          value: row.value || "",
        }));
        setSheetRows(normalized);
      })
      .catch(() => {});
    return () => controller.abort();
  }, [sheetUrl]);

  const openBetaModal = () => {
    setIsBetaOpen(true);
    sessionStorage.setItem(betaSeenKey, "true");
    if (betaTimerRef.current) {
      window.clearTimeout(betaTimerRef.current);
      betaTimerRef.current = null;
    }
  };

  const closeBetaModal = () => {
    setIsBetaOpen(false);
    sessionStorage.setItem(betaSeenKey, "true");
    if (betaTimerRef.current) {
      window.clearTimeout(betaTimerRef.current);
      betaTimerRef.current = null;
    }
  };

  useEffect(() => {
    if (sessionStorage.getItem(betaSeenKey)) return;
    betaTimerRef.current = window.setTimeout(() => {
      openBetaModal();
    }, 30000);

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
          <a href="#reviews">Reviews</a>
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
            Vynte pairs servo-controlled vents, smart temperature pucks, and
            Nest + Ecobee integrations with a room-by-room mobile experience.
            Enjoy the comfort you want with the savings you expect.
          </motion.p>
          <motion.div className="hero-actions" variants={item}>
            <button className="btn btn-primary">Reserve your system</button>
            <button
              className="btn btn-ghost"
              onClick={() => setIsVideoOpen(true)}
            >
              Watch the airflow story
            </button>
          </motion.div>
          <motion.div className="stats" variants={item}>
            {statsData.map((stat, index) => (
              <motion.div
                className="stat"
                variants={item}
                key={stat.title + index}
              >
                <strong>{stat.title}</strong>
                <p>{stat.subtitle}</p>
              </motion.div>
            ))}
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
            <span className="tag">Live comfort map</span>
            <h3>Room Airflow Matrix</h3>
            <p>
              Placeholder for real-time airflow visualization, comfort zones,
              and per-room targets.
            </p>
          </div>
          <div className="glass">
            <span className="tag">Mobile command</span>
            <h3>Vynte App Preview</h3>
            <p>Insert app screenshots from `vynte_ui` here.</p>
          </div>
        </motion.div>
      </section>

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
          <h2>Servo vents, temperature pucks, and intelligent balancing.</h2>
          <p>
            Vynte rethinks HVAC distribution with adaptive vents and sensors
            that continuously learn your home&apos;s comfort profile.
          </p>
        </div>
        <div className="card-grid stagger">
          <article className="card">
            <h3>Servo-Controlled Vents</h3>
            <p>
              Micro-servo precision tunes airflow per room and responds in
              seconds, not hours.
            </p>
          </article>
          <article className="card">
            <h3>Temperature Pucks</h3>
            <p>
              Battery-friendly sensors track comfort where you live, not just at
              the thermostat.
            </p>
          </article>
          <article className="card">
            <h3>Nest + Ecobee Sync</h3>
            <p>
              Layer Vynte&apos;s room intelligence on top of your favorite smart
              thermostat ecosystem.
            </p>
          </article>
          <article className="card">
            <h3>Auto Balancing</h3>
            <p>
              Energy savings grow as the system learns patterns, occupancy, and
              seasonal airflow trends.
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
          <h2>One tap comfort, room by room.</h2>
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
              <h3>Room-by-Room Timeline</h3>
              <p>Space for animated schedules, routines, and energy visuals.</p>
            </div>
            <div className="card">
              <h3>Sensor Network Map</h3>
              <p>Drop in graphics showing puck distribution and live temps.</p>
            </div>
            <div className="card">
              <h3>Automation Scenes</h3>
              <p>
                Show your smart scenes, comfort presets, and occupancy logic.
              </p>
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
          <span className="tag">Energy savings</span>
          <h2>Comfort that pays for itself.</h2>
          <p>
            Highlight real savings data, rebates, and smart automation results
            here once you have metrics to share.
          </p>
        </div>
        <div className="card-grid">
          <div className="card">
            <h3>Monthly Savings</h3>
            <p>Placeholder for real charts and cost offsets.</p>
          </div>
          <div className="card">
            <h3>Usage Forecast</h3>
            <p>Show projections for summer and winter loads.</p>
          </div>
          <div className="card">
            <h3>Live Impact Dashboard</h3>
            <p>Space for data-driven animations and impact counters.</p>
          </div>
        </div>
      </motion.section>

      {/*
      <motion.section
        id="media"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div>
          <span className="tag">Media</span>
          <h2>Make the system feel tangible.</h2>
          <p>
            Drop in product photography, installation videos, and lifestyle
            footage to make Vynte feel immediate.
          </p>
        </div>
        <div className="media-grid">
          {mediaData.map((label) => (
            <div className="media-tile" key={label}>
              {label}
            </div>
          ))}
        </div>
        <div className="media-assets">
          <div className="media-video">
            <video controls playsInline preload="metadata">
              <source src="/Video.mp4" type="video/mp4" />
            </video>
          </div>
          <div className="media-render">
            <Image
              src="/step-renders/vent-closed.png"
              alt="Vynte vent assembly closed"
              width={900}
              height={650}
            />
          </div>
          <div className="media-render">
            <Image
              src="/step-renders/vent-open.png"
              alt="Vynte vent assembly open"
              width={900}
              height={650}
            />
          </div>
        </div>
      </motion.section>
      */}

      {/*
      <motion.section
        id="reviews"
        className="section"
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.7 }}
      >
        <div>
          <span className="tag">Reviews</span>
          <h2>Early access feedback and comfort stories.</h2>
          <p>
            Add real testimonials, star ratings, and case studies once you
            collect them.
          </p>
        </div>
        <div className="card-grid">
          <article className="card review">
            <strong>★★★★★ Placeholder Review</strong>
            <p>
              “We finally stopped fighting over the thermostat. Vynte nailed the
              airflow.”
            </p>
            <span>— Smart home beta tester</span>
          </article>
          <article className="card review">
            <strong>★★★★★ Placeholder Review</strong>
            <p>
              “The app feels like having a thermostat in every room, without the
              extra energy.”
            </p>
            <span>— Energy-conscious family</span>
          </article>
          <article className="card review">
            <strong>★★★★★ Placeholder Review</strong>
            <p>
              “Quiet vents, big impact. Our home finally feels balanced.”
            </p>
            <span>— HVAC installer partner</span>
          </article>
        </div>
      </motion.section>
      */}

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
          <h2>Be first to experience Vynte.</h2>
          <p>
            Capture interest, pricing tiers, and early access deposits when
            you&apos;re ready. This block is ready for your data.
          </p>
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
        <span>Built for energy efficiency and quiet airflow.</span>
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
                  Showcase how servo-controlled vents, temperature pucks, and
                  the app orchestrate cold-air precision without wasting energy.
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
              className="modal"
              onClick={(event) => event.stopPropagation()}
              initial={{ opacity: 0, y: 20, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 20, scale: 0.98 }}
              transition={{ duration: 0.25 }}
              role="dialog"
              aria-modal="true"
              aria-label="Join the beta test"
            >
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
                  We are opening a limited beta for homes ready to test
                  room-by-room comfort, energy savings, and smart vent
                  automation.
                </p>
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
                      Early hardware access, guided install, and priority app
                      updates.
                    </p>
                  </div>
                  <div className="modal-card">
                    <strong>What we need</strong>
                    <p>
                      Usage feedback, comfort logs, and installation insights.
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
