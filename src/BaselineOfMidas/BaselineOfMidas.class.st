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
			self mooseFinder: spec.
			spec
				package: 'Midas-Core' with: [ spec requires: #( 'Famix' ) ];
				package: 'Midas-Meta'
				with: [ spec requires: #( 'Moose-Finder' ) ] ].

		"Groups"
		self defineGroups: spec ]
]

{ #category : #accessing }
BaselineOfMidas >> customProjectAttributes [

	^ RPackageOrganizer default packages
		  detect: [ :package | package name = 'Moose-Finder' ]
		  ifFound: [ #(  ) ]
		  ifNone: [ #( #NeedsMoose ) ]
]

{ #category : #baselines }
BaselineOfMidas >> defineGroups: spec [
	spec
		group: 'default'
		with:
			#('Midas-Core' 'Midas-Visualization' 'Midas-Meta' 'Midas-Tests' 'Midas-Dependency' 'Midas-Famix' 'Midas-FamixQueries' 'Midas-FamixQueries-Tests' 'Midas-Telescope').
	spec group: 'newtools' with: #('default' 'Midas-NewTools')
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
		package: 'Midas-FamixQueries'
			with: [ spec requires: #( 'FamixQueries' 'Midas-Core' ) ];
		package: 'Midas-FamixQueries-Tests'
			with: [ spec requires: #( 'Midas-FamixQueries' 'Midas-Tests' ) ];
		package: 'Midas-Telescope'
			with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ];
		package: 'Midas-NewTools'
			with: [ spec requires: #( 'Midas-Meta' ) ]
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
BaselineOfMidas >> mooseFinder: spec [

	spec
		baseline: 'Moose'
		with: [ 
			spec repository: 'github://moosetechnology/Moose:development/src' ];
		project: 'Moose-Finder'
		copyFrom: 'Moose'
		with: [ spec loads: 'Moose-Finder' ]
]

{ #category : #dependencies }
BaselineOfMidas >> newTools: spec [
	spec baseline: 'NewTools' with: [ spec repository: 'github://pharo-spec/NewTools:67cc6fa' ]
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
