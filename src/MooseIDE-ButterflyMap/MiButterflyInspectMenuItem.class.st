Class {
	#name : #MiButterflyInspectMenuItem,
	#superclass : #MiButterflyMenuItem,
	#category : #'MooseIDE-ButterflyMap-Menu'
}

{ #category : #testing }
MiButterflyInspectMenuItem >> canBeExecuted [

	^ shape isShape
]

{ #category : #testing }
MiButterflyInspectMenuItem >> execute [

	MiInspectorBrowser inspect: shape model rawModel
]

{ #category : #testing }
MiButterflyInspectMenuItem >> group [ 

	^ 100
]

{ #category : #testing }
MiButterflyInspectMenuItem >> iconName [ 
	
	^ #smallInspectIt
]

{ #category : #testing }
MiButterflyInspectMenuItem >> label [

	^ 'Inpsect'
]

{ #category : #testing }
MiButterflyInspectMenuItem >> order [

	^ 100
]
