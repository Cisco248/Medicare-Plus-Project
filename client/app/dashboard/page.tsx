"use client";

import React from "react";
import {
  Activity,
  CalendarDays,
  Clock3,
  Users,
  BedDouble,
  Stethoscope,
  Bell,
  ClipboardList,
  TrendingUp,
  ShieldCheck,
  HeartPulse,
  ArrowRight,
} from "lucide-react";

const stats = [
  {
    title: "Total Patients",
    value: "1,284",
    icon: Users,
  },
  {
    title: "Doctors Available",
    value: "42",
    icon: Stethoscope,
  },
  {
    title: "Appointments Today",
    value: "86",
    icon: CalendarDays,
  },
  {
    title: "Emergency Cases",
    value: "12",
    icon: Activity,
  },
];

const upcomingSessions = [
  {
    doctor: "Dr. John Fernando",
    department: "Cardiology",
    time: "09:30 AM",
    room: "Room 204",
    status: "Scheduled",
  },
  {
    doctor: "Dr. Nethmi Silva",
    department: "Neurology",
    time: "11:00 AM",
    room: "Room 102",
    status: "Ongoing",
  },
  {
    doctor: "Dr. Amal Perera",
    department: "Pediatrics",
    time: "02:00 PM",
    room: "Room 305",
    status: "Scheduled",
  },
];

const notifications = [
  "New patient registration completed",
  "Critical lab report received",
  "MRI session scheduled for 3:00 PM",
  "ICU patient requires monitoring",
];

const page = () => {
  return (
    <div className="min-h-screen w-full bg-slate-100 p-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold text-slate-800">
            Hospital Dashboard
          </h1>
          <p className="text-slate-500 mt-1">
            Manage hospital operations, patient sessions, and medical services.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 bg-white border border-slate-200 px-4 py-2 rounded-2xl shadow-sm hover:bg-slate-50 transition">
            <Bell size={18} />
            Notifications
          </button>

          <button className="flex items-center gap-2 bg-blue-600 text-white px-5 py-2 rounded-2xl shadow hover:bg-blue-700 transition">
            <CalendarDays size={18} />
            Schedule Session
          </button>
        </div>
      </div>

      {/* Statistics */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
        {stats.map((item, index) => {
          const Icon = item.icon;

          return (
            <div
              key={index}
              className="bg-white rounded-3xl p-5 shadow-sm border border-slate-100"
            >
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-slate-500 text-sm">{item.title}</p>
                  <h2 className="text-3xl font-bold text-slate-800 mt-2">
                    {item.value}
                  </h2>
                </div>

                <div className="h-14 w-14 rounded-2xl bg-blue-100 flex items-center justify-center">
                  <Icon className="text-blue-600" size={28} />
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Main Layout */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Left Side */}
        <div className="xl:col-span-2 space-y-6">
          {/* Session Management */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-slate-100">
            <div className="flex items-center justify-between mb-5">
              <div>
                <h2 className="text-xl font-bold text-slate-800">
                  Doctor Sessions
                </h2>
                <p className="text-slate-500 text-sm mt-1">
                  Start and manage scheduled sessions.
                </p>
              </div>

              <button className="text-blue-600 flex items-center gap-1 font-medium hover:underline">
                View All
                <ArrowRight size={16} />
              </button>
            </div>

            <div className="space-y-4">
              {upcomingSessions.map((session, index) => (
                <div
                  key={index}
                  className="border border-slate-200 rounded-2xl p-4 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4"
                >
                  <div>
                    <h3 className="font-semibold text-slate-800">
                      {session.doctor}
                    </h3>

                    <div className="flex flex-wrap gap-3 mt-2 text-sm text-slate-500">
                      <span className="flex items-center gap-1">
                        <Stethoscope size={14} />
                        {session.department}
                      </span>

                      <span className="flex items-center gap-1">
                        <Clock3 size={14} />
                        {session.time}
                      </span>

                      <span className="flex items-center gap-1">
                        <BedDouble size={14} />
                        {session.room}
                      </span>
                    </div>
                  </div>

                  <div className="flex items-center gap-3">
                    <span
                      className={`px-3 py-1 rounded-full text-xs font-medium ${
                        session.status === "Ongoing"
                          ? "bg-green-100 text-green-700"
                          : "bg-yellow-100 text-yellow-700"
                      }`}
                    >
                      {session.status}
                    </span>

                    <button className="bg-blue-600 text-white px-4 py-2 rounded-xl hover:bg-blue-700 transition">
                      Start Session
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Monitoring & Reports */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Health Monitoring */}
            <div className="bg-white rounded-3xl p-6 shadow-sm border border-slate-100">
              <div className="flex items-center gap-3 mb-4">
                <div className="h-12 w-12 rounded-2xl bg-red-100 flex items-center justify-center">
                  <HeartPulse className="text-red-500" />
                </div>

                <div>
                  <h3 className="font-bold text-slate-800">
                    Patient Monitoring
                  </h3>
                  <p className="text-sm text-slate-500">
                    Real-time patient vitals & alerts
                  </p>
                </div>
              </div>

              <div className="space-y-3">
                <div className="p-3 rounded-2xl bg-slate-50">
                  <p className="text-sm text-slate-500">Heart Rate Alerts</p>
                  <h2 className="text-2xl font-bold text-slate-800">18</h2>
                </div>

                <div className="p-3 rounded-2xl bg-slate-50">
                  <p className="text-sm text-slate-500">Critical Patients</p>
                  <h2 className="text-2xl font-bold text-slate-800">5</h2>
                </div>
              </div>
            </div>

            {/* Reports */}
            <div className="bg-white rounded-3xl p-6 shadow-sm border border-slate-100">
              <div className="flex items-center gap-3 mb-4">
                <div className="h-12 w-12 rounded-2xl bg-green-100 flex items-center justify-center">
                  <TrendingUp className="text-green-600" />
                </div>

                <div>
                  <h3 className="font-bold text-slate-800">Hospital Reports</h3>
                  <p className="text-sm text-slate-500">
                    AI generated analytics and reports
                  </p>
                </div>
              </div>

              <div className="space-y-3">
                <div className="p-3 rounded-2xl bg-slate-50 flex items-center justify-between">
                  <span className="text-slate-700">Monthly Patients</span>
                  <span className="font-semibold">+12%</span>
                </div>

                <div className="p-3 rounded-2xl bg-slate-50 flex items-center justify-between">
                  <span className="text-slate-700">Emergency Rate</span>
                  <span className="font-semibold">3.4%</span>
                </div>

                <div className="p-3 rounded-2xl bg-slate-50 flex items-center justify-between">
                  <span className="text-slate-700">Bed Occupancy</span>
                  <span className="font-semibold">78%</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Sidebar */}
        <div className="space-y-6">
          {/* Notifications */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-slate-100">
            <div className="flex items-center gap-3 mb-5">
              <div className="h-12 w-12 rounded-2xl bg-yellow-100 flex items-center justify-center">
                <Bell className="text-yellow-600" />
              </div>

              <div>
                <h3 className="font-bold text-slate-800">Notifications</h3>
                <p className="text-sm text-slate-500">
                  Important hospital alerts
                </p>
              </div>
            </div>

            <div className="space-y-3">
              {notifications.map((item, index) => (
                <div
                  key={index}
                  className="p-3 rounded-2xl bg-slate-50 text-sm text-slate-700"
                >
                  {item}
                </div>
              ))}
            </div>
          </div>

          {/* Security & Records */}
          <div className="bg-white rounded-3xl p-6 shadow-sm border border-slate-100">
            <div className="flex items-center gap-3 mb-5">
              <div className="h-12 w-12 rounded-2xl bg-blue-100 flex items-center justify-center">
                <ShieldCheck className="text-blue-600" />
              </div>

              <div>
                <h3 className="font-bold text-slate-800">Medical Records</h3>
                <p className="text-sm text-slate-500">
                  Secure patient information
                </p>
              </div>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-slate-600">Active Records</span>
                <span className="font-semibold text-slate-800">3,248</span>
              </div>

              <div className="flex items-center justify-between">
                <span className="text-slate-600">AI Reports Generated</span>
                <span className="font-semibold text-slate-800">512</span>
              </div>

              <div className="flex items-center justify-between">
                <span className="text-slate-600">Pending Approvals</span>
                <span className="font-semibold text-slate-800">14</span>
              </div>
            </div>
          </div>

          {/* Quick Actions */}
          <div className="bg-gradient-to-r from-blue-600 to-indigo-600 rounded-3xl p-6 text-white shadow-lg">
            <ClipboardList size={40} />

            <h2 className="text-2xl font-bold mt-4">Start Scheduled Session</h2>

            <p className="mt-2 text-blue-100 text-sm">
              Move directly into the doctor consultation session once the
              scheduled time is reached.
            </p>

            <button className="mt-5 bg-white text-blue-700 px-5 py-3 rounded-2xl font-semibold hover:bg-slate-100 transition">
              Open Session Panel
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default page;
