import bcrypt from "bcryptjs";
import { PrismaClient } from "@prisma/client";
import { NextRequest, NextResponse } from "next/server";

// Initialize Prisma client
const prisma = new PrismaClient();

// Handle POST request for user registration
export async function POST(req: NextRequest) {
  try {
    // Parse request body
    const { firstName, lastName, email, password, phone, role } =
      await req.json();

    // Validate required fields
    if (!firstName || !lastName || !email || !password || !phone || !role) {
      return NextResponse.json(
        { message: "All fields are required" },
        { status: 400 },
      );
    }

    // Check if email already exists
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return NextResponse.json(
        { message: "Email already exists" },
        { status: 400 },
      );
    }

    // Hash password before saving to DB
    const hashedPassword = await bcrypt.hash(password, 12);

    // Generate custom employee ID based on timestamp
    const generateEmployeeId = () => `EMP${Date.now().toString().slice(-6)}`;

    // Create new user in database
    const user = await prisma.user.create({
      data: {
        id: generateEmployeeId(),
        email,
        password: hashedPassword,
        firstName,
        lastName,
        phone,
        role,
      },
    });

    // Respond with success and user details (excluding password)
    return NextResponse.json(
      {
        message: "User registered successfully.",
        user: {
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          role: user.role,
        },
      },
      { status: 201 },
    );
  } catch (error) {
    // Catch any unexpected errors and send a server error response
    return NextResponse.json(
      { message: "Server error", error },
      { status: 500 },
    );
  }
}
