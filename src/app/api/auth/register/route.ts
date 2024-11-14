// pages/api/auth/register.ts
import { NextApiRequest, NextApiResponse } from "next";
import bcrypt from "bcryptjs";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  if (req.method === "POST") {
    const { firstName, lastName, email, password, phone, role } = req.body;

    try {
      // Validate input
      if (!firstName || !lastName || !email || !password || !phone || !role) {
        return res.status(400).json({ message: "All fields are required" });
      }

      // Check if email already exists
      const existingUser = await prisma.user.findUnique({ where: { email } });
      if (existingUser) {
        return res.status(400).json({ message: "Email already exists" });
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      function generateEmployeeId() {
        return `EMP${Date.now().toString().slice(-6)}`;
      }

      // Create user in the database
      await prisma.user.create({
        data: {
          email,
          password: hashedPassword,
          role,
          profile: {
            create: {
              firstName,
              lastName,
              phone,
              employeeId: generateEmployeeId(),
            },
          },
        },
      });

      return res.status(201).json({ message: "User registered successfully." });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: "Server error" });
    }
  } else {
    return res.status(405).json({ message: "Method not allowed" });
  }
}
