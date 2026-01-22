import { google } from "googleapis";
import path from "node:path";

export const runtime = "nodejs";

const spreadsheetId = "1k0wt7kde5iAVTHhNB7idkDeSbG1Fh3YCXBspyIkmEO0";
const sheetMap: Record<string, string> = {
  preorder: "Preorders",
  beta: "beta",
};

function getAuth() {
  const credentialsPath = path.join(process.cwd(), "credentials.json");
  const raw = require("fs").readFileSync(credentialsPath, "utf-8");
  const credentials = JSON.parse(raw);
  if (credentials.private_key) {
    credentials.private_key = credentials.private_key.replace(/\\n/g, "\n");
  }

  return new google.auth.GoogleAuth({
    credentials,
    scopes: ["https://www.googleapis.com/auth/spreadsheets"],
  });
}

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { type, name, email, zip } = body || {};

    if (!type || !sheetMap[type]) {
      return Response.json({ error: "Invalid form type." }, { status: 400 });
    }
    if (!name || !email || !zip) {
      return Response.json({ error: "Missing required fields." }, { status: 400 });
    }

    const auth = getAuth();
    const sheets = google.sheets({ version: "v4", auth });
    const range = `${sheetMap[type]}!A:D`;
    const values = [[new Date().toISOString(), name, email, zip]];

    await sheets.spreadsheets.values.append({
      spreadsheetId,
      range,
      valueInputOption: "USER_ENTERED",
      requestBody: { values },
    });

    return Response.json({ ok: true });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Failed to submit.";
    return Response.json({ error: message }, { status: 500 });
  }
}
