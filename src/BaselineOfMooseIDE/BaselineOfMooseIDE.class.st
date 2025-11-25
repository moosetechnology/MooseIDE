Class {
	#name : 'BaselineOfMooseIDE',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMooseIDE',
	#package : 'BaselineOfMooseIDE'
}

{ #category : 'baselines' }
BaselineOfMooseIDE >> baseline: spec [

	<baseline>
	spec for: #common do: [
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec.

			spec for: #NoFamix do: [
					self defineMooseDependencies: spec.
					self definePackagesWhenNoFamix: spec ].

			spec postLoadDoIt: #registerCustomTools ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> classBlueprint: spec [

	spec
		baseline: 'ClassBlueprint'
		with: [
		spec repository: 'github://moosetechnology/ClassBlueprint/src' ]
]

{ #category : 'accessing' }
BaselineOfMooseIDE >> customProjectAttributes [

	'BaselineOfFamix' asPackageIfAbsent: [ ^ #( #NoFamix ) ].
	^ #( #WithFamix )

]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> defineDependencies: spec [

	self labelContractor: spec.
	self roassalExporters: spec.
	self hierarchicalVisualizations: spec.
	self pharoAIHierachicalClustering: spec.
	self interactiveNotebook: spec.
	self classBlueprint: spec.

	spec for: #WithFamix do: [ self famixQueries: spec ]
]

{ #category : 'groups' }
BaselineOfMooseIDE >> defineGroups: spec [

	spec
		group: 'CriticBrowser-Metamodel'
		with:
			#( 'Famix-CriticBrowser-Entities' 'Famix-CriticBrowser-ManualEntities'
			   'Famix-CriticBrowser-Generator' 'Famix-CriticBrowser-Tests' ) ;
		group: 'bulkedit'
		with: #( 'MooseIDE-BulkEditor' )
]

{ #category : 'packages' }
BaselineOfMooseIDE >> defineMooseCriticsPackages: spec [

	spec
		package: 'MooseIDE-CriticBrowser' with: [ spec requires: #( 'MooseIDE-Core' 'Famix-CriticBrowser-Entities' ) ];
		package: 'MooseIDE-CriticBrowser-Tests' with: [ spec requires: #( 'MooseIDE-Tests' 'MooseIDE-CriticBrowser' ) ];
		
		package: 'Famix-CriticBrowser-ManualEntities' with: [ spec requires: #( 'FamixQueries' ) ];
		package: 'Famix-CriticBrowser-Entities' with: [ spec requires: #('Famix-CriticBrowser-ManualEntities') ];
		package: 'Famix-CriticBrowser-Generator';
		
		package: 'Famix-CriticBrowser-Tests' with: [ spec requires: 'Famix-CriticBrowser-Entities' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> defineMooseDependencies: spec [

	self famix: spec.
	self famixTagging: spec.
	self famixReplication: spec.
	self famixQueries: spec
]

{ #category : 'packages' }
BaselineOfMooseIDE >> definePackages: spec [

	spec
		package: 'MooseIDE-Core' with: [ spec requires: #( 'LabelContractor' 'RoassalExporters' ) ];
		package: 'MooseIDE-WelcomeBrowser'
		with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Meta' 'MooseIDE-CoUsageMap' 'MooseIDE-NewTools' 'MooseIDE-QueriesBrowser' ) ];
		package: 'MooseIDE-Visualization' with: [ spec requires: #( 'MooseIDE-Core' 'HierarchicalVisualizations' ) ];
		package: 'MooseIDE-Meta' with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Famix' ) ];
		package: 'MooseIDE-ArchitecturalMap' with: [ spec requires: #( 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-ArchitecturalMap-Tests' with: [ spec requires: #( 'MooseIDE-ArchitecturalMap' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-DeadCode' with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-DeadCode-Tests' with: [ spec requires: #( 'MooseIDE-DeadCode' 'MooseIDE-Tests' ) ];		
		package: 'MooseIDE-DSM' with: [ spec requires: #( 'MooseIDE-Visualization' 'AIHierarchicalClustering' ) ];
		package: 'MooseIDE-DistributionMap' with: [ spec requires: #( 'MooseIDE-Visualization' 'AIHierarchicalClustering' ) ];
		package: 'MooseIDE-Tests' with: [ spec requires: #( 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-AttributedText';
		package: 'MooseIDE-Famix' with: [ spec requires: #( 'MooseIDE-Visualization' 'MooseIDE-AttributedText' ) ];
		package: 'MooseIDE-QueriesBrowser' with: [ spec requires: #( 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-QueriesBrowser-Tests' with: [ spec requires: #( 'MooseIDE-QueriesBrowser' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-Tagging' with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-Tagging-Tests' with: [ spec requires: #( 'MooseIDE-Tagging' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-CoUsageMap' with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-CoUsageMap-Tests' with: [ spec requires: #( 'MooseIDE-CoUsageMap' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-NewTools' with: [ spec requires: #( 'MooseIDE-Meta' 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-NewTools-Tests' with: [ spec requires: #( 'MooseIDE-NewTools' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-Export' with: [ spec requires: #( 'MooseIDE-Core' 'InteractiveNotebook' ) ];
		package: 'MooseIDE-Duplication' with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-ButterflyMap' with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-ButterflyMap-Tests' with: [ spec requires: #( 'MooseIDE-ButterflyMap' ) ];
		package: 'MooseIDE-QueriesDashboard' with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-LayerVisualization' with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' 'MooseIDE-QueriesDashboard' ) ];
		package: 'MooseIDE-ClassBlueprint' with: [ spec requires: #( 'MooseIDE-Visualization' 'ClassBlueprint' ) ];
		package: 'MooseIDE-Spotter';
		package: 'MooseIDE-Core-Reporter' with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-Spotter-Tests' with: [ spec requires: #( 'MooseIDE-Spotter' ) ];
		package: 'MooseIDE-Analysis' with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-BulkEditor'.

	self defineMooseCriticsPackages: spec
]

{ #category : 'packages' }
BaselineOfMooseIDE >> definePackagesWhenNoFamix: spec [

	spec
		package: 'MooseIDE-Core' with: [ spec requires: #( 'Famix' 'FamixTagging' ) ];
		package: 'MooseIDE-Tagging' with: [ spec requires: #( 'FamixTagging' ) ];
		package: 'MooseIDE-CoUsageMap' with: [ spec requires: #( 'FamixTagging' ) ];
		package: 'MooseIDE-Duplication' with: [ spec requires: #( 'FamixReplication' ) ];
		
		package: 'Famix-CriticBrowser-Entities' with: [ spec requires: #( 'Famix') ];
		package: 'Famix-CriticBrowser-Generator' with: [ spec requires: 'Famix' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> famix: spec [

	spec
		baseline: 'Famix'
		with: [ 
		spec repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> famixQueries: spec [

	spec
		baseline: 'FamixQueries'
		with: [ spec repository: 'github://moosetechnology/FamixQueries' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> famixReplication: spec [

	spec
		baseline: 'FamixReplication'
		with: [ 
		spec repository: 'github://moosetechnology/FamixReplication' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> famixTagging: spec [

	spec
		baseline: 'FamixTagging'
		with: [
		spec repository: 'github://moosetechnology/FamixTagging/src' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> hierarchicalVisualizations: spec [

	spec baseline: 'HierarchicalVisualizations' with: [
		spec repository:
			'github://moosetechnology/HierarchicalVisualizations:main/src' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> interactiveNotebook: spec [

	spec
		baseline: 'InteractiveNotebook'
		with: [ 
		spec repository: 'github://moosetechnology/InteractiveNotebook/src' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> labelContractor: spec [

	spec
		baseline: 'LabelContractor'
		with: [ 
		spec repository: 'github://moosetechnology/LabelContractor/src' ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> microdown: spec [

	spec for: #( #'pharo11.x' #'pharo10.x' ) do: [
		spec
			baseline: 'Microdown'
			with: [
			spec repository: 'github://pillar-markup/Microdown:master/src' ] ].

	spec for: #( #'pharo12.x' ) do: [
		spec
			baseline: 'Microdown'
			with: [
			spec repository: 'github://pillar-markup/Microdown:Pharo12/src' ] ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> pharoAIHierachicalClustering: spec [

	spec
		baseline: 'AIHierarchicalClustering'
		with: [ 
		spec repository: 'github://pharo-ai/hierarchical-clustering/src' ]
]

{ #category : 'actions' }
BaselineOfMooseIDE >> registerCustomTools [

	self registerShortcuts. "MiPlayground could be absent if we load only a group"
	(Smalltalk classNamed: #MiPlaygroundBrowser) ifNotNil: [ :miPlayground | miPlayground register ].

	Smalltalk at: #MooseIDEWelcomeBrowser ifPresent: [ :mooseWelcome | mooseWelcome register ]
]

{ #category : 'actions' }
BaselineOfMooseIDE >> registerShortcuts [

	(Smalltalk classNamed: #MiShortcutsCategory) ifNotNil: [
		:miShortcutsCategory |
		miShortcutsCategory new installAsGlobalCategory ]
]

{ #category : 'dependencies' }
BaselineOfMooseIDE >> roassalExporters: spec [

	spec
		baseline: 'RoassalExporters'
		with: [ 
		spec repository: 'github://pharo-graphics/RoassalExporters:v1.02/src' ]
]
