Class {
	#name : #BaselineOfMooseIDE,
	#superclass : #BaselineOf,
	#category : #BaselineOfMooseIDE
}

{ #category : #baselines }
BaselineOfMooseIDE >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
		self famixQueries: spec.
		self telescope: spec.

		"Packages"
		self definePackages: spec.

		"If Moose is not already present"
		spec for: #NeedsMoose do: [ 
			self famix: spec.
			self famixTagging: spec.
			spec
				package: 'MooseIDE-Core' with: [ spec requires: #( 'Famix' ) ];
				package: 'MooseIDE-Meta' with: [ spec requires: #( 'MooseIDE-Core' ) ];
				package: 'MooseIDE-Tagging'
				with: [ spec requires: #( 'FamixTagging' ) ] ].

		"Groups"
		self defineGroups: spec ]
]

{ #category : #accessing }
BaselineOfMooseIDE >> customProjectAttributes [

	^ RPackageOrganizer default packages
		  detect: [ :package | package name = 'BaselineOfFamix' ]
		  ifFound: [ #(  ) ]
		  ifNone: [ #( #NeedsMoose ) ]
]

{ #category : #baselines }
BaselineOfMooseIDE >> defineGroups: spec [

	spec
		group: 'default'
		with: #( 'MooseIDE-Core' 'MooseIDE-Visualization'
			   'MooseIDE-Meta' 'MooseIDE-Tests' 'MooseIDE-Dependency'
			   'MooseIDE-Famix' 'MooseIDE-Tagging' 'MooseIDE-Telescope'
			   'MooseIDE-Export' 'MooseIDE-NewTools' 'MooseIDE-NewTools-Tests'
			   'MooseIDE-QueriesBrowser' 'MooseIDE-QueriesBrowser-Tests'
			   'MooseIDE-ColorPalette' 'MooseIDE-ColorPalette-Tests' )
]

{ #category : #baselines }
BaselineOfMooseIDE >> definePackages: spec [

	spec
		package: 'MooseIDE-Core';
		package: 'MooseIDE-Visualization'
		with: [ spec requires: #( 'TelescopeRoassal3' ) ];
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
		package: 'MooseIDE-Telescope'
		with: [ 
			spec requires: #( 'MooseIDE-Core' 'MooseIDE-Visualization' ) ];
		package: 'MooseIDE-QueriesBrowser'
		with: [ spec requires: #( 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-QueriesBrowser-Tests'
		with: [ spec requires: #( 'MooseIDE-QueriesBrowser' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-NewTools'
		with: [ spec requires: #( 'MooseIDE-Meta' 'MooseIDE-Core' 'FamixQueries' ) ];
		package: 'MooseIDE-NewTools-Tests'
		with: [ spec requires: #( 'MooseIDE-NewTools' 'MooseIDE-Tests' ) ];
		package: 'MooseIDE-Export'
		with: [ spec requires: #( 'MooseIDE-Core' ) ];
		package: 'MooseIDE-ColorPalette';
		package: 'MooseIDE-ColorPalette-Tests'
		with: [ spec requires: #( 'MooseIDE-ColorPalette' ) ]
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
BaselineOfMooseIDE >> telescope: spec [
	spec
		baseline: 'TelescopeRoassal3'
		with: [ spec repository: 'github://TelescopeSt/TelescopeRoassal3' ]
]
