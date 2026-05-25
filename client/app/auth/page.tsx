import { AuthForm } from "@/lib/components/shared/AuthForm";
import Image from "next/image";

const LoginPage = () => {
  return (
    <div className="grid grid-cols-2 h-full w-full justify-center items-center">
      <div className="flex justify-center items-center h-full w-full">
        <Image
          className="h-full w-full opacity-40"
          src={"/images/auth_bg.png"}
          width={900}
          height={900}
          alt="bg"
        />
      </div>
      <div className="flex flex-col items-center justify-center h-full w-full py-20 px-20">
        <h1 className="text-3xl font-bold text-brand-400">
          Welcome to Medicare+
        </h1>
        <p className="text-muted-foreground text-center text-sm py-4">
          Sign in to your account to access your medical records and manage your
          health information.
        </p>
        <div className="flex justify-center items-center h-full w-full ">
          <AuthForm />
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
