SET NOCOUNT ON

USE [master]
GO
CREATE DATABASE [ContosoUniversity]
GO
ALTER DATABASE [ContosoUniversity] SET COMPATIBILITY_LEVEL = 110
GO
ALTER DATABASE [ContosoUniversity] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [ContosoUniversity] SET ANSI_NULLS OFF
GO
ALTER DATABASE [ContosoUniversity] SET ANSI_PADDING OFF
GO
ALTER DATABASE [ContosoUniversity] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [ContosoUniversity] SET ARITHABORT OFF
GO
ALTER DATABASE [ContosoUniversity] SET AUTO_CLOSE ON
GO
ALTER DATABASE [ContosoUniversity] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [ContosoUniversity] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [ContosoUniversity] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [ContosoUniversity] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [ContosoUniversity] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [ContosoUniversity] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [ContosoUniversity] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [ContosoUniversity] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [ContosoUniversity] SET  DISABLE_BROKER
GO
ALTER DATABASE [ContosoUniversity] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [ContosoUniversity] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [ContosoUniversity] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [ContosoUniversity] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [ContosoUniversity] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [ContosoUniversity] SET READ_COMMITTED_SNAPSHOT ON
GO
ALTER DATABASE [ContosoUniversity] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [ContosoUniversity] SET RECOVERY SIMPLE
GO
ALTER DATABASE [ContosoUniversity] SET  MULTI_USER
GO
ALTER DATABASE [ContosoUniversity] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [ContosoUniversity] SET DB_CHAINING OFF
GO
ALTER DATABASE [ContosoUniversity] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [ContosoUniversity] SET TARGET_RECOVERY_TIME = 0 SECONDS
GO
USE [ContosoUniversity]
GO
/****** Object:  Table [dbo].[Course] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Credits] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Course] PRIMARY KEY CLUSTERED
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseInstructor] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseInstructor](
	[CourseID] [int] NOT NULL,
	[InstructorID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.CourseInstructor] PRIMARY KEY CLUSTERED
(
	[CourseID] ASC,
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Budget] [money] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[InstructorID] [int] NULL,
	[RowVersion] [timestamp] NOT NULL,
 CONSTRAINT [PK_dbo.Department] PRIMARY KEY CLUSTERED
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollment] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollment](
	[EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[CourseID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[Grade] [int] NULL,
 CONSTRAINT [PK_dbo.Enrollment] PRIMARY KEY CLUSTERED
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OfficeAssignment] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfficeAssignment](
	[InstructorID] [int] NOT NULL,
	[Location] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.OfficeAssignment] PRIMARY KEY CLUSTERED
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[HireDate] [datetime] NULL,
	[EnrollmentDate] [datetime] NULL,
	[Discriminator] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.Person] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCourseStudentCount] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCourseStudentCount]
AS
SELECT   Department.DepartmentID, Department.Name, Course.CourseID, Course.Title, COUNT(Enrollment.StudentID) AS StudentCount
FROM     Course
		 LEFT JOIN Department ON Course.DepartmentID = Department.DepartmentID
		 LEFT JOIN Enrollment ON Enrollment.CourseID = Course.CourseID
GROUP BY Department.DepartmentID, Department.Name, Course.CourseID, Course.Title
GO
/****** Object:  View [dbo].[vwCourseStudents] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCourseStudents]
AS
SELECT   Department.DepartmentID, Department.Name as DepartmentName,
		 Course.CourseID, Course.Title as CourseTitle,
		 Person.ID as StudentID, Person.FirstName + ' ' + Person.LastName as StudentName
FROM     Course
		 LEFT JOIN Department ON Course.DepartmentID = Department.DepartmentID
		 LEFT JOIN Enrollment ON Enrollment.CourseID = Course.CourseID
		 LEFT JOIN Person ON Enrollment.StudentID = Person.ID
GO
/****** Object:  View [dbo].[vwDepartmentCourseCount] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwDepartmentCourseCount]
AS
SELECT   Department.DepartmentID, Department.Name, COUNT(Course.CourseID) as CourseCount
FROM     Department LEFT JOIN Course ON Course.DepartmentID = Department.DepartmentID
GROUP BY Department.DepartmentID, Department.Name
GO
SET IDENTITY_INSERT [dbo].[Course] ON

INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (1, N'Entity Framework 6 開發實戰', 1, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (2, N'Git新手入門', 1, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (3, N'Git進階版控流程', 2, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (4, N'ASP.NET MVC 5 開發實戰', 5, 1)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (5, N'Javascript 新手入門', 1, 1)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (6, N'ASP.NET Core 3 開發實戰：從入門到進階', 5, 1)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (7, N'LINQ 語法入門', 3, 1)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (8, N'C# 開發實戰：非同步程式開發技巧', 3, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (9, N'.NET / C# 開發實戰：掌握相依性注入的觀念與開發技巧', 4, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (10, N'Angular 新手開發練功坊', 5, 5)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (12, N'十項超實用 Excel 技能 — 節省 50% 的工作效率', 2, 2)
INSERT [dbo].[Course] ([CourseID], [Title], [Credits], [DepartmentID]) VALUES (13, N'Windows Containers 微服務架構實戰', 4, 13)
SET IDENTITY_INSERT [dbo].[Course] OFF
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 1)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2, 1)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 1)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 2)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3, 2)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (5, 2)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 4)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2, 4)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (5, 4)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3, 18)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 18)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3, 20)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 20)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2, 21)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3, 21)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4, 21)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (5, 21)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 21)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 22)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2, 22)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 23)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (2, 23)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4, 23)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (3, 28)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4, 28)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (5, 28)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 28)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (1, 29)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (4, 29)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (6, 29)
INSERT [dbo].[CourseInstructor] ([CourseID], [InstructorID]) VALUES (5, 30)
SET IDENTITY_INSERT [dbo].[Department] ON

INSERT [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (1, N'教育訓練部', 1000.0000, CAST(N'2015-03-21T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (2, N'人事行政部', 1250.0000, CAST(N'2015-01-01T00:00:00.000' AS DateTime), 4)
INSERT [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (5, N'專案開發部', 1000.0000, CAST(N'2015-01-01T00:00:00.000' AS DateTime), 17)
INSERT [dbo].[Department] ([DepartmentID], [Name], [Budget], [StartDate], [InstructorID]) VALUES (13, N'產品開發部', 1000.0000, CAST(N'2015-01-01T00:00:00.000' AS DateTime), 30)
SET IDENTITY_INSERT [dbo].[Department] OFF
SET IDENTITY_INSERT [dbo].[Enrollment] ON

INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (2, 1, 1, 80)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (3, 1, 3, 70)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (4, 1, 5, 81)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (5, 1, 6, 86)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (6, 1, 7, 85)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (7, 1, 8, 75)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (8, 1, 9, 60)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (9, 3, 10, 0)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (10, 3, 11, 91)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (11, 3, 12, 92)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (12, 3, 13, 52)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (13, 1, 14, 59)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (14, 1, 15, 98)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (15, 2, 1, 65)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (16, 2, 3, 15)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (17, 13, 5, 84)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (18, 2, 6, 65)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (19, 4, 7, 60)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (21, 4, 8, 60)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (22, 2, 9, 21)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (23, 4, 10, 19)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (25, 4, 11, 52)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (26, 2, 12, 50)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (28, 2, 13, 59)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (29, 2, 14, 61)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (30, 2, 15, 67)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (31, 5, 1, 38)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (32, 5, 3, 31)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (33, 3, 5, 48)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (34, 5, 6, 41)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (35, 5, 7, 40)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (36, 5, 8, 19)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (37, 3, 9, 8)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (38, 12, 10, 99)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (39, 12, 11, 91)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (41, 12, 12, 80)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (42, 13, 13, 51)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (43, 13, 14, 67)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (44, 3, 15, 82)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (45, 4, 1, 46)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (46, 4, 3, 51)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (47, 4, 5, 34)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (48, 4, 6, 29)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (49, 10, 7, 81)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (50, 10, 8, 57)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (51, 4, 9, 96)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (52, 4, 10, 84)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (53, 4, 11, 75)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (54, 4, 12, 68)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (55, 4, 13, 12)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (56, 4, 14, 34)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (57, 4, 15, 89)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (58, 5, 1, 21)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (59, 5, 3, 94)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (60, 5, 5, 15)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (61, 5, 6, 36)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (62, 5, 7, 54)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (63, 8, 8, 85)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (64, 8, 9, 65)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (65, 8, 10, 8)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (66, 8, 11, 2)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (67, 5, 12, 19)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (68, 9, 13, 94)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (69, 9, 14, 98)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (70, 5, 15, 56)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (71, 6, 1, 88)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (72, 6, 3, 86)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (73, 6, 5, 81)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (74, 6, 6, 76)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (75, 6, 7, 57)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (77, 6, 8, 67)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (78, 7, 9, 66)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (79, 7, 10, 51)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (80, 7, 11, 51)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (81, 7, 12, 34)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (83, 7, 13, 45)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (84, 6, 14, 44)
INSERT [dbo].[Enrollment] ([EnrollmentID], [CourseID], [StudentID], [Grade]) VALUES (85, 7, 15, 49)
SET IDENTITY_INSERT [dbo].[Enrollment] OFF
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (2, N'Taipei')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (4, N'Taipei')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (16, N'Taichung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (17, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (18, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (19, N'Taichung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (20, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (21, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (22, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (23, N'Kaohsiung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (28, N'Taipei')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (29, N'Taichung')
INSERT [dbo].[OfficeAssignment] ([InstructorID], [Location]) VALUES (30, N'Kaohsiung')
SET IDENTITY_INSERT [dbo].[Person] ON

INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (1, N'Huang', N'Will', NULL, CAST(N'2015-03-21T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (2, N'Huang', N'Will', CAST(N'2015-01-01T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (3, N'Wang', N'Eric', CAST(N'2014-09-01T00:00:00.000' AS DateTime), CAST(N'2015-03-21T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (4, N'Lu', N'David', CAST(N'2015-03-02T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (5, N'White', N'Senior', CAST(N'2013-03-01T00:00:00.000' AS DateTime), CAST(N'2015-01-21T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (6, N'Norman', N'Albert', CAST(N'2013-05-26T00:00:00.000' AS DateTime), CAST(N'2015-02-11T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (7, N'Voyager', N'Geraldine', CAST(N'2013-06-17T00:00:00.000' AS DateTime), CAST(N'2015-02-06T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (8, N'Downs', N'Irving', CAST(N'2013-06-17T00:00:00.000' AS DateTime), CAST(N'2015-01-29T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (9, N'Castle', N'Gregg', CAST(N'2010-12-31T00:00:00.000' AS DateTime), CAST(N'2015-03-08T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (10, N'Taylor', N'Israel', CAST(N'2012-01-15T00:00:00.000' AS DateTime), CAST(N'2015-03-21T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (11, N'Thomas', N'Brian', CAST(N'2015-03-02T00:00:00.000' AS DateTime), CAST(N'2015-03-25T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (12, N'Green', N'Alfonso', CAST(N'1953-01-21T00:00:00.000' AS DateTime), CAST(N'2015-01-16T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (13, N'Banks', N'Troy', CAST(N'2015-03-02T00:00:00.000' AS DateTime), CAST(N'2015-01-31T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (14, N'Vine', N'Chad', CAST(N'1944-08-17T00:00:00.000' AS DateTime), CAST(N'2015-02-01T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (15, N'Jackson', N'Robin', CAST(N'2015-03-02T00:00:00.000' AS DateTime), CAST(N'2015-02-20T00:00:00.000' AS DateTime), N'Student')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (16, N'Ward', N'Cunningham', CAST(N'1949-05-26T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (17, N'Be', N'Leuf', CAST(N'1949-05-26T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (18, N'Gates', N'Bill', CAST(N'1955-10-28T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (19, N'popo', N'Paul', CAST(N'1953-01-21T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (20, N'Paul', N'Gardner Allen', CAST(N'1953-01-21T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (21, N'W. Thompson', N'John', CAST(N'1949-04-24T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (22, N'Nadella', N'Satya', CAST(N'1967-01-10T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (23, N'Larry', N'Ellison', CAST(N'1944-08-17T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (28, N'Larry', N'Page', CAST(N'1973-03-26T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (29, N'Schmidt', N'Eric', CAST(N'1955-04-27T00:00:00.000' AS DateTime), NULL, N'Instructor')
INSERT [dbo].[Person] ([ID], [LastName], [FirstName], [HireDate], [EnrollmentDate], [Discriminator]) VALUES (30, N'Doerr', N'John', CAST(N'1951-06-29T00:00:00.000' AS DateTime), NULL, N'Instructor')
SET IDENTITY_INSERT [dbo].[Person] OFF
/****** Object:  Index [IX_DepartmentID] ******/
CREATE NONCLUSTERED INDEX [IX_DepartmentID] ON [dbo].[Course]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CourseID] ******/
CREATE NONCLUSTERED INDEX [IX_CourseID] ON [dbo].[CourseInstructor]
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InstructorID] ******/
CREATE NONCLUSTERED INDEX [IX_InstructorID] ON [dbo].[CourseInstructor]
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InstructorID] ******/
CREATE NONCLUSTERED INDEX [IX_InstructorID] ON [dbo].[Department]
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CourseID] ******/
CREATE NONCLUSTERED INDEX [IX_CourseID] ON [dbo].[Enrollment]
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StudentID] ******/
CREATE NONCLUSTERED INDEX [IX_StudentID] ON [dbo].[Enrollment]
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InstructorID] ******/
CREATE NONCLUSTERED INDEX [IX_InstructorID] ON [dbo].[OfficeAssignment]
(
	[InstructorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF__Course__Departme__1CF15040]  DEFAULT ((1)) FOR [DepartmentID]
GO
ALTER TABLE [dbo].[Person] ADD  DEFAULT ('Instructor') FOR [Discriminator]
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Course_dbo.Department_DepartmentID] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK_dbo.Course_dbo.Department_DepartmentID]
GO
ALTER TABLE [dbo].[CourseInstructor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CourseInstructor_dbo.Course_CourseID] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK CONSTRAINT [FK_dbo.CourseInstructor_dbo.Course_CourseID]
GO
ALTER TABLE [dbo].[CourseInstructor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CourseInstructor_dbo.Instructor_InstructorID] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK CONSTRAINT [FK_dbo.CourseInstructor_dbo.Instructor_InstructorID]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.Instructor_InstructorID] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.Instructor_InstructorID]
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Enrollment_dbo.Course_CourseID] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_dbo.Enrollment_dbo.Course_CourseID]
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Enrollment_dbo.Person_StudentID] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Person] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_dbo.Enrollment_dbo.Person_StudentID]
GO
ALTER TABLE [dbo].[OfficeAssignment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OfficeAssignment_dbo.Instructor_InstructorID] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[OfficeAssignment] CHECK CONSTRAINT [FK_dbo.OfficeAssignment_dbo.Instructor_InstructorID]
GO
/****** Object:  StoredProcedure [dbo].[Department_Delete] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Department_Delete]
    @DepartmentID [int],
    @RowVersion_Original [rowversion]
AS
BEGIN
    DELETE [dbo].[Department]
    WHERE (([DepartmentID] = @DepartmentID) AND (([RowVersion] = @RowVersion_Original) OR ([RowVersion] IS NULL AND @RowVersion_Original IS NULL)))
END


GO
/****** Object:  StoredProcedure [dbo].[Department_Insert] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Department_Insert]
    @Name [nvarchar](50),
    @Budget [money],
    @StartDate [datetime],
    @InstructorID [int]
AS
BEGIN
    INSERT [dbo].[Department]([Name], [Budget], [StartDate], [InstructorID])
    VALUES (@Name, @Budget, @StartDate, @InstructorID)

    DECLARE @DepartmentID int
    SELECT @DepartmentID = [DepartmentID]
    FROM [dbo].[Department]
    WHERE @@ROWCOUNT > 0 AND [DepartmentID] = scope_identity()

    SELECT t0.[DepartmentID], t0.[RowVersion]
    FROM [dbo].[Department] AS t0
    WHERE @@ROWCOUNT > 0 AND t0.[DepartmentID] = @DepartmentID
END


GO
/****** Object:  StoredProcedure [dbo].[Department_Update] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Department_Update]
    @DepartmentID [int],
    @Name [nvarchar](50),
    @Budget [money],
    @StartDate [datetime],
    @InstructorID [int],
    @RowVersion_Original [rowversion]
AS
BEGIN
    UPDATE [dbo].[Department]
    SET [Name] = @Name, [Budget] = @Budget, [StartDate] = @StartDate, [InstructorID] = @InstructorID
    WHERE (([DepartmentID] = @DepartmentID) AND (([RowVersion] = @RowVersion_Original) OR ([RowVersion] IS NULL AND @RowVersion_Original IS NULL)))

    SELECT t0.[RowVersion]
    FROM [dbo].[Department] AS t0
    WHERE @@ROWCOUNT > 0 AND t0.[DepartmentID] = @DepartmentID
END


GO
USE [master]
GO
ALTER DATABASE [ContosoUniversity] SET  READ_WRITE
GO