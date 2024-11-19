// src/app/api/profile/[userId]/route.ts

import { PrismaClient } from "@prisma/client";
import { NextRequest, NextResponse } from "next/server";

const prisma = new PrismaClient();

export async function GET(
  req: NextRequest,
  // Add this context parameter to get the userId from the URL path
  { params }: { params: { userId: string } },
) {
  try {
    // Use params.userId instead of searchParams
    const userId = params.userId;

    if (!userId) {
      return NextResponse.json(
        { message: "User ID is required" },
        { status: 400 },
      );
    }

    const profile = await prisma.profile.findUnique({
      where: { userId },
      include: { user: true },
    });

    if (!profile) {
      return NextResponse.json(
        { message: "Profile not found" },
        { status: 404 },
      );
    }

    return NextResponse.json({ profile }, { status: 200 });
  } catch (error) {
    return NextResponse.json(
      { message: "Server error", error: error },
      { status: 500 },
    );
  }
}

export async function PUT(
  req: NextRequest,
  { params }: { params: { userId: string } },
) {
  try {
    const userId = params.userId;
    const updateFields = await req.json();

    if (!userId || Object.keys(updateFields).length === 0) {
      return NextResponse.json(
        { message: "At least one field to update is required" },
        { status: 400 },
      );
    }

    const profile = await prisma.profile.update({
      where: { userId },
      data: updateFields,
    });

    return NextResponse.json(
      { message: "Profile updated successfully.", profile },
      { status: 200 },
    );
  } catch (error) {
    return NextResponse.json(
      { message: "Server error", error: error },
      { status: 500 },
    );
  }
}
