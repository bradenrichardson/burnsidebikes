import Image from "next/image";

export default function Home() {
  return (
    <main className="flex min-h-screen">
      <div className="flex flex-row w-full">
        <div className="flex p-5 justify-start items-start"> 
          Burnside Bikes
        </div>
        <div className="flex-grow" />
        <div className="flex p-5 justify-end items-start">
          Login
        </div>
        <div className="flex p-5 justify-end items-start">
          Signup
        </div>
      </div>
    </main>
  );
}