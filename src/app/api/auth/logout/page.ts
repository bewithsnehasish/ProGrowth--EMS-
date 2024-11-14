// pages/api/auth/logout.ts
import { NextApiRequest, NextApiResponse } from "next";

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === "POST") {
    // Clear the JWT token (or instruct client to do so)
    return res.status(200).json({ message: "Logged out successfully" });
  } else {
    return res.status(405).json({ message: "Method not allowed" });
  }
}
