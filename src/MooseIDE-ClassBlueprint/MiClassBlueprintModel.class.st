Class {
	#name : 'MiClassBlueprintModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'currentType'
	],
	#category : 'MooseIDE-ClassBlueprint',
	#package : 'MooseIDE-ClassBlueprint'
}

{ #category : 'accessing' }
MiClassBlueprintModel >> currentType [

	^ currentType
]

{ #category : 'accessing' }
MiClassBlueprintModel >> currentType: aFamixClass [

	currentType := aFamixClass
]

{ #category : 'accessing' }
MiClassBlueprintModel >> entities [

	^ currentType ifNil: [ #(  ) ] ifNotNil: [ { currentType } ]
]

{ #category : 'accessing' }
MiClassBlueprintModel >> miSelectedItem [

	^ currentType
]
