/* global Elm document */

const node = document.getElementById(`main`);
const app  = Elm.Main.embed(node, {
  month: (new Date().getMonth()) + 1,
});

app.ports.check.subscribe((month) => {
  const daysInMonth = new Date(new Date().getFullYear(), month, 0).getDate();

  app.ports.suggestions.send(daysInMonth);
});
