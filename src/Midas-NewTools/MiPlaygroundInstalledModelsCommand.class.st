Class {
	#name : #MiPlaygroundInstalledModelsCommand,
	#superclass : #MiPlaygroundCommand,
	#category : #'Midas-NewTools-Playground'
}

{ #category : #converting }
MiPlaygroundInstalledModelsCommand >> asSpecCommand [
	^ super asSpecCommand
	"	iconName: #mooseMetamodelGroup from: MooseIcons;"
		beDisplayedOnRightSide;
		yourself
]

{ #category : #converting }
MiPlaygroundInstalledModelsCommand >> execute [ 

	self inform: 'TODO'
]

{ #category : #converting }
MiPlaygroundInstalledModelsCommand >> initialize [
	super initialize.
	self
		name: 'Model installed'
]
