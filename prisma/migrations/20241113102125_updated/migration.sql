/*
  Warnings:

  - The values [EXPERIENCE,TERMS_ACCEPTANCE] on the enum `DocumentType` will be removed. If these variants are still used in the database, this will fail.
  - The values [ACTIVE] on the enum `ProjectStatus` will be removed. If these variants are still used in the database, this will fail.
  - The values [ASSIGNED,WORKING,OVERDUE,NOT_COMPLETED] on the enum `TaskStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `createdAt` on the `Attendance` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Attendance` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `Document` table. All the data in the column will be lost.
  - You are about to drop the column `profileId` on the `Document` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Document` table. All the data in the column will be lost.
  - The `status` column on the `Document` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `avatar` on the `Profile` table. All the data in the column will be lost.
  - You are about to drop the column `bio` on the `Profile` table. All the data in the column will be lost.
  - You are about to drop the column `assignedToId` on the `Task` table. All the data in the column will be lost.
  - You are about to drop the column `createdById` on the `Task` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `passwordHash` on the `User` table. All the data in the column will be lost.
  - The `role` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - A unique constraint covering the columns `[userId,date]` on the table `Attendance` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[employeeId]` on the table `Profile` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `checkIn` to the `Attendance` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Document` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Document` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Leave` table without a default value. This is not possible if the table is not empty.
  - Made the column `reason` on table `Leave` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `employeeId` to the `Profile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `firstName` to the `Profile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lastName` to the `Profile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `startDate` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `assignedTo` to the `Task` table without a default value. This is not possible if the table is not empty.
  - Made the column `dueDate` on table `Task` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `password` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('EMPLOYEE', 'MANAGER', 'ADMIN', 'FOUNDER');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('PENDING', 'UNDER_REVIEW', 'VERIFIED', 'REJECTED', 'RESUBMISSION_REQUIRED');

-- CreateEnum
CREATE TYPE "ProjectRole" AS ENUM ('LEADER', 'MEMBER');

-- CreateEnum
CREATE TYPE "Priority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "LeaveType" AS ENUM ('CASUAL', 'SICK', 'VACATION', 'UNPAID');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PROCESSED', 'PAID', 'FAILED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('TASK', 'LEAVE', 'DOCUMENT', 'ATTENDANCE', 'SALARY', 'GENERAL');

-- AlterEnum
ALTER TYPE "AttendanceStatus" ADD VALUE 'WORK_FROM_HOME';

-- AlterEnum
BEGIN;
CREATE TYPE "DocumentType_new" AS ENUM ('EDUCATIONAL', 'PROFESSIONAL', 'PERSONAL', 'OTHER');
ALTER TABLE "Document" ALTER COLUMN "type" TYPE "DocumentType_new" USING ("type"::text::"DocumentType_new");
ALTER TYPE "DocumentType" RENAME TO "DocumentType_old";
ALTER TYPE "DocumentType_new" RENAME TO "DocumentType";
DROP TYPE "DocumentType_old";
COMMIT;

-- AlterEnum
ALTER TYPE "LeaveStatus" ADD VALUE 'CANCELLED';

-- AlterEnum
BEGIN;
CREATE TYPE "ProjectStatus_new" AS ENUM ('PLANNING', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED');
ALTER TABLE "Project" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Project" ALTER COLUMN "status" TYPE "ProjectStatus_new" USING ("status"::text::"ProjectStatus_new");
ALTER TYPE "ProjectStatus" RENAME TO "ProjectStatus_old";
ALTER TYPE "ProjectStatus_new" RENAME TO "ProjectStatus";
DROP TYPE "ProjectStatus_old";
ALTER TABLE "Project" ALTER COLUMN "status" SET DEFAULT 'PLANNING';
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "TaskStatus_new" AS ENUM ('TODO', 'IN_PROGRESS', 'IN_REVIEW', 'COMPLETED', 'CANCELLED');
ALTER TABLE "Task" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Task" ALTER COLUMN "status" TYPE "TaskStatus_new" USING ("status"::text::"TaskStatus_new");
ALTER TYPE "TaskStatus" RENAME TO "TaskStatus_old";
ALTER TYPE "TaskStatus_new" RENAME TO "TaskStatus";
DROP TYPE "TaskStatus_old";
ALTER TABLE "Task" ALTER COLUMN "status" SET DEFAULT 'TODO';
COMMIT;

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_profileId_fkey";

-- DropForeignKey
ALTER TABLE "Profile" DROP CONSTRAINT "Profile_userId_fkey";

-- DropForeignKey
ALTER TABLE "Task" DROP CONSTRAINT "Task_assignedToId_fkey";

-- DropForeignKey
ALTER TABLE "Task" DROP CONSTRAINT "Task_createdById_fkey";

-- DropForeignKey
ALTER TABLE "Task" DROP CONSTRAINT "Task_projectId_fkey";

-- AlterTable
ALTER TABLE "Attendance" DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
ADD COLUMN     "checkIn" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "checkOut" TIMESTAMP(3),
ADD COLUMN     "notes" TEXT,
ADD COLUMN     "workHours" DOUBLE PRECISION,
ALTER COLUMN "date" SET DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "status" SET DEFAULT 'PRESENT';

-- AlterTable
ALTER TABLE "Document" DROP COLUMN "createdAt",
DROP COLUMN "profileId",
DROP COLUMN "updatedAt",
ADD COLUMN     "feedback" TEXT,
ADD COLUMN     "name" TEXT NOT NULL,
ADD COLUMN     "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "userId" TEXT NOT NULL,
ADD COLUMN     "verifiedAt" TIMESTAMP(3),
DROP COLUMN "status",
ADD COLUMN     "status" "VerificationStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Leave" ADD COLUMN     "approvedBy" TEXT,
ADD COLUMN     "type" "LeaveType" NOT NULL,
ALTER COLUMN "reason" SET NOT NULL;

-- AlterTable
ALTER TABLE "Profile" DROP COLUMN "avatar",
DROP COLUMN "bio",
ADD COLUMN     "accountNumber" TEXT,
ADD COLUMN     "address" TEXT,
ADD COLUMN     "bankName" TEXT,
ADD COLUMN     "dateOfBirth" TIMESTAMP(3),
ADD COLUMN     "department" TEXT,
ADD COLUMN     "designation" TEXT,
ADD COLUMN     "emergencyContact" TEXT,
ADD COLUMN     "employeeId" TEXT NOT NULL,
ADD COLUMN     "firstName" TEXT NOT NULL,
ADD COLUMN     "gender" TEXT,
ADD COLUMN     "ifscCode" TEXT,
ADD COLUMN     "joinDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "lastName" TEXT NOT NULL,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "profileImage" TEXT;

-- AlterTable
ALTER TABLE "Project" ADD COLUMN     "endDate" TIMESTAMP(3),
ADD COLUMN     "priority" "Priority" NOT NULL DEFAULT 'MEDIUM',
ADD COLUMN     "startDate" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "status" SET DEFAULT 'PLANNING';

-- AlterTable
ALTER TABLE "Task" DROP COLUMN "assignedToId",
DROP COLUMN "createdById",
ADD COLUMN     "actualHours" DOUBLE PRECISION,
ADD COLUMN     "assignedTo" TEXT NOT NULL,
ADD COLUMN     "estimatedHours" DOUBLE PRECISION,
ADD COLUMN     "priority" "Priority" NOT NULL DEFAULT 'MEDIUM',
ALTER COLUMN "status" SET DEFAULT 'TODO',
ALTER COLUMN "dueDate" SET NOT NULL,
ALTER COLUMN "projectId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "name",
DROP COLUMN "passwordHash",
ADD COLUMN     "isVerified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "password" TEXT NOT NULL,
DROP COLUMN "role",
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'EMPLOYEE';

-- DropEnum
DROP TYPE "DocumentStatus";

-- DropEnum
DROP TYPE "Role";

-- CreateTable
CREATE TABLE "ProjectMember" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "role" "ProjectRole" NOT NULL DEFAULT 'MEMBER',
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProjectMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TaskComment" (
    "id" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TaskComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Salary" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "month" TIMESTAMP(3) NOT NULL,
    "basicSalary" DOUBLE PRECISION NOT NULL,
    "allowances" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "deductions" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "bonus" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "netSalary" DOUBLE PRECISION NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "paymentDate" TIMESTAMP(3),

    CONSTRAINT "Salary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Performance" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "taskCompletion" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "qualityScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "timelineScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "collaborationScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "overallScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "reviewPeriod" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Performance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Department" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employee" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "managerId" TEXT,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ProjectMember_userId_projectId_key" ON "ProjectMember"("userId", "projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Salary_userId_month_key" ON "Salary"("userId", "month");

-- CreateIndex
CREATE UNIQUE INDEX "Performance_employeeId_key" ON "Performance"("employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "Department_name_key" ON "Department"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_userId_key" ON "Employee"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Attendance_userId_date_key" ON "Attendance"("userId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "Profile_employeeId_key" ON "Profile"("employeeId");

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectMember" ADD CONSTRAINT "ProjectMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectMember" ADD CONSTRAINT "ProjectMember_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Task" ADD CONSTRAINT "Task_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Task" ADD CONSTRAINT "Task_assignedTo_fkey" FOREIGN KEY ("assignedTo") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TaskComment" ADD CONSTRAINT "TaskComment_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "Task"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TaskComment" ADD CONSTRAINT "TaskComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Salary" ADD CONSTRAINT "Salary_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
