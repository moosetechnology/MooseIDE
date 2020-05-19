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
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ].
]

{ #category : #baselines }
BaselineOfMidas >> baselineOfRoassal3: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:v0.9' ]
]

{ #category : #baselines }
BaselineOfMidas >> defineDependencies: spec [
	"new tools"
	self baselineOfRoassal3: spec.
	spec baseline: 'NewTools' with: [ spec repository: 'github://pharo-spec/NewTools' ]
]

{ #category : #baselines }
BaselineOfMidas >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfMidas >> definePackages: spec [
	spec package: 'Midas' with: [ spec requires: #('NewTools') ].
	spec package: 'Midas-Tests' with: [ spec requires: #('Midas') ].
	spec package: 'Midas-Dependency' with: [ spec requires: #('Midas' 'Roassal3') ].
	spec package: 'Midas-Famix' with: [ spec requires: #('Midas' 'Roassal3') ]
]
