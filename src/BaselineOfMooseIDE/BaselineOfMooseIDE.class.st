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
		self famixQueries: spec.

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
				with: [ spec requires: #( 'FamixReplication' ) ] ].

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
		package: 'MooseIDE-Dependency'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
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
		with: [ spec requires: #( 'MooseIDE-Core' ) ];
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
		with: [ spec requires: #( 'MooseIDE-Core' ) ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> famix: spec [

	spec
		baseline: 'Famix'
		with: [ 
		spec repository: 'github://moosetechnology/Famix:development/src' ]
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

{ #category : #actions }
BaselineOfMooseIDE >> registerCustomTools [

	(Smalltalk classNamed: #MiPlayground) register
]

{ #category : #dependencies }
BaselineOfMooseIDE >> tylerDurden: spec [
	spec
		package: 'Durden'
		with: [ spec repository: 'github://pharo-contributions/Durden' ]
]
