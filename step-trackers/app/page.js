/*
Next.js + Chart.js (react-chartjs-2) — Step Tracker

- Fetches step logs from: https://step-tracker-backend-1.onrender.com/steps
- Polls every 10 seconds
- Renders chart per selected day
- Has buttons for each unique day
*/

"use client";

import { useEffect, useState } from "react";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { Line } from "react-chartjs-2";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend
);

export default function Home() {
  const [steps, setSteps] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedDay, setSelectedDay] = useState(null);

  // ✅ Fetch + poll
  useEffect(() => {
    const fetchSteps = async () => {
      try {
        const res = await fetch("https://step-tracker-backend-1.onrender.com/steps");
        if (!res.ok) throw new Error("Failed to fetch step logs");
        const data = await res.json();
        setSteps(data);
        setError(null);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchSteps();
    const interval = setInterval(fetchSteps, 120000);
    return () => clearInterval(interval);
  }, []); // 👈 fixed: static dependency array

  // ✅ Set default day only once (first fetch)
  useEffect(() => {
    if (steps.length > 0 && !selectedDay) {
      const firstDay = new Date(steps[0].date).toISOString().split("T")[0];
      setSelectedDay(firstDay);
    }
  }, [steps, selectedDay]);

  if (loading) return <p>Loading step logs...</p>;
  if (error) return <p>Error: {error}</p>;

  // ✅ Extract unique days
  const uniqueDays = [...new Set(steps.map((e) => new Date(e.date).toISOString().split("T")[0]))];

  // ✅ Filter steps for selected day
  const filteredSteps = steps.filter(
    (e) => new Date(e.date).toISOString().split("T")[0] === selectedDay
  );

  // ✅ Chart data
  const chartData = {
    labels: filteredSteps.map((e) => new Date(e.date).toLocaleTimeString()),
    datasets: [
      {
        label: `Steps on ${selectedDay}`,
        data: filteredSteps.map((e) => e.steps),
        borderColor: "rgba(75, 192, 192, 1)",
        backgroundColor: "rgba(75, 192, 192, 0.2)",
        fill: true,
        tension: 0.3,
        pointRadius: 3,
      },
    ],
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>Step Logs by Day</h1>

{/* Chart */}
<div style={{ width: "900px", height: "500px", margin: "0 auto" }}>
  <Line
    data={chartData}
    options={{
      responsive: true,
      maintainAspectRatio: false, // 👈 allow custom height
    }}
  />
</div>


      {/* Day Buttons */}
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          marginTop: "1rem",
          gap: "0.5rem",
        }}
      >
        {uniqueDays.map((day) => (
          <button
            key={day}
            onClick={() => setSelectedDay(day)}
            style={{
              padding: "0.5rem 1rem",
              borderRadius: "4px",
              border: "none",
              backgroundColor: selectedDay === day ? "#4cafef" : "#ddd",
              color: selectedDay === day ? "white" : "black",
              cursor: "pointer",
            }}
          >
            {day}
          </button>
        ))}
      </div>
    </div>
  );
}


// /*
// Next.js + Chart.js (react-chartjs-2) — Ready-to-drop-in page with toggle button

// What this file does
// - Fetches step logs from: https://step-tracker-backend-1.onrender.com/steps
// - Polls every 10 seconds to refresh the data
// - Renders a responsive Line chart using Chart.js (via react-chartjs-2)
// - Provides a button to toggle between Line and Bar charts

// Install
//   npm install chart.js react-chartjs-2
// or
//   yarn add chart.js react-chartjs-2

// */
// "use client";

// import { useEffect, useState } from "react";
// import {
//   Chart as ChartJS,
//   CategoryScale,
//   LinearScale,
//   PointElement,
//   LineElement,
//   BarElement,
//   Title,
//   Tooltip,
//   Legend,
// } from "chart.js";
// import { Line } from "react-chartjs-2";

// ChartJS.register(
//   CategoryScale,
//   LinearScale,
//   PointElement,
//   LineElement,
//   BarElement,
//   Title,
//   Tooltip,
//   Legend
// );

// export default function Home() {
//   const [steps, setSteps] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [selectedDay, setSelectedDay] = useState(null);

//   useEffect(() => {
//     const fetchSteps = async () => {
//       try {
//         const res = await fetch("https://step-tracker-backend-1.onrender.com/steps");
//         if (!res.ok) throw new Error("Failed to fetch step logs");
//         const data = await res.json();
//         setSteps(data);
//         setError(null);

//         // ✅ default to first day found
//         if (data.length > 0) {
//           const firstDay = new Date(data[0].date).toISOString().split("T")[0];
//           setSelectedDay(firstDay);
//         }
//       } catch (err) {
//         setError(err.message);
//       } finally {
//         setLoading(false);
//       }
//     };

//     fetchSteps();
//     const interval = setInterval(fetchSteps, 10000);
//     return () => clearInterval(interval);
//   }, []);

//   if (loading) return <p>Loading step logs...</p>;
//   if (error) return <p>Error: {error}</p>;

//   // ✅ Extract unique days from all entries
//   const uniqueDays = [...new Set(steps.map((e) => new Date(e.date).toISOString().split("T")[0]))];

//   // ✅ Filter steps for the selected day
//   const filteredSteps = steps.filter(
//     (e) => new Date(e.date).toISOString().split("T")[0] === selectedDay
//   );

//   // ✅ Chart data (timestamps of the day only)
//   const chartData = {
//     labels: filteredSteps.map((e) => new Date(e.date).toLocaleTimeString()),
//     datasets: [
//       {
//         label: `Steps on ${selectedDay}`,
//         data: filteredSteps.map((e) => e.steps),
//         borderColor: "rgba(75, 192, 192, 1)",
//         backgroundColor: "rgba(75, 192, 192, 0.2)",
//         fill: true,
//         tension: 0.3,
//         pointRadius: 3,
//       },
//     ],
//   };

//   return (
//     <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
//       <h1>Step Logs by Day</h1>

//       {/* Chart */}
//       <div style={{ width: "600px", margin: "0 auto" }}>
//         <Line data={chartData} />
//       </div>

//       {/* Day Buttons */}
//       <div style={{ display: "flex", justifyContent: "center", marginTop: "1rem", gap: "0.5rem" }}>
//         {uniqueDays.map((day) => (
//           <button
//             key={day}
//             onClick={() => setSelectedDay(day)}
//             style={{
//               padding: "0.5rem 1rem",
//               borderRadius: "4px",
//               border: "none",
//               backgroundColor: selectedDay === day ? "#4cafef" : "#ddd",
//               color: selectedDay === day ? "white" : "black",
//               cursor: "pointer",
//             }}
//           >
//             {day}
//           </button>
//         ))}
//       </div>
//     </div>
//   );
// }
