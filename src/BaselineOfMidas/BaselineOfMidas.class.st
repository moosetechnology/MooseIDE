Class {
	#name : #BaselineOfMidas,
	#superclass : #BaselineOf,
	#category : #BaselineOfMidas
}

{ #category : #baselines }
BaselineOfMidas >> baseline: spec [

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
				package: 'Midas-Core' with: [ spec requires: #( 'Famix' ) ];
				package: 'Midas-Meta' with: [ spec requires: #( 'Midas-Core' ) ];
				package: 'Midas-Tagging'
				with: [ spec requires: #( 'FamixTagging' ) ] ].

		"Groups"
		self defineGroups: spec ]
]

{ #category : #accessing }
BaselineOfMidas >> customProjectAttributes [

	^ RPackageOrganizer default packages
		  detect: [ :package | package name = 'BaselineOfFamix' ]
		  ifFound: [ #(  ) ]
		  ifNone: [ #( #NeedsMoose ) ]
]

{ #category : #baselines }
BaselineOfMidas >> defineGroups: spec [

	spec
		group: 'default'
		with:
			#( 'Midas-Core' 'Midas-Visualization' 'Midas-Meta' 'Midas-Tests'
			   'Midas-Dependency' 'Midas-Famix' 'Midas-Tagging' 'Midas-Telescope' 'Midas-FamixQueries'
			   'Midas-Export' 'Midas-NewTools' 'Midas-NewTools-Tests' )
]

{ #category : #baselines }
BaselineOfMidas >> definePackages: spec [

	spec
		package: 'Midas-Core';
		package: 'Midas-Visualization'
		with: [ spec requires: #( 'TelescopeRoassal3' ) ];
		package: 'Midas-Meta' with: [ spec requires: #( 'Midas-Core' ) ];
		package: 'Midas-Tests' with: [ spec requires: #( 'Midas-Core' ) ];
		package: 'Midas-Dependency'
		with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ];
		package: 'Midas-Famix'
		with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ];
		package: 'Midas-Tagging'
		with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ];
		package: 'Midas-FamixQueries'
		with: [ spec requires: #( 'FamixQueries' 'Midas-Core' ) ];
		package: 'Midas-FamixQueries-Tests'
		with: [ spec requires: #( 'Midas-FamixQueries' 'Midas-Tests' ) ];
		package: 'Midas-Telescope'
		with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ];
		package: 'Midas-NewTools'
		with: [ 
			spec requires: #( 'Midas-Meta' 'Midas-Core' 'FamixQueries' 'Midas-FamixQueries') ];
		package: 'Midas-NewTools-Tests'
		with: [ spec requires: #( 'Midas-NewTools' 'Midas-Tests' ) ];
		package: 'Midas-Export' with: [ spec requires: #( 'Midas-Core' ) ]
]

{ #category : #dependencies }
BaselineOfMidas >> famix: spec [

	spec
		baseline: 'Famix'
		with: [ 
		spec repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : #dependencies }
BaselineOfMidas >> famixQueries: spec [
	spec
		baseline: 'FamixQueries'
		with: [ spec repository: 'github://moosetechnology/FamixQueries' ]
]

{ #category : #dependencies }
BaselineOfMidas >> famixTagging: spec [

	spec
		baseline: 'FamixTagging'
		with: [ 
		spec repository: 'github://moosetechnology/FamixTagging:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfMidas >> spec: spec [
	spec
		baseline: 'Spec2'
		with: [ spec repository: 'github://pharo-spec/Spec:v0.6.0' ]
]

{ #category : #dependencies }
BaselineOfMidas >> telescope: spec [
	spec
		baseline: 'TelescopeRoassal3'
		with: [ spec repository: 'github://TelescopeSt/TelescopeRoassal3' ]
]
