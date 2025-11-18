import 'package:cogni_app/models/game.dart';

final gameLibrary = <GameDescriptor>[
  GameDescriptor(
    id: 'simon',
    title: 'Secuencia de Colores',
    category: GameCategory.memoryAttention,
    summary: 'Repite la secuencia de colores y sonidos para entrenar memoria de trabajo y atención sostenida.',
    objective: 'Recordar y reproducir secuencias crecientes de estímulos visuales.',
    therapeuticFocus: [
      'Memoria de trabajo (visual y auditiva).',
      'Atención sostenida y selectiva frente a distractores leves.',
    ],
    motorFocus: [
      'Coordinación ojo-mano con toques precisos.',
      'Tiempo de reacción para cambios rápidos en la secuencia.',
    ],
    howItHelps: [
      'Incrementa la capacidad de retención en adultos mayores de forma progresiva.',
      'Permite graduar la complejidad ajustando velocidad y longitud de la serie.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Secuencias cortas y ritmo lento.', timeSeconds: 12, stimuliCount: 3),
      GameDifficultyOption(level: 'Medio', description: 'Secuencias moderadas, más cambios de color.', timeSeconds: 10, stimuliCount: 5),
      GameDifficultyOption(level: 'Intenso', description: 'Secuencias largas con poco tiempo de respuesta.', timeSeconds: 8, stimuliCount: 7),
    ],
    setupNotes: [
      'Ideal para comenzar sesiones de calentamiento cognitivo.',
      'Usar volumen moderado si se combinan sonidos con colores.',
    ],
    instructions: [
      'Observa la secuencia de colores que se ilumina.',
      'Repite la secuencia tocando los mismos colores en orden.',
      'Avanza mientras la secuencia crece en longitud.',
    ],
  ),
  GameDescriptor(
    id: 'parejas',
    title: 'Memoria de Parejas',
    category: GameCategory.memoryAttention,
    summary: 'Encuentra cartas iguales para ejercitar memoria episódica y estrategias de búsqueda.',
    objective: 'Recordar la ubicación de símbolos y encontrar todas las parejas.',
    therapeuticFocus: [
      'Memoria visual episódica.',
      'Estrategias de exploración y planificación de búsqueda.',
    ],
    motorFocus: [
      'Toques precisos en tarjetas de tamaño configurable.',
    ],
    howItHelps: [
      'Favorece la retención de ubicaciones y asociación de imágenes.',
      'Permite aumentar gradualmente el número de cartas.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: '4 a 6 cartas visibles.', timeSeconds: 0, stimuliCount: 6),
      GameDifficultyOption(level: 'Medio', description: 'Hasta 10 cartas con más símbolos.', timeSeconds: 0, stimuliCount: 10),
      GameDifficultyOption(level: 'Intenso', description: '12-16 cartas y más distractores visuales.', timeSeconds: 0, stimuliCount: 14),
    ],
    setupNotes: [
      'Usa íconos grandes para pacientes con menor agudeza visual.',
      'Permite ocultar colores muy saturados para evitar fatiga visual.',
    ],
    instructions: [
      'Toca dos tarjetas para revelar su símbolo.',
      'Si coinciden, se mantienen visibles; si no, vuelven a ocultarse.',
      'Encuentra todas las parejas en el menor número de intentos.',
    ],
  ),
  GameDescriptor(
    id: 'stroop',
    title: 'Atención Selectiva (Stroop)',
    category: GameCategory.executiveSpeed,
    summary: 'Selecciona el color correcto ignorando la palabra para entrenar inhibición y velocidad de procesamiento.',
    objective: 'Elegir el color de la fuente y no el texto escrito.',
    therapeuticFocus: [
      'Control inhibitorio y flexibilidad cognitiva.',
      'Velocidad de procesamiento bajo presión leve.',
    ],
    motorFocus: [
      'Toques rápidos en botones de color de tamaño consistente.',
    ],
    howItHelps: [
      'Reduce impulsividad al priorizar instrucciones sobre automatismos.',
      'Entrena cambio rápido de criterio (palabra vs color).',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Colores congruentes y sin límite de tiempo.', timeSeconds: 0, stimuliCount: 6),
      GameDifficultyOption(level: 'Medio', description: 'Algunas incongruencias con tiempo moderado.', timeSeconds: 15, stimuliCount: 10),
      GameDifficultyOption(level: 'Intenso', description: 'Mayor velocidad y distractores frecuentes.', timeSeconds: 10, stimuliCount: 14),
    ],
    setupNotes: [
      'Ideal tras ejercicios de memoria para trabajar control inhibitorio.',
      'Puede usarse con audio indicando el color para aumentar complejidad.',
    ],
    instructions: [
      'Lee la palabra pero enfócate en el color de la fuente.',
      'Toca el botón del color correcto tan rápido como puedas.',
    ],
  ),
  GameDescriptor(
    id: 'golpeo',
    title: 'Golpea el Objetivo',
    category: GameCategory.executiveSpeed,
    summary: 'Toca el estímulo correcto entre distractores dentro de una ventana de tiempo.',
    objective: 'Elegir objetivos válidos mientras se ignoran distractores.',
    therapeuticFocus: [
      'Atención selectiva y velocidad de reacción.',
      'Planificación rápida de movimientos.',
    ],
    motorFocus: [
      'Coordinación ojo-mano con toques rápidos.',
      'Ajuste de fuerza y precisión al tocar.',
    ],
    howItHelps: [
      'Mejora la capacidad de responder bajo tiempo limitado.',
      'Entrena la discriminación de estímulos relevantes.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Pocos distractores y objetivos grandes.', timeSeconds: 15, stimuliCount: 8),
      GameDifficultyOption(level: 'Medio', description: 'Velocidad media con objetivos más pequeños.', timeSeconds: 12, stimuliCount: 12),
      GameDifficultyOption(level: 'Intenso', description: 'Muchos distractores y tiempo reducido.', timeSeconds: 8, stimuliCount: 16),
    ],
    setupNotes: [
      'Ajusta el tamaño de los objetivos según la capacidad motora.',
      'Permite más tiempo si hay rigidez o temblor.',
    ],
    instructions: [
      'Identifica el estímulo objetivo (por color o símbolo).',
      'Toca solo los objetivos antes de que desaparezcan.',
    ],
  ),
  GameDescriptor(
    id: 'arrastrar',
    title: 'Arrastra y Encaja',
    category: GameCategory.visuomotor,
    summary: 'Arrastra piezas a sus contornos para entrenar coordinación fina y percepción visuoespacial.',
    objective: 'Ubicar piezas en siluetas correspondientes sin salirse.',
    therapeuticFocus: [
      'Percepción visuoespacial y discriminación figura-fondo.',
      'Planificación motora fina.',
    ],
    motorFocus: [
      'Prensión y arrastre controlado en pantalla táctil.',
      'Coordinación bilateral si se usan dos manos.',
    ],
    howItHelps: [
      'Fomenta precisión en movimientos cortos.',
      'Permite ajustar tamaño de piezas y sensibilidad del arrastre.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Pocas piezas grandes y contornos claros.', timeSeconds: 0, stimuliCount: 3),
      GameDifficultyOption(level: 'Medio', description: 'Más piezas medianas y contornos cercanos.', timeSeconds: 0, stimuliCount: 6),
      GameDifficultyOption(level: 'Intenso', description: 'Piezas pequeñas y contornos juntos.', timeSeconds: 0, stimuliCount: 9),
    ],
    setupNotes: [
      'Usar tablet horizontal para mayor comodidad en arrastre.',
      'Permitir descanso entre intentos para evitar fatiga.',
    ],
    instructions: [
      'Selecciona una pieza y arrástrala hacia su silueta.',
      'Encaja suavemente evitando soltar fuera del contorno.',
    ],
  ),
  GameDescriptor(
    id: 'trazo',
    title: 'Traza el Camino',
    category: GameCategory.visuomotor,
    summary: 'Sigue un camino sin salirte para mejorar control motor fino y atención sostenida.',
    objective: 'Recorrer trazos curvos o rectos manteniéndose dentro del camino.',
    therapeuticFocus: [
      'Planificación motora secuencial.',
      'Atención sostenida y ritmo.',
    ],
    motorFocus: [
      'Estabilidad de muñeca y dedos en desplazamiento continuo.',
    ],
    howItHelps: [
      'Reduce temblor al practicar trazos lentos y controlados.',
      'Permite variar el ancho del camino según habilidad.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Caminos anchos y cortos.', timeSeconds: 0, stimuliCount: 2),
      GameDifficultyOption(level: 'Medio', description: 'Curvas moderadas y longitud media.', timeSeconds: 0, stimuliCount: 4),
      GameDifficultyOption(level: 'Intenso', description: 'Caminos estrechos con curvas cerradas.', timeSeconds: 0, stimuliCount: 6),
    ],
    setupNotes: [
      'Ideal con stylus si el paciente tiene buena prensión.',
      'Permite pausar y reanudar para evitar fatiga.',
    ],
    instructions: [
      'Apoya el dedo o stylus al inicio del camino.',
      'Desliza siguiendo la ruta hasta el final sin salirte.',
    ],
  ),
  GameDescriptor(
    id: 'calculo',
    title: 'Cálculo y Planificación',
    category: GameCategory.calculationPlanning,
    summary: 'Resuelve operaciones simples con límite de tiempo y pasos mínimos.',
    objective: 'Mantener precisión en cálculos rápidos mientras se planifica el orden de resolución.',
    therapeuticFocus: [
      'Velocidad de procesamiento numérico.',
      'Planificación y priorización de operaciones.',
    ],
    motorFocus: [
      'Toques precisos en teclas numéricas.',
    ],
    howItHelps: [
      'Incrementa la confianza en tareas de la vida diaria (pagos, cuentas).',
      'Permite graduar dificultad con más dígitos o tiempo reducido.',
    ],
    difficultyOptions: const [
      GameDifficultyOption(level: 'Suave', description: 'Sumas de un dígito sin tiempo.', timeSeconds: 0, stimuliCount: 6),
      GameDifficultyOption(level: 'Medio', description: 'Sumas y restas simples con tiempo moderado.', timeSeconds: 25, stimuliCount: 10),
      GameDifficultyOption(level: 'Intenso', description: 'Operaciones mixtas con límite breve.', timeSeconds: 15, stimuliCount: 14),
    ],
    setupNotes: [
      'Usar números grandes y alto contraste.',
      'Permitir hablar en voz alta el cálculo si ayuda a retener.',
    ],
    instructions: [
      'Lee la operación en pantalla.',
      'Ingresa el resultado antes de que termine el tiempo (si aplica).',
    ],
  ),
];

Map<GameCategory, String> categoryLabels = {
  GameCategory.memoryAttention: 'Memoria y Atención',
  GameCategory.executiveSpeed: 'Función ejecutiva y velocidad',
  GameCategory.visuomotor: 'Visuoespacial y motricidad fina',
  GameCategory.calculationPlanning: 'Cálculo y planificación',
};
