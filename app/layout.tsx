import "./globals.css";
import { Sora, Space_Grotesk } from "next/font/google";

const sora = Sora({
  subsets: ["latin"],
  variable: "--font-sora",
  display: "swap",
});

const space = Space_Grotesk({
  subsets: ["latin"],
  variable: "--font-space",
  display: "swap",
});

export const metadata = {
  title: "Vynte | Smart Ventilation, Room by Room",
  description:
    "Servo-controlled vents, smart temperature pucks, and app-driven comfort with energy savings.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${sora.variable} ${space.variable}`}>
      <body>{children}</body>
    </html>
  );
}
