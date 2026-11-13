// SECCIÓN: 01_estado
// Activa las comprobaciones estrictas del lenguaje para evitar asignaciones accidentales.
"use strict";
// Interfaz local uihtml. La captura, el filtrado y la salida son de MATLAB.
// Actualiza el dato «elemento» con el valor o cálculo indicado.
const elemento = (id) => document.getElementById(id);
// Actualiza el dato «limitar» con el valor o cálculo indicado.
const limitar = (v, a, b) => Math.max(a, Math.min(b, v));
// Actualiza el dato «parametrosIniciales» con el valor o cálculo indicado.
const parametrosIniciales = () => ({
  // Define la ganancia de entrada en dB dentro del grupo de datos que se está construyendo.
  inputDB: 0,
  // Define la ganancia de salida en dB dentro del grupo de datos que se está construyendo.
  outputDB: -12,
  // Define el silencio de la salida dentro del grupo de datos que se está construyendo.
  mute: false,
  // Define la comparación con el procesamiento omitido dentro del grupo de datos que se está construyendo.
  bypass: false,
  // Define la activación del pasaaltos dentro del grupo de datos que se está construyendo.
  hpOn: true,
  // Define la frecuencia de corte del pasaaltos dentro del grupo de datos que se está construyendo.
  hpHz: 60,
  // Define las tres bandas de resonancias: activación, frecuencia, Q y profundidad dentro del grupo de datos que se está construyendo.
  notches: [
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [1, 340, 15, 12],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [0, 520, 15, 12],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [0, 720, 15, 12],
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  ],
  // Define la forma notch o campana de cada corte dentro del grupo de datos que se está construyendo.
  notchTypes: [0, 0, 0],
  // Define el número de pasadas del banco dentro del grupo de datos que se está construyendo.
  passes: 1,
  // Define las cuatro bandas del ecualizador dentro del grupo de datos que se está construyendo.
  eq: [
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [120, 0, 0.707],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [500, 0, 1.5],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [2500, 0, 1.2],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    [8000, 0, 0.707],
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  ],
  // Define la activación de la puerta dentro del grupo de datos que se está construyendo.
  gateOn: false,
  // Define el umbral de la puerta dentro del grupo de datos que se está construyendo.
  gateThreshold: -45,
  // Define la atenuación de la puerta cerrada dentro del grupo de datos que se está construyendo.
  gateRange: 30,
  // Define el tiempo de apertura de la puerta dentro del grupo de datos que se está construyendo.
  gateAttack: 1,
  // Define el tiempo de cierre de la puerta dentro del grupo de datos que se está construyendo.
  gateRelease: 150,
  // Define el tiempo de mantenimiento de la puerta dentro del grupo de datos que se está construyendo.
  gateHold: 80,
  // Define la activación del compresor dentro del grupo de datos que se está construyendo.
  compOn: false,
  // Define el umbral del compresor dentro del grupo de datos que se está construyendo.
  compThreshold: -18,
  // Define la proporción de compresión dentro del grupo de datos que se está construyendo.
  ratio: 3,
  // Define el tiempo de ataque del compresor dentro del grupo de datos que se está construyendo.
  compAttack: 10,
  // Define el tiempo de recuperación del compresor dentro del grupo de datos que se está construyendo.
  compRelease: 100,
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Actualiza el estado compartido de la interfaz con el valor o cálculo indicado.
const S = {
  // Define los parámetros del procesamiento dentro del grupo de datos que se está construyendo.
  p: parametrosIniciales(),
  // Define la activación de las bandas del ecualizador dentro del grupo de datos que se está construyendo.
  eqOn: [true, true, true, true],
  // Define los elementos seleccionados dentro del grupo de datos que se está construyendo.
  selected: "e1",
  // Define la unidad seleccionada para el ancho dentro del grupo de datos que se está construyendo.
  widthUnit: "q",
  // Define el intervalo vertical de la gráfica dentro del grupo de datos que se está construyendo.
  range: 15,
  // Define la visibilidad del espectro en tiempo real dentro del grupo de datos que se está construyendo.
  rta: true,
  // Define el estado de ejecución dentro del grupo de datos que se está construyendo.
  running: false,
  // Define el dato «config» dentro del grupo de datos que se está construyendo.
  config: {
    // Define la fuente de audio dentro del grupo de datos que se está construyendo.
    mode: "Demo",
    // Define el controlador de audio dentro del grupo de datos que se está construyendo.
    driver: "DirectSound",
    // Define el dispositivo o los datos de entrada según el contexto dentro del grupo de datos que se está construyendo.
    input: "Default",
    // Define el dispositivo o los datos de salida según el contexto dentro del grupo de datos que se está construyendo.
    output: "Default",
    // Define la frecuencia de muestreo dentro del grupo de datos que se está construyendo.
    fs: 48000,
    // Define las muestras por bloque dentro del grupo de datos que se está construyendo.
    block: 256,
    // Define el canal de entrada dentro del grupo de datos que se está construyendo.
    inCh: 0,
    // Define el primer canal de salida dentro del grupo de datos que se está construyendo.
    outCh: 1,
    // Define la duplicación mono en dos canales dentro del grupo de datos que se está construyendo.
    stereo: true,
    // Define la repetición del WAV dentro del grupo de datos que se está construyendo.
    loop: false,
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  },
  // Define las entradas de audio dentro del grupo de datos que se está construyendo.
  inputs: ["Default"],
  // Define las salidas de audio dentro del grupo de datos que se está construyendo.
  outputs: ["Default"],
  // Define las frecuencias sugeridas dentro del grupo de datos que se está construyendo.
  candidates: [],
  // Define los resultados del análisis dentro del grupo de datos que se está construyendo.
  suggestions: null,
  // Define la revisión del análisis dentro del grupo de datos que se está construyendo.
  suggestionVersion: -1,
  // Define los datos de los dispositivos dentro del grupo de datos que se está construyendo.
  deviceInfo: null,
  // Define el identificador de la consulta de dispositivos dentro del grupo de datos que se está construyendo.
  deviceRequest: 0,
  // Define la selección al comenzar la consulta dentro del grupo de datos que se está construyendo.
  deviceSelection: null,
  // Define la descripción de la ruta de audio dentro del grupo de datos que se está construyendo.
  route: null,
  // Define la visibilidad de la comparación de etapas dentro del grupo de datos que se está construyendo.
  stageView: false,
  // Define la representación temporal o frecuencial dentro del grupo de datos que se está construyendo.
  stageMode: "frequency",
  // Define el panel abierto dentro del grupo de datos que se está construyendo.
  panel: "eq",
  // Define las últimas mediciones recibidas dentro del grupo de datos que se está construyendo.
  frame: null,
  // Define la conexión con MATLAB dentro del grupo de datos que se está construyendo.
  bridge: null,
  // Define el identificador usado para localizar el elemento dentro del grupo de datos que se está construyendo.
  id: 0,
  // Define el envío pendiente de parámetros dentro del grupo de datos que se está construyendo.
  timer: null,
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Actualiza los nombres, colores y tipos de bandas con el valor o cálculo indicado.
const bands = [
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "n0", name: "NOTCH 1", type: "NOTCH / RESONANCIA", color: "#efa76d" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "n1", name: "NOTCH 2", type: "NOTCH / RESONANCIA", color: "#df9366" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "n2", name: "NOTCH 3", type: "NOTCH / RESONANCIA", color: "#ca805d" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "e0", name: "BAJOS", type: "LOW SHELF / S = 1", color: "#77d699" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "e1", name: "MEDIOS", type: "PEAKING / BELL", color: "#5ebbf1" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "e2", name: "PRESENCIA", type: "PEAKING / BELL", color: "#b798e6" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "e3", name: "BRILLO", type: "HIGH SHELF / S = 1", color: "#e4cb6d" },
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
];
// Actualiza la malla inicial de frecuencias con el valor o cálculo indicado.
const baseFreq = Array.from({ length: 480 }, (_, i) => 20 * Math.pow(1000, i / 479));
// Actualiza las frecuencias usadas para dibujar las curvas con el valor o cálculo indicado.
let freq = baseFreq.slice();
// Actualiza el dato «posicionFrecuencia» con el valor o cálculo indicado.
const posicionFrecuencia = (f) => 48 + (904 * Math.log10(f / 20)) / 3;
// Actualiza el dato «posicionGanancia» con el valor o cálculo indicado.
const posicionGanancia = (g) => 168 - (153 * g) / S.range;
// Actualiza el dato «posicionEspectro»; mantiene un valor dentro del intervalo permitido.
const posicionEspectro = (db) => 15 + (306 * (0 - limitar(db, -100, 0))) / 100;
// Actualiza el dato «formatearFrecuencia» con el valor o cálculo indicado.
const formatearFrecuencia = (v) =>
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  v >= 1000 ? (v / 1000).toFixed(v < 10000 ? 2 : 1) + " kHz" : Math.round(v) + " Hz";
// Actualiza el dato «escaparTexto» con el valor o cálculo indicado.
const escaparTexto = (v) =>
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  String(v).replace(
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    /[&<>"']/g,
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c],
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );

// SECCIÓN: 02_comunicacion
// Copia los parámetros y anula la ganancia de las bandas desactivadas.
function parametrosActivos() {
  // Actualiza los parámetros del procesamiento con el valor o cálculo indicado.
  const p = JSON.parse(JSON.stringify(S.p));
  // Recorre la lista para calcular o actualizar cada elemento.
  p.eq.forEach((b, i) => {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (!S.eqOn[i]) b[1] = 0;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return p;
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Muestra un aviso y distingue visualmente si se trata de un error.
function mostrarEstado(s, error = false) {
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("status").textContent = s;
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("status").classList.toggle("error", error);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Envía a MATLAB una acción con los ajustes y la configuración actuales.
function enviarComando(action) {
  // Cancela el envío pendiente para evitar aplicar un cambio antiguo después de uno nuevo.
  clearTimeout(S.timer);
  // Actualiza el envío pendiente de parámetros con el valor o cálculo indicado.
  S.timer = null;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.bridge) {
    // Actualiza el identificador usado para localizar el elemento con el valor o cálculo indicado.
    const id = ++S.id;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (action === "devices" || action === "ready" || action === "start") {
      // Actualiza el identificador de la consulta de dispositivos con el valor o cálculo indicado.
      S.deviceRequest = id;
      // Actualiza la selección al comenzar la consulta con el valor o cálculo indicado.
      S.deviceSelection = { input: S.config.input, output: S.config.output };
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
    // Actualiza el dato «S.bridge.Data» con el valor o cálculo indicado.
    S.bridge.Data = {
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      action,
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      id,
      // Define la visibilidad de la comparación de etapas dentro del grupo de datos que se está construyendo.
      stageView: S.stageView,
      // Define los parámetros del procesamiento dentro del grupo de datos que se está construyendo.
      p: parametrosActivos(),
      // Define el dato «ui» dentro del grupo de datos que se está construyendo.
      ui: { eq: S.p.eq.map((r) => r.slice()), eqOn: S.eqOn.slice() },
      // Define el dato «config» dentro del grupo de datos que se está construyendo.
      config: JSON.parse(JSON.stringify(S.config)),
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    };
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  } else if (action !== "params")
    // Muestra un aviso y distingue visualmente si se trata de un error.
    mostrarEstado("Vista de interfaz: abre ABRIR_SNARE.m en MATLAB para procesar audio.");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
function notificarCambio() {
  // Actualiza las gráficas, el inspector y los controles con el estado actual.
  actualizarInterfaz();
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.timer) S.timer = setTimeout(() => enviarComando("params"), 40);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// MATLAB llama setup al cargar el documento; no requiere servidor ni Internet.
// Recibe la conexión uihtml de MATLAB; este nombre debe conservarse por compatibilidad.
function setup(htmlComponent) {
  // Actualiza la conexión con MATLAB con el valor o cálculo indicado.
  S.bridge = htmlComponent;
  // Registra la acción que debe ejecutarse cuando ocurra el evento «DataChanged».
  htmlComponent.addEventListener("DataChanged", () => recibirMensaje(htmlComponent.Data));
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("connection").textContent = "MATLAB · V4.1";
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("connection-dot").classList.add("online");
  // Envía a MATLAB una acción con los ajustes y la configuración actuales.
  enviarComando("ready");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza el dato «window.setup» con el valor o cálculo indicado.
window.setup = setup;
// Interpreta el mensaje de MATLAB y actualiza el área correspondiente.
function recibirMensaje(d) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (typeof d === "string") {
    // Intenta interpretar la información recibida y permite detectar errores de formato.
    try {
      // Actualiza la proporción de señal original que limita la profundidad del notch con el valor o cálculo indicado.
      d = JSON.parse(d);
    // Atiende un error de interpretación sin interrumpir el resto de la interfaz.
    } catch (_) {
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      return;
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!d || !d.kind) return;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.message) mostrarEstado(d.message, d.kind === "error");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.devices) recibirDispositivos(d.devices);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.suggestionVersion !== undefined) recibirSugerencias(d);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.inputRoute !== undefined) {
    // Actualiza la descripción de la ruta de audio con el valor o cálculo indicado.
    S.route = d;
    // Describe el dispositivo y el canal que están recibiendo y reproduciendo audio.
    actualizarRutaAudio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Selecciona la respuesta adecuada según el tipo de mensaje recibido.
  switch (d.kind) {
    // Atiende el mensaje o caso "frame".
    case "frame":
      // Actualiza las últimas mediciones recibidas con el valor o cálculo indicado.
      S.frame = d;
      // Actualiza los botones y bloquea la configuración que no puede cambiar durante una toma.
      mostrarEstadoEjecucion(d.running);
      // Representa los espectros de entrada y salida recibidos de MATLAB.
      dibujarEspectros();
      // Dibuja las mismas ventanas de audio antes y después de cada etapa.
      dibujarEtapas();
      // Actualiza las barras de nivel, el indicador de saturación y los datos de la toma.
      actualizarMedidores(d);
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "state".
    case "state":
      // Actualiza los botones y bloquea la configuración que no puede cambiar durante una toma.
      mostrarEstadoEjecucion(d.running);
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "file".
    case "file":
      // Borra las curvas de comparación cuando todavía no existen mediciones.
      limpiarEtapas();
      // Actualiza la fuente de audio con el valor o cálculo indicado.
      S.config.mode = "WAV";
      // Actualiza la frecuencia de muestreo con el valor o cálculo indicado.
      S.config.fs = d.fs;
      // Actualiza las últimas mediciones recibidas con el valor o cálculo indicado.
      S.frame = null;
      // Busca un control de la página por su identificador.
      elemento("source").value = "WAV";
      // Actualiza el texto visible del control con el resultado o estado actual.
      elemento("filename").textContent = d.name + " · " + d.duration.toFixed(1) + " s";
      // Actualiza las gráficas, el inspector y los controles con el estado actual.
      actualizarInterfaz();
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "devices".
    case "devices":
      // Actualiza las listas de audio y descarta respuestas anteriores a la última selección.
      recibirDispositivos(d);
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "candidates".
    case "candidates":
      // Comprueba la condición indicada antes de ejecutar la acción siguiente.
      if (d.openPanel) abrirPanel("notch");
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "preset".
    case "preset":
      // Actualiza los parámetros del procesamiento con el valor o cálculo indicado.
      S.p = d.p;
      // Actualiza la forma notch o campana de cada corte con el valor o cálculo indicado.
      S.p.notchTypes = S.p.notchTypes || [0, 0, 0];
      // Actualiza la activación de las bandas del ecualizador con el valor o cálculo indicado.
      S.eqOn = d.eqOn || [true, true, true, true];
      // Actualiza las gráficas, el inspector y los controles con el estado actual.
      actualizarInterfaz();
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
    // Atiende el mensaje o caso "curve".
    case "curve":
      // Comprueba la condición indicada antes de ejecutar la acción siguiente.
      if (!S.timer && !drag) dibujarRespuestaTotal(d.freq, d.curve);
      // Finaliza este caso para no ejecutar los casos siguientes.
      break;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Convierte una respuesta vacía, simple o múltiple a una lista uniforme.
function convertirEnLista(v) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return v == null ? [] : Array.isArray(v) ? v : [v];
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza las listas de audio y descarta respuestas anteriores a la última selección.
function recibirDispositivos(d) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.mode !== S.config.mode || d.driver !== S.config.driver || d.requestId < S.deviceRequest)
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    return;
  // Actualiza los datos de los dispositivos con el valor o cálculo indicado.
  S.deviceInfo = d;
  // Actualiza las entradas de audio; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
  S.inputs = convertirEnLista(d.inputs);
  // Actualiza las salidas de audio; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
  S.outputs = convertirEnLista(d.outputs);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.inputs.includes("Default")) S.inputs.unshift("Default");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.outputs.includes("Default")) S.outputs.unshift("Default");
  // Una respuesta atrasada no pisa una seleccion manual mas reciente.
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.deviceSelection && S.config.input === S.deviceSelection.input)
    // Actualiza el dispositivo o los datos de entrada según el contexto con el valor o cálculo indicado.
    S.config.input = d.input || "Default";
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.deviceSelection && S.config.output === S.deviceSelection.output)
    // Actualiza el dispositivo o los datos de salida según el contexto con el valor o cálculo indicado.
    S.config.output = d.output || "Default";
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.panel === "audio") abrirPanel("audio", false);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Recibe una nueva revisión de las resonancias sugeridas.
function recibirSugerencias(d) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (d.suggestionVersion <= S.suggestionVersion) return;
  // Actualiza la revisión del análisis con el valor o cálculo indicado.
  S.suggestionVersion = d.suggestionVersion;
  // Actualiza los resultados del análisis con el valor o cálculo indicado.
  S.suggestions =
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    d.suggestions && typeof d.suggestions === "object" && !Array.isArray(d.suggestions)
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ? d.suggestions
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : null;
  // Actualiza las frecuencias sugeridas; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
  S.candidates = convertirEnLista(S.suggestions && S.suggestions.values);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.panel === "notch") {
    // Actualiza el dato «region»; busca un control de la página por su identificador.
    const region = elemento("suggestion-results");
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (region) region.innerHTML = contenidoSugerencias();
    // Conecta el botón que copia las sugerencias a los filtros.
    conectarAplicacionDeSugerencias();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.suggestions && d.kind === "frame")
    // Muestra un aviso y distingue visualmente si se trata de un error.
    mostrarEstado(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      S.candidates.length
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        ? "Sugerencias: " +
            // Presenta una frecuencia con unidades Hz o kHz.
            S.candidates.map((v) => formatearFrecuencia(v)).join(", ") +
            // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
            ". Abre RESONANCIAS para revisar los cortes."
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        : S.suggestions.message,
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Construye las etiquetas de frecuencia, Q y corte propuestos.
function contenidoSugerencias() {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.candidates.length)
    // Devuelve el resultado de la expresión o del contenido construido en esta función.
    return (
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "<p>" +
      // Protege el texto que se insertará en la página para tratarlo como contenido.
      escaparTexto(
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        S.suggestions
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          ? S.suggestions.message
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          : "Analisis automatico: carga un WAV o inicia Demo / Tiempo real. Se actualiza cada 4 segundos.",
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "</p>"
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    );
  // Actualiza los coeficientes de la cadena con el valor o cálculo indicado.
  const s = S.suggestions,
    // Actualiza el factor Q que controla la anchura; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
    q = convertirEnLista(s.q),
    // Actualiza el dato «cuts»; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
    cuts = convertirEnLista(s.cuts),
    // Actualiza el orden armónico de cada pico; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
    orders = convertirEnLista(s.harmonics);
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return (
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    S.candidates
      // Recorre la lista para calcular o actualizar cada elemento.
      .map(
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (v, i) =>
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          '<span class="candidate" title="' +
          // Protege el texto que se insertará en la página para tratarlo como contenido.
          escaparTexto(
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            orders[i] > 1
              // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
              ? "Armonico probable H" +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  orders[i] +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  "; fundamental " +
                  // Presenta una frecuencia con unidades Hz o kHz.
                  formatearFrecuencia(s.fundamental)
              // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
              : "Pico persistente; no implica armonico",
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          ) +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          '">' +
          // Presenta una frecuencia con unidades Hz o kHz.
          formatearFrecuencia(v) +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          " · −" +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          cuts[i] +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          " dB · Q " +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          q[i] +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          (orders[i] > 1 ? " · H" + orders[i] : "") +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          "</span>",
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      )
      // Une los fragmentos calculados para formar el contenido final.
      .join("") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<div class="row-buttons"><button id="apply-candidates" class="primary">Aplicar candidatos</button></div>'
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Conecta el botón que copia las sugerencias a los filtros.
function conectarAplicacionDeSugerencias() {
  // Actualiza el dato «apply»; busca un control de la página por su identificador.
  const apply = elemento("apply-candidates");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!apply) return;
  // Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
  apply.onclick = () => {
    // Actualiza el factor Q que controla la anchura; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
    const q = convertirEnLista(S.suggestions.q),
      // Actualiza el dato «cuts»; convierte una respuesta vacía, simple o múltiple a una lista uniforme.
      cuts = convertirEnLista(S.suggestions.cuts);
    // Recorre la lista para calcular o actualizar cada elemento.
    S.p.notches.forEach((r, i) => {
      // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
      r[0] = i < S.candidates.length ? 1 : 0;
      // Comprueba la condición indicada antes de ejecutar la acción siguiente.
      if (r[0]) {
        // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
        r[1] = S.candidates[i];
        // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
        r[2] = q[i];
        // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
        r[3] = Math.round((cuts[i] / S.p.passes) * 100) / 100;
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      }
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    });
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
    // Envía a MATLAB una acción con los ajustes y la configuración actuales.
    enviarComando("params");
    // Abre la sección solicitada y conecta sus controles con los parámetros.
    abrirPanel("eq");
    // Muestra un aviso y distingue visualmente si se trata de un error.
    mostrarEstado("Sugerencias aplicadas. Compara con BYPASS y ajusta escuchando.");
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  };
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Describe el dispositivo y el canal que están recibiendo y reproduciendo audio.
function actualizarRutaAudio() {
  // Actualiza el dato «e»; busca un control de la página por su identificador.
  const e = elemento("audio-route");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!e) return;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.running && S.route) {
    // Actualiza la proporción de señal original que limita la profundidad del notch con el valor o cálculo indicado.
    const d = S.route;
    // Actualiza el texto visible del control con el resultado o estado actual.
    e.textContent =
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "Entrada: " +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      d.inputRoute +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      " · " +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (d.activeInput ? "canal " + d.activeInput : "buscando canal") +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (d.inputHasSignal ? " · con senal" : " · sin senal suficiente") +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      ". Salida: " +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      d.outputRoute +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      ".";
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  } else if (S.deviceInfo) e.textContent = S.deviceInfo.message;
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza los botones y bloquea la configuración que no puede cambiar durante una toma.
function mostrarEstadoEjecucion(v) {
  // Actualiza el estado de ejecución con el valor o cálculo indicado.
  S.running = !!v;
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("live-dot").classList.toggle("running", S.running);
  // Busca un control de la página por su identificador.
  elemento("start").disabled = S.running;
  // Busca un control de la página por su identificador.
  elemento("stop").disabled = !S.running;
  // Busca un control de la página por su identificador.
  elemento("source").disabled = S.running;
  // Busca un control de la página por su identificador.
  elemento("load").disabled = S.running;
  // Localiza en la página los controles que cumplen el selector indicado.
  document.querySelectorAll("[data-idle]").forEach((e) => (e.disabled = S.running));
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Mismas ecuaciones RBJ que SnareDSP: la curva sigue el gesto inmediatamente.

// SECCIÓN: 03_filtros_y_grafica
// Calcula los coeficientes de un filtro digital de segundo orden.
function calcularFiltro(type, fs, f, q, g) {
  // Convierte la frecuencia central de Hz a radianes por muestra.
  const w = (2 * Math.PI * f) / fs,
    // Calcula el coseno de la frecuencia angular para formar los coeficientes.
    c = Math.cos(w),
    // Relaciona el seno de la frecuencia con Q; un Q mayor produce una banda más estrecha.
    al = Math.sin(w) / (2 * q),
    // Convierte la ganancia en dB al factor de amplitud utilizado por estas ecuaciones.
    A = Math.pow(10, g / 40),
    // Calcula el término auxiliar de las bandas de graves y brillo con pendiente fija.
    t = Math.sqrt(2 * A) * Math.sin(w);
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  let b, a;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (type === "hp") {
    // Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
    b = [(1 + c) / 2, -1 - c, (1 + c) / 2];
    // Define los coeficientes que realimentan las muestras de salida anteriores.
    a = [1 + al, -2 * c, 1 - al];
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (type === "notch") {
    // Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
    b = [1, -2 * c, 1];
    // Define los coeficientes que realimentan las muestras de salida anteriores.
    a = [1 + al, -2 * c, 1 - al];
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (type === "peak") {
    // Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
    b = [1 + al * A, -2 * c, 1 - al * A];
    // Define los coeficientes que realimentan las muestras de salida anteriores.
    a = [1 + al / A, -2 * c, 1 - al / A];
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (type === "low") {
    // Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
    b = [
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      A * (A + 1 - (A - 1) * c + t),
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      2 * A * (A - 1 - (A + 1) * c),
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      A * (A + 1 - (A - 1) * c - t),
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    ];
    // Define los coeficientes que realimentan las muestras de salida anteriores.
    a = [A + 1 + (A - 1) * c + t, -2 * (A - 1 + (A + 1) * c), A + 1 + (A - 1) * c - t];
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (type === "high") {
    // Define los coeficientes que ponderan la entrada actual y las entradas anteriores.
    b = [
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      A * (A + 1 + (A - 1) * c + t),
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      -2 * A * (A - 1 + (A + 1) * c),
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      A * (A + 1 + (A - 1) * c - t),
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    ];
    // Define los coeficientes que realimentan las muestras de salida anteriores.
    a = [A + 1 - (A - 1) * c + t, 2 * (A - 1 - (A + 1) * c), A + 1 - (A - 1) * c - t];
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return [...b.map((v) => v / a[0]), ...a.map((v) => v / a[0])];
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Calcula en dB la respuesta de un filtro a una frecuencia concreta.
function magnitudFiltro(s, f) {
  // Actualiza la frecuencia angular o la ventana de análisis según el contexto con el valor o cálculo indicado.
  const w = (2 * Math.PI * f) / S.config.fs,
    // Actualiza el dato «c» con el valor o cálculo indicado.
    c = Math.cos(w),
    // Actualiza el dato «si» con el valor o cálculo indicado.
    si = -Math.sin(w),
    // Actualiza el dato «c2» con el valor o cálculo indicado.
    c2 = Math.cos(2 * w),
    // Actualiza el dato «s2» con el valor o cálculo indicado.
    s2 = -Math.sin(2 * w);
  // Actualiza el dato «nr» con el valor o cálculo indicado.
  const nr = s[0] + s[1] * c + s[2] * c2,
    // Actualiza el dato «ni» con el valor o cálculo indicado.
    ni = s[1] * si + s[2] * s2,
    // Actualiza el dato «dr» con el valor o cálculo indicado.
    dr = 1 + s[4] * c + s[5] * c2,
    // Actualiza el dato «di» con el valor o cálculo indicado.
    di = s[4] * si + s[5] * s2;
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return 10 * Math.log10(Math.max(1e-16, (nr * nr + ni * ni) / (dr * dr + di * di)));
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Calcula la respuesta de una banda y considera su activación y número de pasadas.
function curvaDeBanda(id) {
  // Actualiza el dato «i» con el valor o cálculo indicado.
  const i = +id[1],
    // Actualiza el número de muestras o índice de trabajo con el valor o cálculo indicado.
    n = id[0] === "n",
    // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
    r = n ? S.p.notches[i] : S.p.eq[i];
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  let s;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (n) {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (S.p.notchTypes[i] === 1) s = calcularFiltro("peak", S.config.fs, r[1], r[2], -r[3]);
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else {
      // Actualiza los coeficientes de la cadena; calcula los coeficientes de un filtro digital de segundo orden.
      s = calcularFiltro("notch", S.config.fs, r[1], r[2], 0);
      // Actualiza la proporción de señal original que limita la profundidad del notch con el valor o cálculo indicado.
      const d = Math.pow(10, -r[3] / 20);
      // Recorre los parámetros o los elementos indicados para aplicarles la misma operación.
      for (let j = 0; j < 3; j++) s[j] = d * s[j + 3] + (1 - d) * s[j];
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  } else
    // Actualiza los coeficientes de la cadena; calcula los coeficientes de un filtro digital de segundo orden.
    s = calcularFiltro(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ["low", "peak", "peak", "high"][i],
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      S.config.fs,
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      r[0],
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      r[2],
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      S.eqOn[i] ? r[1] : 0,
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    );
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return freq.map((f) => (n ? (r[0] ? S.p.passes : 0) : 1) * magnitudFiltro(s, f));
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
function trazadoDeCurva(f, v, fn) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return f
    // Convierte una frecuencia a su posición horizontal en escala logarítmica.
    .map((x, i) => (i ? "L" : "M") + posicionFrecuencia(x).toFixed(2) + "," + fn(v[i]).toFixed(2))
    // Une los fragmentos calculados para formar el contenido final.
    .join(" ");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza la curva combinada y representa una respuesta plana cuando hay BYPASS.
function dibujarRespuestaTotal(f, v) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!f || !v) return;
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("curve").setAttribute(
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "d",
    // Convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
    trazadoDeCurva(f, S.p.bypass ? f.map(() => 0) : v, posicionGanancia),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Dibuja las respuestas de filtros, la banda seleccionada y sus nodos de arrastre.
function dibujarGrafica() {
  // Malla local densa: preserva la respuesta real sin dibujar vertices falsos.
  // Actualiza el dato «local» con el valor o cálculo indicado.
  const local = [...S.p.notches.map((r) => [r[1], r[2]]), ...S.p.eq.map((r) => [r[0], r[2]])];
  // Actualiza las frecuencias usadas para dibujar las curvas con el valor o cálculo indicado.
  freq = [
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ...new Set([
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ...baseFreq,
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ...local.flatMap(([f, q]) =>
        // Mantiene un valor dentro del intervalo permitido.
        Array.from({ length: 161 }, (_, i) => f * Math.exp(limitar((i - 80) / 5 / q, -20, 20))),
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      ),
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    ]),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  ]
    // Conserva únicamente los valores que cumplen el criterio indicado.
    .filter((f) => f >= 20 && f <= 20000)
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    .sort((a, b) => a - b);
  // Actualiza la respuesta combinada de los filtros con el valor o cálculo indicado.
  let total = freq.map(() => 0),
    // Actualiza las áreas y los contornos individuales con el valor o cálculo indicado.
    fills = "";
  // Recorre la lista para calcular o actualizar cada elemento.
  bands.forEach((b) => {
    // Actualiza el dato «v»; calcula la respuesta de una banda y considera su activación y número de pasadas.
    const v = curvaDeBanda(b.id);
    // Actualiza la respuesta combinada de los filtros con el valor o cálculo indicado.
    total = total.map((g, i) => g + v[i]);
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (b.id === S.selected)
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      fills +=
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<path d="' +
        // Convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
        trazadoDeCurva(freq, v, posicionGanancia) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        " L952," +
        // Convierte una ganancia en dB a la posición vertical de la gráfica.
        posicionGanancia(0) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        " L48," +
        // Convierte una ganancia en dB a la posición vertical de la gráfica.
        posicionGanancia(0) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        ' Z" fill="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" opacity=".13"/><path d="' +
        // Convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
        trazadoDeCurva(freq, v, posicionGanancia) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" fill="none" stroke="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" opacity=".7" stroke-width="1.2"/>';
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      fills +=
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<path d="' +
        // Convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
        trazadoDeCurva(freq, v, posicionGanancia) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" fill="none" stroke="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" opacity=".25" stroke-width="1"/>';
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.p.hpOn) {
    // Actualiza los coeficientes de la cadena; calcula los coeficientes de un filtro digital de segundo orden.
    const s = calcularFiltro("hp", S.config.fs, S.p.hpHz, 1 / Math.sqrt(2), 0);
    // Actualiza la respuesta combinada de los filtros con el valor o cálculo indicado.
    total = total.map((g, i) => g + magnitudFiltro(s, freq[i]));
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  elemento("band-fills").innerHTML = S.p.bypass ? "" : fills;
  // Actualiza la curva combinada y representa una respuesta plana cuando hay BYPASS.
  dibujarRespuestaTotal(freq, total);
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  elemento("nodes").innerHTML = bands
    // Recorre la lista para calcular o actualizar cada elemento.
    .map((b) => {
      // Actualiza el dato «v»; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
      const v = obtenerBanda(b.id),
        // Actualiza la presencia de señal suficiente con el valor o cálculo indicado.
        active = v.on;
      // Devuelve el resultado de la expresión o del contenido construido en esta función.
      return (
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<g class="node ' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (b.id === S.selected ? "selected" : "") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" data-band="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.id +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" transform="translate(' +
        // Convierte una frecuencia a su posición horizontal en escala logarítmica.
        posicionFrecuencia(v.freq) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "," +
        // Mantiene un valor dentro del intervalo permitido.
        limitar(posicionGanancia(v.notch ? -v.depth * S.p.passes : v.gain), 19, 317) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        ')" opacity="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (active ? 1 : 0.4) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '"><circle r="17" fill="transparent"/><circle class="ring" r="11" stroke="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" ' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (!active ? 'stroke-dasharray="3 3"' : "") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '/><text text-anchor="middle" dy="3.5" fill="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '">' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (v.notch ? "N" + (+b.id[1] + 1) : +b.id[1] + 1) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '</text><text text-anchor="middle" y="-19" fill="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '">' +
        // Presenta una frecuencia con unidades Hz o kHz.
        (b.id === S.selected ? formatearFrecuencia(v.freq) : "") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "</text></g>"
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      );
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    })
    // Une los fragmentos calculados para formar el contenido final.
    .join("");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Dibuja referencias de frecuencia y nivel para facilitar la lectura.
function dibujarCuadricula() {
  // Actualiza los coeficientes de la cadena con el valor o cálculo indicado.
  let s = "";
  // Recorre la lista para calcular o actualizar cada elemento.
  [20, 30, 50, 100, 200, 300, 500, 1000, 2000, 3000, 5000, 10000, 20000].forEach((f) => {
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    s +=
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<line class="grid-line" x1="' +
      // Convierte una frecuencia a su posición horizontal en escala logarítmica.
      posicionFrecuencia(f) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '" x2="' +
      // Convierte una frecuencia a su posición horizontal en escala logarítmica.
      posicionFrecuencia(f) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '" y1="15" y2="321"/>';
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (![30, 300, 3000].includes(f))
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      s +=
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<text class="grid-label" x="' +
        // Convierte una frecuencia a su posición horizontal en escala logarítmica.
        posicionFrecuencia(f) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" y="346" text-anchor="middle">' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (f >= 1000 ? f / 1000 + "k" : f) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "</text>";
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Recorre la lista para calcular o actualizar cada elemento.
  [-1, -2 / 3, -1 / 3, 0, 1 / 3, 2 / 3, 1].forEach((r) => {
    // Actualiza el dato «v» con el valor o cálculo indicado.
    const v = Math.round(r * S.range),
      // Actualiza las muestras de salida; convierte una ganancia en dB a la posición vertical de la gráfica.
      y = posicionGanancia(v);
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    s +=
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<line class="' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (v === 0 ? "grid-zero" : "grid-line") +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '" x1="48" x2="952" y1="' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      y +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '" y2="' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      y +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '"/><text class="grid-label" x="34" y="' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (y + 4) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '" text-anchor="end">' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (v > 0 ? "+" : "") +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      v +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "</text>";
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Recorre la lista para calcular o actualizar cada elemento.
  [0, -20, -40, -60, -80, -100].forEach(
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (v) =>
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (s +=
        // Convierte un nivel dBFS a su altura en el espectro.
        '<text class="grid-label" x="966" y="' + (posicionEspectro(v) + 4) + '">' + v + "</text>"),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  elemento("grid").innerHTML = s;
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("range").textContent = "±" + S.range + " dB";
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Representa los espectros de entrada y salida recibidos de MATLAB.
function dibujarEspectros() {
  // Actualiza la proporción de señal original que limita la profundidad del notch con el valor o cálculo indicado.
  const d = S.frame,
    // Actualiza el dato «show» con el valor o cálculo indicado.
    show = S.rta && d && d.input && d.input.length > 1;
  // Recorre la lista para calcular o actualizar cada elemento.
  ["in-spectrum", "out-spectrum", "spectrum-fill"].forEach(
    // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
    (id) => (elemento(id).style.display = show ? "" : "none"),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
  // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
  elemento("no-signal").style.display = d ? "none" : "";
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!show) return;
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("in-spectrum").setAttribute("d", trazadoDeCurva(d.freq, d.input, posicionEspectro));
  // Actualiza los parámetros del procesamiento; convierte frecuencias y niveles en instrucciones para dibujar una curva SVG.
  const p = trazadoDeCurva(d.freq, d.output, posicionEspectro);
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("out-spectrum").setAttribute("d", p);
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("spectrum-fill").setAttribute("d", p + " L952,321 L48,321 Z");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
function obtenerBanda(id = S.selected) {
  // Actualiza el dato «i» con el valor o cálculo indicado.
  const i = +id[1],
    // Actualiza el indicador de una banda de resonancias con el valor o cálculo indicado.
    notch = id[0] === "n",
    // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
    r = notch ? S.p.notches[i] : S.p.eq[i];
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return {
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    notch,
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    i,
    // Define la activación de la banda dentro del grupo de datos que se está construyendo.
    on: notch ? !!r[0] : S.eqOn[i],
    // Define las frecuencias usadas para dibujar las curvas dentro del grupo de datos que se está construyendo.
    freq: r[notch ? 1 : 0],
    // Define el factor Q que controla la anchura dentro del grupo de datos que se está construyendo.
    q: r[2],
    // Define la ganancia de la banda dentro del grupo de datos que se está construyendo.
    gain: notch ? -r[3] : r[1],
    // Define la profundidad del corte dentro del grupo de datos que se está construyendo.
    depth: notch ? r[3] : 0,
    // Define el indicador de una banda de graves o brillo con pendiente fija dentro del grupo de datos que se está construyendo.
    shelf: !notch && (i === 0 || i === 3),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  };
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Comprueba que el ancho produzca coeficientes finitos y una respuesta estable.
function validarQ(q, b = obtenerBanda()) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!Number.isFinite(q) || q <= 0) return false;
  // Actualiza el dato «type» con el valor o cálculo indicado.
  const type = b.notch ? (S.p.notchTypes[b.i] === 1 ? "peak" : "notch") : "peak";
  // Actualiza el dato «v»; calcula los coeficientes de un filtro digital de segundo orden.
  const v = calcularFiltro(type, S.config.fs, b.freq, q, b.gain);
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return (
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    v.every(Number.isFinite) && Math.abs(v[5]) < 1 && 1 + v[4] + v[5] > 0 && 1 - v[4] + v[5] > 0
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza el parámetro solicitado de la banda respetando sus límites.
function modificarBanda(key, value) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!Number.isFinite(value)) return;
  // Actualiza los coeficientes del numerador; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
  const b = obtenerBanda(),
    // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
    r = b.notch ? S.p.notches[b.i] : S.p.eq[b.i];
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (key === "freq") r[b.notch ? 1 : 0] = limitar(value, b.notch ? 40 : 30, 18000);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (key === "gain") {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (b.notch) r[3] = limitar(-value, 0, 40);
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else r[1] = limitar(value, -18, 18);
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (key === "q" && !b.shelf) {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (!validarQ(value, b)) {
      // Muestra un aviso y distingue visualmente si se trata de un error.
      mostrarEstado(
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "Q fuera de la precisión numérica del filtro. Usa un valor positivo menos extremo.",
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        true,
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      );
      // Muestra valores y posiciones de las perillas correspondientes a la banda elegida.
      actualizarInspector();
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      return;
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
    // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
    r[2] = value;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Marca la banda que el inspector permitirá editar.
function seleccionarBanda(id) {
  // Actualiza los elementos seleccionados con el valor o cálculo indicado.
  S.selected = id;
  // Actualiza las gráficas, el inspector y los controles con el estado actual.
  actualizarInterfaz();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Activa o desactiva una banda conservando sus ajustes.
function alternarBanda(id) {
  // Actualiza el dato «i» con el valor o cálculo indicado.
  const i = +id[1];
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (id[0] === "n") S.p.notches[i][0] = 1 - S.p.notches[i][0];
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  else S.eqOn[i] = !S.eqOn[i];
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Obtiene el título visible a partir de la forma elegida para cada filtro.
function nombreBanda(banda) {
  // Conserva el nombre de las bandas que no tienen selector de Notch o Campana.
  if (banda.id[0] !== "n") return banda.name;
  // Recupera el número interno de la banda sin modificar sus ajustes.
  const indice = Number(banda.id[1]);
  // Presenta el tipo seleccionado y su número correspondiente en pantalla.
  return (S.p.notchTypes[indice] === 1 ? "CAMPANA " : "NOTCH ") + (indice + 1);
// Finaliza la consulta del nombre; el cálculo del filtro permanece independiente.
}
// Muestra valores y posiciones de las perillas correspondientes a la banda elegida.
function actualizarInspector() {
  // Actualiza los coeficientes del numerador; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
  const b = obtenerBanda(),
    // Actualiza el nombre y el color de la banda con el valor o cálculo indicado.
    meta = bands.find((x) => x.id === S.selected);
  // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
  document.querySelector(".inspector").style.setProperty("--band", meta.color);
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("band-name").textContent = nombreBanda(meta);
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("band-type").textContent = b.notch
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ? S.p.notchTypes[b.i] === 1
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ? "BELL / RESONANCIA"
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : "NOTCH / RESONANCIA"
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    : meta.type;
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("filter-shape").classList.toggle("hidden", !b.notch);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (b.notch) elemento("filter-shape").value = S.p.notchTypes[b.i];
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("band-power").classList.toggle("on", b.on);
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("band-power").setAttribute("aria-pressed", b.on);
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("gain-label").textContent = b.notch ? "CORTE / PASADA" : "GANANCIA";
  // Busca un control de la página por su identificador.
  elemento("band-gain").min = b.notch ? -40 : -18;
  // Busca un control de la página por su identificador.
  elemento("band-gain").max = b.notch ? 0 : 18;
  // Busca un control de la página por su identificador.
  elemento("band-freq").min = b.notch ? 40 : 30;
  // Busca un control de la página por su identificador.
  elemento("band-q").min = 0;
  // Busca un control de la página por su identificador.
  elemento("band-q").removeAttribute("max");
  // Busca un control de la página por su identificador.
  elemento("band-q").step = "any";
  // Recorre los parámetros o los elementos indicados para aplicarles la misma operación.
  for (const key of ["gain", "freq", "q"]) {
    // Actualiza el dato «e»; busca un control de la página por su identificador.
    const e = elemento("band-" + key),
      // Actualiza el dato «v»; expresa el ancho de la banda en Q o en hercios según la unidad seleccionada.
      v = key === "q" ? obtenerAncho(b) : b[key];
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (document.activeElement !== e)
      // Actualiza el valor recibido del control con el valor o cálculo indicado.
      e.value = key === "freq" ? Math.round(v) : Number(v.toPrecision(6));
    // Actualiza la condición que deshabilita el control con el valor o cálculo indicado.
    const disabled = key === "q" && b.shelf;
    // Actualiza la condición que deshabilita el control con el valor o cálculo indicado.
    e.disabled = disabled;
    // Actualiza el dato «k»; busca un control de la página por su identificador.
    const k = elemento("knob-" + key);
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    k.setAttribute("aria-disabled", disabled);
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    k.setAttribute("aria-valuenow", v);
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    k.setAttribute("aria-valuemin", e.min);
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (e.hasAttribute("max")) k.setAttribute("aria-valuemax", e.max);
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else k.removeAttribute("aria-valuemax");
    // Escala abierta: no hay tope artificial en Q. El giro converge al extremo.
    // Actualiza los instantes de tiempo de la señal con el valor o cálculo indicado.
    const t =
      // Actualiza el parámetro que se está modificando con el valor o cálculo indicado.
      key === "freq"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        ? Math.log(v / 30) / Math.log(600)
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        : key === "gain"
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          ? (v - (b.notch ? -40 : -18)) / (b.notch ? 40 : 36)
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          : 0.5 + Math.atan(Math.log(v / (S.widthUnit === "hz" ? 100 : 1))) / Math.PI;
    // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
    k.firstElementChild.style.transform = "rotate(" + (-135 + 270 * limitar(t, 0, 1)) + "deg)";
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Busca un control de la página por su identificador.
  elemento("width-unit").value = S.widthUnit;
  // Busca un control de la página por su identificador.
  elemento("width-unit").disabled = b.shelf;
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("band-hint").textContent = b.shelf
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ? "Shelf · pendiente fija"
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    : S.widthUnit === "hz"
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ? "Más Hz = más ancho"
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : "Menos Q = más ancho";
  // Busca un control de la página por su identificador.
  elemento("band-q").title =
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "Hz = ancho de diseño digital; en Campana se mide a mitad del corte en dB. Q alto estrecha el filtro.";
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("q-label").textContent = b.shelf
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ? "PENDIENTE FIJA"
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    : "ANCHO / " + (S.widthUnit === "hz" ? "Hz" : "Q");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Ancho de diseno del biquad, con correccion de frecuencia digital.
// Para campana corresponde al ancho a mitad de ganancia (dB).
// Expresa el ancho de la banda en Q o en hercios según la unidad seleccionada.
function obtenerAncho(b = obtenerBanda()) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return S.widthUnit === "hz"
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ? (S.config.fs / Math.PI) *
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        Math.atan(Math.sin((2 * Math.PI * b.freq) / S.config.fs) / (2 * b.q))
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    : b.q;
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Valida el ancho escrito y lo convierte a Q cuando está expresado en hercios.
function modificarAncho(value) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!Number.isFinite(value) || value <= 0) {
    // Muestra un aviso y distingue visualmente si se trata de un error.
    mostrarEstado("Introduce un ancho positivo y finito.", true);
    // Actualiza las gráficas, el inspector y los controles con el estado actual.
    actualizarInterfaz();
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    return;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.widthUnit === "hz") {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (value >= S.config.fs / 2) {
      // Muestra un aviso y distingue visualmente si se trata de un error.
      mostrarEstado("El ancho en Hz debe ser menor que Fs/2.", true);
      // Actualiza las gráficas, el inspector y los controles con el estado actual.
      actualizarInterfaz();
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      return;
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
    // Actualiza el valor recibido del control con el valor o cálculo indicado.
    value =
      // Recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
      Math.sin((2 * Math.PI * obtenerBanda().freq) / S.config.fs) /
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (2 * Math.tan((Math.PI * value) / S.config.fs));
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Actualiza el parámetro solicitado de la banda respetando sus límites.
  modificarBanda("q", value);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("width-unit").onchange = (e) => {
  // Actualiza la unidad seleccionada para el ancho con el valor o cálculo indicado.
  S.widthUnit = e.target.value;
  // Muestra valores y posiciones de las perillas correspondientes a la banda elegida.
  actualizarInspector();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("filter-shape").onchange = (e) => {
  // Actualiza los coeficientes del numerador; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
  const b = obtenerBanda();
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (b.notch) {
    // Actualiza la forma notch o campana de cada corte con el valor o cálculo indicado.
    S.p.notchTypes[b.i] = +e.target.value;
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};

// SECCIÓN: 04_mezclador
// Actualiza las tiras de entrada, filtros y salida con el valor o cálculo indicado.
const strips = [
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "in", name: "ENTRADA", color: "#79d5d9" },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  ...bands,
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { id: "main", name: "MAIN", color: "#00e5ff" },
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
];
// Obtiene la ganancia que debe mostrar cada deslizador.
function valorDeslizador(id) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (id === "in") return S.p.inputDB;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (id === "main") return S.p.outputDB;
  // Devuelve el resultado: recupera frecuencia, ganancia, q y estado de la banda seleccionada.
  return obtenerBanda(id).gain;
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Determina los límites de entrada, salida o filtro para cada deslizador.
function rangoDeslizador(id) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return id === "in" ? [-24, 24] : id === "main" ? [-60, 12] : id[0] === "n" ? [-40, 0] : [-18, 18];
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Aplica el movimiento del deslizador a la ganancia correspondiente.
function modificarDeslizador(id, v) {
  // Determina los límites de entrada, salida o filtro para cada deslizador.
  const [lo, hi] = rangoDeslizador(id);
  // Actualiza el dato «v»; mantiene un valor dentro del intervalo permitido.
  v = limitar(v, lo, hi);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (id === "in") S.p.inputDB = v;
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  else if (id === "main") S.p.outputDB = v;
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  else {
    // Actualiza los elementos seleccionados con el valor o cálculo indicado.
    S.selected = id;
    // Actualiza el parámetro solicitado de la banda respetando sus límites.
    modificarBanda("gain", v);
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    return;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Construye las tiras de entrada, bandas de filtros y salida principal.
function crearTiras() {
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  elemento("strips").innerHTML = strips
    // Recorre la lista para calcular o actualizar cada elemento.
    .map(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (b) =>
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<div class="strip" data-id="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.id +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" style="--band:' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.color +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '"><button class="strip-title" data-select="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.id +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '"><i></i>' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        nombreBanda(b) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '</button><div class="strip-sub"></div><div class="strip-body"><div class="fader-rail" data-fader="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.id +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" role="slider" tabindex="0" aria-label="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        nombreBanda(b) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        ' dB">' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        [0, 25, 50, 75, 100]
          // Recorre la lista para calcular o actualizar cada elemento.
          .map(
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            (p, i) =>
              // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
              '<div class="fader-tick" style="top:' +
              // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
              p +
              // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
              '%"><span>' +
              // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
              Math.round(
                // Determina los límites de entrada, salida o filtro para cada deslizador.
                rangoDeslizador(b.id)[1] -
                  // Determina los límites de entrada, salida o filtro para cada deslizador.
                  ((rangoDeslizador(b.id)[1] - rangoDeslizador(b.id)[0]) * i) / 4,
              // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
              ) +
              // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
              "</span></div>",
          // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
          )
          // Une los fragmentos calculados para formar el contenido final.
          .join("") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<div class="fader-thumb"></div></div>' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (["in", "main"].includes(b.id)
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          ? '<div class="strip-meter">' +
            // Une los fragmentos calculados para formar el contenido final.
            Array.from({ length: 18 }, () => "<i></i>").join("") +
            // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
            '</div><i class="clip-led"></i>'
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          : "") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '</div><div class="strip-db"></div><button class="strip-enable" data-enable="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        b.id +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '"></button></div>',
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    )
    // Une los fragmentos calculados para formar el contenido final.
    .join("");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza posición, ganancia y estado de cada tira.
function actualizarTiras() {
  // Recorre la lista para calcular o actualizar cada elemento.
  strips.forEach((b) => {
    // Localiza en la página los controles que cumplen el selector indicado.
    const e = document.querySelector('.strip[data-id="' + b.id + '"]'),
      // Actualiza el dato «v»; obtiene la ganancia que debe mostrar cada deslizador.
      v = valorDeslizador(b.id),
      // Actualiza el intervalo vertical de la gráfica; determina los límites de entrada, salida o filtro para cada deslizador.
      range = rangoDeslizador(b.id),
      // Actualiza el dato «filter» con el valor o cálculo indicado.
      filter = !["in", "main"].includes(b.id),
      // Actualiza el dato «band»; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
      band = filter ? obtenerBanda(b.id) : null;
    // Actualiza solo el texto del título y conserva el indicador de color del botón.
    e.querySelector(".strip-title").lastChild.textContent = nombreBanda(b);
    // Actualiza también el nombre accesible del deslizador según el filtro seleccionado.
    e.querySelector(".fader-rail").setAttribute("aria-label", nombreBanda(b) + " dB");
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    e.classList.toggle("selected", S.selected === b.id);
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    e.classList.toggle("strip-off", filter && !band.on);
    // Actualiza el texto visible del control con el resultado o estado actual.
    e.querySelector(".strip-sub").textContent = filter
      // Presenta una frecuencia con unidades Hz o kHz.
      ? formatearFrecuencia(band.freq) + (band.notch ? " · Q " + band.q.toFixed(1) : "")
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : b.id === "in"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        ? "TRIM / MONO"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        : "SALIDA / MONO";
    // Localiza en la página los controles que cumplen el selector indicado.
    const rail = e.querySelector(".fader-rail");
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    rail.setAttribute("aria-valuenow", v);
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    rail.setAttribute("aria-valuemin", range[0]);
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    rail.setAttribute("aria-valuemax", range[1]);
    // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
    e.querySelector(".fader-thumb").style.top =
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      12 + (76 * (range[1] - v)) / (range[1] - range[0]) + "%";
    // Actualiza el texto visible del control con el resultado o estado actual.
    e.querySelector(".strip-db").textContent = (v > 0 ? "+" : "") + v.toFixed(1) + " dB";
    // Localiza en la página los controles que cumplen el selector indicado.
    const btn = e.querySelector(".strip-enable");
    // Actualiza el texto visible del control con el resultado o estado actual.
    btn.textContent =
      // Actualiza el identificador usado para localizar el elemento con el valor o cálculo indicado.
      b.id === "in"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        ? "RESET TRIM"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        : b.id === "main"
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          ? S.p.mute
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            ? "MUTE"
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            : "SALIDA ACTIVA"
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          : band.on
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            ? "ACTIVO"
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            : "BYPASS";
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    btn.classList.toggle("muted", b.id === "main" && S.p.mute);
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    btn.classList.toggle("on", filter && band.on);
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza las barras de nivel, el indicador de saturación y los datos de la toma.
function actualizarMedidores(d) {
  // Recorre la lista para calcular o actualizar cada elemento.
  ["in", "main"].forEach((id, k) => {
    // Localiza en la página los controles que cumplen el selector indicado.
    const e = document.querySelector('.strip[data-id="' + id + '"]'),
      // Actualiza los niveles expresados en decibelios con el valor o cálculo indicado.
      db = k ? d.outPeak : d.inPeak,
      // Actualiza el número de muestras o índice de trabajo; mantiene un valor dentro del intervalo permitido.
      n = limitar(Math.ceil(((db + 60) / 60) * 18), 0, 18);
    // Localiza en la página los controles que cumplen el selector indicado.
    e.querySelectorAll(".strip-meter i").forEach((bar, i) => {
      // Actualiza la posición, el color o la visibilidad del elemento en pantalla.
      bar.style.background =
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        i < n ? (i < 13 ? "#58d888" : i < 16 ? "#e7ce60" : "#ef7062") : "#182b2a";
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    });
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    e.querySelector(".clip-led").classList.toggle("on", k ? d.clip > 0 : d.inPeak >= -0.1);
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("metrics").textContent =
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    S.config.fs / 1000 +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " kHz · " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    S.config.block +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " smp · GR " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    Number(d.compression || 0).toFixed(1) +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " dB · " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    Number(d.seconds || 0).toFixed(1) +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " s · pérdidas " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (d.over || 0) +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "/" +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (d.under || 0) +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (S.config.mode === "Tiempo real"
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ? " · IN " + (d.activeInput || "…") + (S.config.inCh === 0 ? " AUTO" : "")
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : "");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Actualiza las gráficas, el inspector y los controles con el estado actual.
function actualizarInterfaz() {
  // Dibuja referencias de frecuencia y nivel para facilitar la lectura.
  dibujarCuadricula();
  // Dibuja las respuestas de filtros, la banda seleccionada y sus nodos de arrastre.
  dibujarGrafica();
  // Representa los espectros de entrada y salida recibidos de MATLAB.
  dibujarEspectros();
  // Muestra valores y posiciones de las perillas correspondientes a la banda elegida.
  actualizarInspector();
  // Actualiza posición, ganancia y estado de cada tira.
  actualizarTiras();
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("mute").classList.toggle("danger", S.p.mute);
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("mute").setAttribute("aria-pressed", S.p.mute);
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("bypass").classList.toggle("active", S.p.bypass);
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  elemento("bypass").setAttribute("aria-pressed", S.p.bypass);
  // Busca un control de la página por su identificador.
  elemento("hp").checked = S.p.hpOn;
  // Busca un control de la página por su identificador.
  elemento("hpHz").value = S.p.hpHz;
  // Busca un control de la página por su identificador.
  elemento("passes").value = S.p.passes;
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("rta").classList.toggle("active", S.rta);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}

// SECCIÓN: 05_interacciones
// Actualiza la operación de arrastre activa con el valor o cálculo indicado.
let drag = null;
// Convierte la posición del puntero a coordenadas internas del gráfico.
function coordenadasPuntero(e) {
  // Mide la posición y el tamaño visibles del control para interpretar el puntero.
  const r = elemento("graph").getBoundingClientRect();
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return { x: ((e.clientX - r.left) / r.width) * 1000, y: ((e.clientY - r.top) / r.height) * 360 };
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Registra la acción que debe ejecutarse cuando ocurra el evento «pointerdown».
elemento("graph").addEventListener("pointerdown", (e) => {
  // Actualiza el dato «node» con el valor o cálculo indicado.
  const node = e.target.closest("[data-band]");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!node) return;
  // Marca la banda que el inspector permitirá editar.
  seleccionarBanda(node.dataset.band);
  // Actualiza la operación de arrastre activa con el valor o cálculo indicado.
  drag = { type: "node" };
  // Mantiene el seguimiento del arrastre aunque el puntero salga del control.
  elemento("graph").setPointerCapture(e.pointerId);
  // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
  e.preventDefault();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «pointermove».
document.addEventListener("pointermove", (e) => {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!drag) return;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (drag.type === "node") {
    // Actualiza las coordenadas del puntero; convierte la posición del puntero a coordenadas internas del gráfico.
    const pt = coordenadasPuntero(e),
      // Actualiza los coeficientes del numerador; recupera frecuencia, ganancia, Q y estado de la banda seleccionada.
      b = obtenerBanda(),
      // Actualiza los parámetros de la banda actual con el valor o cálculo indicado.
      r = b.notch ? S.p.notches[b.i] : S.p.eq[b.i];
    // Mantiene un valor dentro del intervalo permitido.
    r[b.notch ? 1 : 0] = limitar(20 * Math.pow(1000, (pt.x - 48) / 904), b.notch ? 40 : 30, 18000);
    // Actualiza la ganancia aplicada con el valor o cálculo indicado.
    const g = ((168 - pt.y) / 153) * S.range;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (b.notch) r[3] = limitar(-g / S.p.passes, 0, 40);
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else r[1] = limitar(g, -18, 18);
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (drag.type === "knob") {
    // Actualiza el desplazamiento del puntero con el valor o cálculo indicado.
    const delta = drag.y - e.clientY;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (drag.key === "q") modificarAncho(drag.v * Math.pow(2, delta / 80));
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else
      // Actualiza el parámetro solicitado de la banda respetando sus límites.
      modificarBanda(
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        drag.key,
        // Actualiza el parámetro que se está modificando con el valor o cálculo indicado.
        drag.key === "freq" ? drag.v * Math.pow(2, delta / 45) : drag.v + delta * 0.12,
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      );
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (drag.type === "fader") {
    // Mide la posición y el tamaño visibles del control para interpretar el puntero.
    const r = drag.el.getBoundingClientRect(),
      // Determina los límites de entrada, salida o filtro para cada deslizador.
      [lo, hi] = rangoDeslizador(drag.id);
    // Aplica el movimiento del deslizador a la ganancia correspondiente.
    modificarDeslizador(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      drag.id,
      // Mantiene un valor dentro del intervalo permitido.
      hi - (hi - lo) * limitar(((e.clientY - r.top) / r.height - 0.12) / 0.76, 0, 1),
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    );
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «pointerup».
document.addEventListener("pointerup", () => {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (drag) {
    // Actualiza la operación de arrastre activa con el valor o cálculo indicado.
    drag = null;
    // Envía a MATLAB una acción con los ajustes y la configuración actuales.
    enviarComando("params");
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «pointercancel».
document.addEventListener("pointercancel", () => {
  // Actualiza la operación de arrastre activa con el valor o cálculo indicado.
  drag = null;
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Busca un control de la página por su identificador.
elemento("graph").addEventListener(
  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
  "wheel",
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  (e) => {
    // Actualiza el número de muestras o índice de trabajo con el valor o cálculo indicado.
    const n = e.target.closest("[data-band]");
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (!n) return;
    // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
    e.preventDefault();
    // Marca la banda que el inspector permitirá editar.
    seleccionarBanda(n.dataset.band);
    // Actualiza el parámetro solicitado de la banda respetando sus límites.
    modificarBanda("q", obtenerBanda().q * Math.pow(1.12, e.deltaY < 0 ? 1 : -1));
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  },
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  { passive: false },
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
);
// Localiza en la página los controles que cumplen el selector indicado.
document.querySelectorAll(".knob").forEach((k) => {
  // Registra la acción que debe ejecutarse cuando ocurra el evento «pointerdown».
  k.addEventListener("pointerdown", (e) => {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (k.getAttribute("aria-disabled") === "true") return;
    // Actualiza la operación de arrastre activa con el valor o cálculo indicado.
    drag = {
      // Define el dato «type» dentro del grupo de datos que se está construyendo.
      type: "knob",
      // Define el parámetro que se está modificando dentro del grupo de datos que se está construyendo.
      key: k.dataset.key,
      // Define el dato «v» dentro del grupo de datos que se está construyendo.
      v: k.dataset.key === "q" ? obtenerAncho() : obtenerBanda()[k.dataset.key],
      // Define las muestras de salida dentro del grupo de datos que se está construyendo.
      y: e.clientY,
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    };
    // Mantiene el seguimiento del arrastre aunque el puntero salga del control.
    k.setPointerCapture(e.pointerId);
    // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
    e.preventDefault();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
  // Registra la acción que debe ejecutarse cuando ocurra el evento «keydown».
  k.addEventListener("keydown", (e) => {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (!["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(e.key)) return;
    // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
    e.preventDefault();
    // Actualiza el dato «sign» con el valor o cálculo indicado.
    const sign = ["ArrowUp", "ArrowRight"].includes(e.key) ? 1 : -1,
      // Actualiza el parámetro que se está modificando con el valor o cálculo indicado.
      key = k.dataset.key;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (key === "q") modificarAncho(obtenerAncho() * Math.pow(1.1, sign));
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else modificarBanda(key, obtenerBanda()[key] + sign * (key === "freq" ? 10 : 0.1));
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Recorre los parámetros o los elementos indicados para aplicarles la misma operación.
for (const k of ["gain", "freq", "q"])
  // Registra la acción que debe ejecutarse cuando ocurra el evento «change».
  elemento("band-" + k).addEventListener("change", (e) => {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (k === "q") modificarAncho(+e.target.value);
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else modificarBanda(k, +e.target.value);
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  });
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("band-power").onclick = () => alternarBanda(S.selected);
// Registra la acción que debe ejecutarse cuando ocurra el evento «click».
elemento("strips").addEventListener("click", (e) => {
  // Actualiza los coeficientes de la cadena con el valor o cálculo indicado.
  const s = e.target.closest("[data-select]"),
    // Actualiza los coeficientes del numerador con el valor o cálculo indicado.
    b = e.target.closest("[data-enable]");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (s && s.dataset.select !== "in" && s.dataset.select !== "main")
    // Marca la banda que el inspector permitirá editar.
    seleccionarBanda(s.dataset.select);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (b) {
    // Actualiza el identificador usado para localizar el elemento con el valor o cálculo indicado.
    const id = b.dataset.enable;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (id === "main") S.p.mute = !S.p.mute;
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else if (id === "in") S.p.inputDB = 0;
    // Atiende el caso alternativo cuando no se cumple la condición anterior.
    else alternarBanda(id);
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «pointerdown».
elemento("strips").addEventListener("pointerdown", (e) => {
  // Actualiza el dato «el» con el valor o cálculo indicado.
  const el = e.target.closest("[data-fader]");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!el) return;
  // Actualiza la operación de arrastre activa con el valor o cálculo indicado.
  drag = { type: "fader", id: el.dataset.fader, el };
  // Mantiene el seguimiento del arrastre aunque el puntero salga del control.
  el.setPointerCapture(e.pointerId);
  // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
  e.preventDefault();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «keydown».
elemento("strips").addEventListener("keydown", (e) => {
  // Actualiza el dato «el» con el valor o cálculo indicado.
  const el = e.target.closest("[data-fader]");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!el || !["ArrowUp", "ArrowDown"].includes(e.key)) return;
  // Evita la acción habitual del navegador para atender el gesto dentro de la aplicación.
  e.preventDefault();
  // Aplica el movimiento del deslizador a la ganancia correspondiente.
  modificarDeslizador(
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    el.dataset.fader,
    // Obtiene la ganancia que debe mostrar cada deslizador.
    valorDeslizador(el.dataset.fader) + (e.key === "ArrowUp" ? 0.5 : -0.5),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("mute").onclick = () => {
  // Actualiza el silencio de la salida con el valor o cálculo indicado.
  S.p.mute = !S.p.mute;
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("bypass").onclick = () => {
  // Actualiza la comparación con el procesamiento omitido con el valor o cálculo indicado.
  S.p.bypass = !S.p.bypass;
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("hp").onchange = (e) => {
  // Actualiza la activación del pasaaltos con el valor o cálculo indicado.
  S.p.hpOn = e.target.checked;
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("hpHz").onchange = (e) => {
  // Actualiza la frecuencia de corte del pasaaltos; mantiene un valor dentro del intervalo permitido.
  S.p.hpHz = limitar(+e.target.value, 20, 300);
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("passes").onchange = (e) => {
  // Actualiza el número de pasadas del banco con el valor o cálculo indicado.
  S.p.passes = +e.target.value;
  // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
  notificarCambio();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("range").onclick = () => {
  // Actualiza el intervalo vertical de la gráfica con el valor o cálculo indicado.
  S.range = S.range === 15 ? 30 : S.range === 30 ? 60 : 15;
  // Actualiza las gráficas, el inspector y los controles con el estado actual.
  actualizarInterfaz();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("rta").onclick = () => {
  // Actualiza la visibilidad del espectro en tiempo real con el valor o cálculo indicado.
  S.rta = !S.rta;
  // Actualiza las gráficas, el inspector y los controles con el estado actual.
  actualizarInterfaz();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("load").onclick = () => enviarComando("load");
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("start").onclick = () => {
  // Actualiza las últimas mediciones recibidas con el valor o cálculo indicado.
  S.frame = null;
  // Borra las curvas de comparación cuando todavía no existen mediciones.
  limpiarEtapas();
  // Envía a MATLAB una acción con los ajustes y la configuración actuales.
  enviarComando("start");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("stop").onclick = () => enviarComando("stop");
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("detect").onclick = () => {
  // Abre la sección solicitada y conecta sus controles con los parámetros.
  abrirPanel("notch");
  // Envía a MATLAB una acción con los ajustes y la configuración actuales.
  enviarComando("detect");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("source").onchange = (e) => {
  // Actualiza la fuente de audio con el valor o cálculo indicado.
  S.config.mode = e.target.value;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (S.config.mode === "Tiempo real") abrirPanel("audio");
  // Atiende el caso alternativo cuando no se cumple la condición anterior.
  else
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("filename").textContent =
      // Actualiza la fuente de audio con el valor o cálculo indicado.
      S.config.mode === "Demo" ? "Redoblante · demo de prueba" : "Selecciona un WAV con Cargar WAV";
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};

// SECCIÓN: 06_paneles_y_etapas
// Genera un campo numérico para editar un parámetro o una opción de audio.
function campoNumerico(label, key, val, min, max, step = 1, config = false) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return (
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<label class="field">' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    label +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "<input " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (config ? "data-config" : "data-param") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    key +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" type="number" value="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    val +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" min="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    min +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" max="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    max +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" step="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    step +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" ' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (config ? "data-idle" : "") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "></label>"
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Genera una casilla para activar o desactivar una opción.
function casillaActivacion(label, key, val, config = false) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return (
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<label class="field">' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    label +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "<input " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (config ? "data-config" : "data-param") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    key +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '" type="checkbox" ' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (val ? "checked" : "") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (config ? "data-idle" : "") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "></label>"
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Genera una lista de valores disponibles conservando la selección actual.
function listaSeleccion(label, key, values) {
  // Devuelve el resultado de la expresión o del contenido construido en esta función.
  return (
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<label class="field">' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    label +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<select data-idle data-config="' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    key +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '">' +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    values
      // Recorre la lista para calcular o actualizar cada elemento.
      .map((v) => {
        // Actualiza el dato «name» con el valor o cálculo indicado.
        let name = String(v);
        // Comprueba la condición indicada antes de ejecutar la acción siguiente.
        if (v === "Default") {
          // Actualiza el dato «actual» con el valor o cálculo indicado.
          const actual =
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            S.deviceInfo &&
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            (key === "input" ? S.deviceInfo.defaultInput : S.deviceInfo.defaultOutput);
          // Actualiza el dato «name» con el valor o cálculo indicado.
          name = "Automatico" + (actual ? " · " + actual : " (sistema)");
        // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
        }
        // Devuelve el resultado de la expresión o del contenido construido en esta función.
        return (
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          '<option value="' +
          // Protege el texto que se insertará en la página para tratarlo como contenido.
          escaparTexto(v) +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          '" ' +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          (String(S.config[key]) === String(v) ? "selected" : "") +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          ">" +
          // Protege el texto que se insertará en la página para tratarlo como contenido.
          escaparTexto(name) +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          "</option>"
        // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
        );
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      })
      // Une los fragmentos calculados para formar el contenido final.
      .join("") +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    "</select></label>"
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}

// Abre la sección solicitada y conecta sus controles con los parámetros.
function abrirPanel(panel, refresh = true) {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "stages" || panel === "eq") {
    // Actualiza el dato «viewChanged» con el valor o cálculo indicado.
    const viewChanged = S.stageView !== (panel === "stages");
    // Actualiza la visibilidad de la comparación de etapas con el valor o cálculo indicado.
    S.stageView = panel === "stages";
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    elemento("stage-view").classList.toggle("hidden", !S.stageView);
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    document.querySelector(".workspace").classList.toggle("hidden", S.stageView);
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (viewChanged) enviarComando("view");
    // Dibuja las mismas ventanas de audio antes y después de cada etapa.
    dibujarEtapas();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Actualiza el panel abierto con el valor o cálculo indicado.
  S.panel = panel;
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  document
    // Localiza en la página los controles que cumplen el selector indicado.
    .querySelectorAll(".nav")
    // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
    .forEach((b) => b.classList.toggle("active", b.dataset.panel === panel));
  // Actualiza el dato «hidden» con el valor o cálculo indicado.
  const hidden = panel === "eq" || panel === "stages";
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("drawer").classList.toggle("hidden", hidden);
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("shade").classList.toggle("hidden", hidden);
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (hidden) return;
  // Actualiza el dato «c» con el valor o cálculo indicado.
  const c = S.config,
    // Actualiza los parámetros del procesamiento con el valor o cálculo indicado.
    p = S.p;
  // Actualiza el contenido del panel con el valor o cálculo indicado.
  let h = "";
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "audio") {
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("drawer-title").textContent = "AUDIO / ENTRADA Y SALIDA";
    // Actualiza el contenido del panel con el valor o cálculo indicado.
    h =
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<p id="audio-route">Automatico sigue el dispositivo predeterminado. Canal IN 0 selecciona el canal con senal dentro de esa entrada.</p>' +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Fuente", "mode", ["Demo", "WAV", "Tiempo real"]) +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Frecuencia de muestreo", "fs", [44100, 48000]) +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Bloque (muestras)", "block", [64, 128, 256, 512, 1024]) +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Controlador (Windows)", "driver", ["DirectSound", "WASAPI", "ASIO"]) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<div class="row-buttons"><button data-action="devices" data-idle>Actualizar dispositivos</button></div>' +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Entrada de audio", "input", S.inputs) +
      // Genera una lista de valores disponibles conservando la selección actual.
      listaSeleccion("Salida de audio", "output", S.outputs) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Canal IN (0 = automatico)", "inCh", c.inCh, 0, 64, 1, true) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Primer canal de salida", "outCh", c.outCh, 1, 64, 1, true) +
      // Genera una casilla para activar o desactivar una opción.
      casillaActivacion("Duplicar mono en dos salidas", "stereo", c.stereo, true) +
      // Genera una casilla para activar o desactivar una opción.
      casillaActivacion("Repetir WAV", "loop", c.loop, true) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<p class="notice">Iniciar reproduce directamente en la salida elegida. MUTE silencia el audio. Tiempo real usa la entrada elegida: consola USB, micrófono o entrada de línea. Se muestran dispositivos de audio, no números de puertos USB. Con ASIO y el mismo dispositivo de entrada/salida se activa el dúplex automáticamente.</p><h3>TOMA A/B · ÚLTIMOS 60 SEGUNDOS</h3><div class="row-buttons"><button data-action="listenIn" data-idle>Escuchar original</button><button data-action="listenOut" data-idle>Escuchar procesado</button><button data-action="stopListen" data-idle>Detener escucha</button><button data-action="export" data-idle>Exportar WAV A/B</button></div><p>Exportación: L original, R procesado, incluye MAIN y MUTE. La salida continua usa Java Sound cuando falta Audio Toolbox; USB en vivo requiere Audio Toolbox.</p>';
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "dynamics") {
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("drawer-title").textContent = "DINÁMICA";
    // Actualiza el contenido del panel con el valor o cálculo indicado.
    h =
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "<p>Puerta y compresor después del EQ. BYPASS omite filtros y dinámica; mantiene TRIM, MAIN y MUTE.</p><h3>GATE / PUERTA</h3>" +
      // Genera una casilla para activar o desactivar una opción.
      casillaActivacion("Activar puerta", "gateOn", p.gateOn) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Umbral · dBFS", "gateThreshold", p.gateThreshold, -80, -5) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Atenuación · dB", "gateRange", p.gateRange, 0, 80) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Ataque · ms", "gateAttack", p.gateAttack, 0.1, 50, 0.1) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Hold · ms", "gateHold", p.gateHold, 0, 1000) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Release · ms", "gateRelease", p.gateRelease, 10, 1500) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "<h3>COMPRESOR</h3>" +
      // Genera una casilla para activar o desactivar una opción.
      casillaActivacion("Activar compresor", "compOn", p.compOn) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Umbral · dBFS", "compThreshold", p.compThreshold, -60, 0) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Ratio · :1", "ratio", p.ratio, 1, 20, 0.1) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Ataque · ms", "compAttack", p.compAttack, 0.1, 100, 0.1) +
      // Genera un campo numérico para editar un parámetro o una opción de audio.
      campoNumerico("Release · ms", "compRelease", p.compRelease, 10, 1500) +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "<p>La reducción GR se muestra en la barra inferior. El tope final de muestras está en −1 dBFS; no es un limitador true-peak.</p>";
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "notch") {
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("drawer-title").textContent = "ATENUADOR DE RESONANCIAS";
    // Actualiza el contenido del panel con el valor o cálculo indicado.
    h =
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<p>Los notch también son filtros IIR. Selecciona N1, N2 o N3 en el gráfico para elegir Notch o Campana y ajustar el ancho en Hz o Q. Menos Q produce una curva más ancha; Q admite valores superiores a 60. Las pasadas repiten todo el banco notch; no repiten el EQ.</p><div class="table"><span>ON</span><span>Hz</span><span>Q</span><span>dB/paso</span>' +
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      p.notches
        // Recorre la lista para calcular o actualizar cada elemento.
        .map(
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          (r, i) =>
            // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
            '<input data-notch="' +
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            i +
            // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
            ',0" type="checkbox" ' +
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            (r[0] ? "checked" : "") +
            // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
            ">" +
            // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
            [1, 2, 3]
              // Recorre la lista para calcular o actualizar cada elemento.
              .map(
                // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                (j) =>
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  '<input data-notch="' +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  i +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  "," +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  j +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  '" type="number" value="' +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  r[j] +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  '" min="' +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  [0, 40, 0, 0][j] +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  '" ' +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  (j === 2 ? "" : 'max="' + [0, 18000, 0, 40][j] + '"') +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  ' step="' +
                  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
                  (j === 1 ? 1 : 0.1) +
                  // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
                  '">',
              // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
              )
              // Une los fragmentos calculados para formar el contenido final.
              .join(""),
        // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
        )
        // Une los fragmentos calculados para formar el contenido final.
        .join("") +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '</div><div class="row-buttons"><button data-action="detect">Detectar resonancias</button></div><h3>SUGERENCIAS / 80 Hz–12 kHz</h3><div id="suggestion-results">' +
      // Construye las etiquetas de frecuencia, Q y corte propuestos.
      contenidoSugerencias() +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      "</div>" +
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<p class="notice">H indica un armonico probable de una familia detectada; otros picos pueden ser resonancias inarmonicas. Son sugerencias, no defectos confirmados. El corte mostrado es total y se reparte entre las pasadas. Solo se aplica al pulsar Aplicar candidatos.</p>';
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "presets") {
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("drawer-title").textContent = "AJUSTES / SESIÓN";
    // Actualiza el contenido del panel con el valor o cálculo indicado.
    h =
      // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
      '<p>Guarda o carga todos los parámetros DSP en JSON. La configuración del dispositivo se mantiene local y no se guarda en el ajuste.</p><div class="row-buttons"><button data-action="savePreset" data-idle>Guardar ajuste</button><button data-action="loadPreset" data-idle>Cargar ajuste</button><button id="reset-dsp">Restablecer DSP</button></div><h3>FLUJO DE TRABAJO</h3><p>1. Carga un WAV o configura Tiempo real.<br>2. Inicia y detecta resonancias.<br>3. Revisa y aplica los candidatos.<br>4. Arrastra las bandas para ecualizar.<br>5. Compara con BYPASS y exporta tu toma.</p><p class="notice">BAJOS y BRILLO son shelves de pendiente fija. MEDIOS y PRESENCIA tienen Q ajustable. La gráfica muestra filtros lineales; no incluye la ganancia MAIN ni la dinámica.</p>';
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  elemento("drawer-content").innerHTML = h;
  // Actualiza los botones y bloquea la configuración que no puede cambiar durante una toma.
  mostrarEstadoEjecucion(S.running);
  // Conecta el botón que copia las sugerencias a los filtros.
  conectarAplicacionDeSugerencias();
  // Describe el dispositivo y el canal que están recibiendo y reproduciendo audio.
  actualizarRutaAudio();
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (panel === "audio") {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (refresh && !S.running) enviarComando("devices");
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Actualiza el dato «reset»; busca un control de la página por su identificador.
  const reset = elemento("reset-dsp");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (reset)
    // Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
    reset.onclick = () => {
      // Actualiza los parámetros del procesamiento; define los ajustes con los que comienza una sesión.
      S.p = parametrosIniciales();
      // Actualiza la activación de las bandas del ecualizador con el valor o cálculo indicado.
      S.eqOn = [true, true, true, true];
      // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
      notificarCambio();
      // Abre la sección solicitada y conecta sus controles con los parámetros.
      abrirPanel("eq");
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    };
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
document.querySelectorAll(".nav").forEach((b) => (b.onclick = () => abrirPanel(b.dataset.panel)));
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("close-drawer").onclick = elemento("shade").onclick = () =>
  // Abre la sección solicitada y conecta sus controles con los parámetros.
  abrirPanel(S.stageView ? "stages" : "eq");
// Registra la acción que debe ejecutarse cuando ocurra el evento «click».
elemento("drawer-content").addEventListener("click", (e) => {
  // Actualiza los coeficientes del numerador con el valor o cálculo indicado.
  const b = e.target.closest("[data-action]");
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (b) enviarComando(b.dataset.action);
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «change».
elemento("drawer-content").addEventListener("change", (e) => {
  // Actualiza el dato «el» con el valor o cálculo indicado.
  const el = e.target;
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (el.dataset.config) {
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (S.running) return;
    // Actualiza el parámetro que se está modificando con el valor o cálculo indicado.
    const key = el.dataset.config;
    // Actualiza el dato «S.config[key]» con el valor o cálculo indicado.
    S.config[key] =
      // Actualiza el dato «el.type» con el valor o cálculo indicado.
      el.type === "checkbox"
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        ? el.checked
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        : typeof S.config[key] === "number"
          // Mantiene un valor dentro del intervalo permitido.
          ? limitar(+el.value, el.min ? +el.min : -Infinity, el.max ? +el.max : Infinity)
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          : el.value;
    // Busca un control de la página por su identificador.
    elemento("source").value = S.config.mode;
    // Actualiza las gráficas, el inspector y los controles con el estado actual.
    actualizarInterfaz();
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (["mode", "driver"].includes(key)) {
      // Actualiza los datos de los dispositivos con el valor o cálculo indicado.
      S.deviceInfo = null;
      // Envía a MATLAB una acción con los ajustes y la configuración actuales.
      enviarComando("devices");
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (el.dataset.param) {
    // Actualiza los parámetros del procesamiento con el valor o cálculo indicado.
    S.p[el.dataset.param] =
      // Actualiza el dato «el.type»; mantiene un valor dentro del intervalo permitido.
      el.type === "checkbox" ? el.checked : limitar(+el.value, +el.min, +el.max);
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (el.dataset.notch) {
    // Recorre la lista para calcular o actualizar cada elemento.
    const [i, j] = el.dataset.notch.split(",").map(Number);
    // Actualiza el valor recibido del control con el valor o cálculo indicado.
    const value = +el.value;
    // Comprueba la condición indicada antes de ejecutar la acción siguiente.
    if (j === 2 && !validarQ(value, obtenerBanda("n" + i))) {
      // Muestra un aviso y distingue visualmente si se trata de un error.
      mostrarEstado("Q debe ser positivo, finito y numéricamente estable.", true);
      // Actualiza el valor recibido del control con el valor o cálculo indicado.
      el.value = S.p.notches[i][j];
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      return;
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    }
    // Actualiza las tres bandas de resonancias: activación, frecuencia, Q y profundidad con el valor o cálculo indicado.
    S.p.notches[i][j] =
      // Actualiza el dato «j»; mantiene un valor dentro del intervalo permitido.
      j === 0 ? +el.checked : limitar(value, +el.min, el.hasAttribute("max") ? +el.max : Infinity);
    // Redibuja los controles y agrupa los cambios para enviarlos a MATLAB.
    notificarCambio();
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});
// Registra la acción que debe ejecutarse cuando ocurra el evento «keydown».
document.addEventListener("keydown", (e) => {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (e.key === "Escape") abrirPanel(S.stageView ? "stages" : "eq");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
});

// Borra las curvas de comparación cuando todavía no existen mediciones.
function limpiarEtapas() {
  // Recorre la lista para calcular o actualizar cada elemento.
  ["notch-a", "notch-b", "eq-a", "eq-b"].forEach((id) =>
    // Actualiza un atributo visual o de accesibilidad del elemento indicado.
    elemento("stage-" + id).setAttribute("d", ""),
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  );
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("stage-state").textContent = "Inicia una toma para comparar las etapas.";
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Dibuja las mismas ventanas de audio antes y después de cada etapa.
function dibujarEtapas() {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.stageView) return;
  // Actualiza la proporción de señal original que limita la profundidad del notch con el valor o cálculo indicado.
  const d = S.frame && S.frame.stages,
    // Actualiza el dato «time» con el valor o cálculo indicado.
    time = S.stageMode === "time";
  // Actualiza el dato «valid» con el valor o cálculo indicado.
  const valid = d && Array.isArray(d.before) && d.before.length > 1;
  // Actualiza el dato «xvalues» con el valor o cálculo indicado.
  const xvalues = time ? (valid ? d.time : [-10, 0]) : valid ? d.freq : [20, 20000];
  // Actualiza el dato «xmin» con el valor o cálculo indicado.
  const xmin = xvalues[0],
    // Actualiza el dato «xmax» con el valor o cálculo indicado.
    xmax = xvalues[xvalues.length - 1];
  // Actualiza el dato «posicionHorizontalEtapa» con el valor o cálculo indicado.
  const posicionHorizontalEtapa = (v) =>
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    52 + 926 * (time ? (v - xmin) / (xmax - xmin) : Math.log10(v / 20) / 3);
  // Actualiza las amplitudes de las señales comparadas con el valor o cálculo indicado.
  const amplitudes = valid ? [d.waveBefore, d.waveNotch, d.waveEQ].flat() : [];
  // Actualiza la amplitud máxima de la escala compartida con el valor o cálculo indicado.
  const amp = Math.max(0.01, ...amplitudes.map(Math.abs));
  // Actualiza el dato «posicionVerticalEtapa» con el valor o cálculo indicado.
  const posicionVerticalEtapa = (v) =>
    // Mantiene un valor dentro del intervalo permitido.
    time ? 102.5 - (88.5 * v) / amp : 14 + (177 * (12 - limitar(v, -108, 12))) / 120;
  // Actualiza el dato «ticks» con el valor o cálculo indicado.
  const ticks = time ? [xmin, (xmin + xmax) / 2, xmax] : [20, 100, 1000, 10000, 20000];
  // Actualiza el dato «yticks» con el valor o cálculo indicado.
  const yticks = time ? [-amp, 0, amp] : [-100, -80, -60, -40, -20, 0];
  // Actualiza las líneas y etiquetas de referencia con el valor o cálculo indicado.
  let grid = ticks
    // Recorre la lista para calcular o actualizar cada elemento.
    .map(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (v) =>
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<line class="stage-grid-line" x1="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        posicionHorizontalEtapa(v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" x2="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        posicionHorizontalEtapa(v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" y1="14" y2="191"/><text class="stage-grid-label" x="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        posicionHorizontalEtapa(v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" y="211" text-anchor="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (v === ticks[0] ? "start" : v === ticks[ticks.length - 1] ? "end" : "middle") +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '">' +
        // Presenta una frecuencia con unidades Hz o kHz.
        (time ? v.toFixed(1) + " ms" : formatearFrecuencia(v)) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "</text>",
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    )
    // Une los fragmentos calculados para formar el contenido final.
    .join("");
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  grid += yticks
    // Recorre la lista para calcular o actualizar cada elemento.
    .map(
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      (v) =>
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '<line class="stage-grid-line" x1="52" x2="978" y1="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        posicionVerticalEtapa(v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" y2="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        posicionVerticalEtapa(v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '"/><text class="stage-grid-label" x="45" y="' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (posicionVerticalEtapa(v) + 4) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        '" text-anchor="end">' +
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (time ? v.toFixed(2) : v) +
        // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
        "</text>",
    // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
    )
    // Une los fragmentos calculados para formar el contenido final.
    .join("");
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  grid +=
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    '<text class="stage-grid-label" x="52" y="11">' + (time ? "Amplitud" : "dBFS") + "</text>";
  // Coloca el contenido HTML o SVG construido dentro del panel correspondiente.
  ["notch", "eq"].forEach((id) => (elemento("stage-grid-" + id).innerHTML = grid));
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!valid) {
    // Borra las curvas de comparación cuando todavía no existen mediciones.
    limpiarEtapas();
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    return;
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
  // Actualiza el dato «trazadoDeCurva» con el valor o cálculo indicado.
  const trazadoDeCurva = (values) =>
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    values
      // Recorre la lista para calcular o actualizar cada elemento.
      .map(
        // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
        (v, i) =>
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          (i ? "L" : "M") +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          posicionHorizontalEtapa(xvalues[i]).toFixed(2) +
          // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
          "," +
          // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
          posicionVerticalEtapa(v).toFixed(2),
      // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
      )
      // Une los fragmentos calculados para formar el contenido final.
      .join(" ");
  // Actualiza el dato «before» con el valor o cálculo indicado.
  const before = time ? d.waveBefore : d.before,
    // Actualiza el indicador de una banda de resonancias con el valor o cálculo indicado.
    notch = time ? d.waveNotch : d.notch,
    // Actualiza las cuatro bandas del ecualizador con el valor o cálculo indicado.
    eq = time ? d.waveEQ : d.eq;
  // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
  [
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ["notch-a", before],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ["notch-b", notch],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ["eq-a", notch],
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ["eq-b", eq],
  // Actualiza un atributo visual o de accesibilidad del elemento indicado.
  ].forEach(([id, values]) => elemento("stage-" + id).setAttribute("d", trazadoDeCurva(values)));
  // Actualiza el texto visible del control con el resultado o estado actual.
  elemento("stage-state").textContent =
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    ((d.live === undefined ? S.running : d.live) ? "EN VIVO" :
      // Identifica la ventana del golpe que MATLAB conserva al terminar una toma en vivo.
      (d.retained ? "Golpe conservado · mayor energía de entrada" : "Última ventana de la toma")) +
    // Añade este texto, etiqueta o fragmento de marcado al contenido que se está construyendo.
    " · " +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (time
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      ? "mismas muestras y escala"
      // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
      : "ventana " + Number(d.windowMS).toFixed(0) + " ms · misma escala") +
    // Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
    (d.bypass ? " · BYPASS: estas etapas internas no se envían a la salida." : "");
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
}
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("stage-frequency").onclick = () => {
  // Actualiza la representación temporal o frecuencial con el valor o cálculo indicado.
  S.stageMode = "frequency";
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("stage-frequency").classList.add("active");
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("stage-time").classList.remove("active");
  // Dibuja las mismas ventanas de audio antes y después de cada etapa.
  dibujarEtapas();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};
// Asocia este control con la acción que se ejecutará al pulsarlo o cambiar su valor.
elemento("stage-time").onclick = () => {
  // Actualiza la representación temporal o frecuencial con el valor o cálculo indicado.
  S.stageMode = "time";
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("stage-time").classList.add("active");
  // Actualiza las clases visuales que indican selección, visibilidad o estado del control.
  elemento("stage-frequency").classList.remove("active");
  // Dibuja las mismas ventanas de audio antes y después de cada etapa.
  dibujarEtapas();
// Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
};

// SECCIÓN: principal
// Construye las tiras de entrada, bandas de filtros y salida principal.
crearTiras();
// Actualiza las gráficas, el inspector y los controles con el estado actual.
actualizarInterfaz();
// Actualiza los botones y bloquea la configuración que no puede cambiar durante una toma.
mostrarEstadoEjecucion(false);
// Programa la acción después del intervalo indicado sin bloquear la interacción.
setTimeout(() => {
  // Comprueba la condición indicada antes de ejecutar la acción siguiente.
  if (!S.bridge) {
    // Actualiza el texto visible del control con el resultado o estado actual.
    elemento("connection").textContent = "VISTA DE INTERFAZ";
    // Muestra un aviso y distingue visualmente si se trata de un error.
    mostrarEstado("Abre ABRIR_SNARE.m en MATLAB para procesar WAV o audio USB.");
  // Cierra el bloque, la lista o la llamada que agrupa las instrucciones anteriores.
  }
// Completa el cálculo, los argumentos o el contenido de la instrucción anterior.
}, 1500);
