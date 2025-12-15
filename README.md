## Architecture

Ce projet utilise une architecture **MVVM-C avec SwiftUI**, composée de **Views**, **ViewModels**, d’un **Coordinator** pour la navigation, et d’une couche de **Handlers** pour regrouper les actions applicatives.

Les **Views SwiftUI** sont responsables uniquement de l’affichage et des interactions utilisateur. Elles ne contiennent ni logique réseau ni logique de navigation.

Les **ViewModels** gèrent l’état de l’interface (chargement, données prêtes, erreur) et délèguent l’exécution des actions applicatives aux Handlers afin de rester simples et lisibles.

Les erreurs sont levées au niveau du service (via `throws`), capturées dans les ViewModels, puis exposées comme un état UI clair, ce qui permet une présentation cohérente sans coupler l’interface aux détails techniques.

Les **Handlers** encapsulent les opérations applicatives (chargement de la liste des pays, chargement du détail d’un pays) et servent de frontière entre la couche de présentation et les services techniques.

Le **service RestCountries** est responsable des appels réseau et du décodage des réponses, ce qui permet d’isoler les détails techniques et de faciliter les tests unitaires.

La navigation est gérée par un **Coordinator**, ce qui permet de découpler les décisions de navigation de l’UI. Le coordinator peut également centraliser la présentation de certains états globaux, comme les erreurs, afin de garder les Views et ViewModels découplés des mécanismes de présentation.

Cette architecture vise un équilibre entre simplicité, lisibilité et testabilité, tout en restant adaptée au périmètre d’un test technique.