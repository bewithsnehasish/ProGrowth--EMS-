import bcrypt from "bcryptjs";
import { PrismaClient } from "@prisma/client";
import { NextRequest, NextResponse } from "next/server";

// Initialize Prisma client
const prisma = new PrismaClient();

// Handle POST request for user registration
export async function POST(req: NextRequest) {
  try {
    const { firstName, lastName, email, password, role, phone } =
      await req.json();

    if (!firstName || !lastName || !email || !password || !role || !phone) {
      return NextResponse.json(
        { message: "All fields are required" },
        { status: 400 },
      );
    }

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return NextResponse.json(
        { message: "Email already exists" },
        { status: 400 },
      );
    }

    const hashedPassword = await bcrypt.hash(password, 12);
    const generateEmployeeId = () => `EMP${Date.now().toString().slice(-6)}`;

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        role,
        profile: {
          create: {
            employeeId: generateEmployeeId(),
            firstName,
            lastName,
            phone,
          },
        },
      },
      include: { profile: true },
    });

    return NextResponse.json(
      {
        message: "User registered successfully.",
        user: {
          id: user.id,
          email: user.email,
          role: user.role,
          profile: {
            firstName: user.profile?.firstName,
            lastName: user.profile?.lastName,
            phone: user.profile?.phone,
            employeeId: user.profile?.employeeId,
          },
        },
      },
      { status: 201 },
    );
  } catch (error) {
    return NextResponse.json(
      { message: "Server error", error },
      { status: 500 },
    );
  }
}
