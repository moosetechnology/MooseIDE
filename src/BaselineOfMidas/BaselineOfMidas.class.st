Class {
	#name : #BaselineOfMidas,
	#superclass : #BaselineOf,
	#category : #BaselineOfMidas
}

{ #category : #baselines }
BaselineOfMidas >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfFamix: spec [
	spec
		baseline: 'Famix'
		with: [ spec repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfFamixQueries: spec [
	spec
		baseline: 'FamixQueries'
		with: [ spec repository: 'github://moosetechnology/FamixQueries' ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfNewTools: spec [
	spec baseline: 'NewTools' with: [ spec repository: 'github://pharo-spec/NewTools:67cc6fa' ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfRoassal3: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:v0.9.1' ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfSpec: spec [
	spec
		baseline: 'Spec2'
		with: [ spec repository: 'github://pharo-spec/Spec:v0.6.0' ]
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfTelescope: spec [
	spec
		baseline: 'TelescopeRoassal3'
		with: [ spec repository: 'github://TelescopeSt/TelescopeRoassal3' ]
]

{ #category : #baselines }
BaselineOfMidas >> defineDependencies: spec [
	self baselineOfRoassal3: spec.
	self baselineOfFamix: spec.
	self baselineOfFamixQueries: spec.
	self baselineOfTelescope: spec.

	"Spec and New tools are natively in Pharo 9"
	spec for: #'pharo8.x' do: [ 
		self baselineOfNewTools: spec.
		self baselineOfSpec: spec ]
]

{ #category : #baselines }
BaselineOfMidas >> defineGroups: spec [
	spec
		group: 'default'
		with:
			#('Midas-Core' 'Midas-Visualization' 'Midas-Meta' 'Midas-Tests' 'Midas-Dependency' 'Midas-Famix' 'Midas-FamixQueries' 'Midas-FamixQueries-Tests').
	spec group: 'telescope' with: #('default' 'Midas-Telescope').
	spec group: 'newtools' with: #('default' 'Midas-NewTools')
]

{ #category : #baselines }
BaselineOfMidas >> definePackages: spec [
	spec package: 'Midas-Visualization' with: [ spec requires: #( 'Roassal3' ) ].
	spec package: 'Midas-Meta' with: [ spec requires: #( 'Midas-Core' ) ].
	spec package: 'Midas-Tests' with: [ spec requires: #( 'Midas-Core' ) ].
	spec package: 'Midas-Dependency' with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ].
	spec package: 'Midas-Famix' with: [ spec requires: #( 'Midas-Core' 'Midas-Visualization' ) ].
	spec package: 'Midas-FamixQueries' with: [ spec requires: #( 'FamixQueries' 'Midas-Core' ) ].
	spec package: 'Midas-FamixQueries-Tests' with: [ spec requires: #( 'Midas-FamixQueries' 'Midas-Tests' ) ].
	spec package: 'Midas-Telescope' with: [ spec requires: #('Midas-Core' 'Midas-Visualization' 'TelescopeRoassal3' ) ].
	
	"Spec and New tools are natively in Pharo 9"
	spec for: #'pharo8.x' do: [ 
		spec package: 'Midas-Core' with: [ spec requires: #( 'Famix' 'Spec2' ) ].
		spec package: 'Midas-NewTools' with: [ spec requires: #( 'NewTools' 'Midas-Meta' ) ] ].
	spec for: #'pharo9.x' do: [ 
		spec package: 'Midas-Core' with: [ spec requires: #( 'Famix' ) ].
		spec package: 'Midas-NewTools' with: [ spec requires: #( 'Midas-Meta' ) ] ].
]
