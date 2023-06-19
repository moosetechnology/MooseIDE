Class {
	#name : #BaselineOfMooseIDE,
	#superclass : #BaselineOf,
	#category : #BaselineOfMooseIDE
}

{ #category : #baselines }
BaselineOfMooseIDE >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
		self tylerDurden: spec.
		self labelContractor: spec.
		self hierarchicalVisualizations: spec.
		self roassal3: spec.
		self famixQueries: spec.
		self pharoAIHierachicalClustering: spec.
		self stonCustomizer: spec.
		self microdown: spec.

		"Packages"
		self definePackages: spec.

		"If Moose is not already present"
		spec for: #NeedsMoose do: [ 
			self famix: spec.
			self famixTagging: spec.
			self famixReplication: spec.
			spec
				package: 'MooseIDE-Core' with: [ spec requires: #( 'Famix' ) ];
				package: 'MooseIDE-Meta'
				with: [ spec requires: #( 'MooseIDE-Core' ) ];
				package: 'MooseIDE-Tagging'
				with: [ spec requires: #( 'FamixTagging' ) ];
				package: 'MooseIDE-CoUsageMap'
				with: [ spec requires: #( 'FamixTagging' ) ];
				package: 'MooseIDE-Dependency'
				with: [ spec requires: #( 'FamixTagging' ) ];
				package: 'MooseIDE-NewTools'
				with: [ spec requires: #( 'FamixQueries' ) ];
				package: 'MooseIDE-Duplication'
				with: [ spec requires: #( 'FamixReplication' ) ];
				package: 'Famix-CriticBrowser-Entities'
				with: [ spec requires: 'Famix' ];
				package: 'Famix-CriticBrowser-Generator'
				with: [ spec requires: 'Famix' ] ].

		"Register custom tools"
		spec postLoadDoIt: #registerCustomTools ]
]

{ #category : #accessing }
BaselineOfMooseIDE >> customProjectAttributes [

	^ RPackageOrganizer default packages
		  detect: [ :package | package name = 'BaselineOfFamix' ]
		  ifFound: [ #(  ) ]
		  ifNone: [ #( #NeedsMoose ) ]
]

{ #category : #baselines }
BaselineOfMooseIDE >> defineMooseCriticsPackages: spec [

	spec
		package: 'MooseIDE-CriticBrowser' with: [
			spec requires: #( 'MooseIDE-Core' 'Famix-CriticBrowser-Entities'
					   'STONCustomizer' ) ];
		package: 'MooseIDE-CriticBrowser-Tests'
		with: [
			spec requires: #( 'MooseIDE-Tests' 'MooseIDE-CriticBrowser' ) ];
		package: 'Famix-CriticBrowser-Entities';
		package: 'Famix-CriticBrowser-Generator';
		package: 'Famix-CriticBrowser-Tests'
		with: [ spec requires: 'Famix-CriticBrowser-Entities' ].

	spec
		group: 'CriticBrowser-Metamodel'
		with:
			#( 'Famix-CriticBrowser-Entities' 'Famix-CriticBrowser-Generator'
			   'Famix-CriticBrowser-Tests' )
]

{ #category : #baselines }
BaselineOfMooseIDE >> definePackages: spec [

	spec
		package: 'MooseIDE-Core'
		with: [ spec requires: #( 'LabelContractor' ) ];
		package: 'MooseIDE-Visualization'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'HierarchicalVisualizations' ) ];

		package: 'MooseIDE-Meta'
		with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-Tests' with: [ 
			spec requires:
					#( 'MooseIDE-Core' 'MooseIDE-Dependency' 'MooseIDE-Tagging' ) ];
		package: 'MooseIDE-Dependency' with: [ 
			spec requires:
					#( 'MooseIDE-Core' 'MooseIDE-Visualization'
					   'Roassal3' 'AIHierarchicalClustering' ) ];
		package: 'MooseIDE-Famix'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-Tagging'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-Tagging-Tests'
		with: [ spec requires: #( 'MooseIDE-Tagging' ) ];
		package: 'MooseIDE-QueriesBrowser'
		with: [ spec requires: #( 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-QueriesBrowser-Tests'
		with: [ 
			spec requires: #( 'MooseIDE-QueriesBrowser'
				   'MooseIDE-Tests' ) ];
		package: 'MooseIDE-NewTools'
		with: [ spec requires: #( 'MooseIDE-Meta' 'MooseIDE-Core' ) ];
		package: 'MooseIDE-NewTools-Tests'
		with: [ spec requires: #( 'MooseIDE-NewTools' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-Export'
		with: [ spec requires: #( 'MooseIDE-Core' 'Microdown' ) ];
		package: 'MooseIDE-ColorPalette';
		package: 'MooseIDE-ColorPalette-Tests'
		with: [ spec requires: #( 'MooseIDE-ColorPalette' ) ];
		package: 'MooseIDE-Durden'
		with: [ spec requires: #( 'MooseIDE-Core' 'Durden' ) ];
		package: 'MooseIDE-CoUsageMap'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-CoUsageMap-Tests'
		with: [ spec requires: #( 'MooseIDE-CoUsageMap'
				   'MooseIDE-Tests' ) ];
		package: 'MooseIDE-Duplication'
		with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-ButterflyMap'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-ButterflyMap-Tests'
		with: [ spec requires: #( 'MooseIDE-ButterflyMap' ) ].

	self defineMooseCriticsPackages: spec
]

{ #category : #dependencies }
BaselineOfMooseIDE >> famix: spec [

	spec
		baseline: 'Famix'
		with: [ 
		spec repository: 'github://moosetechnology/Famix:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> famixQueries: spec [
	spec
		baseline: 'FamixQueries'
		with: [ spec repository: 'github://moosetechnology/FamixQueries' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> famixReplication: spec [

	spec
		baseline: 'FamixReplication'
		with: [ 
		spec repository: 'github://moosetechnology/FamixReplication' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> famixTagging: spec [

	spec
		baseline: 'FamixTagging'
		with: [ 
		spec repository: 'github://moosetechnology/FamixTagging:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> hierarchicalVisualizations: spec [

	spec
		baseline: 'HierarchicalVisualizations'
		with: [ 
		spec repository: 'github://ObjectProfile/HierarchicalVisualizations:main/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> labelContractor: spec [

	spec
		baseline: 'LabelContractor'
		with: [ 
		spec repository: 'github://moosetechnology/LabelContractor/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> microdown: spec [

	spec
		baseline: 'Microdown'
		with: [ 
		spec repository: 'github://pillar-markup/Microdown:master/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> pharoAIHierachicalClustering: spec [

	spec
		baseline: 'AIHierarchicalClustering'
		with: [ 
		spec repository: 'github://pharo-ai/hierarchical-clustering/src' ]
]

{ #category : #actions }
BaselineOfMooseIDE >> registerCustomTools [
	"MiPlayground could be absent if we load only a group"

	(Smalltalk classNamed: #MiPlayground) ifNotNil: [ :miPlayground |
		miPlayground register ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> roassal3: spec [

	spec
		baseline: 'Roassal3'
		with: [ 
		spec repository: 'github://ObjectProfile/Roassal3:master/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> stonCustomizer: spec [

	spec
		baseline: 'STONCustomizer'
		with: [ 
		spec repository: 'github://jecisc/STONCustomizer:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> tylerDurden: spec [
	spec
		package: 'Durden'
		with: [ spec repository: 'github://pharo-contributions/Durden' ]
]
