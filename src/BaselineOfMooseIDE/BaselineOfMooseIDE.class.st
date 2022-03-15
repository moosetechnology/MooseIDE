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
		self famixQueries: spec.
		self telescope: spec.
		self labelContractor: spec.
		self hierarchicalVisualizations: spec.

		"Packages"
		self definePackages: spec.

		"If Moose is not already present"
		spec for: #NeedsMoose do: [ 
			self famix: spec.
			self famixTagging: spec.
			spec
				package: 'MooseIDE-Core' with: [ spec requires: #( 'Famix' ) ];
				package: 'MooseIDE-Meta'
				with: [ spec requires: #( 'MooseIDE-Core' ) ];
				package: 'MooseIDE-Tagging'
				with: [ spec requires: #( 'FamixTagging' ) ];
				package: 'MooseIDE-CoUsageMap'
				with: [ spec requires: #( 'FamixTagging' ) ] ].

		"Register custom tools"
		spec
			postLoadDoIt: #registerCustomTools;
			postLoadDoIt: #resetMiApplications ]
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
		package: 'MooseIDE-Visualization' with: [ 
			spec requires:
					#( 'MooseIDE-Core' 'TelescopeRoassal3' 'HierarchicalVisualizations' ) ];
		package: 'MooseIDE-Meta'
		with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-Tests'
		with: [ spec requires: #( 'MooseIDE-Core' 'MooseIDE-Tagging' ) ];
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
		package: 'MooseIDE-Telescope'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-QueriesBrowser'
		with: [ spec requires: #( 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-QueriesBrowser-Tests'
		with: [ 
			spec requires: #( 'MooseIDE-QueriesBrowser'
				   'MooseIDE-Tests' ) ];
		package: 'MooseIDE-NewTools'
		with: [ 
			spec requires: #( 'MooseIDE-Meta' 'MooseIDE-Core' 'FamixQueries' ) ];
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
				   'MooseIDE-Tests' ) ]
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

{ #category : #actions }
BaselineOfMooseIDE >> resetMiApplications [

	(Smalltalk classNamed: #MiApplication) reset.
	(Smalltalk classNamed: #MiTestApplication) reset
]

{ #category : #dependencies }
BaselineOfMooseIDE >> telescope: spec [
	spec
		baseline: 'TelescopeRoassal3'
		with: [ spec repository: 'github://TelescopeSt/TelescopeRoassal3' ]
]

{ #category : #dependencies }
BaselineOfMooseIDE >> tylerDurden: spec [
	spec
		package: 'Durden'
		with: [ spec repository: 'github://pharo-contributions/Durden' ]
]
