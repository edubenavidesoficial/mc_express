const API_BASE_URL = "https://mc.ingealimite.com/api/v1";

async function loadDashboard() {
  const [dashboardResponse, requestsResponse] = await Promise.all([
    fetch(`${API_BASE_URL}/admin/dashboard`),
    fetch(`${API_BASE_URL}/admin/requests`),
  ]);

  const dashboard = await dashboardResponse.json();
  const requests = await requestsResponse.json();

  document.getElementById("users").textContent = dashboard.users ?? 0;
  document.getElementById("professionals").textContent =
    dashboard.professionals ?? 0;
  document.getElementById("requests").textContent = dashboard.requests ?? 0;
  document.getElementById("payments").textContent = dashboard.payments ?? 0;

  const list = document.getElementById("requestList");
  list.innerHTML = "";
  requests.forEach((request) => {
    const item = document.createElement("div");
    item.className = "request";
    item.innerHTML = `
      <strong>#${request.id}</strong>
      <span>${request.address}</span>
      <span class="status">${request.status}</span>
    `;
    list.appendChild(item);
  });
}

document.getElementById("refreshButton").addEventListener("click", loadDashboard);
loadDashboard().catch(() => {
  document.getElementById("requestList").innerHTML =
    '<p>No se pudo conectar con el API. Revisa el dominio y CORS.</p>';
});
