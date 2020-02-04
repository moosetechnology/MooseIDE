Class {
	#name : #MiMooseModelBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected',
		'model'
	],
	#category : #'Midas-MooseModelBrowser'
}

{ #category : #accessing }
MiMooseModelBrowserModel >> initialize [
	super initialize.
	MooseModel root ifEmpty: [ model := MooseModel new ].
	model := MooseModel root anyOne
]

{ #category : #accessing }
MiMooseModelBrowserModel >> model [
	^ model
]

{ #category : #accessing }
MiMooseModelBrowserModel >> model: aMooseModel [
	model := aMooseModel
]

{ #category : #accessing }
MiMooseModelBrowserModel >> selected [
	^ selected
]

{ #category : #accessing }
MiMooseModelBrowserModel >> selected: anObject [
	selected := anObject
]
