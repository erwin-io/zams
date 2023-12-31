PGDMP          #                {            zamsdb_backup    15.4    15.4 �    Y           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Z           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            [           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            \           1262    29355    zamsdb_backup    DATABASE     �   CREATE DATABASE zamsdb_backup WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE zamsdb_backup;
                postgres    false                        2615    38833    dbo    SCHEMA        CREATE SCHEMA dbo;
    DROP SCHEMA dbo;
                postgres    false                       1255    38835    usp_reset() 	   PROCEDURE     �	  CREATE PROCEDURE dbo.usp_reset()
    LANGUAGE plpgsql
    AS $_$
begin

	DELETE FROM dbo."LinkStudentRequest";
	DELETE FROM dbo."EmployeeUser";
	DELETE FROM dbo."UserFirebaseToken";
	DELETE FROM dbo."StudentStrand";
	DELETE FROM dbo."Strands";
	DELETE FROM dbo."StudentCourse";
	DELETE FROM dbo."StudentSection";
	DELETE FROM dbo."SchoolRequestAccess";
	DELETE FROM dbo."Operators";
	DELETE FROM dbo."TapLogs";
	DELETE FROM dbo."Machines";
	DELETE FROM dbo."Notifications";
	DELETE FROM dbo."UserFirebaseToken";
	DELETE FROM dbo."ParentStudent";
	DELETE FROM dbo."Parents";
	DELETE FROM dbo."Students";
	DELETE FROM dbo."Courses";
	DELETE FROM dbo."Sections";
	DELETE FROM dbo."Employees";
	DELETE FROM dbo."EmployeeRoles";
	DELETE FROM dbo."EmployeeTitles";
	DELETE FROM dbo."Departments";
	DELETE FROM dbo."SchoolYearLevels";
	DELETE FROM dbo."Schools";
	DELETE FROM dbo."UserProfilePic";
	DELETE FROM dbo."Files";
	DELETE FROM dbo."Users";
	
	ALTER SEQUENCE dbo."Strands_StrandId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Files_FileId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."LinkStudentRequest_LinkStudentRequestId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Operators_OperatorId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Schools_SchoolId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."SchoolYearLevels_SchoolYearLevelId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."EmployeeRoles_EmployeeRoleId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Departments_DepartmentId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Sections_SectionId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Courses_CourseId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Users_UserId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Employees_EmployeeId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."EmployeeTitles_EmployeeTitleId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Students_StudentId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Parents_ParentId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Notifications_NotificationId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."Machines_MachineId_seq" RESTART WITH 1;
	ALTER SEQUENCE dbo."TapLogs_TapLogId_seq" RESTART WITH 1;
	
	INSERT INTO dbo."Users" (
		"UserCode",
		"UserName",
		"Password", 
		"UserType",
		"DateRegistered")
	VALUES (
			'000001',
			'admin',
			'$2b$10$LqN3kzfgaYnP5PfDZFfT4edUFqh5Lu7amIxeDDDmu/KEqQFze.p8a',  
			'OPERATOR',
			(now() AT TIME ZONE 'Asia/Manila'::text)
	);

	INSERT INTO dbo."Operators" (
		"OperatorCode",
		"UserId",
		"Name",
		"AccessGranted")
	VALUES (
			'000001',
			1,
			'Admin Admin',
			true
	);
	
END;
$_$;
     DROP PROCEDURE dbo.usp_reset();
       dbo          postgres    false    6            �            1259    38836    Courses    TABLE     �  CREATE TABLE dbo."Courses" (
    "CourseId" bigint NOT NULL,
    "CourseCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Name" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Courses";
       dbo         heap    postgres    false    6            �            1259    38843    Courses_CourseId_seq    SEQUENCE     �   ALTER TABLE dbo."Courses" ALTER COLUMN "CourseId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Courses_CourseId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    215            �            1259    38844    Departments    TABLE     �  CREATE TABLE dbo."Departments" (
    "DepartmentId" bigint NOT NULL,
    "DepartmentCode" character varying,
    "SchoolId" bigint NOT NULL,
    "DepartmentName" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Departments";
       dbo         heap    postgres    false    6            �            1259    38851    Departments_DepartmentId_seq    SEQUENCE     �   ALTER TABLE dbo."Departments" ALTER COLUMN "DepartmentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Departments_DepartmentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    217    6            �            1259    38852    EmployeeRoles    TABLE     �  CREATE TABLE dbo."EmployeeRoles" (
    "EmployeeRoleId" bigint NOT NULL,
    "EmployeeRoleCode" character varying,
    "Name" character varying NOT NULL,
    "EmployeeRoleAccess" json DEFAULT '[]'::json NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "SchoolId" bigint NOT NULL,
    "Active" boolean DEFAULT true NOT NULL
);
     DROP TABLE dbo."EmployeeRoles";
       dbo         heap    postgres    false    6            �            1259    38860     EmployeeRoles_EmployeeRoleId_seq    SEQUENCE     �   ALTER TABLE dbo."EmployeeRoles" ALTER COLUMN "EmployeeRoleId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EmployeeRoles_EmployeeRoleId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    219            �            1259    38861    EmployeeTitles    TABLE     �  CREATE TABLE dbo."EmployeeTitles" (
    "EmployeeTitleId" bigint NOT NULL,
    "EmployeeTitleCode" character varying,
    "Name" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "SchoolId" bigint NOT NULL
);
 !   DROP TABLE dbo."EmployeeTitles";
       dbo         heap    postgres    false    6            �            1259    38868 "   EmployeeTitles_EmployeeTitleId_seq    SEQUENCE     �   ALTER TABLE dbo."EmployeeTitles" ALTER COLUMN "EmployeeTitleId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EmployeeTitles_EmployeeTitleId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    221    6            �            1259    38869    EmployeeUser    TABLE     �   CREATE TABLE dbo."EmployeeUser" (
    "EmployeeId" bigint NOT NULL,
    "UserId" bigint NOT NULL,
    "DateRegistered" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "EmployeeRoleId" bigint
);
    DROP TABLE dbo."EmployeeUser";
       dbo         heap    postgres    false    6            �            1259    38873 	   Employees    TABLE     1  CREATE TABLE dbo."Employees" (
    "EmployeeId" bigint NOT NULL,
    "EmployeeCode" character varying,
    "EmployeePositionId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleInitial" character varying,
    "LastName" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "SchoolId" bigint NOT NULL,
    "Active" boolean DEFAULT true NOT NULL,
    "AccessGranted" boolean DEFAULT false NOT NULL,
    "MobileNumber" character varying NOT NULL,
    "CardNumber" character varying NOT NULL,
    "DepartmentId" bigint NOT NULL,
    "FullName" character varying DEFAULT ''::character varying NOT NULL
);
    DROP TABLE dbo."Employees";
       dbo         heap    postgres    false    6            �            1259    38882    Employees_EmployeeId_seq    SEQUENCE     �   ALTER TABLE dbo."Employees" ALTER COLUMN "EmployeeId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Employees_EmployeeId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    224            �            1259    38883    Files    TABLE     i   CREATE TABLE dbo."Files" (
    "FileId" bigint NOT NULL,
    "FileName" text NOT NULL,
    "Url" text
);
    DROP TABLE dbo."Files";
       dbo         heap    postgres    false    6            �            1259    38888    Files_FileId_seq    SEQUENCE     �   ALTER TABLE dbo."Files" ALTER COLUMN "FileId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Files_FileId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    226    6            �            1259    38889    LinkStudentRequest    TABLE       CREATE TABLE dbo."LinkStudentRequest" (
    "LinkStudentRequestId" bigint NOT NULL,
    "SchoolId" bigint NOT NULL,
    "StudentId" bigint NOT NULL,
    "Status" character varying DEFAULT 'PENDING'::character varying NOT NULL,
    "DateRequested" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RequestedByParentId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Notes" character varying,
    "LinkStudentRequestCode" character varying
);
 %   DROP TABLE dbo."LinkStudentRequest";
       dbo         heap    postgres    false    6            �            1259    38896 +   LinkStudentRequest_LinkStudentRequestId_seq    SEQUENCE       ALTER TABLE dbo."LinkStudentRequest" ALTER COLUMN "LinkStudentRequestId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."LinkStudentRequest_LinkStudentRequestId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    228    6            �            1259    38897    Machines    TABLE     �  CREATE TABLE dbo."Machines" (
    "MachineId" bigint NOT NULL,
    "MachineCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Description" character varying NOT NULL,
    "Path" character varying,
    "Domain" character varying,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Machines";
       dbo         heap    postgres    false    6            �            1259    38904    Machines_MachineId_seq    SEQUENCE     �   ALTER TABLE dbo."Machines" ALTER COLUMN "MachineId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Machines_MachineId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    230    6            �            1259    38905    Notifications    TABLE     �  CREATE TABLE dbo."Notifications" (
    "NotificationId" bigint NOT NULL,
    "ForUserId" bigint NOT NULL,
    "Type" character varying NOT NULL,
    "Title" character varying NOT NULL,
    "Description" character varying NOT NULL,
    "DateTime" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "IsRead" boolean DEFAULT false NOT NULL,
    "Active" boolean DEFAULT true NOT NULL,
    "ReferenceId" character varying DEFAULT ''::character varying NOT NULL
);
     DROP TABLE dbo."Notifications";
       dbo         heap    postgres    false    6            �            1259    38914     Notifications_NotificationId_seq    SEQUENCE     �   ALTER TABLE dbo."Notifications" ALTER COLUMN "NotificationId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Notifications_NotificationId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    232            �            1259    38915 	   Operators    TABLE       CREATE TABLE dbo."Operators" (
    "OperatorId" bigint NOT NULL,
    "OperatorCode" character varying,
    "UserId" bigint NOT NULL,
    "Name" character varying NOT NULL,
    "Active" boolean DEFAULT true NOT NULL,
    "AccessGranted" boolean DEFAULT false NOT NULL
);
    DROP TABLE dbo."Operators";
       dbo         heap    postgres    false    6            �            1259    38922    Operators_OperatorId_seq    SEQUENCE     �   ALTER TABLE dbo."Operators" ALTER COLUMN "OperatorId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Operators_OperatorId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    234            �            1259    38923    ParentStudent    TABLE     �   CREATE TABLE dbo."ParentStudent" (
    "ParentId" bigint NOT NULL,
    "StudentId" bigint NOT NULL,
    "DateAdded" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "Active" boolean DEFAULT true NOT NULL
);
     DROP TABLE dbo."ParentStudent";
       dbo         heap    postgres    false    6            �            1259    38928    Parents    TABLE     
  CREATE TABLE dbo."Parents" (
    "ParentId" bigint NOT NULL,
    "ParentCode" character varying,
    "UserId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleInitial" character varying,
    "LastName" character varying NOT NULL,
    "Gender" character varying NOT NULL,
    "BirthDate" date,
    "MobileNumber" character varying NOT NULL,
    "Email" character varying,
    "Address" character varying NOT NULL,
    "RegistrationDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RegisteredByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "FullName" character varying DEFAULT ''::character varying NOT NULL
);
    DROP TABLE dbo."Parents";
       dbo         heap    postgres    false    6            �            1259    38936    Parents_ParentId_seq    SEQUENCE     �   ALTER TABLE dbo."Parents" ALTER COLUMN "ParentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Parents_ParentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    237            �            1259    38937    SchoolRequestAccess    TABLE     |  CREATE TABLE dbo."SchoolRequestAccess" (
    "SchoolRequestAccessId" bigint NOT NULL,
    "SchoolId" bigint NOT NULL,
    "Status" character varying NOT NULL,
    "DateRequested" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RequestedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint
);
 &   DROP TABLE dbo."SchoolRequestAccess";
       dbo         heap    postgres    false    6            �            1259    38943 -   SchoolRequestAccess_SchoolRequestAccessId_seq    SEQUENCE       ALTER TABLE dbo."SchoolRequestAccess" ALTER COLUMN "SchoolRequestAccessId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."SchoolRequestAccess_SchoolRequestAccessId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    239    6            �            1259    38944    SchoolYearLevels    TABLE       CREATE TABLE dbo."SchoolYearLevels" (
    "SchoolYearLevelId" bigint NOT NULL,
    "SchoolYearLevelCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Name" character varying,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "EducationalStage" character varying DEFAULT ''::character varying NOT NULL
);
 #   DROP TABLE dbo."SchoolYearLevels";
       dbo         heap    postgres    false    6            �            1259    38952 &   SchoolYearLevels_SchoolYearLevelId_seq    SEQUENCE     �   ALTER TABLE dbo."SchoolYearLevels" ALTER COLUMN "SchoolYearLevelId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."SchoolYearLevels_SchoolYearLevelId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    241            �            1259    38953    Schools    TABLE       CREATE TABLE dbo."Schools" (
    "SchoolId" bigint NOT NULL,
    "SchoolCode" character varying,
    "SchoolName" character varying NOT NULL,
    "StudentsAllowableTimeLate" character varying,
    "StudentsTimeLate" character varying,
    "RestrictGuardianTime" boolean,
    "EmployeesTimeBeforeSwipeIsAllowed" character varying,
    "EmployeesAllowableTimeLate" character varying,
    "EmployeesTimeLate" character varying,
    "TimeBeforeSwipeIsAllowed" character varying,
    "SMSNotificationForStaffEntry" character varying,
    "SMSNotificationForStudentBreakTime" character varying,
    "SchoolContactNumber" character varying,
    "SchoolAddress" character varying,
    "SchoolEmail" character varying,
    "DateRegistered" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RegisteredByUserId" bigint NOT NULL,
    "DateUpdated" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "OrgSchoolCode" character varying DEFAULT ''::character varying NOT NULL
);
    DROP TABLE dbo."Schools";
       dbo         heap    postgres    false    6            �            1259    38961    Schools_SchoolId_seq    SEQUENCE     �   ALTER TABLE dbo."Schools" ALTER COLUMN "SchoolId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Schools_SchoolId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    243            �            1259    38962    Sections    TABLE     -  CREATE TABLE dbo."Sections" (
    "SectionId" bigint NOT NULL,
    "SectionCode" character varying,
    "DepartmentId" bigint NOT NULL,
    "SchoolYearLevelId" bigint NOT NULL,
    "SectionName" character varying NOT NULL,
    "AdviserEmployeeId" bigint NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "SchoolId" bigint NOT NULL
);
    DROP TABLE dbo."Sections";
       dbo         heap    postgres    false    6            �            1259    38969    Sections_SectionId_seq    SEQUENCE     �   ALTER TABLE dbo."Sections" ALTER COLUMN "SectionId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Sections_SectionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    245            �            1259    38970    Strands    TABLE     �  CREATE TABLE dbo."Strands" (
    "StrandId" bigint NOT NULL,
    "StrandCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Name" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Strands";
       dbo         heap    postgres    false    6            �            1259    38977    Strands_StrandId_seq    SEQUENCE     �   ALTER TABLE dbo."Strands" ALTER COLUMN "StrandId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Strands_StrandId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    247            �            1259    38978    StudentCourse    TABLE     �   CREATE TABLE dbo."StudentCourse" (
    "StudentId" bigint NOT NULL,
    "CourseId" bigint NOT NULL,
    "EnrolledDate" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
     DROP TABLE dbo."StudentCourse";
       dbo         heap    postgres    false    6            �            1259    38982    StudentSection    TABLE     �   CREATE TABLE dbo."StudentSection" (
    "StudentId" bigint NOT NULL,
    "SectionId" bigint NOT NULL,
    "DateAdded" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
 !   DROP TABLE dbo."StudentSection";
       dbo         heap    postgres    false    6            �            1259    38986    StudentStrand    TABLE     �   CREATE TABLE dbo."StudentStrand" (
    "StudentId" bigint NOT NULL,
    "StrandId" bigint NOT NULL,
    "EnrolledDate" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
     DROP TABLE dbo."StudentStrand";
       dbo         heap    postgres    false    6            �            1259    38990    Students    TABLE     �  CREATE TABLE dbo."Students" (
    "StudentId" bigint NOT NULL,
    "StudentCode" character varying,
    "DepartmentId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleInitial" character varying,
    "LastName" character varying NOT NULL,
    "CardNumber" character varying NOT NULL,
    "MobileNumber" character varying NOT NULL,
    "Email" character varying,
    "Address" character varying,
    "AccessGranted" boolean DEFAULT false,
    "RegistrationDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RegisteredByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "SchoolId" bigint NOT NULL,
    "SchoolYearLevelId" bigint NOT NULL,
    "FullName" character varying DEFAULT ''::character varying NOT NULL,
    "OrgStudentId" character varying DEFAULT ''::character varying NOT NULL
);
    DROP TABLE dbo."Students";
       dbo         heap    postgres    false    6            �            1259    39000    Students_StudentId_seq    SEQUENCE     �   ALTER TABLE dbo."Students" ALTER COLUMN "StudentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Students_StudentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    252    6            �            1259    39001    TapLogs    TABLE       CREATE TABLE dbo."TapLogs" (
    "TapLogId" bigint NOT NULL,
    "StudentId" bigint NOT NULL,
    "Status" character varying NOT NULL,
    "MachineId" bigint NOT NULL,
    "Date" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "Time" character varying NOT NULL
);
    DROP TABLE dbo."TapLogs";
       dbo         heap    postgres    false    6            �            1259    39007    TapLogs_TapLogId_seq    SEQUENCE     �   ALTER TABLE dbo."TapLogs" ALTER COLUMN "TapLogId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."TapLogs_TapLogId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    254    6                        1259    39008    UserFirebaseToken    TABLE     �   CREATE TABLE dbo."UserFirebaseToken" (
    "UserId" bigint NOT NULL,
    "FirebaseToken" character varying NOT NULL,
    "Device" character varying NOT NULL
);
 $   DROP TABLE dbo."UserFirebaseToken";
       dbo         heap    postgres    false    6                       1259    39013    UserProfilePic    TABLE     b   CREATE TABLE dbo."UserProfilePic" (
    "UserId" bigint NOT NULL,
    "FileId" bigint NOT NULL
);
 !   DROP TABLE dbo."UserProfilePic";
       dbo         heap    postgres    false    6                       1259    39016    Users    TABLE     �  CREATE TABLE dbo."Users" (
    "UserId" bigint NOT NULL,
    "UserCode" character varying,
    "UserName" character varying NOT NULL,
    "Password" character varying NOT NULL,
    "UserType" character varying NOT NULL,
    "DateRegistered" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "DateUpdated" timestamp with time zone,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Users";
       dbo         heap    postgres    false    6                       1259    39023    Users_UserId_seq    SEQUENCE     �   ALTER TABLE dbo."Users" ALTER COLUMN "UserId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Users_UserId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    258            *          0    38836    Courses 
   TABLE DATA           �   COPY dbo."Courses" ("CourseId", "CourseCode", "SchoolId", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    215   m@      ,          0    38844    Departments 
   TABLE DATA           �   COPY dbo."Departments" ("DepartmentId", "DepartmentCode", "SchoolId", "DepartmentName", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    217   �@      .          0    38852    EmployeeRoles 
   TABLE DATA           �   COPY dbo."EmployeeRoles" ("EmployeeRoleId", "EmployeeRoleCode", "Name", "EmployeeRoleAccess", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "SchoolId", "Active") FROM stdin;
    dbo          postgres    false    219   �@      0          0    38861    EmployeeTitles 
   TABLE DATA           �   COPY dbo."EmployeeTitles" ("EmployeeTitleId", "EmployeeTitleCode", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId") FROM stdin;
    dbo          postgres    false    221   �@      2          0    38869    EmployeeUser 
   TABLE DATA           a   COPY dbo."EmployeeUser" ("EmployeeId", "UserId", "DateRegistered", "EmployeeRoleId") FROM stdin;
    dbo          postgres    false    223   �@      3          0    38873 	   Employees 
   TABLE DATA           %  COPY dbo."Employees" ("EmployeeId", "EmployeeCode", "EmployeePositionId", "FirstName", "MiddleInitial", "LastName", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "SchoolId", "Active", "AccessGranted", "MobileNumber", "CardNumber", "DepartmentId", "FullName") FROM stdin;
    dbo          postgres    false    224   �@      5          0    38883    Files 
   TABLE DATA           ;   COPY dbo."Files" ("FileId", "FileName", "Url") FROM stdin;
    dbo          postgres    false    226   A      7          0    38889    LinkStudentRequest 
   TABLE DATA           �   COPY dbo."LinkStudentRequest" ("LinkStudentRequestId", "SchoolId", "StudentId", "Status", "DateRequested", "RequestedByParentId", "UpdatedDate", "UpdatedByUserId", "Notes", "LinkStudentRequestCode") FROM stdin;
    dbo          postgres    false    228   8A      9          0    38897    Machines 
   TABLE DATA           �   COPY dbo."Machines" ("MachineId", "MachineCode", "SchoolId", "Description", "Path", "Domain", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    230   UA      ;          0    38905    Notifications 
   TABLE DATA           �   COPY dbo."Notifications" ("NotificationId", "ForUserId", "Type", "Title", "Description", "DateTime", "IsRead", "Active", "ReferenceId") FROM stdin;
    dbo          postgres    false    232   rA      =          0    38915 	   Operators 
   TABLE DATA           m   COPY dbo."Operators" ("OperatorId", "OperatorCode", "UserId", "Name", "Active", "AccessGranted") FROM stdin;
    dbo          postgres    false    234   �A      ?          0    38923    ParentStudent 
   TABLE DATA           V   COPY dbo."ParentStudent" ("ParentId", "StudentId", "DateAdded", "Active") FROM stdin;
    dbo          postgres    false    236   �A      @          0    38928    Parents 
   TABLE DATA             COPY dbo."Parents" ("ParentId", "ParentCode", "UserId", "FirstName", "MiddleInitial", "LastName", "Gender", "BirthDate", "MobileNumber", "Email", "Address", "RegistrationDate", "RegisteredByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "FullName") FROM stdin;
    dbo          postgres    false    237   �A      B          0    38937    SchoolRequestAccess 
   TABLE DATA           �   COPY dbo."SchoolRequestAccess" ("SchoolRequestAccessId", "SchoolId", "Status", "DateRequested", "RequestedByUserId", "UpdatedDate", "UpdatedByUserId") FROM stdin;
    dbo          postgres    false    239   �A      D          0    38944    SchoolYearLevels 
   TABLE DATA           �   COPY dbo."SchoolYearLevels" ("SchoolYearLevelId", "SchoolYearLevelCode", "SchoolId", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "EducationalStage") FROM stdin;
    dbo          postgres    false    241   B      F          0    38953    Schools 
   TABLE DATA           �  COPY dbo."Schools" ("SchoolId", "SchoolCode", "SchoolName", "StudentsAllowableTimeLate", "StudentsTimeLate", "RestrictGuardianTime", "EmployeesTimeBeforeSwipeIsAllowed", "EmployeesAllowableTimeLate", "EmployeesTimeLate", "TimeBeforeSwipeIsAllowed", "SMSNotificationForStaffEntry", "SMSNotificationForStudentBreakTime", "SchoolContactNumber", "SchoolAddress", "SchoolEmail", "DateRegistered", "RegisteredByUserId", "DateUpdated", "UpdatedByUserId", "Active", "OrgSchoolCode") FROM stdin;
    dbo          postgres    false    243   5B      H          0    38962    Sections 
   TABLE DATA           �   COPY dbo."Sections" ("SectionId", "SectionCode", "DepartmentId", "SchoolYearLevelId", "SectionName", "AdviserEmployeeId", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId") FROM stdin;
    dbo          postgres    false    245   RB      J          0    38970    Strands 
   TABLE DATA           �   COPY dbo."Strands" ("StrandId", "StrandCode", "SchoolId", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    247   oB      L          0    38978    StudentCourse 
   TABLE DATA           O   COPY dbo."StudentCourse" ("StudentId", "CourseId", "EnrolledDate") FROM stdin;
    dbo          postgres    false    249   �B      M          0    38982    StudentSection 
   TABLE DATA           N   COPY dbo."StudentSection" ("StudentId", "SectionId", "DateAdded") FROM stdin;
    dbo          postgres    false    250   �B      N          0    38986    StudentStrand 
   TABLE DATA           O   COPY dbo."StudentStrand" ("StudentId", "StrandId", "EnrolledDate") FROM stdin;
    dbo          postgres    false    251   �B      O          0    38990    Students 
   TABLE DATA           M  COPY dbo."Students" ("StudentId", "StudentCode", "DepartmentId", "FirstName", "MiddleInitial", "LastName", "CardNumber", "MobileNumber", "Email", "Address", "AccessGranted", "RegistrationDate", "RegisteredByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId", "SchoolYearLevelId", "FullName", "OrgStudentId") FROM stdin;
    dbo          postgres    false    252   �B      Q          0    39001    TapLogs 
   TABLE DATA           `   COPY dbo."TapLogs" ("TapLogId", "StudentId", "Status", "MachineId", "Date", "Time") FROM stdin;
    dbo          postgres    false    254    C      S          0    39008    UserFirebaseToken 
   TABLE DATA           O   COPY dbo."UserFirebaseToken" ("UserId", "FirebaseToken", "Device") FROM stdin;
    dbo          postgres    false    256   C      T          0    39013    UserProfilePic 
   TABLE DATA           ;   COPY dbo."UserProfilePic" ("UserId", "FileId") FROM stdin;
    dbo          postgres    false    257   :C      U          0    39016    Users 
   TABLE DATA           �   COPY dbo."Users" ("UserId", "UserCode", "UserName", "Password", "UserType", "DateRegistered", "DateUpdated", "Active") FROM stdin;
    dbo          postgres    false    258   WC      ]           0    0    Courses_CourseId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."Courses_CourseId_seq"', 1, false);
          dbo          postgres    false    216            ^           0    0    Departments_DepartmentId_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('dbo."Departments_DepartmentId_seq"', 1, false);
          dbo          postgres    false    218            _           0    0     EmployeeRoles_EmployeeRoleId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('dbo."EmployeeRoles_EmployeeRoleId_seq"', 1, false);
          dbo          postgres    false    220            `           0    0 "   EmployeeTitles_EmployeeTitleId_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('dbo."EmployeeTitles_EmployeeTitleId_seq"', 1, false);
          dbo          postgres    false    222            a           0    0    Employees_EmployeeId_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('dbo."Employees_EmployeeId_seq"', 1, false);
          dbo          postgres    false    225            b           0    0    Files_FileId_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('dbo."Files_FileId_seq"', 1, false);
          dbo          postgres    false    227            c           0    0 +   LinkStudentRequest_LinkStudentRequestId_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('dbo."LinkStudentRequest_LinkStudentRequestId_seq"', 1, false);
          dbo          postgres    false    229            d           0    0    Machines_MachineId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('dbo."Machines_MachineId_seq"', 1, false);
          dbo          postgres    false    231            e           0    0     Notifications_NotificationId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('dbo."Notifications_NotificationId_seq"', 1, false);
          dbo          postgres    false    233            f           0    0    Operators_OperatorId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('dbo."Operators_OperatorId_seq"', 1, true);
          dbo          postgres    false    235            g           0    0    Parents_ParentId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."Parents_ParentId_seq"', 1, false);
          dbo          postgres    false    238            h           0    0 -   SchoolRequestAccess_SchoolRequestAccessId_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('dbo."SchoolRequestAccess_SchoolRequestAccessId_seq"', 1, false);
          dbo          postgres    false    240            i           0    0 &   SchoolYearLevels_SchoolYearLevelId_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('dbo."SchoolYearLevels_SchoolYearLevelId_seq"', 1, false);
          dbo          postgres    false    242            j           0    0    Schools_SchoolId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."Schools_SchoolId_seq"', 1, false);
          dbo          postgres    false    244            k           0    0    Sections_SectionId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('dbo."Sections_SectionId_seq"', 1, false);
          dbo          postgres    false    246            l           0    0    Strands_StrandId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."Strands_StrandId_seq"', 1, false);
          dbo          postgres    false    248            m           0    0    Students_StudentId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('dbo."Students_StudentId_seq"', 1, false);
          dbo          postgres    false    253            n           0    0    TapLogs_TapLogId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."TapLogs_TapLogId_seq"', 1, false);
          dbo          postgres    false    255            o           0    0    Users_UserId_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('dbo."Users_UserId_seq"', 1, true);
          dbo          postgres    false    259                       2606    39025    Courses Courses_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "Courses_pkey" PRIMARY KEY ("CourseId");
 ?   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "Courses_pkey";
       dbo            postgres    false    215                       2606    39027    Departments Departments_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "Departments_pkey" PRIMARY KEY ("DepartmentId");
 G   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "Departments_pkey";
       dbo            postgres    false    217                       2606    39029     EmployeeRoles EmployeeRoles_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "EmployeeRoles_pkey" PRIMARY KEY ("EmployeeRoleId");
 K   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "EmployeeRoles_pkey";
       dbo            postgres    false    219                       2606    39031 "   EmployeeTitles EmployeeTitles_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "EmployeeTitles_pkey" PRIMARY KEY ("EmployeeTitleId");
 M   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "EmployeeTitles_pkey";
       dbo            postgres    false    221                       2606    39033    EmployeeUser EmployeeUser_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "EmployeeUser_pkey" PRIMARY KEY ("EmployeeId", "UserId");
 I   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "EmployeeUser_pkey";
       dbo            postgres    false    223    223                       2606    39035    Employees Employees_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "Employees_pkey" PRIMARY KEY ("EmployeeId");
 C   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "Employees_pkey";
       dbo            postgres    false    224            %           2606    39037 *   LinkStudentRequest LinkStudentRequest_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "LinkStudentRequest_pkey" PRIMARY KEY ("LinkStudentRequestId");
 U   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "LinkStudentRequest_pkey";
       dbo            postgres    false    228            '           2606    39039    Machines Machines_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "Machines_pkey" PRIMARY KEY ("MachineId");
 A   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "Machines_pkey";
       dbo            postgres    false    230            *           2606    39041     Notifications Notifications_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY dbo."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY ("NotificationId");
 K   ALTER TABLE ONLY dbo."Notifications" DROP CONSTRAINT "Notifications_pkey";
       dbo            postgres    false    232            ,           2606    39043    Operators Operators_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY dbo."Operators"
    ADD CONSTRAINT "Operators_pkey" PRIMARY KEY ("OperatorId");
 C   ALTER TABLE ONLY dbo."Operators" DROP CONSTRAINT "Operators_pkey";
       dbo            postgres    false    234            .           2606    39045     ParentStudent ParentStudent_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "ParentStudent_pkey" PRIMARY KEY ("ParentId", "StudentId");
 K   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "ParentStudent_pkey";
       dbo            postgres    false    236    236            0           2606    39047    Parents Parents_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "Parents_pkey" PRIMARY KEY ("ParentId");
 ?   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "Parents_pkey";
       dbo            postgres    false    237            4           2606    39049 ,   SchoolRequestAccess SchoolRequestAccess_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "SchoolRequestAccess_pkey" PRIMARY KEY ("SchoolRequestAccessId");
 W   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "SchoolRequestAccess_pkey";
       dbo            postgres    false    239            6           2606    39051 &   SchoolYearLevels SchoolYearLevels_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "SchoolYearLevels_pkey" PRIMARY KEY ("SchoolYearLevelId");
 Q   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "SchoolYearLevels_pkey";
       dbo            postgres    false    241            9           2606    39053    Schools Schools_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "Schools_pkey" PRIMARY KEY ("SchoolId");
 ?   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "Schools_pkey";
       dbo            postgres    false    243            ;           2606    39055    Sections Sections_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "Sections_pkey" PRIMARY KEY ("SectionId");
 A   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "Sections_pkey";
       dbo            postgres    false    245            =           2606    39057    Strands Strands_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Strands"
    ADD CONSTRAINT "Strands_pkey" PRIMARY KEY ("StrandId");
 ?   ALTER TABLE ONLY dbo."Strands" DROP CONSTRAINT "Strands_pkey";
       dbo            postgres    false    247            @           2606    39059     StudentCourse StudentCourse_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "StudentCourse_pkey" PRIMARY KEY ("StudentId", "CourseId");
 K   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "StudentCourse_pkey";
       dbo            postgres    false    249    249            D           2606    39061 "   StudentSection StudentSection_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "StudentSection_pkey" PRIMARY KEY ("StudentId", "SectionId");
 M   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "StudentSection_pkey";
       dbo            postgres    false    250    250            H           2606    39063     StudentStrand StudentStrand_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY dbo."StudentStrand"
    ADD CONSTRAINT "StudentStrand_pkey" PRIMARY KEY ("StudentId", "StrandId");
 K   ALTER TABLE ONLY dbo."StudentStrand" DROP CONSTRAINT "StudentStrand_pkey";
       dbo            postgres    false    251    251            L           2606    39065    Students Students_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "Students_pkey" PRIMARY KEY ("StudentId");
 A   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "Students_pkey";
       dbo            postgres    false    252            Q           2606    39067    TapLogs TapLogs_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "TapLogs_pkey" PRIMARY KEY ("TapLogId");
 ?   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "TapLogs_pkey";
       dbo            postgres    false    254            S           2606    39069 (   UserFirebaseToken UserFirebaseToken_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY dbo."UserFirebaseToken"
    ADD CONSTRAINT "UserFirebaseToken_pkey" PRIMARY KEY ("UserId", "FirebaseToken", "Device");
 S   ALTER TABLE ONLY dbo."UserFirebaseToken" DROP CONSTRAINT "UserFirebaseToken_pkey";
       dbo            postgres    false    256    256    256            W           2606    39071    Users Users_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY dbo."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("UserId");
 ;   ALTER TABLE ONLY dbo."Users" DROP CONSTRAINT "Users_pkey";
       dbo            postgres    false    258            #           2606    39073    Files pk_files_901578250 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Files"
    ADD CONSTRAINT pk_files_901578250 PRIMARY KEY ("FileId");
 A   ALTER TABLE ONLY dbo."Files" DROP CONSTRAINT pk_files_901578250;
       dbo            postgres    false    226            U           2606    39075 -   UserProfilePic pk_userprofilepic_1_1525580473 
   CONSTRAINT     p   ALTER TABLE ONLY dbo."UserProfilePic"
    ADD CONSTRAINT pk_userprofilepic_1_1525580473 PRIMARY KEY ("UserId");
 V   ALTER TABLE ONLY dbo."UserProfilePic" DROP CONSTRAINT pk_userprofilepic_1_1525580473;
       dbo            postgres    false    257                       2606    39077    EmployeeUser u_Employee 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "u_Employee" UNIQUE ("EmployeeId");
 B   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "u_Employee";
       dbo            postgres    false    223            B           2606    39079    StudentCourse u_StudentCourse 
   CONSTRAINT     `   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "u_StudentCourse" UNIQUE ("StudentId");
 H   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "u_StudentCourse";
       dbo            postgres    false    249            F           2606    39081    StudentSection u_StudentSection 
   CONSTRAINT     b   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "u_StudentSection" UNIQUE ("StudentId");
 J   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "u_StudentSection";
       dbo            postgres    false    250            J           2606    39083    StudentStrand u_StudentStrand 
   CONSTRAINT     `   ALTER TABLE ONLY dbo."StudentStrand"
    ADD CONSTRAINT "u_StudentStrand" UNIQUE ("StudentId");
 H   ALTER TABLE ONLY dbo."StudentStrand" DROP CONSTRAINT "u_StudentStrand";
       dbo            postgres    false    251                       1259    39084    u_course    INDEX     �   CREATE UNIQUE INDEX u_course ON dbo."Courses" USING btree ("Name", "SchoolId", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_course;
       dbo            postgres    false    215    215    215    215                       1259    39085    u_department    INDEX     �   CREATE UNIQUE INDEX u_department ON dbo."Departments" USING btree ("DepartmentName", "SchoolId", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_department;
       dbo            postgres    false    217    217    217    217                        1259    39086    u_employees_card    INDEX     �   CREATE UNIQUE INDEX u_employees_card ON dbo."Employees" USING btree ("CardNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_employees_card;
       dbo            postgres    false    224    224    224            !           1259    39087    u_employees_number    INDEX     �   CREATE UNIQUE INDEX u_employees_number ON dbo."Employees" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 #   DROP INDEX dbo.u_employees_number;
       dbo            postgres    false    224    224    224            (           1259    39088 	   u_machine    INDEX     �   CREATE UNIQUE INDEX u_machine ON dbo."Machines" USING btree ("Description", "SchoolId", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_machine;
       dbo            postgres    false    230    230    230    230            1           1259    39089    u_parents_email    INDEX     �   CREATE UNIQUE INDEX u_parents_email ON dbo."Parents" USING btree ("Email", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
     DROP INDEX dbo.u_parents_email;
       dbo            postgres    false    237    237    237            2           1259    39090    u_parents_number    INDEX     �   CREATE UNIQUE INDEX u_parents_number ON dbo."Parents" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_parents_number;
       dbo            postgres    false    237    237    237            7           1259    39091    u_school_year_level    INDEX     �   CREATE UNIQUE INDEX u_school_year_level ON dbo."SchoolYearLevels" USING btree ("SchoolId", "Name", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 $   DROP INDEX dbo.u_school_year_level;
       dbo            postgres    false    241    241    241    241            >           1259    39092    u_strand    INDEX     �   CREATE UNIQUE INDEX u_strand ON dbo."Strands" USING btree ("Name", "SchoolId", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_strand;
       dbo            postgres    false    247    247    247    247            M           1259    39093    u_students_card    INDEX     �   CREATE UNIQUE INDEX u_students_card ON dbo."Students" USING btree ("CardNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
     DROP INDEX dbo.u_students_card;
       dbo            postgres    false    252    252    252            N           1259    39094    u_students_email    INDEX     �   CREATE UNIQUE INDEX u_students_email ON dbo."Students" USING btree ("Email", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_students_email;
       dbo            postgres    false    252    252    252            O           1259    39095    u_students_number    INDEX     �   CREATE UNIQUE INDEX u_students_number ON dbo."Students" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 "   DROP INDEX dbo.u_students_number;
       dbo            postgres    false    252    252    252            X           1259    39096    u_user    INDEX     �   CREATE UNIQUE INDEX u_user ON dbo."Users" USING btree ("UserName", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_user;
       dbo            postgres    false    258    258    258            Y           2606    39097     Courses fk_Courses_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_CreatedByUser";
       dbo          postgres    false    258    3415    215            Z           2606    39102    Courses fk_Courses_Schools    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_Schools" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 E   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_Schools";
       dbo          postgres    false    3385    243    215            [           2606    39107     Courses fk_Courses_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_UpdatedByUser";
       dbo          postgres    false    215    3415    258            \           2606    39112 *   Departments fk_Departments_CreatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_CreatedByUserId" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 U   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_CreatedByUserId";
       dbo          postgres    false    258    217    3415            ]           2606    39117 !   Departments fk_Departments_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 L   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_School";
       dbo          postgres    false    243    3385    217            ^           2606    39122 (   Departments fk_Departments_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 S   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_UpdatedByUser";
       dbo          postgres    false    258    217    3415            _           2606    39127 ,   EmployeeRoles fk_EmployeeRoles_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 W   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_CreatedByUser";
       dbo          postgres    false    258    219    3415            `           2606    39132 %   EmployeeRoles fk_EmployeeRoles_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 P   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_School";
       dbo          postgres    false    3385    243    219            a           2606    39137 ,   EmployeeRoles fk_EmployeeRoles_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 W   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_UpdatedByUser";
       dbo          postgres    false    258    219    3415            b           2606    39142 .   EmployeeTitles fk_EmployeeTitles_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 Y   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_CreatedByUser";
       dbo          postgres    false    258    221    3415            c           2606    39147 '   EmployeeTitles fk_EmployeeTitles_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 R   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_School";
       dbo          postgres    false    221    243    3385            d           2606    39152 .   EmployeeTitles fk_EmployeeTitles_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 Y   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_UpdatedByUser";
       dbo          postgres    false    221    258    3415            e           2606    39157 %   EmployeeUser fk_EmployeeUser_Employee    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_Employee" FOREIGN KEY ("EmployeeId") REFERENCES dbo."Employees"("EmployeeId");
 P   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_Employee";
       dbo          postgres    false    224    223    3359            f           2606    39162 +   EmployeeUser fk_EmployeeUser_EmployeeRoleId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_EmployeeRoleId" FOREIGN KEY ("EmployeeRoleId") REFERENCES dbo."EmployeeRoles"("EmployeeRoleId") NOT VALID;
 V   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_EmployeeRoleId";
       dbo          postgres    false    223    3351    219            g           2606    39167 !   EmployeeUser fk_EmployeeUser_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId");
 L   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_User";
       dbo          postgres    false    3415    258    223            h           2606    39172 &   Employees fk_Employees_CreatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_CreatedByUserId" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 Q   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_CreatedByUserId";
       dbo          postgres    false    258    3415    224            i           2606    39177 "   Employees fk_Employees_Departments    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_Departments" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_Departments";
       dbo          postgres    false    3348    224    217            j           2606    39182 '   Employees fk_Employees_EmployeePosition    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_EmployeePosition" FOREIGN KEY ("EmployeePositionId") REFERENCES dbo."EmployeeTitles"("EmployeeTitleId");
 R   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_EmployeePosition";
       dbo          postgres    false    3353    221    224            k           2606    39187    Employees fk_Employees_SchoolId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_SchoolId" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 J   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_SchoolId";
       dbo          postgres    false    224    243    3385            l           2606    39192 &   Employees fk_Employees_UpdatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_UpdatedByUserId" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 Q   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_UpdatedByUserId";
       dbo          postgres    false    224    3415    258            m           2606    39197 :   LinkStudentRequest fk_LinkStudentRequest_RequestedByParent    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_RequestedByParent" FOREIGN KEY ("RequestedByParentId") REFERENCES dbo."Parents"("ParentId");
 e   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_RequestedByParent";
       dbo          postgres    false    237    3376    228            n           2606    39202 /   LinkStudentRequest fk_LinkStudentRequest_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 Z   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_School";
       dbo          postgres    false    228    3385    243            o           2606    39207 0   LinkStudentRequest fk_LinkStudentRequest_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 [   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_Student";
       dbo          postgres    false    3404    228    252            p           2606    39212 6   LinkStudentRequest fk_LinkStudentRequest_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 a   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_UpdatedByUser";
       dbo          postgres    false    228    258    3415            q           2606    39217 "   Machines fk_Machines_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_CreatedByUser";
       dbo          postgres    false    258    3415    230            r           2606    39222    Machines fk_Machines_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 F   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_School";
       dbo          postgres    false    3385    230    243            s           2606    39227 "   Machines fk_Machines_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_UpdatedByUser";
       dbo          postgres    false    230    258    3415            t           2606    39232 &   Notifications fk_Notifications_ForUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Notifications"
    ADD CONSTRAINT "fk_Notifications_ForUser" FOREIGN KEY ("ForUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 Q   ALTER TABLE ONLY dbo."Notifications" DROP CONSTRAINT "fk_Notifications_ForUser";
       dbo          postgres    false    232    258    3415            u           2606    39237    Operators fk_Operator_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Operators"
    ADD CONSTRAINT "fk_Operator_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 E   ALTER TABLE ONLY dbo."Operators" DROP CONSTRAINT "fk_Operator_User";
       dbo          postgres    false    234    258    3415            v           2606    39242 %   ParentStudent fk_ParentStudent_Parent    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "fk_ParentStudent_Parent" FOREIGN KEY ("ParentId") REFERENCES dbo."Parents"("ParentId") NOT VALID;
 P   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "fk_ParentStudent_Parent";
       dbo          postgres    false    3376    236    237            w           2606    39247 &   ParentStudent fk_ParentStudent_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "fk_ParentStudent_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId") NOT VALID;
 Q   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "fk_ParentStudent_Student";
       dbo          postgres    false    236    252    3404            x           2606    39252 #   Parents fk_Parents_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 N   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_RegisteredByUser";
       dbo          postgres    false    237    3415    258            y           2606    39257     Parents fk_Parents_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_UpdatedByUser";
       dbo          postgres    false    258    3415    237            z           2606    39262    Parents fk_Parents_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 B   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_User";
       dbo          postgres    false    3415    258    237            {           2606    39267 :   SchoolRequestAccess fk_SchoolRequestAccess_RequestedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_RequestedByUser" FOREIGN KEY ("RequestedByUserId") REFERENCES dbo."Users"("UserId");
 e   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_RequestedByUser";
       dbo          postgres    false    3415    258    239            |           2606    39272 1   SchoolRequestAccess fk_SchoolRequestAccess_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 \   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_School";
       dbo          postgres    false    239    243    3385            }           2606    39277 8   SchoolRequestAccess fk_SchoolRequestAccess_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 c   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_UpdatedByUser";
       dbo          postgres    false    239    258    3415            ~           2606    39282 0   SchoolYearLevels fk_SchoolYearLevel_CreatedByUse    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_CreatedByUse" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 [   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_CreatedByUse";
       dbo          postgres    false    3415    258    241                       2606    39287 *   SchoolYearLevels fk_SchoolYearLevel_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 U   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_School";
       dbo          postgres    false    243    3385    241            �           2606    39292 1   SchoolYearLevels fk_SchoolYearLevel_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 \   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_UpdatedByUser";
       dbo          postgres    false    241    3415    258            �           2606    39297 #   Schools fk_Schools_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "fk_Schools_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 N   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "fk_Schools_RegisteredByUser";
       dbo          postgres    false    3415    243    258            �           2606    39302     Schools fk_Schools_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "fk_Schools_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "fk_Schools_UpdatedByUser";
       dbo          postgres    false    258    243    3415            �           2606    39307 $   Sections fk_Sections_AdviserEmployee    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_AdviserEmployee" FOREIGN KEY ("AdviserEmployeeId") REFERENCES dbo."Employees"("EmployeeId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_AdviserEmployee";
       dbo          postgres    false    3359    224    245            �           2606    39312 "   Sections fk_Sections_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_CreatedByUser";
       dbo          postgres    false    258    3415    245            �           2606    39317    Sections fk_Sections_Department    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_Department" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 J   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_Department";
       dbo          postgres    false    245    3348    217            �           2606    39322    Sections fk_Sections_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 F   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_School";
       dbo          postgres    false    243    245    3385            �           2606    39327 $   Sections fk_Sections_SchoolYearLevel    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_SchoolYearLevel" FOREIGN KEY ("SchoolYearLevelId") REFERENCES dbo."SchoolYearLevels"("SchoolYearLevelId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_SchoolYearLevel";
       dbo          postgres    false    3382    241    245            �           2606    39332 "   Sections fk_Sections_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_UpdatedByUser";
       dbo          postgres    false    258    245    3415            �           2606    39337     Strands fk_Strands_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Strands"
    ADD CONSTRAINT "fk_Strands_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 K   ALTER TABLE ONLY dbo."Strands" DROP CONSTRAINT "fk_Strands_CreatedByUser";
       dbo          postgres    false    3415    247    258            �           2606    39342    Strands fk_Strands_Schools    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Strands"
    ADD CONSTRAINT "fk_Strands_Schools" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 E   ALTER TABLE ONLY dbo."Strands" DROP CONSTRAINT "fk_Strands_Schools";
       dbo          postgres    false    3385    247    243            �           2606    39347     Strands fk_Strands_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Strands"
    ADD CONSTRAINT "fk_Strands_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 K   ALTER TABLE ONLY dbo."Strands" DROP CONSTRAINT "fk_Strands_UpdatedByUser";
       dbo          postgres    false    258    3415    247            �           2606    39352 %   StudentCourse fk_StudentCourse_Course    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "fk_StudentCourse_Course" FOREIGN KEY ("CourseId") REFERENCES dbo."Courses"("CourseId");
 P   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "fk_StudentCourse_Course";
       dbo          postgres    false    215    249    3345            �           2606    39357 &   StudentCourse fk_StudentCourse_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "fk_StudentCourse_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 Q   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "fk_StudentCourse_Student";
       dbo          postgres    false    252    249    3404            �           2606    39362 (   StudentSection fk_StudentSection_Section    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "fk_StudentSection_Section" FOREIGN KEY ("SectionId") REFERENCES dbo."Sections"("SectionId") NOT VALID;
 S   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "fk_StudentSection_Section";
       dbo          postgres    false    250    245    3387            �           2606    39367 (   StudentSection fk_StudentSection_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "fk_StudentSection_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId") NOT VALID;
 S   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "fk_StudentSection_Student";
       dbo          postgres    false    252    3404    250            �           2606    39372 %   StudentStrand fk_StudentStrand_Strand    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentStrand"
    ADD CONSTRAINT "fk_StudentStrand_Strand" FOREIGN KEY ("StrandId") REFERENCES dbo."Strands"("StrandId") NOT VALID;
 P   ALTER TABLE ONLY dbo."StudentStrand" DROP CONSTRAINT "fk_StudentStrand_Strand";
       dbo          postgres    false    3389    251    247            �           2606    39377 &   StudentStrand fk_StudentStrand_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentStrand"
    ADD CONSTRAINT "fk_StudentStrand_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId") NOT VALID;
 Q   ALTER TABLE ONLY dbo."StudentStrand" DROP CONSTRAINT "fk_StudentStrand_Student";
       dbo          postgres    false    3404    251    252            �           2606    39382    Students fk_Students_Department    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_Department" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 J   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_Department";
       dbo          postgres    false    3348    217    252            �           2606    39387 %   Students fk_Students_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 P   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_RegisteredByUser";
       dbo          postgres    false    252    3415    258            �           2606    39392    Students fk_Students_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 F   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_School";
       dbo          postgres    false    252    243    3385            �           2606    39397 $   Students fk_Students_SchoolYearLevel    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_SchoolYearLevel" FOREIGN KEY ("SchoolYearLevelId") REFERENCES dbo."SchoolYearLevels"("SchoolYearLevelId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_SchoolYearLevel";
       dbo          postgres    false    241    252    3382            �           2606    39402 "   Students fk_Students_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_UpdatedByUser";
       dbo          postgres    false    258    252    3415            �           2606    39407    TapLogs fk_TapLogs_Machine    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "fk_TapLogs_Machine" FOREIGN KEY ("MachineId") REFERENCES dbo."Machines"("MachineId");
 E   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "fk_TapLogs_Machine";
       dbo          postgres    false    254    3367    230            �           2606    39412    TapLogs fk_TapLogs_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "fk_TapLogs_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 E   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "fk_TapLogs_Student";
       dbo          postgres    false    252    3404    254            �           2606    39417 +   UserFirebaseToken fk_UserFirebaseToken_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."UserFirebaseToken"
    ADD CONSTRAINT "fk_UserFirebaseToken_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId");
 V   ALTER TABLE ONLY dbo."UserFirebaseToken" DROP CONSTRAINT "fk_UserFirebaseToken_User";
       dbo          postgres    false    3415    258    256            �           2606    39422 0   UserProfilePic fk_userprofilepic_files_354100302    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."UserProfilePic"
    ADD CONSTRAINT fk_userprofilepic_files_354100302 FOREIGN KEY ("FileId") REFERENCES dbo."Files"("FileId");
 Y   ALTER TABLE ONLY dbo."UserProfilePic" DROP CONSTRAINT fk_userprofilepic_files_354100302;
       dbo          postgres    false    226    257    3363            �           2606    39427 &   UserProfilePic fk_userprofilepic_users    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."UserProfilePic"
    ADD CONSTRAINT fk_userprofilepic_users FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId");
 O   ALTER TABLE ONLY dbo."UserProfilePic" DROP CONSTRAINT fk_userprofilepic_users;
       dbo          postgres    false    257    3415    258            *      x������ � �      ,      x������ � �      .      x������ � �      0      x������ � �      2      x������ � �      3      x������ � �      5      x������ � �      7      x������ � �      9      x������ � �      ;      x������ � �      =   "   x�3�4 CNCNǔ��<0�Y�Y����� u�=      ?      x������ � �      @      x������ � �      B      x������ � �      D      x������ � �      F      x������ � �      H      x������ � �      J      x������ � �      L      x������ � �      M      x������ � �      N      x������ � �      O      x������ � �      Q      x������ � �      S      x������ � �      T      x������ � �      U   �   x�3�4 C�Ĕ��<N�$C�B?�쪴��ȼ Ӏ4�(���ԔP��S�R��\ϊT��R}o��@��T��DN� � �� N##c]C#]cCC+C+K=KKsKm�?��=... �� �     