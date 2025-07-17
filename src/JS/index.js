function changeActiveFilter(svg) {
  let activeFilter = document.querySelector(".activeFilter");

  if (svg.parentElement.classList.contains("activeFilter")) {
    return;
  } else {
    activeFilter.classList.remove("activeFilter");
    svg.parentElement.classList.add("activeFilter");
  }
}

function treeFilter() {
  const treeFilter = document.getElementById("treeFilter");
  const list = document.getElementById("toc");
  const treeOrderList = [...list.children];
  const alphaOrderList = [...list.children].sort((a, b) =>
    a.textContent.localeCompare(b.textContent)
  );

  treeFilter.addEventListener("click", (e) => {
    const svg = e.target.closest("svg");

    if (svg) {
      const lists = {
        treeOrder: treeOrderList,
        alphaOrder: alphaOrderList,
      };

      const whichIcon = svg.classList.value;

      list.innerHTML = lists[`${whichIcon}`].map((li) => li.outerHTML).join("");

      changeActiveFilter(svg);
    }
  });
}

function init() {
  treeFilter();
}

document.body.addEventListener("load", init());
