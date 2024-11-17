// pages/api/auth/logout.ts
import { NextRequest, NextResponse } from "next/server";

// The POST function must accept the request (NextRequest) parameter
export function POST(req: NextRequest) {
  return NextResponse.json(
    { message: "Logged out successfully" },
    { status: 200 },
  );
}
