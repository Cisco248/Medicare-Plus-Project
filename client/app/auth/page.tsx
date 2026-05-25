import { AuthForm } from "@/lib/components/shared/AuthForm";
import Image from "next/image";

const LoginPage = () => {
  return (
    <div className="grid grid-cols-[1.5fr_600px] w-full h-dvh justify-center items-center">
      <div className="flex justify-center items-center h-full w-full">
        <Image
          className="h-dvh w-full opacity-40 object-cover"
          src={"/images/auth_bg.png"}
          width={1000}
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
