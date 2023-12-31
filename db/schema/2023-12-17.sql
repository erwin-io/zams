PGDMP     0    2                {            zamsdb    15.4    15.4 �    '           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            (           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            )           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            *           1262    28397    zamsdb    DATABASE     �   CREATE DATABASE zamsdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE zamsdb;
                postgres    false                        2615    28398    dbo    SCHEMA        CREATE SCHEMA dbo;
    DROP SCHEMA dbo;
                postgres    false            	           1255    28806    usp_reset() 	   PROCEDURE     �  CREATE PROCEDURE dbo.usp_reset()
    LANGUAGE plpgsql
    AS $_$
begin

	DELETE FROM dbo."LinkStudentRequest";
	DELETE FROM dbo."EmployeeUser";
	DELETE FROM dbo."UserFirebaseToken";
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
	DELETE FROM dbo."Users";
	
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
       dbo          postgres    false    6            �            1259    28439    Courses    TABLE     �  CREATE TABLE dbo."Courses" (
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
       dbo         heap    postgres    false    6            �            1259    28438    Courses_CourseId_seq    SEQUENCE     �   ALTER TABLE dbo."Courses" ALTER COLUMN "CourseId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Courses_CourseId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    224    6            �            1259    28420    Departments    TABLE     �  CREATE TABLE dbo."Departments" (
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
       dbo         heap    postgres    false    6            �            1259    28419    Departments_DepartmentId_seq    SEQUENCE     �   ALTER TABLE dbo."Departments" ALTER COLUMN "DepartmentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Departments_DepartmentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    220    6            �            1259    28975    EmployeeRoles    TABLE     �  CREATE TABLE dbo."EmployeeRoles" (
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
       dbo         heap    postgres    false    6            �            1259    28974     EmployeeRoles_EmployeeRoleId_seq    SEQUENCE     �   ALTER TABLE dbo."EmployeeRoles" ALTER COLUMN "EmployeeRoleId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EmployeeRoles_EmployeeRoleId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    244            �            1259    28929    EmployeeTitles    TABLE     �  CREATE TABLE dbo."EmployeeTitles" (
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
       dbo         heap    postgres    false    6            �            1259    28928 "   EmployeeTitles_EmployeeTitleId_seq    SEQUENCE     �   ALTER TABLE dbo."EmployeeTitles" ALTER COLUMN "EmployeeTitleId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EmployeeTitles_EmployeeTitleId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    242            �            1259    29209    EmployeeUser    TABLE     �   CREATE TABLE dbo."EmployeeUser" (
    "EmployeeId" bigint NOT NULL,
    "UserId" bigint NOT NULL,
    "DateRegistered" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "EmployeeRoleId" bigint
);
    DROP TABLE dbo."EmployeeUser";
       dbo         heap    postgres    false    6            �            1259    29001 	   Employees    TABLE     .  CREATE TABLE dbo."Employees" (
    "EmployeeId" bigint NOT NULL,
    "EmployeeCode" character varying,
    "EmployeePositionId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleName" character varying,
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
       dbo         heap    postgres    false    6            �            1259    29000    Employees_EmployeeId_seq    SEQUENCE     �   ALTER TABLE dbo."Employees" ALTER COLUMN "EmployeeId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Employees_EmployeeId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    246    6            �            1259    29314    LinkStudentRequest    TABLE       CREATE TABLE dbo."LinkStudentRequest" (
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
       dbo         heap    postgres    false    6            �            1259    29313 +   LinkStudentRequest_LinkStudentRequestId_seq    SEQUENCE       ALTER TABLE dbo."LinkStudentRequest" ALTER COLUMN "LinkStudentRequestId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."LinkStudentRequest_LinkStudentRequestId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    253    6            �            1259    28759    Machines    TABLE       CREATE TABLE dbo."Machines" (
    "MachineId" bigint NOT NULL,
    "MachineCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Description" character varying NOT NULL,
    "Path" character varying NOT NULL,
    "Domain" character varying NOT NULL,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Machines";
       dbo         heap    postgres    false    6            �            1259    28758    Machines_MachineId_seq    SEQUENCE     �   ALTER TABLE dbo."Machines" ALTER COLUMN "MachineId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Machines_MachineId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    236            �            1259    28524    Notifications    TABLE     �  CREATE TABLE dbo."Notifications" (
    "NotificationId" bigint NOT NULL,
    "ForUserId" bigint NOT NULL,
    "Type" character varying NOT NULL,
    "Title" character varying NOT NULL,
    "Description" character varying NOT NULL,
    "DateTime" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "IsRead" boolean DEFAULT false NOT NULL,
    "Active" boolean DEFAULT true NOT NULL
);
     DROP TABLE dbo."Notifications";
       dbo         heap    postgres    false    6            �            1259    28523     Notifications_NotificationId_seq    SEQUENCE     �   ALTER TABLE dbo."Notifications" ALTER COLUMN "NotificationId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Notifications_NotificationId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    233    6            �            1259    28836 	   Operators    TABLE       CREATE TABLE dbo."Operators" (
    "OperatorId" bigint NOT NULL,
    "OperatorCode" character varying,
    "UserId" bigint NOT NULL,
    "Name" character varying NOT NULL,
    "Active" boolean DEFAULT true NOT NULL,
    "AccessGranted" boolean DEFAULT false NOT NULL
);
    DROP TABLE dbo."Operators";
       dbo         heap    postgres    false    6            �            1259    28835    Operators_OperatorId_seq    SEQUENCE     �   ALTER TABLE dbo."Operators" ALTER COLUMN "OperatorId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Operators_OperatorId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    240            �            1259    28516    ParentStudent    TABLE     �   CREATE TABLE dbo."ParentStudent" (
    "ParentId" bigint NOT NULL,
    "StudentId" bigint NOT NULL,
    "DateAdded" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "Active" boolean DEFAULT true NOT NULL
);
     DROP TABLE dbo."ParentStudent";
       dbo         heap    postgres    false    6            �            1259    28507    Parents    TABLE       CREATE TABLE dbo."Parents" (
    "ParentId" bigint NOT NULL,
    "ParentCode" character varying,
    "UserId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleName" character varying,
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
       dbo         heap    postgres    false    6            �            1259    28506    Parents_ParentId_seq    SEQUENCE     �   ALTER TABLE dbo."Parents" ALTER COLUMN "ParentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Parents_ParentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    230            �            1259    29154    SchoolRequestAccess    TABLE     |  CREATE TABLE dbo."SchoolRequestAccess" (
    "SchoolRequestAccessId" bigint NOT NULL,
    "SchoolId" bigint NOT NULL,
    "Status" character varying NOT NULL,
    "DateRequested" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RequestedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint
);
 &   DROP TABLE dbo."SchoolRequestAccess";
       dbo         heap    postgres    false    6            �            1259    29153 -   SchoolRequestAccess_SchoolRequestAccessId_seq    SEQUENCE       ALTER TABLE dbo."SchoolRequestAccess" ALTER COLUMN "SchoolRequestAccessId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."SchoolRequestAccess_SchoolRequestAccessId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    250    6            �            1259    28409    SchoolYearLevels    TABLE     �  CREATE TABLE dbo."SchoolYearLevels" (
    "SchoolYearLevelId" bigint NOT NULL,
    "SchoolYearLevelCode" character varying,
    "SchoolId" bigint NOT NULL,
    "Name" character varying,
    "CanSelectCourses" boolean DEFAULT false,
    "CreatedDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "CreatedByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL
);
 #   DROP TABLE dbo."SchoolYearLevels";
       dbo         heap    postgres    false    6            �            1259    28408 &   SchoolYearLevels_SchoolYearLevelId_seq    SEQUENCE     �   ALTER TABLE dbo."SchoolYearLevels" ALTER COLUMN "SchoolYearLevelId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."SchoolYearLevels_SchoolYearLevelId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    6    218            �            1259    28400    Schools    TABLE     �  CREATE TABLE dbo."Schools" (
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
    "Active" boolean DEFAULT true NOT NULL
);
    DROP TABLE dbo."Schools";
       dbo         heap    postgres    false    6            �            1259    28399    Schools_SchoolId_seq    SEQUENCE     �   ALTER TABLE dbo."Schools" ALTER COLUMN "SchoolId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Schools_SchoolId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    216    6            �            1259    28430    Sections    TABLE     -  CREATE TABLE dbo."Sections" (
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
       dbo         heap    postgres    false    6            �            1259    28429    Sections_SectionId_seq    SEQUENCE     �   ALTER TABLE dbo."Sections" ALTER COLUMN "SectionId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Sections_SectionId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    222    6            �            1259    29066    StudentCourse    TABLE     �   CREATE TABLE dbo."StudentCourse" (
    "StudentId" bigint NOT NULL,
    "CourseId" bigint NOT NULL,
    "EnrolledDate" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
     DROP TABLE dbo."StudentCourse";
       dbo         heap    postgres    false    6            �            1259    29051    StudentSection    TABLE     �   CREATE TABLE dbo."StudentSection" (
    "StudentId" bigint NOT NULL,
    "SectionId" bigint NOT NULL,
    "DateAdded" date DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
 !   DROP TABLE dbo."StudentSection";
       dbo         heap    postgres    false    6            �            1259    28495    Students    TABLE     �  CREATE TABLE dbo."Students" (
    "StudentId" bigint NOT NULL,
    "StudentCode" character varying,
    "DepartmentId" bigint NOT NULL,
    "FirstName" character varying NOT NULL,
    "MiddleName" character varying,
    "LastName" character varying NOT NULL,
    "LRN" character varying NOT NULL,
    "CardNumber" character varying NOT NULL,
    "BirthDate" date,
    "MobileNumber" character varying NOT NULL,
    "Email" character varying,
    "Address" character varying,
    "Gender" character varying DEFAULT 'Others'::character varying,
    "AccessGranted" boolean DEFAULT false,
    "RegistrationDate" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL,
    "RegisteredByUserId" bigint NOT NULL,
    "UpdatedDate" timestamp with time zone,
    "UpdatedByUserId" bigint,
    "Active" boolean DEFAULT true NOT NULL,
    "SchoolId" bigint NOT NULL,
    "SchoolYearLevelId" bigint NOT NULL,
    "FullName" character varying DEFAULT ''::character varying NOT NULL
);
    DROP TABLE dbo."Students";
       dbo         heap    postgres    false    6            �            1259    28494    Students_StudentId_seq    SEQUENCE     �   ALTER TABLE dbo."Students" ALTER COLUMN "StudentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Students_StudentId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    228    6            �            1259    28769    TapLogs    TABLE       CREATE TABLE dbo."TapLogs" (
    "TapLogId" bigint NOT NULL,
    "StudentId" bigint NOT NULL,
    "Status" character varying NOT NULL,
    "MachineId" bigint NOT NULL,
    "DateTime" timestamp with time zone DEFAULT (now() AT TIME ZONE 'Asia/Manila'::text) NOT NULL
);
    DROP TABLE dbo."TapLogs";
       dbo         heap    postgres    false    6            �            1259    28768    TapLogs_TapLogId_seq    SEQUENCE     �   ALTER TABLE dbo."TapLogs" ALTER COLUMN "TapLogId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."TapLogs_TapLogId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    238    6            �            1259    28534    UserFirebaseToken    TABLE     �   CREATE TABLE dbo."UserFirebaseToken" (
    "UserId" bigint NOT NULL,
    "FirebaseToken" character varying NOT NULL,
    "Device" character varying NOT NULL
);
 $   DROP TABLE dbo."UserFirebaseToken";
       dbo         heap    postgres    false    6            �            1259    28448    Users    TABLE     �  CREATE TABLE dbo."Users" (
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
       dbo         heap    postgres    false    6            �            1259    28447    Users_UserId_seq    SEQUENCE     �   ALTER TABLE dbo."Users" ALTER COLUMN "UserId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Users_UserId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            dbo          postgres    false    226    6                      0    28439    Courses 
   TABLE DATA           �   COPY dbo."Courses" ("CourseId", "CourseCode", "SchoolId", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    224   �                0    28420    Departments 
   TABLE DATA           �   COPY dbo."Departments" ("DepartmentId", "DepartmentCode", "SchoolId", "DepartmentName", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    220                   0    28975    EmployeeRoles 
   TABLE DATA           �   COPY dbo."EmployeeRoles" ("EmployeeRoleId", "EmployeeRoleCode", "Name", "EmployeeRoleAccess", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "SchoolId", "Active") FROM stdin;
    dbo          postgres    false    244   �                0    28929    EmployeeTitles 
   TABLE DATA           �   COPY dbo."EmployeeTitles" ("EmployeeTitleId", "EmployeeTitleCode", "Name", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId") FROM stdin;
    dbo          postgres    false    242   �      "          0    29209    EmployeeUser 
   TABLE DATA           a   COPY dbo."EmployeeUser" ("EmployeeId", "UserId", "DateRegistered", "EmployeeRoleId") FROM stdin;
    dbo          postgres    false    251   4                0    29001 	   Employees 
   TABLE DATA           "  COPY dbo."Employees" ("EmployeeId", "EmployeeCode", "EmployeePositionId", "FirstName", "MiddleName", "LastName", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "SchoolId", "Active", "AccessGranted", "MobileNumber", "CardNumber", "DepartmentId", "FullName") FROM stdin;
    dbo          postgres    false    246   Q      $          0    29314    LinkStudentRequest 
   TABLE DATA           �   COPY dbo."LinkStudentRequest" ("LinkStudentRequestId", "SchoolId", "StudentId", "Status", "DateRequested", "RequestedByParentId", "UpdatedDate", "UpdatedByUserId", "Notes", "LinkStudentRequestCode") FROM stdin;
    dbo          postgres    false    253   �                0    28759    Machines 
   TABLE DATA           �   COPY dbo."Machines" ("MachineId", "MachineCode", "SchoolId", "Description", "Path", "Domain", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    236   n                0    28524    Notifications 
   TABLE DATA           �   COPY dbo."Notifications" ("NotificationId", "ForUserId", "Type", "Title", "Description", "DateTime", "IsRead", "Active") FROM stdin;
    dbo          postgres    false    233   �                0    28836 	   Operators 
   TABLE DATA           m   COPY dbo."Operators" ("OperatorId", "OperatorCode", "UserId", "Name", "Active", "AccessGranted") FROM stdin;
    dbo          postgres    false    240   �                0    28516    ParentStudent 
   TABLE DATA           V   COPY dbo."ParentStudent" ("ParentId", "StudentId", "DateAdded", "Active") FROM stdin;
    dbo          postgres    false    231   �                0    28507    Parents 
   TABLE DATA             COPY dbo."Parents" ("ParentId", "ParentCode", "UserId", "FirstName", "MiddleName", "LastName", "Gender", "BirthDate", "MobileNumber", "Email", "Address", "RegistrationDate", "RegisteredByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "FullName") FROM stdin;
    dbo          postgres    false    230   A      !          0    29154    SchoolRequestAccess 
   TABLE DATA           �   COPY dbo."SchoolRequestAccess" ("SchoolRequestAccessId", "SchoolId", "Status", "DateRequested", "RequestedByUserId", "UpdatedDate", "UpdatedByUserId") FROM stdin;
    dbo          postgres    false    250   �                0    28409    SchoolYearLevels 
   TABLE DATA           �   COPY dbo."SchoolYearLevels" ("SchoolYearLevelId", "SchoolYearLevelCode", "SchoolId", "Name", "CanSelectCourses", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    218   �      �          0    28400    Schools 
   TABLE DATA           �  COPY dbo."Schools" ("SchoolId", "SchoolCode", "SchoolName", "StudentsAllowableTimeLate", "StudentsTimeLate", "RestrictGuardianTime", "EmployeesTimeBeforeSwipeIsAllowed", "EmployeesAllowableTimeLate", "EmployeesTimeLate", "TimeBeforeSwipeIsAllowed", "SMSNotificationForStaffEntry", "SMSNotificationForStudentBreakTime", "SchoolContactNumber", "SchoolAddress", "SchoolEmail", "DateRegistered", "RegisteredByUserId", "DateUpdated", "UpdatedByUserId", "Active") FROM stdin;
    dbo          postgres    false    216   �                0    28430    Sections 
   TABLE DATA           �   COPY dbo."Sections" ("SectionId", "SectionCode", "DepartmentId", "SchoolYearLevelId", "SectionName", "AdviserEmployeeId", "CreatedDate", "CreatedByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId") FROM stdin;
    dbo          postgres    false    222                    0    29066    StudentCourse 
   TABLE DATA           O   COPY dbo."StudentCourse" ("StudentId", "CourseId", "EnrolledDate") FROM stdin;
    dbo          postgres    false    248   V                 0    29051    StudentSection 
   TABLE DATA           N   COPY dbo."StudentSection" ("StudentId", "SectionId", "DateAdded") FROM stdin;
    dbo          postgres    false    247   �                 0    28495    Students 
   TABLE DATA           X  COPY dbo."Students" ("StudentId", "StudentCode", "DepartmentId", "FirstName", "MiddleName", "LastName", "LRN", "CardNumber", "BirthDate", "MobileNumber", "Email", "Address", "Gender", "AccessGranted", "RegistrationDate", "RegisteredByUserId", "UpdatedDate", "UpdatedByUserId", "Active", "SchoolId", "SchoolYearLevelId", "FullName") FROM stdin;
    dbo          postgres    false    228   �                 0    28769    TapLogs 
   TABLE DATA           \   COPY dbo."TapLogs" ("TapLogId", "StudentId", "Status", "MachineId", "DateTime") FROM stdin;
    dbo          postgres    false    238   g!                0    28534    UserFirebaseToken 
   TABLE DATA           O   COPY dbo."UserFirebaseToken" ("UserId", "FirebaseToken", "Device") FROM stdin;
    dbo          postgres    false    234   �!      	          0    28448    Users 
   TABLE DATA           �   COPY dbo."Users" ("UserId", "UserCode", "UserName", "Password", "UserType", "DateRegistered", "DateUpdated", "Active") FROM stdin;
    dbo          postgres    false    226   �!      +           0    0    Courses_CourseId_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('dbo."Courses_CourseId_seq"', 3, true);
          dbo          postgres    false    223            ,           0    0    Departments_DepartmentId_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('dbo."Departments_DepartmentId_seq"', 2, true);
          dbo          postgres    false    219            -           0    0     EmployeeRoles_EmployeeRoleId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('dbo."EmployeeRoles_EmployeeRoleId_seq"', 1, false);
          dbo          postgres    false    243            .           0    0 "   EmployeeTitles_EmployeeTitleId_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('dbo."EmployeeTitles_EmployeeTitleId_seq"', 2, true);
          dbo          postgres    false    241            /           0    0    Employees_EmployeeId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('dbo."Employees_EmployeeId_seq"', 2, true);
          dbo          postgres    false    245            0           0    0 +   LinkStudentRequest_LinkStudentRequestId_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('dbo."LinkStudentRequest_LinkStudentRequestId_seq"', 3, true);
          dbo          postgres    false    252            1           0    0    Machines_MachineId_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('dbo."Machines_MachineId_seq"', 1, false);
          dbo          postgres    false    235            2           0    0     Notifications_NotificationId_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('dbo."Notifications_NotificationId_seq"', 12, true);
          dbo          postgres    false    232            3           0    0    Operators_OperatorId_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('dbo."Operators_OperatorId_seq"', 2, true);
          dbo          postgres    false    239            4           0    0    Parents_ParentId_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('dbo."Parents_ParentId_seq"', 4, true);
          dbo          postgres    false    229            5           0    0 -   SchoolRequestAccess_SchoolRequestAccessId_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('dbo."SchoolRequestAccess_SchoolRequestAccessId_seq"', 1, false);
          dbo          postgres    false    249            6           0    0 &   SchoolYearLevels_SchoolYearLevelId_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('dbo."SchoolYearLevels_SchoolYearLevelId_seq"', 4, true);
          dbo          postgres    false    217            7           0    0    Schools_SchoolId_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('dbo."Schools_SchoolId_seq"', 2, true);
          dbo          postgres    false    215            8           0    0    Sections_SectionId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('dbo."Sections_SectionId_seq"', 1, true);
          dbo          postgres    false    221            9           0    0    Students_StudentId_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('dbo."Students_StudentId_seq"', 3, true);
          dbo          postgres    false    227            :           0    0    TapLogs_TapLogId_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('dbo."TapLogs_TapLogId_seq"', 1, false);
          dbo          postgres    false    237            ;           0    0    Users_UserId_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('dbo."Users_UserId_seq"', 6, true);
          dbo          postgres    false    225                       2606    28446    Courses Courses_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "Courses_pkey" PRIMARY KEY ("CourseId");
 ?   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "Courses_pkey";
       dbo            postgres    false    224            �           2606    28427    Departments Departments_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "Departments_pkey" PRIMARY KEY ("DepartmentId");
 G   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "Departments_pkey";
       dbo            postgres    false    220                       2606    28984     EmployeeRoles EmployeeRoles_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "EmployeeRoles_pkey" PRIMARY KEY ("EmployeeRoleId");
 K   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "EmployeeRoles_pkey";
       dbo            postgres    false    244                       2606    28937 "   EmployeeTitles EmployeeTitles_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "EmployeeTitles_pkey" PRIMARY KEY ("EmployeeTitleId");
 M   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "EmployeeTitles_pkey";
       dbo            postgres    false    242            /           2606    29214    EmployeeUser EmployeeUser_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "EmployeeUser_pkey" PRIMARY KEY ("EmployeeId", "UserId");
 I   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "EmployeeUser_pkey";
       dbo            postgres    false    251    251            !           2606    29010    Employees Employees_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "Employees_pkey" PRIMARY KEY ("EmployeeId");
 C   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "Employees_pkey";
       dbo            postgres    false    246            3           2606    29321 *   LinkStudentRequest LinkStudentRequest_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "LinkStudentRequest_pkey" PRIMARY KEY ("LinkStudentRequestId");
 U   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "LinkStudentRequest_pkey";
       dbo            postgres    false    253                       2606    28767    Machines Machines_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "Machines_pkey" PRIMARY KEY ("MachineId");
 A   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "Machines_pkey";
       dbo            postgres    false    236                       2606    28533     Notifications Notifications_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY dbo."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY ("NotificationId");
 K   ALTER TABLE ONLY dbo."Notifications" DROP CONSTRAINT "Notifications_pkey";
       dbo            postgres    false    233                       2606    28843    Operators Operators_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY dbo."Operators"
    ADD CONSTRAINT "Operators_pkey" PRIMARY KEY ("OperatorId");
 C   ALTER TABLE ONLY dbo."Operators" DROP CONSTRAINT "Operators_pkey";
       dbo            postgres    false    240                       2606    28522     ParentStudent ParentStudent_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "ParentStudent_pkey" PRIMARY KEY ("ParentId", "StudentId");
 K   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "ParentStudent_pkey";
       dbo            postgres    false    231    231                       2606    28515    Parents Parents_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "Parents_pkey" PRIMARY KEY ("ParentId");
 ?   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "Parents_pkey";
       dbo            postgres    false    230            -           2606    29161 ,   SchoolRequestAccess SchoolRequestAccess_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "SchoolRequestAccess_pkey" PRIMARY KEY ("SchoolRequestAccessId");
 W   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "SchoolRequestAccess_pkey";
       dbo            postgres    false    250            �           2606    28417 &   SchoolYearLevels SchoolYearLevels_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "SchoolYearLevels_pkey" PRIMARY KEY ("SchoolYearLevelId");
 Q   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "SchoolYearLevels_pkey";
       dbo            postgres    false    218            �           2606    28407    Schools Schools_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "Schools_pkey" PRIMARY KEY ("SchoolId");
 ?   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "Schools_pkey";
       dbo            postgres    false    216                        2606    28437    Sections Sections_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "Sections_pkey" PRIMARY KEY ("SectionId");
 A   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "Sections_pkey";
       dbo            postgres    false    222            )           2606    29071     StudentCourse StudentCourse_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "StudentCourse_pkey" PRIMARY KEY ("StudentId", "CourseId");
 K   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "StudentCourse_pkey";
       dbo            postgres    false    248    248            %           2606    29055 "   StudentSection StudentSection_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "StudentSection_pkey" PRIMARY KEY ("StudentId", "SectionId");
 M   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "StudentSection_pkey";
       dbo            postgres    false    247    247                       2606    28505    Students Students_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "Students_pkey" PRIMARY KEY ("StudentId");
 A   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "Students_pkey";
       dbo            postgres    false    228                       2606    28776    TapLogs TapLogs_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "TapLogs_pkey" PRIMARY KEY ("TapLogId");
 ?   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "TapLogs_pkey";
       dbo            postgres    false    238                       2606    28540 (   UserFirebaseToken UserFirebaseToken_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY dbo."UserFirebaseToken"
    ADD CONSTRAINT "UserFirebaseToken_pkey" PRIMARY KEY ("UserId", "FirebaseToken", "Device");
 S   ALTER TABLE ONLY dbo."UserFirebaseToken" DROP CONSTRAINT "UserFirebaseToken_pkey";
       dbo            postgres    false    234    234    234                       2606    28456    Users Users_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY dbo."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("UserId");
 ;   ALTER TABLE ONLY dbo."Users" DROP CONSTRAINT "Users_pkey";
       dbo            postgres    false    226            1           2606    29226    EmployeeUser u_Employee 
   CONSTRAINT     [   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "u_Employee" UNIQUE ("EmployeeId");
 B   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "u_Employee";
       dbo            postgres    false    251            +           2606    29312    StudentCourse u_StudentCourse 
   CONSTRAINT     `   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "u_StudentCourse" UNIQUE ("StudentId");
 H   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "u_StudentCourse";
       dbo            postgres    false    248            '           2606    29310    StudentSection u_StudentSection 
   CONSTRAINT     b   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "u_StudentSection" UNIQUE ("StudentId");
 J   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "u_StudentSection";
       dbo            postgres    false    247            "           1259    29147    u_employees_card    INDEX     �   CREATE UNIQUE INDEX u_employees_card ON dbo."Employees" USING btree ("CardNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_employees_card;
       dbo            postgres    false    246    246    246            #           1259    29141    u_employees_number    INDEX     �   CREATE UNIQUE INDEX u_employees_number ON dbo."Employees" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 #   DROP INDEX dbo.u_employees_number;
       dbo            postgres    false    246    246    246                       1259    29145    u_machine_desc    INDEX     �   CREATE UNIQUE INDEX u_machine_desc ON dbo."Machines" USING btree ("Description", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_machine_desc;
       dbo            postgres    false    236    236    236                       1259    29143    u_parents_email    INDEX     �   CREATE UNIQUE INDEX u_parents_email ON dbo."Parents" USING btree ("Email", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
     DROP INDEX dbo.u_parents_email;
       dbo            postgres    false    230    230    230                       1259    29144    u_parents_number    INDEX     �   CREATE UNIQUE INDEX u_parents_number ON dbo."Parents" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_parents_number;
       dbo            postgres    false    230    230    230                       1259    29146    u_students_card    INDEX     �   CREATE UNIQUE INDEX u_students_card ON dbo."Students" USING btree ("CardNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
     DROP INDEX dbo.u_students_card;
       dbo            postgres    false    228    228    228            	           1259    29139    u_students_email    INDEX     �   CREATE UNIQUE INDEX u_students_email ON dbo."Students" USING btree ("Email", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 !   DROP INDEX dbo.u_students_email;
       dbo            postgres    false    228    228    228            
           1259    29140    u_students_number    INDEX     �   CREATE UNIQUE INDEX u_students_number ON dbo."Students" USING btree ("MobileNumber", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
 "   DROP INDEX dbo.u_students_number;
       dbo            postgres    false    228    228    228                       1259    29138    u_user    INDEX     �   CREATE UNIQUE INDEX u_user ON dbo."Users" USING btree ("UserName", "Active") WITH (deduplicate_items='false') WHERE ("Active" = true);
    DROP INDEX dbo.u_user;
       dbo            postgres    false    226    226    226            B           2606    28561     Courses fk_Courses_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_CreatedByUser";
       dbo          postgres    false    226    224    3332            C           2606    28556    Courses fk_Courses_Schools    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_Schools" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 E   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_Schools";
       dbo          postgres    false    224    3322    216            D           2606    28566     Courses fk_Courses_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Courses"
    ADD CONSTRAINT "fk_Courses_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Courses" DROP CONSTRAINT "fk_Courses_UpdatedByUser";
       dbo          postgres    false    226    3332    224            9           2606    28576 *   Departments fk_Departments_CreatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_CreatedByUserId" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 U   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_CreatedByUserId";
       dbo          postgres    false    3332    220    226            :           2606    28571 !   Departments fk_Departments_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 L   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_School";
       dbo          postgres    false    220    216    3322            ;           2606    28581 (   Departments fk_Departments_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT "fk_Departments_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 S   ALTER TABLE ONLY dbo."Departments" DROP CONSTRAINT "fk_Departments_UpdatedByUser";
       dbo          postgres    false    226    220    3332            Z           2606    28985 ,   EmployeeRoles fk_EmployeeRoles_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 W   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_CreatedByUser";
       dbo          postgres    false    244    226    3332            [           2606    28990 %   EmployeeRoles fk_EmployeeRoles_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 P   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_School";
       dbo          postgres    false    3322    244    216            \           2606    28995 ,   EmployeeRoles fk_EmployeeRoles_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeRoles"
    ADD CONSTRAINT "fk_EmployeeRoles_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 W   ALTER TABLE ONLY dbo."EmployeeRoles" DROP CONSTRAINT "fk_EmployeeRoles_UpdatedByUser";
       dbo          postgres    false    3332    244    226            W           2606    28938 .   EmployeeTitles fk_EmployeeTitles_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 Y   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_CreatedByUser";
       dbo          postgres    false    3332    242    226            X           2606    29082 '   EmployeeTitles fk_EmployeeTitles_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 R   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_School";
       dbo          postgres    false    3322    242    216            Y           2606    28943 .   EmployeeTitles fk_EmployeeTitles_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeTitles"
    ADD CONSTRAINT "fk_EmployeeTitles_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 Y   ALTER TABLE ONLY dbo."EmployeeTitles" DROP CONSTRAINT "fk_EmployeeTitles_UpdatedByUser";
       dbo          postgres    false    3332    226    242            i           2606    29215 %   EmployeeUser fk_EmployeeUser_Employee    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_Employee" FOREIGN KEY ("EmployeeId") REFERENCES dbo."Employees"("EmployeeId");
 P   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_Employee";
       dbo          postgres    false    246    3361    251            j           2606    29259 +   EmployeeUser fk_EmployeeUser_EmployeeRoleId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_EmployeeRoleId" FOREIGN KEY ("EmployeeRoleId") REFERENCES dbo."EmployeeRoles"("EmployeeRoleId") NOT VALID;
 V   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_EmployeeRoleId";
       dbo          postgres    false    251    3359    244            k           2606    29220 !   EmployeeUser fk_EmployeeUser_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."EmployeeUser"
    ADD CONSTRAINT "fk_EmployeeUser_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId");
 L   ALTER TABLE ONLY dbo."EmployeeUser" DROP CONSTRAINT "fk_EmployeeUser_User";
       dbo          postgres    false    226    251    3332            ]           2606    29011 &   Employees fk_Employees_CreatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_CreatedByUserId" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId");
 Q   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_CreatedByUserId";
       dbo          postgres    false    246    226    3332            ^           2606    29148 "   Employees fk_Employees_Departments    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_Departments" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_Departments";
       dbo          postgres    false    220    246    3326            _           2606    29021 '   Employees fk_Employees_EmployeePosition    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_EmployeePosition" FOREIGN KEY ("EmployeePositionId") REFERENCES dbo."EmployeeTitles"("EmployeeTitleId");
 R   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_EmployeePosition";
       dbo          postgres    false    242    3357    246            `           2606    29016    Employees fk_Employees_SchoolId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_SchoolId" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 J   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_SchoolId";
       dbo          postgres    false    246    3322    216            a           2606    29031 &   Employees fk_Employees_UpdatedByUserId    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Employees"
    ADD CONSTRAINT "fk_Employees_UpdatedByUserId" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 Q   ALTER TABLE ONLY dbo."Employees" DROP CONSTRAINT "fk_Employees_UpdatedByUserId";
       dbo          postgres    false    226    246    3332            l           2606    29347 :   LinkStudentRequest fk_LinkStudentRequest_RequestedByParent    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_RequestedByParent" FOREIGN KEY ("RequestedByParentId") REFERENCES dbo."Parents"("ParentId") NOT VALID;
 e   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_RequestedByParent";
       dbo          postgres    false    230    253    3340            m           2606    29327 /   LinkStudentRequest fk_LinkStudentRequest_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 Z   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_School";
       dbo          postgres    false    216    3322    253            n           2606    29332 0   LinkStudentRequest fk_LinkStudentRequest_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 [   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_Student";
       dbo          postgres    false    228    253    3335            o           2606    29337 6   LinkStudentRequest fk_LinkStudentRequest_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."LinkStudentRequest"
    ADD CONSTRAINT "fk_LinkStudentRequest_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 a   ALTER TABLE ONLY dbo."LinkStudentRequest" DROP CONSTRAINT "fk_LinkStudentRequest_UpdatedByUser";
       dbo          postgres    false    3332    253    226            Q           2606    28793 "   Machines fk_Machines_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_CreatedByUser";
       dbo          postgres    false    226    236    3332            R           2606    28788    Machines fk_Machines_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 F   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_School";
       dbo          postgres    false    216    3322    236            S           2606    28798 "   Machines fk_Machines_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Machines"
    ADD CONSTRAINT "fk_Machines_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Machines" DROP CONSTRAINT "fk_Machines_UpdatedByUser";
       dbo          postgres    false    236    226    3332            O           2606    28586 &   Notifications fk_Notifications_ForUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Notifications"
    ADD CONSTRAINT "fk_Notifications_ForUser" FOREIGN KEY ("ForUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 Q   ALTER TABLE ONLY dbo."Notifications" DROP CONSTRAINT "fk_Notifications_ForUser";
       dbo          postgres    false    226    3332    233            V           2606    28846    Operators fk_Operator_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Operators"
    ADD CONSTRAINT "fk_Operator_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 E   ALTER TABLE ONLY dbo."Operators" DROP CONSTRAINT "fk_Operator_User";
       dbo          postgres    false    3332    240    226            M           2606    28591 %   ParentStudent fk_ParentStudent_Parent    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "fk_ParentStudent_Parent" FOREIGN KEY ("ParentId") REFERENCES dbo."Parents"("ParentId") NOT VALID;
 P   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "fk_ParentStudent_Parent";
       dbo          postgres    false    231    230    3340            N           2606    28596 &   ParentStudent fk_ParentStudent_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."ParentStudent"
    ADD CONSTRAINT "fk_ParentStudent_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId") NOT VALID;
 Q   ALTER TABLE ONLY dbo."ParentStudent" DROP CONSTRAINT "fk_ParentStudent_Student";
       dbo          postgres    false    228    231    3335            J           2606    28606 #   Parents fk_Parents_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 N   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_RegisteredByUser";
       dbo          postgres    false    226    3332    230            K           2606    28611     Parents fk_Parents_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_UpdatedByUser";
       dbo          postgres    false    230    3332    226            L           2606    28601    Parents fk_Parents_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Parents"
    ADD CONSTRAINT "fk_Parents_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 B   ALTER TABLE ONLY dbo."Parents" DROP CONSTRAINT "fk_Parents_User";
       dbo          postgres    false    230    226    3332            f           2606    29167 :   SchoolRequestAccess fk_SchoolRequestAccess_RequestedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_RequestedByUser" FOREIGN KEY ("RequestedByUserId") REFERENCES dbo."Users"("UserId");
 e   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_RequestedByUser";
       dbo          postgres    false    250    3332    226            g           2606    29162 1   SchoolRequestAccess fk_SchoolRequestAccess_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId");
 \   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_School";
       dbo          postgres    false    216    250    3322            h           2606    29172 8   SchoolRequestAccess fk_SchoolRequestAccess_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolRequestAccess"
    ADD CONSTRAINT "fk_SchoolRequestAccess_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId");
 c   ALTER TABLE ONLY dbo."SchoolRequestAccess" DROP CONSTRAINT "fk_SchoolRequestAccess_UpdatedByUser";
       dbo          postgres    false    226    250    3332            6           2606    28621 0   SchoolYearLevels fk_SchoolYearLevel_CreatedByUse    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_CreatedByUse" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 [   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_CreatedByUse";
       dbo          postgres    false    218    3332    226            7           2606    28616 *   SchoolYearLevels fk_SchoolYearLevel_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 U   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_School";
       dbo          postgres    false    216    218    3322            8           2606    28626 1   SchoolYearLevels fk_SchoolYearLevel_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."SchoolYearLevels"
    ADD CONSTRAINT "fk_SchoolYearLevel_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 \   ALTER TABLE ONLY dbo."SchoolYearLevels" DROP CONSTRAINT "fk_SchoolYearLevel_UpdatedByUser";
       dbo          postgres    false    3332    218    226            4           2606    28546 #   Schools fk_Schools_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "fk_Schools_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 N   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "fk_Schools_RegisteredByUser";
       dbo          postgres    false    216    226    3332            5           2606    28551     Schools fk_Schools_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Schools"
    ADD CONSTRAINT "fk_Schools_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 K   ALTER TABLE ONLY dbo."Schools" DROP CONSTRAINT "fk_Schools_UpdatedByUser";
       dbo          postgres    false    216    226    3332            <           2606    29041 $   Sections fk_Sections_AdviserEmployee    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_AdviserEmployee" FOREIGN KEY ("AdviserEmployeeId") REFERENCES dbo."Employees"("EmployeeId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_AdviserEmployee";
       dbo          postgres    false    246    222    3361            =           2606    28646 "   Sections fk_Sections_CreatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_CreatedByUser" FOREIGN KEY ("CreatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_CreatedByUser";
       dbo          postgres    false    3332    226    222            >           2606    28631    Sections fk_Sections_Department    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_Department" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 J   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_Department";
       dbo          postgres    false    3326    220    222            ?           2606    29133    Sections fk_Sections_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 F   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_School";
       dbo          postgres    false    216    222    3322            @           2606    28636 $   Sections fk_Sections_SchoolYearLevel    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_SchoolYearLevel" FOREIGN KEY ("SchoolYearLevelId") REFERENCES dbo."SchoolYearLevels"("SchoolYearLevelId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_SchoolYearLevel";
       dbo          postgres    false    222    3324    218            A           2606    28651 "   Sections fk_Sections_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Sections"
    ADD CONSTRAINT "fk_Sections_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Sections" DROP CONSTRAINT "fk_Sections_UpdatedByUser";
       dbo          postgres    false    226    3332    222            d           2606    29077 %   StudentCourse fk_StudentCourse_Course    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "fk_StudentCourse_Course" FOREIGN KEY ("CourseId") REFERENCES dbo."Courses"("CourseId");
 P   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "fk_StudentCourse_Course";
       dbo          postgres    false    224    248    3330            e           2606    29072 &   StudentCourse fk_StudentCourse_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentCourse"
    ADD CONSTRAINT "fk_StudentCourse_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 Q   ALTER TABLE ONLY dbo."StudentCourse" DROP CONSTRAINT "fk_StudentCourse_Student";
       dbo          postgres    false    248    3335    228            b           2606    29092 (   StudentSection fk_StudentSection_Section    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "fk_StudentSection_Section" FOREIGN KEY ("SectionId") REFERENCES dbo."Sections"("SectionId") NOT VALID;
 S   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "fk_StudentSection_Section";
       dbo          postgres    false    3328    247    222            c           2606    29097 (   StudentSection fk_StudentSection_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."StudentSection"
    ADD CONSTRAINT "fk_StudentSection_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId") NOT VALID;
 S   ALTER TABLE ONLY dbo."StudentSection" DROP CONSTRAINT "fk_StudentSection_Student";
       dbo          postgres    false    247    3335    228            E           2606    29046    Students fk_Students_Department    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_Department" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("DepartmentId") NOT VALID;
 J   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_Department";
       dbo          postgres    false    220    3326    228            F           2606    28738 %   Students fk_Students_RegisteredByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_RegisteredByUser" FOREIGN KEY ("RegisteredByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 P   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_RegisteredByUser";
       dbo          postgres    false    3332    226    228            G           2606    28748    Students fk_Students_School    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_School" FOREIGN KEY ("SchoolId") REFERENCES dbo."Schools"("SchoolId") NOT VALID;
 F   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_School";
       dbo          postgres    false    3322    216    228            H           2606    28753 $   Students fk_Students_SchoolYearLevel    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_SchoolYearLevel" FOREIGN KEY ("SchoolYearLevelId") REFERENCES dbo."SchoolYearLevels"("SchoolYearLevelId") NOT VALID;
 O   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_SchoolYearLevel";
       dbo          postgres    false    228    218    3324            I           2606    28743 "   Students fk_Students_UpdatedByUser    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."Students"
    ADD CONSTRAINT "fk_Students_UpdatedByUser" FOREIGN KEY ("UpdatedByUserId") REFERENCES dbo."Users"("UserId") NOT VALID;
 M   ALTER TABLE ONLY dbo."Students" DROP CONSTRAINT "fk_Students_UpdatedByUser";
       dbo          postgres    false    3332    228    226            T           2606    28782    TapLogs fk_TapLogs_Machine    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "fk_TapLogs_Machine" FOREIGN KEY ("MachineId") REFERENCES dbo."Machines"("MachineId");
 E   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "fk_TapLogs_Machine";
       dbo          postgres    false    3350    238    236            U           2606    28777    TapLogs fk_TapLogs_Student    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."TapLogs"
    ADD CONSTRAINT "fk_TapLogs_Student" FOREIGN KEY ("StudentId") REFERENCES dbo."Students"("StudentId");
 E   ALTER TABLE ONLY dbo."TapLogs" DROP CONSTRAINT "fk_TapLogs_Student";
       dbo          postgres    false    238    228    3335            P           2606    28541 +   UserFirebaseToken fk_UserFirebaseToken_User    FK CONSTRAINT     �   ALTER TABLE ONLY dbo."UserFirebaseToken"
    ADD CONSTRAINT "fk_UserFirebaseToken_User" FOREIGN KEY ("UserId") REFERENCES dbo."Users"("UserId");
 V   ALTER TABLE ONLY dbo."UserFirebaseToken" DROP CONSTRAINT "fk_UserFirebaseToken_User";
       dbo          postgres    false    3332    234    226               k   x�m���0D��+ثX�����Ҏ��_%dB�����!Y��y~����i0g����a��Q��va�xB���uAt毌Ii��.�U~�^7���u���� �M"H         z   x�U̱�0E�9�
����%�ݻteA�V�h"���ꔧ��Cϑ!s/�&o��a�
s^�$ɋF�qG7`��#��qz�U��[k�jʢ
��I9i��JnH��GB�o��Yk��(�            x������ � �         c   x�]��
�0C��Wt�%�ZotsAGgWA��t��K Z��y��}��P[�E�	-�0���,�����"�V��#j]
`�򱔖��s/\��      "      x������ � �         }   x�U���0Dg�+��F���;+_е���T)�-۲�wuQ(����\{�2O��sTմ�Z�Ag�?���Z����^:�|y{���3�)�bD*s���Z�Dn�ݔ_����B{�00      $   �   x�u�=�0��9>;���'I�A�*������lo��H�u�vm�G��� :H>H�:V$��G���Q�Ib��[@!���4���4�ǀ�"{���)*�_QQݫN��˿c��%��ޤ��D���/E            x������ � �           x���MK�@����W�g�23;�y)^4���KMF�B[���}W!{��ޙ]RN]���S}��[׏�������^?H#�à�6�~�馓� 텺��>t?[���ϣ�>��������UdWH+C&̎M���.!�W5Tv	�bfkl����"0gp�&�v��_��wi��Ƒs�eH�]D;Z~�Ș�f� O��D�"#$�"���)�/����0�i�4C	&a�y���!�.q�4\��B��,�􈐔�&�\����e'��TU��Y�         4   x�3�4 CNCNǔ��<0�Y�Y�e�2�4��/H-J,�/2K��qqq �l`         B   x�Uʻ� �ڞ"}����ga��/�\}NJ��4]�(O�@�/&}�b���\c�=[�� ��         �   x�m�?�0��˧�.�/i��J�T\ܺ8�:�~L0-R�;x��~XG���9���f��%#KO�� �Cb`��)?qG>�K�6:`(��ܲvM�~�
�E�9�=�XE]�TƤ����R��ʍ�f�Ƙ��6�      !      x������ � �         �   x����
�0 �s���B���>�waѡ��0���R<��%��B[���.�<_�p}-�|�]q�,�@c`̑2!��S��N���NH�z�$, g�,#HJ��[*��e��en��}��h[�AL�+k��6Z;r���~ߞ�{��D�      �   ]   x�3�4 C��`g�?J��h���)D���)X��X[�[jXpB��pA�5�%�Tsc+#c+s=#sTSc���� b$�         @   x�3�4 CNN-Qp�4�4202�54�54W00�21�20�3���6� *���NC�=... ��            x�3�4�4202�54�54�2F���qqq d�            x�3�4�4202�54�54�2F���qqq d�         �   x�}�;�@��_�^r�>�N�:�P���Ha�p"���<��v�C0�  \���᫐X����J2�9R�U�mO�w�+�>	e��4�I�)7�U!�CZ��Bqd�`���S�|{�c��g=	���CQYbˢ�B"ů)��Q4#�ܟ-��J�ȠC`            x������ � �            x������ � �      	   O  x�u�;w�0 ����[�1	�
X����qAI�r	j���֡�����y��CR���Lj�M��HL�S�w�2��͕�#�%S[���ũsg�i��·%|�b����zVЍ�@��m��Hmbh`� hDר����H�~^^�2��%�u-��{����/�b<����a�� ��?���]�tL!��%�@
��J��%�+�eWT�nOLϓI_�j�qg�	*�]���b������%qV�������I�"�&R�
:E��kS}�u�b�=N8��bv�B��w�z���v,.j>���A�v��W�����(T%2���\�F��'�     