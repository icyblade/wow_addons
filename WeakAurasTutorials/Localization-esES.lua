if not(GetLocale() == "esES") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["Actions and Animations: 1/7"] = "Acciones y Animaciones: 1/7"
L["Actions and Animations: 2/7"] = "Acciones y Animaciones: 2/7"
L["Actions and Animations: 3/7"] = "Acciones y Animaciones: 3/7"
L["Actions and Animations: 4/7"] = "Acciones y Animaciones: 4/7"
L["Actions and Animations: 5/7"] = "Acciones y Animaciones: 5/7"
L["Actions and Animations: 6/7"] = "Acciones y Animaciones: 6/7"
L["Actions and Animations: 7/7"] = "Acciones y Animaciones: 7/7"
L["Actions and Animations Text"] = [=[Para probar tu animación, debes ocultar tu visualización y hacerla aparecer de nuevo. esto puede hacerse usando el boton Vista de visualizaciones en la barra lateral.

Púlsala varias veces para comenzar la animación]=]
L["Activation Settings: 1/5"] = [=[Configuraciones de Activaciones: 1/5
]=]
L["Activation Settings: 2/5"] = "Configuraciones de Activaciones: 2/5"
L["Activation Settings: 3/5"] = "Configuraciones de Activaciones: 3/5"
L["Activation Settings: 4/5"] = "Configuraciones de Activaciones: 4/5"
L["Activation Settings: 5/5"] = "Configuraciones de Activaciones: 5/5"
L["Activation Settings Text"] = "Ya que eres %s, puedes activar las opciones de Clase de Personaje y seleccionar %s."
L["Auto-cloning: 1/10"] = "Auto-clonado. 1/10"
L["Auto-cloning 1/10 Text"] = [=[La función mas importante añadida en |cFF8800FF1.4|r es el |cFFFF0000auto-clonado|r. El |cFFFF0000auto-clonado|r  permite a tus visualizaciones a duplicarse automáticamente para mostrar múltiples orígenes de información. Cuando se pone en un Grupo Dinámico, te permite crear grupos de información dinámicos extensivos.

Hay tres tipos de disparadores que soportan el |cFFFF0000auto-clonado|r:  EscaneoCompletos de Auras, Auras de Grupo y Auras Multi-Objetivo.]=]
L["Beginners Finished Text"] = [=[Estos es todo en la Guía para Principiantes, Sin embargo, solo has rascado en la superficie de las funciones de |cFF8800FFWeakAuras|r.

Más adelante, |cFFFF0000Tutoriales| |cFFFFFF00Más|r |cFFFF7F00Avanzados|r serán publicados para adentrarte más en las infinitas posiblidades de |cFF8800FFWeakAuras|r.]=]
L["Beginners Guide Desc"] = "Guía de Principiantes"
L["Beginners Guide Desc Text"] = "Una guía sobre las opciones básicas de configuración de WeakAuras"
L["Create a Display: 1/5"] = "Crear una visualización: 1/5"
L["Create a Display: 2/5"] = "Crear una visualización: 2/5"
L["Create a Display: 3/5"] = "Crear una visualización: 3/5"
L["Create a Display: 4/5"] = "Crear una visualización: 4/5"
L["Create a Display: 5/5"] = "Crear una visualización: 5/5"
L["Create a Display Text"] = [=[Aunque la pestaña de Visualización tiene controles deslizantes para Anchura, Altura y Posicionamiento XY, hay una forma más fácil de mover tu visualización.

simplemente haz clic y arrastra tu visualización a cualquier parte de la pantalla y haz clic y arrastra las esquinas para cambiar el tamaño.

También puedes apretar Mayúsculas para ocultar el cuadro para mover/dimensionar para un posicionamiento más preciso.]=]
L["Display Options: 1/4"] = "Opciones de visualización: 1/4"
L["Display Options 1/4 Text"] = "Ahora, selecciona una visualización de Barra de Progreso (o puedes crear una nueva)"
L["Display Options: 2/4"] = "Opciones de visualización: 2/4"
L["Display Options 2/4 Text"] = [=[Los tipos |cFFFFFFFFBarra de Progreso|r e |cFFFFFFFFIcono|r ahora tienen una opción para mostrar los textos de ayuda cuando pasas el puntero por encima.

Esta opción está solamente disponible si tu visualización usa un disparador basado en un aura, objeto o hechizo. ]=]
L["Display Options: 4/4"] = "Opciones de visualización: 4/4"
L["Display Options 4/4 Text"] = "Finalmente, un nuevo tipo de visualización, |cFFFFFFFFModelo|r, te permite aprovechar cualquier modelo 3D del juego."
L["Dynamic Group Options: 2/4"] = "Opciones de Grupos Dinámicos: 2/4"
L["Dynamic Group Options 2/4 Text"] = [=[La mayor mejora de los |cFFFFFFFGrupos Dinámicos|rs es una nueva selección para las opciones de Crecimiento.

Selecciona \"Circular\" para verlo en acción.]=]
L["Dynamic Group Options: 3/4"] = "Opciones de Grupos Dinámicos: 3/4"
L["Dynamic Group Options 3/4 Text"] = [=[Las opciones de la constante de factor te permite controlar como crece tu grupo circular.

En un grupo circular con espaciado constante crece su radio a medida que se añaden mas auras, mientras que una visualización de radio constante simplemente causa que las auras se junten a medida que más son añadidas.]=] -- Needs review
L["Dynamic Group Options: 4/4"] = "Opciones de Grupos Dinámicos: 4/4"
L["Dynamic Group Options 4/4 Text"] = [=[Los grupos dinámicos ahora pueden tener sus hijos automáticamente ordenados por el tiempo restante.

Las auras que no tienen tiempo restante son situadas en la parte superior o inferior, dependiendo si eliges \"Ascendiente\" o \"Descendiente\".]=] -- Needs review
L["Finished"] = "Finalizado"
L["Full-scan Auras: 2/10"] = "Escaneo completo de Auras: 2/10"
L["Full-scan Auras 2/10 Text"] = "Primero, habilitado la opción de Escaneo Completo"
L["Full-scan Auras: 3/10"] = "Escaneo completo de Auras: 3/10"
L["Full-scan Auras 3/10 Text"] = [=[|cFFFF0000Auto-clonado|r  puedes ser ahora activado utilizando la opción \"%s\".

Esto causa que una nueva aura sea creada para cada aura que coincida con los parámetros dados.]=] -- Needs review
L["Full-scan Auras: 4/10"] = "Escaneo completo de Auras: 4/10"
L["Full-scan Auras 4/10 Text"] = [=[Una ventana emergente debería aparecer, informándote que las auras |cFFFF0000auto-clonadas|r deben ser generalmente utilizadas en grupos dinámicos.

Presiona \"Sí\" para permitir a |cFF8800FFWeakAuras|r poner automáticamente tu aura en un grupo dinámico.]=] -- Needs review
L["Full-scan Auras: 5/10"] = "Escaneo completo de Auras: 5/10"
L["Full-scan Auras 5/10 Text"] = "Deshabilitar la opción de escaneo completo para reactivar otras selecciones de las opciones de Unidad "
L["Group Auras 6/10"] = "Auras de Grupo: 6/10"
L["Group Auras 6/10 Text"] = "Ahora selecciona \"Grupo\" para la opción de Unidad"
L["Group Auras: 7/10"] = "Auras de Grupo: 7/10"
L["Group Auras 7/10 Text"] = [=[|cFFFF0000Auto-clonado|r está, otra vez, habilitado utilizando la opción \"%s\".

Una nueva aura será creada para cada miembro de tu grupo que esté afectado por la(s) aura(s) especificada(s).]=] -- Needs review
L["Group Auras: 8/10"] = "Auras de Grupo: 8/10"
L["Group Auras 8/10 Text"] = "Activando la opción %s para una Aura Grupal con |cFFFF0000auto-clonado|r activada creará una nueva aura para cada miembro de tu grupo |cFFFFFFFFno|r afectado por la(s) aura(s) especificada(s)." -- Needs review
L["Home"] = "Inicio"
L["Multi-target Auras: 10/10"] = "Auras Multi-objetivo: 10/10"
L["Multi-target Auras 10/10 Text"] = [=[Las auras Multi-objetivo auras tienen el |cFFFF0000auto-clonado|r activo por defecto..

Los desencadenadores de auras multi-objetivo son diferentes de los desencadenadores de las auras normales ya que están basados en eventos del Registro de Combate, lo cúal significa que tendrán un seguimiento de las auras de criaturas que nadie tiene como objetivo (aunque alguna información dinámica no está disponible si alguien en tu grupo no los tiene como objetivo).

Esto hace a las auras Multi-objetivo una buena elección para tener un seguimiendo de los DoTs en enemigos múltiples.]=] -- Needs review
L["Multi-target Auras: 9/10"] = "Auras Multi-objetivo: 9/10"
L["Multi-target Auras 9/10 Text"] = "Finalmente, selecciona \"Multi-objetivo\" para la opción de Unidad."
L["New in 1.4:"] = "Nuevo en 1.4:"
L["New in 1.4 Desc:"] = "Nuevo en 1.4"
L["New in 1.4 Desc Text"] = "Lee las nuevas funciones de WeakAuras 1.4"
L["New in 1.4 Finnished Text"] = [=[Por supuesto, hay más características en |cFF8800FFWeakAuras 1.4|r de las que se pueden explicar a la vez, sin mencionar el incontable número de mejoras de eficiencia y de errores.

Con suerte, este tutorial te guiará hacia las características principales que están disponibles.

¡Gracias por utilizar |cFF8800FFWeakAuras|r!]=] -- Needs review
L["New in 1.4 Text1"] = [=[La versión 1.4 de |cFF8800FFWeakAuras|r introduce varias nuevas potentes características.

Este tutorial muestra un resumen de las capacidades más importantes y como utilizarlas.]=] -- Needs review
L["New in 1.4 Text2"] = "Primero, crea una nueva visualización para su uso como demostración."
L["Previous"] = "Previo"
L["Trigger Options: 1/4"] = "Opciones de Disparador: 1/4"
L["Trigger Options 1/4 Text"] = [=[Además de \"Multi-objetivo\" hay otra opción para la opción de Unidad: Unidad Específica

Selecciónala para poder crear un nuevo campo de texto.]=] -- Needs review
L["Trigger Options: 2/4"] = "Opciones de Disparador: 2/4"
L["Trigger Options 2/4 Text"] = [=[En este campo, puedes especificar el nombre de cualquier jugador o ID personalizada de Unidad. Los IDs de Unidad tales como \"boss1\" \"boss2\" etc. son especialmente útiles para encuentros de banda.

Todos los desencadenadores te permiten especificar una unidad (no únicamente los desencadenadores de Aura) ahora soportan la opción de Unidad Especifica.]=] -- Needs review
L["Trigger Options: 3/4"] = "Opciones de Disparador: 3/4"
L["Trigger Options 3/4 Text"] = [=[|cFF8800FFWeakAuras 1.4|r también añade algunos tipos nuevos de Desencadenadores.

Selecciona la categoria Estado para darles un vistazo.]=] -- Needs review
L["Trigger Options: 4/4"] = "Opciones de Disparador: 4/4"
L["Trigger Options 4/4 Text"] = [=[Los desencadenadors de |cFFFFFFFFCaracterísticas de Unidad|r te permiten comprobar el nombre de una unidad, clase, hostilidad y si es un jugador o no.

Los desencadenadores |cFFFFFFFFTiempo de reutilización Global|r y |cFFFFFFFFTemporizador de golpe|r complementan el desencadenador de Lanzamiento.]=] -- Needs review
L["WeakAuras Tutorials"] = "Tutoriales de WeakAuras"
L["Welcome"] = "Bienvenido"
L["Welcome Text"] = [=[Bienvenido a la Guía de Principiante de |cFF8800FFWeakAuras|r.

Esta guía te mostará como utilizar WeakAuras y explicará las opciones de configuración básicas.]=] -- Needs review



