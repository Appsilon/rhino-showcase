/* global HTMLWidgets */

function ensureArray(x) {
  if (!(typeof (x) === 'object' && x.length)) {
    return [x];
  }
  return x;
}

window.LeafletWidget.methods.setStyle = function setStyle(category, layerId, style) {
  const map = this;
  if (!layerId) return;

  // Convert columnstore to row store.
  const convertedStyle = HTMLWidgets.dataframeToD3(style);

  ensureArray(layerId).forEach((d, i) => {
    const layer = map.layerManager.getLayer(category, d);
    if (layer) { // Or should this raise an error?
      layer.setStyle(convertedStyle[i]);
    }
  });
};

window.LeafletWidget.methods.setLabel = function setLabel(category, layerId, label) {
  const map = this;
  if (!layerId) return;

  ensureArray(layerId).forEach((d, i) => {
    const layer = map.layerManager.getLayer(category, d);
    if (layer) { // Or should this raise an error?
      layer.unbindTooltip();
      // The object subsetting to get the integer array and casting to string is what I added.
      layer.bindTooltip(label.label[i].toString());
    }
  });
};

window.LeafletWidget.methods.setPopup = function setPopup(category, layerId, popup) {
  const map = this;
  if (!layerId) return;

  ensureArray(layerId).forEach((d, i) => {
    const layer = map.layerManager.getLayer(category, d);
    if (layer) { // Or should this raise an error?
      layer.unbindPopup();
      // The object subsetting to get the integer array and casting to string is what I added.
      layer.bindPopup(popup.popup[i].toString());
    }
  });
};

$(document).ready(() => {
  $('#app-info_text-about_section-about_button').click(() => {
    Shiny.setInputValue('app-info_text-about_section-about_button', 'active', {
      priority: 'event',
    });
  });
});
