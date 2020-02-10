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
BaselineOfMidas >> baselineOfRoassal2Spec2: spec [
	spec
		baseline: 'Roassal2Spec2'
		with: [ spec repository: 'github://mahugnon/Roassal2Spec2:master/src' ]
]

{ #category : #baselines }
BaselineOfMidas >> defineDependencies: spec [
	"new tools"

	self baselineOfRoassal2Spec2: spec.
	spec baseline: 'NewTools' with: [ spec repository: 'github://pharo-spec/NewTools' ]
]

{ #category : #baselines }
BaselineOfMidas >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfMidas >> definePackages: spec [
	spec package: 'Midas' with: [ spec requires: #('NewTools') ].
	spec package: 'Midas-Famix' with: [ spec requires: #('Midas' 'Roassal2Spec2') ]
]
